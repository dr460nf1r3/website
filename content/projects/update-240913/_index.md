---
title: "Short updates about what's going on"
date: 2024-09-13
draft: false
description: "Giving some updates about what is currently on my mind"
slug: "garuda"
summary: "Giving some updates about what is currently on my mind, since the last post has been long time ago"
tags: ["garuda", "linux", "foss", "open source", "chaotic-aur"]
---

## First of all

It has been quite a while since the last post I made. Of course, at this time I have been doing a lot of things as usual :grin:

## Personal life

Since the first of April, my previous occupation changed from being in training as a system administrator to being in training for application development. Since it's easy to change the specialization, I lost no time and am now very happy to be doing programming as a daytime job.
While system administration is fun, it didn't turn out to be the thing I want to be doing every day as a job, at least not in a corporate/job environment.
Programming did turn out to be the thing I love doing most, which also emerged from the fact that it has always fascinated me from day one.
So NodeJs, NestJs, and Angular are very likely what I'll be doing most of my daily life during the next years.

## Chaotic Manager / new build system

Being fascinated by CI and automation, I had the idea of moving Chaotic-AUR's infra 3.0, mostly consisting of a toolbox of bash scripts gluing together multiple very different builders to a complete build system, to a new build system powered by GitLab CI.
The first drafts were soon improved a lot by TNE, who I attribute a lot of things I learned during this journey to! Not only did they massively improve the first bash script efficiency, but they also wrote the scheduler backend powered by Typescript - which at first, was quite new to me. Little did I know, the new job turned out to provide me with the exact knowledge needed to also work on this part of the system.
I was very happy to find out that this was in fact a win-win situation - being able to improve skills needed for work and improving open source tools at the same time. Nothing better than that! There is quite a big README that explains the whole thing in-depth in the currently in-testing Chaotic-AUR infra 4.0:

- [README](https://gitlab.com/chaotic-aur/pkgbuilds)
- [Chaotic Manager repo](https://gitlab.com/garuda-linux/tools/chaotic-manager)
- [Chaotic Repository Template repo](https://github.com/chaotic-cx/chaotic-repository-template)

On another note, this has been powering the Garuda Linux repo's build infra since almost the beginning of the year, if I remember correctly. Which was much easier thanks to quite homogen package process requirements.

## Chaotic-AUR's new website

As I entered the new job, I had to learn new frameworks and programming languages (Java-/Typescript especially).
What can be better than choosing a fun and _useful_ project to learn them? That's when I decided to apply new knowledge to rework the Chaotic-AUR website, which consisted of one page README until this day.
Firstly, an API for fetching data from the new build system was implemented via NestJs.
This consisted of currently running builds and further queued up packages in Redis.
Next, a way of showing past deployments was the thing I wanted to implement.
Since TNE insisted on not adding a database (all state in Git, or the temporary Redis cache storing queues and logs), I had a crazy idea of using the Telegram deploy log channel for this reason.
Not only does this store deployments close to forever, but it is also accessible via API.
So yeah, [deploy logs](https://aur.chaotic.cx/status) are basically now powered by Telegram as a database, the Telegram API as a database client, and some algorithms to extract the requested messages from the channel history.
Whether this is wise - probably, and absolutely not. Does it work? Hell yes, it does. Given the requirements of not adding an additional database, it was a fun excercise of learning how to work with API's. And it made fetching the newest announcement channel news much more easy! :grin:
I think it turned out pretty nice considering I'm not a frontend type of guy, and has useful features that didn't exist before :party:
