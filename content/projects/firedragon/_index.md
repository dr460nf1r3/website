---
title: "The FireDragon browser"
date: 2021-12-24
draft: false
description: "A short FireDragon history lesson"
slug: "firedragon-browser"
featured_image: firedragon.webp
summary: "Recently we got to know that Mozilla no longer supports free internet. Their browser, Firefox, collects a lot of telemetry by default. Since using Chromium-based browsers is not an alternative (There shouldn't be a single browser engine dictating web standards! :eyes:), a better solution had to be found!"
tags: ["firedragon", "browser", "privacy", "foss", "dr460nized"]
---

### Initial idea :wolf:

Recently we got to know that Mozilla no longer supports free internet. Their browser, Firefox, collects a lot of telemetry by default. Since using Chromium-based browsers is not an alternative (There shouldn't be a single browser engine dictating web standards! :eyes:), some people decided to step in and provide a better solution. [Librewolf](https://librewolf.net) is a community-maintained project which removes the privacy-compromising parts and provides an additionally hardened browser config. That means no `about:config` tweaking is needed to get going - everything just works after opening the browser for the first time. It has a few drawbacks though: It does not integrate well into Garuda dr460nized and has too strict default settings for most people.

{{< figure src="firedragon.webp" >}}

### Creating an alternative :dragon:

When I found out that a talented [Maintainer](https://github.com/vnepogodin) brought a PKGBUILD to [AUR](https://aur.archlinux.org/packages/librewolf-hg) which can build Librewolf from Firefox's nightly branch I was interested in using it! Even better, with some modifications, I was able to build a custom-branded version with my settings called _FireDragon_. The initial idea was to create a fork of `librewolf-hg` however this quickly changed when the Garuda forum got interested in a stable version as well. This fork ships saner defaults to also include regular (not paranoid :yum:) users of Garuda Linux in its audience and ships with the [searX search engine](https://searx.garudalinux.org) by default, some handpicked patches from Gentoo, Ubuntu & Debian and some useful add-ons. Of course, FireDragon is available at [Chaotic-AUR]({{< ref "projects/chaotic-aur" >}}) - the nightly `firedragon-hg` package is even built daily from the latest source!

{{< figure src="firedragon-sweet.webp" >}}

### Notable features :fire:

There are some features that I love about this browser:

- App menu support thanks to Ubuntu patches
- Enhanced KDE integration thanks to OpenSUSE patches
- Better system library usage thanks to Gentoo patches
- Uses the self-hosted sync server of Garuda to sync the Mozilla account
- Uses the self-hosted Whoogle instance of Garuda as the default search engine
