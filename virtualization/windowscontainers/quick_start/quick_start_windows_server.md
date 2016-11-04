---
title: Windows Containers on Windows Server
description: Container deployment quick start
keywords: docker, containers
author: enderb-ms
ms.date: 09/26/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: e3b2a4dc-9082-4de3-9c95-5d516c03482b
---

# Windows Containers on Windows Server

This exercise will walk through basic deployment and use of the Windows container feature on Windows Server. After completion, you will have installed the container role and have deployed a simple Windows Server container. Before starting this quick start, familiarize yourself with basic container concepts and terminology. This information can be found in the [Quick Start Introduction](./quick_start.md).

This quick start is specific to Windows Server containers on Windows Server 2016. Additional quick start documentation can be found in the table of contents on the left hand side of this page.

**Prerequisites:**

One computer system (physical or virtual) running Windows Server 2016. If you are using Windows Server 2016 TP5, please update to [Window Server 2016 Evaluation](https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2016 ). 

> Critical updates are needed in order for the Windows Container feature to function. Please install all updates before working through this tutorial.

## 1. Install Docker

To install Docker we'll use the [OneGet provider PowerShell module](https://github.com/oneget/oneget). The provider will enable the containers feature on your machine and install Docker - this will require a reboot. Docker is required in order to work with Windows containers. It consists of the Docker Engine and the Docker client.

Open an elevated PowerShell session and run the following commands.

First we'll install the OneGet PowerShell module.

```none
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
```

Next we'll use OneGet to install the latest version of Docker.
```none
Install-Package -Name docker -ProviderName DockerMsftProvider
```

When PowerShell asks you whether to trust the package source 'DockerDefault', type A to continue the installation. When the installation is complete, reboot the computer.

```none
Restart-Computer -Force
```

## 2. Install Windows Updates

To ensure your Windows Server system is up-to-date, you should install Windows Updates by running:

```none
sconfig
```

You'll see a text-based configuration menu, where you can choose option 6 to Download and Install Updates:

```none
===============================================================================
                         Server Configuration
===============================================================================

1) Domain/Workgroup:                    Workgroup:  WORKGROUP
2) Computer Name:                       WIN-HEFDK4V68M5
3) Add Local Administrator
4) Configure Remote Management          Enabled

5) Windows Update Settings:             DownloadOnly
6) Download and Install Updates
7) Remote Desktop:                      Disabled
...
```

When prompted, choose option A to download all updates.

## 3. Deploy Your First Container

For this exercise, you will download a pre-created .NET sample image from the Docker Hub registry and deploy a simple container running a .Net Hello World application..  

Use `docker run` to deploy the .Net container. This will also download the container image which may take a few minutes.

```none
docker run microsoft/sample-dotnet
```

The container will start, print the hello world message, and then exit.

```none
       Welcome to .NET Core!
    __________________
                      \
                       \
                          ....
                          ....'
                           ....
                        ..........
                    .............'..'..
                 ................'..'.....
               .......'..........'..'..'....
              ........'..........'..'..'.....
             .'....'..'..........'..'.......'.
             .'..................'...   ......
             .  ......'.........         .....
             .                           ......
            ..    .            ..        ......
           ....       .                 .......
           ......  .......          ............
            ................  ......................
            ........................'................
           ......................'..'......    .......
        .........................'..'.....       .......
     ........    ..'.............'..'....      ..........
   ..'..'...      ...............'.......      ..........
  ...'......     ...... ..........  ......         .......
 ...........   .......              ........        ......
.......        '...'.'.              '.'.'.'         ....
.......       .....'..               ..'.....
   ..       ..........               ..'........
          ............               ..............
         .............               '..............
        ...........'..              .'.'............
       ...............              .'.'.............
      .............'..               ..'..'...........
      ...............                 .'..............
       .........                        ..............
        .....
```

For in depth information on the Docker Run command, see [Docker Run Reference on Docker.com]( https://docs.docker.com/engine/reference/run/).

## Next Steps

[Container Images on Windows Server](./quick_start_images.md)

[Windows Containers on Windows 10](./quick_start_windows_10.md)
