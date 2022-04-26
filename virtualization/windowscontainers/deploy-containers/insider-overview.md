---
title: Use Containers with Windows Insider Program
description: Learn how to get started using windows containers with the Windows Insider program
keywords: docker, containers, insider, windows
author: cwilhit
ms.author: crwilhit
ms.date: 12/29/2020
ms.topic: how-to
---

# Use containers with the Windows Insider program

This topic walks you through the deployment and use of the Windows container feature on the latest insider build of Windows Server from the Windows Insider Preview program. During this exercise, you'll install the container role and deploy a preview edition of the base OS images. If you need to familiarize yourself with containers, you can find this information in [About Containers](../about/index.md).

## Join the Windows Insider Program

To run the insider version of Windows containers, you must have a host running the latest build of Windows Server from the Windows Insider program and/or the latest build of Windows 10 from the Windows Insider program. Join the [Windows Insider Program](https://insider.windows.com/) and review the Terms of Use.

> [!IMPORTANT]
> You must use a build of Windows Server from the Windows Server Insider Preview program or a build of Windows 10 from the Windows Insider Preview program to use the base image described below. If you are not using one of these builds, using these base images will fail to start a container.

## Install Docker

If you do not have Docker already installed, follow the [Get Started](../quick-start/set-up-environment.md) guide to install Docker.

## Pull an insider container image

By being part of the Windows Insider program, you can use our latest builds for the base images. You specify the insider build image you want to use in the `docker pull` command, for example, `mcr.microsoft.com/windows/server/insider:10.0.{build}.{revision}`.

To pull the Windows Server Insider base image, run the following: 

```console
docker pull mcr.microsoft.com/windows/server/insider:10.0.20348.1
```

To pull the Nano Server Insider base image, run the following:

```console
docker pull mcr.microsoft.com/windows/nanoserver/insider:10.0.20348.1
```

To pull the Windows Server Core insider base image, run the following:

```console
docker pull mcr.microsoft.com/windows/servercore/insider:10.0.20348.1
```

To see all of the available insider base images, see [Base images for Windows Insiders](../manage-containers/container-base-images.md#base-images-for-windows-insiders).

> [!IMPORTANT]
> We recommend that you read the Windows containers OS image [EULA](../images-eula.md ) and the Windows Insider program [Terms of Use](https://insider.windows.com/program-agreement).
