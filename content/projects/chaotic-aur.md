---
title: "Chaotic-AUR"
date: 2021-12-24
draft: false
description: "What is going on at Chaotic-AUR?"
slug: "chaotic-aur"
tags: ["chaotic-aur", "repository", "arch", "garuda-linux", "aur"]
---

## What is Chaotic-AUR?

As Chaotic-AUR is the repository (kind of an appstore for Linux distributions) of Garuda Linux and one of the user repositories with the most (and most useful) packages out there I decided to provide another mirror for it. Especially a massive increase of web traffic on the main server made this necessary! The repo can be accessed at chaotic.dr460nf1r3.me and can be found in the chaotic-mirrorlist package as well.

Chaotic-AUR provides everyday applications such as Spotify, GitHub Desktop, Visual Studio Code Insiders, a variety of Linux-tkg kernels and lots of other software which is not available in the official Arch repositories. The recent loss of the 380GB RAM main cluster made changes necessary - thats how our Garuda builder became one of three clusters to build individual packages for Chaotic-AUR. About 1820 of the previous over 4000 packages have been recovered until now and building packages is automated again! :happy:

This server has now evolved into a Chaotic-AUR builder to help with compiling all those nifty packages which couldn't have been updated daily otherwise! Currently it builds the entire KDE/Plasma -git stack (bleeding edge, daily compiled packages), most of the stuff I use personally & some of the requested, less heavy packages daily. Have a look here to have some insight :blush: