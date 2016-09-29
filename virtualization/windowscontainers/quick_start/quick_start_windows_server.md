---
title: Windows Containers on Windows Server
description: Container deployment quick start
keywords: docker, containers
author: neilpeterson
manager: timlt
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

## 1. Install Container Feature

The container feature needs to be enabled before working with Windows containers. To do so run the following command in an elevated PowerShell session.

```none
Install-WindowsFeature containers
```

When the feature installation has completed, reboot the computer.

```none
Restart-Computer -Force
```

## 2. Install Docker

Docker is required in order to work with Windows containers. Docker consists of the Docker Engine, and the Docker client. For this exercise, both will be installed.

Download the release candidate of the Commercially Supported Docker Engine and client as a zip archive.

```none
Invoke-WebRequest "https://download.docker.com/components/engine/windows-server/cs-1.12/docker.zip" -OutFile "$env:TEMP\docker.zip" -UseBasicParsing
```

Expand the zip archive into Program Files.

```none
Expand-Archive -Path "$env:TEMP\docker.zip" -DestinationPath $env:ProgramFiles
```

Add the Docker directory to the system path.

```none
# For quick use, does not require shell to be restarted.
$env:path += ";c:\program files\docker"

# For persistent use, will apply even after a reboot. 
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Docker", [EnvironmentVariableTarget]::Machine)
```

To install Docker as a Windows service, run the following.

```none
dockerd.exe --register-service
```

Once installed, the service can be started.

```none
Start-Service docker
```

## 3. Deploy Your First Container

For this exercise, you will download a pre-created .NET sample image from the Docker Hub registry and deploy a simple container running a .Net Hello World application..  

User `docker run` to deploy the .Net container. This will also download the container image which may take a few minutes.

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