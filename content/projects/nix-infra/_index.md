---
title: "Garuda Linux"
date: 2023-10-29
draft: false
description: "The new NixOS infrastructure"
slug: "garuda"
featured_image: infra-nix.webp
summary: "This is a summary about the most recent major server maintenance we had at Garuda Linux / Chaotic-AUR :wrench:"
tags: ["garuda", "linux", "foss", "open source", "chaotic-aur"]
---

# The recent server migrations

## First of all :point_down:

Since people asked for a more detailed explanation and also for something like a dev blog, I figured
I'd write down some of my thoughts and observations about the recent migration.

## Why did we do this? :eyes:

The Garuda infra has historically always been developing over time. Starting out with pure Docker-based setups, we quickly figured it would be beneficial to have a tool to manage configurations with. After TNE came up with Ansible, we set up our infra playbooks to manage the Arch-based servers. All of this was fine, and upgrading and managing, as well as saving the state to git repositories were quite significant advantages over manual server management.

Time passes and we discovered NixOS as server OS. Now why choose another OS for the job? It's simple, managing NixOS systems is even better than using Ansible due to its declarative nature (declarative = define it, tool executes it, imperative = entering commands to achieve settings). Not only would you define a system state and apply it, but changes would also be reverted in case of removing a part of a configuration - something Ansible does not do, it just applies the defined state. We fell in love with NixOS and the possibilities it provides. Bootstrapping an entire system including its configs is pretty much a matter of downloading the git repository with the configurations and running `nixos-install`.

So, we were running NixOS for infrastructure purposes for quite a while now. While we started out with a few VMs back in the day, we were having 1 dedicated server and 1 root server to host VMs / LXC containers for multiple purposes. They contained builders, web applications, the forum, and all the things we need to provide Garuda as is. As you can imagine, VMs are quite isolated from the host and use more resources than eg. having a Docker container. They take their own, fixed amount of RAM from the host and use the CPU to emulate the interfaces and devices. LXC containers on the other hand were more lightweight, as they share resources with each other and the host.

Fast forward to about a month ago - the contract for the root server is about to expire and it's obvious that we could get much more value for the same amount of money by upgrading the dedicated server and replacing the root server with it. TNE and I planned to move our "host" part of the server to NixOS for a while already and this was the perfect time to execute the plan - given I had a week of vacation to spend on this.

## The idea? :thinking:

Now there were a lot of ideas and questions on how to solve specific problems. Resources should be used as efficiently as possible, while
also containing all of our previous VMs/Containers. NixOS has a thing called `nixos-containers`, which are basically declarative (or imperative!)
systemd-nspawn Containers running NixOS. They share the Nix store with the host (the Nix store being the thing making Nix Nix - all files, applications, and basically the whole operating system is located in this store, which are then being symlinked to the regular locations) and can be configured to be
ephemeral, which means that the root filesystem is located in a temporary filesystem, which is being deleted on shutdown or restart. This means only locations or files we bind-mound from the host's filesystem into the containers would survive a restart of the container and we would always have a "fresh" system.
So we only keep things we want to keep, automatically clear the rest on restarts and share a lot of common resources between the host & containers while still having them isolated in some kind of way. It may be noticed that the goal here was not to achieve strict isolation - that would've meant not being able to run Docker or our Chaotic builder inside those containers.

## Execution :wrench:

The first days of working on this consisted of writing the required Nix expressions to provide our containers. We came up with a custom function that builds our containers just the way we want them. Since we started out of a container supposed to be building Chaotic-AUR packages, we hit the first obstacle. The problem consisted of needing to run systemd-nspawn inside systemd-nspawn, since the toolbox utilizes it to build in a clean environment. This was eventually solved by mounting mounting `/sys/fs/groups` at the startup of the container. The next part of the implementation was getting Docker to run inside the nspawn containers. By default, we were not able to get Docker to run successfully - the solution consisted of providing additional capabilities and mounts to the container.

We opted for running everything Docker-based in one container, and everything native in separate ones. That means, that we are running 10 different containers for different purposes. The forum also runs in Docker, but since it did Discourse expects the installation in /var/discourse rather than where our custom NixOS module puts it, we choose to put it into its own container, too. All of this is behind the `web-front` container, which uses Nginx as reverse proxy, adding in SSL. Different containers are also in place for different repositories we distribute via Chaotic-AUR (`chaotic-aur`, `garuda`, and `kde-git`).

```
❯ machinectl
MACHINE     CLASS     SERVICE        OS    VERSION ADDRESSES
chaotic-kde container systemd-nspawn nixos 23.11   10.0.5.90…
docker      container systemd-nspawn nixos 23.11   10.0.5.100…
forum       container systemd-nspawn nixos 23.11   10.0.5.70…
iso-runner  container systemd-nspawn nixos 23.11   10.0.5.40…
mastodon    container systemd-nspawn nixos 23.11   10.0.5.80…
meshcentral container systemd-nspawn nixos 23.11   10.0.5.60…
postgres    container systemd-nspawn nixos 23.11   10.0.5.50…
repo        container systemd-nspawn nixos 23.11   10.0.5.30…
temeraire   container systemd-nspawn nixos 23.11   10.0.5.20…
web-front   container systemd-nspawn nixos 23.11   10.0.5.10…

10 machines listed.
```

## Moving the data :man_technologist:

The transition of all Chaotic-AUR services went quite painless, including the main node. After that, we started the main migration, which included all web services and their data. This was also the point, where the announced service disruptions occurred. The transfer of the data happened and most services were back after the estimated time frame had passed. Things still missing included Mastodon, which needed its database configuration fixed, Chaotic-AUR suddenly starting to misbehave after allocating ISO builds to it and Matrix bridges not being able to connect to the main instance. Though, after working on this for a whole day, it was time to sleep to not introduce additional issues due to being tired.

The next day consisted of fixing the remaining issues - mostly database configurations, a missing port forward of the Matrix federation port, and adjusting the webserver configuration of Discourse to the new environment to avoid rate limits. By now, all issues that were found are worked out.

## The aftermath :rocket:

After observing the system for the time being, we can say that things are considerably faster than before (loading forum pages is QUICK!), especially Chaotic-AUR builds since we are now able to build in RAM. One of the biggest advantages of this configuration turned out to be a disadvantage as well - the declarative nixos-containers. Since they would respond to every change of our configuration, changing a non-container-specific option would cause every container to be shut down and recreated, causing small downtimes of services. This should however not be an issue once the configuration is 100% completed.

## Things left to do? :face_with_monocle:

We quickly noticed Chaotic-AUR builds would hit the rate limit of AUR, which is a problem since builds for the most part rely on sourcing packages from AUR. Not being able to connect means that every build fails. Basically, it is the same issue that plagues Piped, Invidious, Searx, and Whoogle instances for quite a while (especially Piped and Invidious were striking the rate limit after deploying to the new server very quickly, so they are still out of order). Though, we are working on a possible solution that involves rotating IPv6 addresses of the /64 subnet that Hetzner provides to every server for outgoing requests. Initial attempts caused web services to be unreachable and we are still investigating the cause for this.

## Conclusion :earth_africa:

This whole action was definitely a bigger operation than I expected at first, especially the transition of all the different web services, with more total downtime than anticipated. However, it also turned out to be a great learning opportunity and definitely provided a big enhancement to the performance of every component of Garuda's web services. And at this point, I'd like to offer my sincere apologies for any inconvenience caused during the transition! I hope this provided some interesting insight into our current actions :smiling_face:
