---
title: Deploy Windows Containers on Nano Server
description: Deploy Windows Containers on Nano Server
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: b82acdf9-042d-4b5c-8b67-1a8013fa1435
---

# Container host deployment - Nano Server

**This is preliminary content and subject to change.** 

Deploying a Windows container host has different steps, depending on the operating system and the host system type (physical or virtual). The steps in this document are used to deploy a Windows Container host to Nano Server on a physical or virtual system.

Before starting the configuration of Windows container on Nano server, you will need a system running Nano Server, and have a connected PowerShell session with the Nano Server system.

For more information on deploying Nano server and creating the remote PowerShell session, see [Getting Started with Nano Server]( https://technet.microsoft.com/en-us/library/mt126167.aspx) .

An evaluation copy of Nano Server can be found [here](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/nano_eula).

## 1. Install Container Feature

Install the Nano Server package management provider.

```none
Install-PackageProvider NanoServerPackage
```

After the package provide has been installed, install the container feature.

```none
Install-NanoServerPackage -Name Microsoft-NanoServer-Containers-Package
```

Optionally, if Hyper-V containers will be deployed, install the Hyper-V role. If the Nano Server is virtualized, nested virtualization will need to be enabled, for more information see [Nested Virtualization]( https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/nesting).

```none
Install-NanoServerPackage Microsoft-NanoServer-Compute-Package
```

## 2. Install Docker

Docker is required in order to work with Windows containers. Docker consists of the Docker Engine, and the Docker client. For this exercise, both will be installed. Run the following commands to do so. 

```none
# Create Docker directory
New-Item -Type Directory $env:programfiles\docker

# Download Docker Engine
Invoke-WebRequest https://master.dockerproject.org/windows/amd64/dockerd-1.12.0-dev.exe -OutFile $env:programfiles\docker\dockerd.exe
```

Download the Docker client.

```none
Invoke-WebRequest https://master.dockerproject.org/windows/amd64/docker.exe -OutFile $env:programfiles\docker\docker.exe
```

Next, add the docker directory to the path variable. This will allow Docker commands to be run from any path. 

```none
[Environment]::SetEnvironmentVariable("Path",$Env:Path + ";%programfiles%\docker", "Machine")
```

Finally, to install Docker as a Windows service, run the following.

```none
dockerd --register-service
```

## 3. Install Base Container Images

Base OS images are used as the base to any Windows Server or Hyper-V container. Base OS images are available with both Windows Server Core and Nano Server as the underlying operating system and can be installed using the container Provider PowerShell module.

For instructions on installing base OS images in an offline or non-internet connected environment see, [Offline image installation]( https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/manage_images#offline-installation). 

The following command can be used to install the Container Image PowerShell module.

```none
Install-PackageProvider ContainerImage -Force
```

Once installed, a list of Base OS images can be returned using `Find-ContainerImage`.

```none
Find-ContainerImage

Name                           Version          Source           Summary
----                           -------          ------           -------
NanoServer                     10.0.14300.1010  ContainerImag... Container OS Image of Windows Server 2016 Technical...
WindowsServerCore              10.0.14300.1000  ContainerImag... Container OS Image of Windows Server 2016 Technical...
```

To download and install the Nano Server base OS image, run the following:

```none
Install-ContainerImage -Name NanoServer
```

**Note** - At this time, only the Nano Server OS Image is compatible with a Nano Server container host.

For more information on container image management, see [Windows container images](../management/manage_images.md).