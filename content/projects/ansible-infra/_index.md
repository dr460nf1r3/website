---
title: "Ansible roles for the infra!"
date: 2022-04-19
draft: false
description: "How to automate infrastructure using Ansible"
slug: "ansible"
featured_image: ansible.webp
summary: "As our infrastructure is growing, the number of services and tasks is increasing as well. This can be tedious and time consuming, especially when you have to deal with a lot of servers - enter Ansible! Ansible allows automating tasks on a wide range of platforms, including Linux, Windows, and Mac. :wrench:"
tags: ["garuda", "linux", "ansible", "foss", "open source", "chaotic-aur"]
---

## Introduction

As our infrastructure is growing, the number of services and tasks is increasing as well. This can be tedious and time consuming, especially when you have to deal with a lot of servers - enter [Ansible](https://www.ansible.com/)! Ansible allows automating tasks on a wide range of platforms, including Linux, Windows, and Mac. It is based on so called playbooks, roles and tasks. Once defined, it is really easy to deploy the defined settings to target machines. All it needs is adding a few lines to the `hosts` file and defining `host_vars` to let Ansible know what kind of tasks to execute.

{{< figure src="playbook.webp" >}}

## Starting out

As I didn't know much about Ansible before, I decided to study already existing playbooks in order to learn more about how it works. The [Arch infrastructure repository](https://github.com/archlinux/infrastructure) helped me a lot understanding how to setup the different roles needed. I began by writing a [role](https://gitlab.com/garuda-linux/infrastructure/-/blob/main/ansible/roles/common/tasks/main.yml) for all kind of common tasks like installing base packages, setting up services and installing a MOTD.

{{< figure src="motd.webp" >}}

## Host_vars and conditionals to the rescue

Since not every host needs to be configured the same way, `host_vars` provide a neat way to define what task to execute on which machine. I also added a few conditionals to the role to make sure that certain tasks are only executed if needed - eg. Chaotic-AUR GPG keys don't need to be fetched every time the playbook is executed. There was also one issue with our `docker-compose` configurations - as the repo was closed source previously, it contained a lot of sensible environment variables in those files. In order to make it open source, those variables needed to be replaced with Ansible variables. Thanks to the `template` feature of Ansible, it is quite easy to supply a template `docker-compose.yml.j2` (Jinja2 formatting) which then gets rendered into a proper `docker-compose.yml` file with the variables replaced when the playbook is executed. Also, `ansible-vault` is a great little tool that allows encrypting sensitive files and data easily - Ansible automatically decrypts the content when deploying changes.

## Automating everything!

While writing the different roles, I had so much fun that I couldn't stop working on it until it was all automated. Ansible Galaxy also came in handy, as it provided an already existing playbook for basic hardening of Linux installations and SSH with the [devsec.hardening](https://github.com/dev-sec/ansible-collection-hardening) collection. Meanwhile, I also rewrote our existing Nginx configurations to better fit our needs. Thinking about how I used [Nginx Proxy Manager](https://github.com/NginxProxyManager/nginx-proxy-manager) to handle web server needs not too long ago, I'm somewhat happy I finally learned how to do it properly. It just provides so much more flexibility conerning configurations and setup. While NPM worked fine for the time being, it feels really good to be able write own Nginx configurations!

## Chaotic-AUR cluster bootstrap?

Well, since I'm also operating Chaotic-AUR, it was natural to also include it in the process of automating stuff. After a long trial and error session, the `chaotic_aur` role is now available on Chaotic's [Github organization](https://github.com/chaotic-aur/chaotic-aur-ansible). It is also available in Garuda's infrastructure repository as git submodule and can be used to setup a whole cluster if provided with the correct `host_vars`.

## Throwing in some GitLab CI

Automating and running playbooks on my personal machine was too boring, so I decided to utilize GitLab CI to [trigger deployments](https://gitlab.com/garuda-linux/infrastructure/-/jobs/2345629958) based on commit messages. Currently, the repo responds to `deploy <playbook.yml>` as well as `dry-run <playbook.yml>`. Obviously `deploy` deploys the supplied playbook while the latter initiates a dry run via `ansible-playbook <playbook.yml> --check`.

{{< figure src="gitlab-ci.webp" >}}

## Wrapping it all up

I had a great time learning how to use Ansible! It will be really useful to decrease time spent configuring servers, allowing me to focus on other things which aren't automated. After all, changes just need to be pushed by `ansible-playbook full_run.yml` while setting up a new server became a matter of a few minutes.
