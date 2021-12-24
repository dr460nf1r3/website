---
title: "FireDragon"
date: 2021-12-24
draft: false
description: "A short FireDragon history lesson"
slug: "firedragon"
tags: ["firedragon", "browser", "privacy", "foss", "dr460nized"]
---

## The FireDragon browser

### Initial idea
Recently we got to know that Mozilla no longer supports a free internet. Their browser, Firefox, collects a lot of telemetry by default. Librewolf is a community maintained project which cuts the privacy compromising parts out of Firefox and provides a hardened browser config. That means no about:config tweaking is needed, everything works just after opening the browser for the first time. It has one very big drawback though: no Nightly (alpha) are builds available - just stable releases. 

### The creation
When I found out that a talented Maintainer brought a working PKGBUILD to AUR which is able to build from bleeding edge branches I was definitely interested! Even better, with some modifications I was able to build a custom branded version with my own settings called "FireDragon". This fork ships sane defaults which let many things which are broken in Librewolf work out of the box, ships with the Searx search engine, some handpicked patches from Gentoo, Ubuntu & Debian and some useful addons. Of course it is also available at Chaotic-AUR, built daily from the latest source!