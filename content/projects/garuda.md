---
title: "Garuda Linux"
date: 2021-12-24
draft: false
description: "Garuda Linux and me"
slug: "garuda"
tags: ["garuda", "linux", "privacy", "foss", "open source", "dr460nized"]
---

## The beginning of the journey :man_walking:

Since about 2 years I have been using Linux. Since the beginning, I loved the way things work on Linux, the simplicity and customizability - something unheard of in among windows users. A long time of these two years I spent distro hopping, searching for the optimal Linux distribution for my requirements. For those of you who do know the term "distro hopping" - a very good explanation can be found here! As a result I have tried countless Distributions like with Ubuntu, Fedora, Arch and Gentoo in all kinds of forms. After a while I sticked with Gentoo - the customisability was just too great, turning features on and off at compile time with use flags? Hell yes. But there were two major drawbacks: The compile times on a dual core CPU T440p were just too much (imagine Chromium taking 18 hours to compile) and to get all required software a lot of so called "overlays" had to be used which made the system feel very messy to me at some point - a solution had to be found.

## Early days of Garuda Linux :baby:

During these days I found myself trying out Garuda Linux. It emerged out of the custom Manjaro build called "Manjarowish" which implemeted a lot of great things such as performance enhancements or OpenSUSE style BTRFS with automated snapshots before each update by default. Garuda takes this to another level running on top of pure Arch which means always the latest and greatest packges! Eventually there was no maintainer for the GNOME edition at the time I was this edition for a short time - being completely new to this kind of business I decided to step in and maintain it (at this time Garuda was still rather unknown - the Telegram group had about 20 members back then). Since then many things changed - a lot of new ideas were implemented, existing tools improved, the team welcomed new members and appearently people like it so far since feedback has been mostly pretty overwhelming! 


## Expansion and new ressources :children_crossing:

Some time passed and the Garuda slowly grew. Everything I did was done using my own hardware for quite some time - that changed when we were suggested checking out Fosshost, a project which provides all kind of hosting services to open source projects. Its goal is to "support, promote, and advance the development and movement of free software" which is kind of what we are trying to do with Garuda! The time before contributing to Garuda I was learning how to selfhost a lot of open source projects including Searx and Nextcloud but sadly none of my people was actually interested in such things so this seemed like the perfect opportunity to do something useful with the knowledge I aquired..
After some brainstorming we decided to apply for ressources (needed them especially for the forum & building - the cluster which it was running on before was possibly going to be shut down) and got them granted! This means we did not have to take donations to continue providing this distribution until now. There were three VPS for us to use, one to host web services like the website or Searx, one to build iso files (this one also builds packages for Chaotic-AUR now) and one to hold applications which require more storage (looking at you, Nextcloud). Also the people behind Fosshost were really kind and helpful while migrating everything to their services - shoutouts to them!

## Setting everything up :wrench:

After initial setup of the servers (which I got helped with luckily, the Proxmox VNC window of the VMs was somewhat buggy and didnt input the characters I needed) it was time to actually deploy the applications. This was quite fun and I noticed that it was indeed easy for me after having done countless trial & error sessions at my VPS earlier. The only thing which proved to be impossible to setup along all other applications was Discourse, the forum software. This one comes with a complete installer which turns the system into a forum server and occupies both port 80 and 443 (the ones needed for HTTP and HTTPS) which quite of interfered with NGINX, the proxy server used. Luckily Fosshost gave us one little instance to use for whatever we needed it for - indeed a lucky coincidence because it was perfect to run Discourse on! The migration from its previous location happened without issues. Inspired by Fosshosts Telegram channel (which was bridged into Matrix, the first time I actually heard of it) I did some research on how to bridge our own Telegram channel to a selfhosted Matrix instance as Matrix is an open source and decentralized protocol which allows bridging into many known platforms - among them Telegram! Sounds like heaven for an open source enthusiast who does not want companies to own his data? Well for me it did. Being new to Matrix it took some time to actually figure it all out but in the end it worked quite well. Other things which were setup in the following month were a Telegram moderator bot (Rose - a great open source and free bot) and all applications you can find here. This one also made it into Garudas browser settings as startpage! During this time we also transitioned from Garudas previous domain (.in) to the one we are using today (.org) which was accompanied by me having to learn how to properly forward a domain to another one (you need SSL certificates for both domains, which I did not know back then). But luckily help was not far away and this issue got solved quickly!

## The future :trophy:

A lot of things happened since that time, I really need to start documenting things again! :thinking: There is a crazy detailed podcast dealing with all the things happening to Garuda though, I highly recommend watching it! :fire:

{{< youtube id="2YoOIJ2p7tk" title="Garudians of the Galaxy" >}}