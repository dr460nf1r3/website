---
title: "Chaotic-AUR"
date: 2021-12-24
draft: false
description: "What is going on at Chaotic-AUR?"
slug: "chaotic-aur"
featured_image: lair-neofetch.webp
summary: "As Chaotic-AUR is the repository (kind of an appstore for Linux distributions) of Garuda Linux and one of the user repositories with the most (and most useful) packages out there I decided to help with maintenance and provide another mirror for it. Especially a massive increase of web traffic on the main server made this necessary!"
tags: ["chaotic-aur", "repository", "arch", "garuda-linux", "aur"]
---

## What is Chaotic-AUR? :eyes:

As Chaotic-AUR is the repository (kind of an appstore for Linux distributions) of Garuda Linux and one of the user repositories with the most (and most useful) packages out there I decided to provide another mirror for it. Especially a massive increase of web traffic on the main server made this necessary! The repo can be accessed at [mirrors.dr460nf1r3.org](https://mirrors.dr460nf1r3.org) and can be found in the [chaotic-mirrorlist](https://github.com/chaotic-aur/pkgbuild-chaotic-mirrorlist/blob/main/mirrorlist) package as well. :page_with_curl:

![Chaotic-AUR](https://avatars.githubusercontent.com/u/66071775?s=400&u=99bc0536e7e77fe3e58839996600848f2d930ed5&v=4)


## What and how much packages does it provide? :package:

Chaotic-AUR provides everyday applications such as Spotify, GitHub Desktop, Visual Studio Code Insiders, a variety of [Linux-tkg kernels](https://github.com/Frogging-Family/linux-tkg) and a lot of other software which is not available in the official Arch repositories. The loss of the 380GB RAM main cluster in December 2020 made changes necessary and our Garuda builder became one of new three clusters to build individual packages for Chaotic-AUR. About 2630 of the previous over 4000 packages have been recovered until now and building packages is automated again! :blush:

{{< figure src="chaotic-compilation.webp" >}}


## How does this server help Chaotic-AUR? :chart_with_upwards_trend:
This server is also a Chaotic-AUR builder to help with compiling all those great packages which couldn't have been updated daily otherwise! Currently it builds the entire KDE/Plasma -git stack (bleeding edge, daily compiled packages), most of the stuff I use personally & some of the requested packages daily. Have a look [here](https://github.com/chaotic-aur/packages/tree/main/dragon-cluster) to have some insight :blush:

{{< figure src="lair-neofetch.webp" >}}
