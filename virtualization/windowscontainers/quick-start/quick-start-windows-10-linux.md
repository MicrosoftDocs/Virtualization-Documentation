---
title: Windows and Linux Containers on Windows 10
description: Container deployment quick start
keywords: docker, containers, LCOW
author: taylorb-microsoft
ms.date: 11/8/2018
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: bb9bfbe0-5bdc-4984-912f-9c93ea67105f
---

# Linux Containers on Windows 10

> [!div class="op_single_selector"]
> - [Linux Containers on Windows](quick-start-windows-10-linux.md)
> - [Windows containers on Windows](quick-start-windows-10.md)

The exercise will walk through creating and running Linux containers on Windows 10.

In this quick start you will accomplish:

1. Installing Docker Desktop
2. Running a simple Linux container using Linux Containers on Windows (LCOW)

This quick start is specific to Windows 10. Additional quick start documentation can be found in the table of contents on the left-hand side of this page.

## Prerequisites

Please make sure you meet the following requirements:
- One physical computer system running Windows 10 Professional, Windows 10 Enterprise, or Windows
Server 2019 version 1809 or later
- Make sure [Hyper-V](https://docs.microsoft.com/virtualization/hyper-v-on-windows/reference/hyper-v-requirements) is enabled.

***Hyper-V isolation:***
Linux Containers on Windows require Hyper-V isolation on Windows 10 in order to provide developers with the appropriate Linux kernel to run the container. More about Hyper-V isolation can be found on the [About Windows containers](../about/index.md) page.

## Install Docker Desktop

Download [Docker Desktop](https://store.docker.com/editions/community/docker-ce-desktop-windows) and run the installer (You will be required to login. Create an account if you don't have one already). [Detailed installation instructions](https://docs.docker.com/docker-for-windows/install) are available in the Docker documentation.

> If you already have Docker installed, make sure you have version 18.02 or later to support LCOW. Check by running `docker -v` or checking *About Docker*.

> The 'experimental features' option in *Docker Settings > Daemon* must be activated to run LCOW containers.

## Run Your First LCOW Container

For this example, a BusyBox container will be deployed. First, attempt to run a 'Hello World' BusyBox image.

```console
docker run --rm busybox echo hello_world
```

Note that this returns an error when Docker attempts to pull the image. This occurs because Dockers requires a directive via the `--platform` flag to confirm that the image and host operating system are matched appropriately. Since the default platform in Windows container mode is Windows, add a `--platform linux` flag to pull and run the container.

```console
docker run --rm --platform linux busybox echo hello_world
```

Once the image has been pulled with the platform indicated, the `--platform` flag is no longer necessary. Run the command without it to test this.

```console
docker run --rm busybox echo hello_world
```

Run `docker images` to return a list of installed images. In this case, both the Windows and Linux images.

```console
docker images

REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
microsoft/nanoserver   latest              105d76d0f40e        4 days ago          652 MB
busybox                latest              59788edf1f3e        4 weeks ago         3.41MB
```

> [!TIP]
> Bonus: See Docker's corresponding [blog post](https://blog.docker.com/2018/02/docker-for-windows-18-02-with-windows-10-fall-creators-update/) on running LCOW.

## Next Steps

> [!div class="nextstepaction"]
> [Learn how to build a sample app](./building-sample-app.md)
