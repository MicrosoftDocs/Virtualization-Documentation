---
title: Tar and Curl Come to Windows!
description: Learn about curl and bsdtar, two new command-line tools that are now supported in Windows.
author: sethmanheim
ms.author: sethm
date:       2017-12-19 18:00:23
ms.date: 12/19/2017
categories: containers
---
# Tar and Curl Come to Windows

Beginning in Insider Build **17063,** we're introducing two command-line tools to the Windows toolchain: curl and bsdtar. It's been a long time coming, I know. We'd like to give credit to the folks who've created and maintain [bsdtar](http://libarchive.org/) and [curl](https://curl.haxx.se/)—awesome open-source tools used by millions of humans every day. Let's take a look at two impactful ways these tools will make developing on Windows an even better experience. 

## 1\. Developers! Developers! Developers!

Tar and curl are staples in a developer's toolbox; beginning today, you'll find these tools are available from the command-line for all SKUs of Windows. And yes, they're the same tools you've come to know and love! If you're unfamiliar with these tools, here's an overview of what they do: 

  * **Tar:** A command line tool that allows a user to extract files and create archives. Outside of PowerShell or the installation of third party software, there was no way to extract a file from cmd.exe. We're correcting this behavior :) The implementation we're shipping in Windows uses [libarchive](http://libarchive.org/).
  * **Curl:** Another command line tool that allows for transferring of files to and from servers (so you can, say, now download a file from the internet).

Now not only will you be able to perform file transfers from the command line,  you'll also be able to extract files in formats in addition to .zip (like .tar.gz, for example). PowerShell _does_ already offer similar functionality (it has curl and its own file extraction utilities), but we recognize that there might be instances where PowerShell is not readily available or the user wants to stay in cmd. <!--[![](https://msdnshared.blob.core.windows.net/media/2017/12/tar.gif)](https://msdnshared.blob.core.windows.net/media/2017/12/tar.gif)-->

## 2\. The Containers Experience

Now that we're shipping these tools inbox, you no longer need to worry about using a separate container image as the builder when targeting nanoserver-based containers. Instead, we can invoke the tools like so: 

### Background

We offer two base images for our containers: _windowsservercore_ and _nanoserver_. The servercore image is the larger of the two and has support for such things as the full .NET framework. On the opposite end of the spectrum is nanoserver, which is built to be lightweight with as minimal a memory footprint as possible. It's capable of running .NET core but, in keeping with the minimalism, we've tried to slim down the image size as much as possible. We threw out all components we felt were not mission-critical for the container image. PowerShell was one of the components that was put on the chopping block for our nanoserver image. PowerShell is a whopping 56 Mb (given that the total size of the nanoserver image is 200 Mb…that's quite the savings!) But the consequence of removing PowerShell meant there was no way to pull down a package and unzip it from within the container.  If you're familiar with writing dockerfiles, you'll know that it's common practice to pull in all the packages (node, mongo, etc.) you need and install them. Instead, users would have to rely on using a separate image with PowerShell as the "builder" image to accomplish constructing an image. This is clearly not the experience we want our users to have when targeting nanoserver—they'd end up having to download the much larger servercore image. This is all resolved with the addition of curl and tar. You can call these tools from servercore images as well. <!--[![](https://msdnshared.blob.core.windows.net/media/2017/12/curl.gif)](https://msdnshared.blob.core.windows.net/media/2017/12/curl.gif)  -->

## We want your Feedback!

Are there other developer tools you would like to see added to the command-line? Drop a comment below with your thoughts! In the mean time, go grab **Insider Build 17063** and get busy curl'ing an tar'ing to your heart's desire.
