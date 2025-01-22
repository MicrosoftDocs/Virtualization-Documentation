---
title: Set up Linux containers on Windows
description: Linux container deployment quickstart.
author: taylorb-microsoft
ms.author: mosagie
ms.date: 01/21/2025
ms.topic: quickstart
ms.assetid: bb9bfbe0-5bdc-4984-912f-9c93ea67105f
---

# Set up Linux Containers on Windows

Linux containers make up a huge percent of the overall container ecosystem and are fundamental to both developer experiences and production environments. Since containers share a kernel with the container host, however, running Linux containers directly on Windows isn't an option. This is where virtualization comes into the picture.

The exercise walks through creating and running Linux containers on Windows 10 and Windows 11.

In this quick start you'll:

1. Install Docker Desktop
2. Run a simple Linux container

## Prerequisites

Make sure you meet the following requirements:

- One physical computer system running Windows 10 Professional, Windows 10 Enterprise, or later. Or Windows Server 2019 version 1809 or later
- Make sure [Hyper-V](/virtualization/hyper-v-on-windows/reference/hyper-v-requirements) is enabled.

## Install Docker Desktop

Install [Docker Desktop](https://docs.docker.com/desktop/setup/install/windows-install/) on Windows.

## Run Your First Linux Container

In order to run Linux containers, you need to make sure Docker is targeting the correct daemon. You can toggle this by selecting `Switch to Linux Containers` from the action menu when clicking on the Docker whale icon in the system tray. If you see `Switch to Windows Containers`, then you're already targeting the Linux daemon.

![Docker system tray menu showing the "Switch to Windows containers" command.](./media/switchDaemon.png)

Once you've confirmed you're targeting the correct daemon, run the container with the following command:

```console
docker run --rm busybox echo hello_world
```

The container runs, prints "hello_world", then exits.

When you query `docker images`, you see the Linux container image that you just pulled and ran:

```console
docker images

REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
busybox                latest              59788edf1f3e        4 weeks ago         3.41MB
```

## Next Steps

> [!div class="nextstepaction"]
> [Learn how to build a sample app](./building-sample-app.md)
