---
title: Use Containers with Windows Insider Program
description: Learn how to get started using windows containers with the Windows Insider program
keywords: docker, containers, insider, windows
author: v-susbo
ms.author: v-susbo
ms.date: 12/29/2020
ms.topic: how-to
---

# Use containers with the Windows Insider program

This exercise will walk you through the deployment and use of the Windows container feature on the latest insider build of Windows Server from the Windows Insider Preview program. During this exercise, you will install the container role and deploy a preview edition of the base OS images. If you need to familiarize yourself with containers, you can find this information in [About Containers](../about/index.md).

## Join the Windows Insider Program

In order to run the insider version of Windows containers, you must have a host running the latest build of Windows Server from the Windows Insider program and/or the latest build of Windows 10 from the Windows Insider program. Join the [Windows Insider Program](https://insider.windows.com/GettingStarted) and review the Terms of Use.

> [!IMPORTANT]
> You must use a build of Windows Server from the Windows Server Insider Preview program or a build of Windows 10 from the Windows Insider Preview program to use the base image described below. If you are not using one of these builds, the use of these base images will result in failure to start a container.

## Install Docker

If you do not have Docker already installed, follow the [Get Started](../quick-start/set-up-environment.md) guide to install Docker.

## Pull an insider container image

By being part of the Windows Insider program, you can use our latest builds for the base images.

To pull the Nano Server Insider base image run the following:

```console
docker pull mcr.microsoft.com/nanoserver/insider
```

To pull the Windows Server Core insider base image run the following:

```console
docker pull mcr.microsoft.com/windows/servercore/insider
```

The "Windows" and "IoTCore" base images also have an insider version that is available to pull. You can read more about the available insider base images in the [Container base images](../manage-containers/container-base-images.md) doc.

> [!IMPORTANT]
> Please read the Windows containers OS image [EULA](../images-eula.md ) and the Windows Insider program [Terms of Use](https://www.microsoft.com/software-download/windowsinsiderpreviewserver).
