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

## Windows Container on Windows 10

This exercise will walk through the basic deployment of the Windows container feature and Docker on Windows 10. This exercise assumes that you have familiarized yourself with basic container concepts and terminology. If you need to review concepts and terminology, see the [Quick Start Introduction](./quick_start.md).

This exercise must be run on **Windows Server 10** Insiders release. If you would like to work through this exercise on Windows 10, see the [Windows 10 Container Quick Start](./windows_containers_101.md).


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

# Download Docker Engine and Client
Invoke-WebRequest https://master.dockerproject.org/windows/amd64/dockerd-1.12.0-dev.exe -OutFile $env:programfiles\docker\dockerd.exe
Invoke-WebRequest https://master.dockerproject.org/windows/amd64/docker.exe -OutFile $env:programfiles\docker\docker.exe

Next, add the docker directory to the path variable. This will allow Docker commands to be run from any path. 

```none
$env:Path += ";$env:programfiles\docker"
```

Finally, to install Docker as a Windows service, run the following.

```none
dockerd --register-service
```

## 3. Install Base Container Images

Before a container can be deployed, a container base OS image needs to be downloaded. The following commands will download the Windows Server Core base OS image. This process can take some time, so teak a break and pick back up once the download has completed. 
    
```none
# Install Container Image Provider    
Install-PackageProvider ContainerImage -Force    

# Install Windows Server Core Image  
Install-ContainerImage -Name WindowsServerCore    
```

## 4. Verify Deployment

At this stage the Windows container feature and Docker are ready to deploy containers. To verify, open up a Windows command prompt and type `docker images’, this will display the installed images.

```none
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nanoserver          10.0.14300.1010     cb48429c84fa        7 weeks ago         817.1 MB
```

## 5. Deploy Your First Container

