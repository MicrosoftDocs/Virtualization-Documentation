---
title: Windows Container on Windows 10
description: Container deployment quick start
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05//2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 
---

# Windows Containers on Windows 10

The exercise will walk through a basic deployment and use of the Windows container feature. After completion, you will have installed the container role, and deployed a simple Hyper-V container. Before starting this quick start, familiarize yourself with basic container concepts and terminology. This information can be found on the [Quick Start Introduction](./quick_start.md).   

Prerequisites:

One physical computer system running a [Windows Server 10 Insiders release](https://insider.windows.com/).   
This quick start can be run on a Windows 10 virtual machine if nested virtualization is configured on the system. More information can be found in the [Nested Virtualization Guide](https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/nesting).

## 1. Install Container Feature

The container feature needs to be enabled before working with Windows containers. To do so run the following command in an elevated PowerShell session. 

```none
Enable-WindowsOptionalFeature -Online -FeatureName containers –All
```

Because Windows 10 only supports Hyper-V containers, the Hyper-V feature must be enabled. To enable the Hyper-V feature using PowerShell, run the following command in an elevated PowerShell session.

```none
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All
```

When the installation has completed, reboot the computer.

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
> Note: Please start a new Windows PowerShell window after running this command so it can take effect. Otherwise, the next steps will fail.


Finally, to install Docker as a Windows service, run the following.

```none
dockerd --register-service
Start-Service Docker
```

## 3. Install Base Container Images

Before a container can be deployed, a container base OS image needs to be downloaded. The following commands will download the Windows Server Core base OS image. This process can take some time, so teak a break and pick back up once the download has completed. 
    
```none
# Install Container Image Provider    
Install-PackageProvider ContainerImage -Force

# Install Windows Server Core Image  
Install-ContainerImage -Name NanoServer   
```

After the base image has been installed, the docker service needs to be restarted.

```none
Restart-Service docker
```

At this stage, running `docker images` will return the Windows Server Core image.

```none
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nanoserver          10.0.14300.1010     cb48429c84fa        8 weeks ago         817.1 MB
```

Before proceeding, this image needs to be tagged with a version of ‘latest’. To do so, run the following command.

```none
docker tag nanoserver:10.0.14300.1010 nanoserver:latest
```

## 4. Deploy Your First Container


```none
docker pull microsoft/sample-nginx:nanoserver
```

```none
docker images

REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
microsoft/sample-nginx   nanoserver          01afe1442f41        2 weeks ago         821.7 MB
nanoserver               10.0.14300.1010     cb48429c84fa        8 weeks ago         817.1 MB
nanoserver               latest              cb48429c84fa        8 weeks ago         817.1 MB
```
