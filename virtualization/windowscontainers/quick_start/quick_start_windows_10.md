---
title: Windows Container on Windows 10
description: Container deployment quick start
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/26/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: bb9bfbe0-5bdc-4984-912f-9c93ea67105f
---

# Windows Containers on Windows 10

**This is preliminary content and subject to change.** 

The exercise will walk through basic deployment and use of the Windows container feature on Windows 10 (insiders build 14352 and up). After completion, you will have installed the container role, and deployed a simple Hyper-V container. Before starting this quick start, familiarize yourself with basic container concepts and terminology. This information can be found on the [Quick Start Introduction](./quick_start.md). 

> This quick start is specific to Hyper-V containers on Windows 10. Additional quick start documentation can be found in the table of contents on the left hand side of this page.

**Prerequisites:**

- One physical computer system running a [Windows Server 10 Insiders release](https://insider.windows.com/).   

This quick start can be run on a Windows 10 virtual machine however nested virtualization will need to be enabled. More information can be found in the [Nested Virtualization Guide](https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/nesting).

## 1. Install Container Feature

The container feature needs to be enabled before working with Windows containers. To do so run the following command in an elevated PowerShell session. 

```none
Enable-WindowsOptionalFeature -Online -FeatureName containers –All
```

Because Windows 10 only supports Hyper-V containers, the Hyper-V feature must also be enabled. To enable the Hyper-V feature using PowerShell, run the following command in an elevated PowerShell session.

```none
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All
```

When the installation has completed, reboot the computer.

## 2. Install Docker

Docker is required in order to work with Windows containers. Docker consists of the Docker Engine, and the Docker client. For this exercise, both will be installed. Run the following commands to do so. 

Download the Docker daemon.

```none
Invoke-WebRequest https://aka.ms/tp5/b/dockerd -OutFile $env:SystemRoot\system32\dockerd.exe
```

Download the Docker client.

```none
Invoke-WebRequest https://aka.ms/tp5/b/docker -OutFile $env:SystemRoot\system32\docker.exe
```

To install Docker as a Windows service, run the following.

```none
dockerd --register-service
```

Once installed, the service can be started.

```none
Start-Service Docker
```

## 3. Install Base Container Images

Windows containers are deployed from templates or images. Before a container can be deployed, a container base OS image needs to be downloaded. The following commands will download the Nano Server base image.
    
Set the PowerShell execution policy.

```none
Set-ExecutionPolicy -Scope LocalMachine Bypass
```

Install the container image package provider.

```none  
Install-PackageProvider ContainerImage -Force
```

Next, install the Nano Server image.

```none
Install-ContainerImage -Name NanoServer
```

After the base image has been installed, the docker service needs to be restarted.

```none
Restart-Service docker
```

At this stage, running `docker images` will return a list of installed images, in this case the Nano Server image.

```none
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nanoserver          10.0.14300.1010     cb48429c84fa        8 weeks ago         817.1 MB
```

Before proceeding, this image needs to be tagged with a version of ‘latest’. To do so, run the following command.

```none
docker tag nanoserver:10.0.14300.1010 nanoserver:latest
```

For in depth information on Windows container images see, [Managing Container Images](../management/manage_images.md).

## 4. Deploy Your First Container

For this simple example a .NET Core image has been pre-created. Download this image using the `docker pull` command.

When run, a container will be started, the simple .NET Core application will execute, and then container will then exit. 

```none
docker pull microsoft/sample-dotnet
```

This can be verified with the `docker images` command.

```none
docker images

REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
microsoft/sample-dotnet   latest              289f9cdaf773        32 minutes ago      929.9 MB
nanoserver               10.0.14300.1010     cb48429c84fa        8 weeks ago         817.1 MB
nanoserver               latest              cb48429c84fa        8 weeks ago         817.1 MB
```

Run the container with the `docker run` command. The following example specifies the `--rm` parameter, this instructs the Docker engine to delete the container once it is no longer running. 

For in depth information on the Docker Run command, see [Docker Run Reference on Docker.com]( https://docs.docker.com/engine/reference/run/).

```none
docker run --isolation=hyperv --rm microsoft/sample-dotnet
```

The outcome of this command is that a Hyper-V container was created from the sample-dotnet image, a sample application was then executed (output echoed to the shell), and then the container stopped and removed. 
Subsequent Windows 10 and container quick starts will dig into creating and deploying application in containers on Windows 10.

## Next Steps

[Windows Containers on Windows Server](./quick_start_windows_server.md)


