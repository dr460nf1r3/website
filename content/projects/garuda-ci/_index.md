---
title: "Improving Garuda's repository set via CI/CD pipelines"
date: 2021-12-24
draft: false
description: "How our repository setup got automated, bringing a handful of advantages with it"
slug: "garuda-ci"
featured_image: pipeline.webp
summary: "This is another post dedicated to recent changes to some of our infrastructure - this time tackling the repository setups, particularly those containing PKGBUILDs or sources for our packages :wrench:"
tags:
  [
    "garuda",
    "linux",
    "privacy",
    "foss",
    "open source",
    "infrastructure",
    "ci/cd",
    "pipelines",
    "repository",
  ]
---

## Intro

Hello everyone! :man_technologist:

This is another post dedicated to recent changes to some of our infrastructure - this time tackling the repository setups, particularly those containing PKGBUILDs or sources for our packages :wrench:

## Motivation

For those, who already worked with our git repos to contribute, as well as the ones who took a look at what the source of certain packages looks like, you might have noticed that we had _a LOT_ of different repositories for all kinds of purposes. This also included repositories, which only inherited one PKGBUILD and its `.install` file. Treating things this way had a simple reason: the scripts used to build packages ([chaotic-toolbox](https://github.com/chaotic-aur/toolbox)) only support custom Git sources that have the PKGBUILD right in the root of the cloned repository, which is just how the AUR does it.

After having worked with this setup for quite a while, it became obvious that having all of the build recipes in one place would be a great improvement to everyone having to deal with multiple packages at once. Not only would this allow changing multiple PKGBUILD's dependencies without having to do countless git operations (sure, those can be scripted. But why make it harder than it has to be?), but it also provides the possibility to perform the same actions for all PKGBUILDs easily. And not to forget, working with CI/CD pipelines is a task I enjoy a lot! :face_with_hand_over_mouth:

## Advantages and plans

These are some of the advantages in comparison to the situation we had before (the scope of this is the `garuda` repository, not the `chaotic-aur` one!):

- It is easy to find the right repository and files for contributors, hopefully making a contribution more attractive than before
- It allows generating changelogs without looking at each repository (collecting those tends to be a tedious task!)
- It provides an entry point for syntax/anti-pattern checks of the code
- It makes reviewing PRs easier and faster since a suite of checks is automatically run against it, detecting the most obvious errors
- It enables us to use git for deployments - which now can be done by **every maintainer of the Garuda team**, rather than only by package maintainers and server admins
- It speeds up certain actions, such as updating the PKGBUILD to push a new version by automatically executing the required actions
- It allows enforcing a baseline of standards for code, which hasn't been the case before

All of these were implemented by now.

## What changed?

Let's look at some of the changes and how they affect things.

### PKGBUILD location and where to edit files

This is a change that will be relevant for everyone who wants to contribute changes to packages and settings. Unlike before, there is now a single unified repository for all PKGBUILDs:

<https://gitlab.com/garuda-linux/pkgbuilds>

As the description already suggests, some packages also have their sources included here. This applies to most packages, which consist of up to a few text files, like `garuda-fish-config` or `garuda-hooks`. The other ones are the ones that require more extensive source code or reference external repos (all packages not listed in the [SOURCES](https://gitlab.com/garuda-linux/pkgbuilds/-/blob/main/SOURCES?ref_type=heads) file automatically belong to the first category). This means the following for changing files or reporting issues:

1. Packaging matters should be implemented/reported in the [PKGBUILDs](https://gitlab.com/garuda-linux/pkgbuilds) repository
2. Issues/changes to settings should be reported in their respective source repositories.

For version bumps, this means:

1. Packages of the first category get bumped via the [PKGBUILDs](https://gitlab.com/garuda-linux/pkgbuilds) repository, triggering an instant deployment by supplying `[deploy $pkgname]` in the commit message
2. Packages of the second category just need a new tag in their source repositories to be pushed in case no packaging changes occur (which does not happen _that_ often after all), the rest - updating PKGBUILD, checksums, triggering a build - will automatically be done by the [PKGBUILDs CI pipeline](https://gitlab.com/garuda-linux/pkgbuilds/-/commit/f97affd8b4d20d287192bff47fed5fc9e3d7a9d5)!

This also means that everyone can now inspect the build status for packages of the `[garuda]` repository by looking at the [pipeline runs](https://gitlab.com/garuda-linux/pkgbuilds/-/pipelines).

### Generating changelogs

By adopting [conventional commit messages](https://www.conventionalcommits.org/) with the [Angular convention](https://github.com/angular/angular.js/blob/master/DEVELOPERS.md#type), another manual task could be automated. Changelogs are now automatically generated via [commitizen](https://github.com/commitizen-tools/commitizen). For each automated version update of packages of the before-mentioned second category, changelogs of the source repos are automatically attached to the commit message.

This however only works, if the commit message convention is used. Otherwise, commitizen is unable to parse them accordingly. To ensure this is always the case, another CI job checks whether commits comply with the format.

For contributors, this basically means using the correct commit messages. It may sound harder than it is. There would be a handful of most used formats:

- `fix: xyz not working`
- `feat: add new waybar icon`
- `style(garuda-fish-config): improve spacing` # Providing a scope like this would only be necessary for the PKGBUILDs repo to automatically track the package to which the commits are later accounted to

Recommendations include:

- Keep the message short: Makes the list of commits more readable (~50 chars).
- Talk imperative
- Think about the CHANGELOG: Your commits will probably end up in the changelog so try writing for it, but also keep in mind that you can skip sending commits to the CHANGELOG by using different keywords (like build).
- Use a commit per new feature: if you introduce multiple things related to the same commit, squash them. This is useful for auto-generating CHANGELOG.

The [commitizen](https://github.com/commitizen-tools/commitizen) app is also able to interactively generate a complying commit message, so it can be a great help in case someone doesn't want to spend time reading documentation.

### Basic syntax/style checks

Another great thing to be added to the new repository is checks against PKGBUILDs and other files. Every commit is checked for basic integrity with a set of linters ([have a look at the script behind it](https://gitlab.com/garuda-linux/pkgbuilds/-/blob/main/.ci/lint.sh?ref_type=heads)) by a pipeline run:

<https://gitlab.com/garuda-linux/pkgbuilds/-/jobs/5487774423>

This would give instant feedback about whether obvious issues exist with a commit, which may be corrected (such as not complying with conventional commits!). Hopefully, it also increases code quality on its way by a bit :D The script may be run locally via `bash .ci/lint.sh`, possibly even correcting some of the issues by passing an argument `bash .ci/lint.sh apply` (dependencies of course need to be installed).

If there are any other helpful tools in this regard, let me know! 😄

### Implementation

Well, the implementation mostly consisted of writing the required bash scripts, preparing the server to accept build requests (securing it properly on the way), and testing it. First, the linter script was implemented, followed by the deployment (since it checks first and only deploys if checks were successful) via commit message. After that, the version bumps were implemented. It turned out to be working better than I anticipated! After having the setup in a working state, all of our packages/source repositories were either deleted (the obsolete ones, before the content was moved to our [archive](https://gitlab.com/garuda-linux/archive) of course) or had their PKGBUILD removed and a new [README](https://gitlab.com/garuda-linux/themes-and-settings/settings/garuda-dr460nized/-/blob/master/README.md?ref_type=heads) explaining where to find things and how to contribute added (the source repos mostly). Also, all package sources are now checked via sha256sums, some were either using md5sum or SKIP before. Existing PKGBUILDs needed issues reported by [shellcheck](https://www.shellcheck.net/)/[shfmt](https://github.com/mvdan/sh) to be worked out before the CI would actually be useful. Of course, documentation had to be updated with a new [repository section](https://docs.garudalinux.net/repositories/general).

{{< figure src="pipeline.webp" title="Updating PKGBUILDs automatically by pushing a new tag" >}}

### Looking forward

Things are implemented and working quite well so far. I'm sure there will be some more bugs to be worked out, but so far, so good! A similar setup may be implemented on our [iso-profiles](https://gitlab.com/garuda-linux/tools/iso-profiles) repo, but for ISO builds :smile: I hope that my efforts to better document things via our [infra docs](https://docs.garudalinux.net), as well as to apply certain standards encourage more people (also on the infra side!) to contribute to our beloved project :heart:

As a positive side-effect our Telegram channel for [GitLab updates](https://t.me/garuda_updates) is working again since I found Telegram notifications to be an inbuilt integration by now (it didn't use to be?), the previous webhook solution we used seemingly got abandoned and wasn't working reliably/at all.

Furthermore, I'd love to make better use of GitLabs features, eg. by tracking current bigger tasks via [Epics](https://gitlab.com/groups/garuda-linux/-/epics?state=opened&page=1&sort=start_date_desc) and [corresponding issues](https://gitlab.com/garuda-linux/infra-nix/-/issues/2). This should also provide a better insight into what we are currently up to for everyone who is interested in these matters.

That's all for now, thanks for reading! :hugs:
