---
title: Deploy Windows Containers on Windows Server
description: Deploy Windows Containers on Windows Server
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/26/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: ba4eb594-0cdb-4148-81ac-a83b4bc337bc
---

# Container Host Deployment - Windows Server

**This is preliminary content and subject to change.** 

Deploying a Windows container host has different steps depending on the operating system and the host system type (physical or virtual). This document details deploying a Windows container host to either Windows Server 2016 or Windows Server Core 2016 on a physical or virtual system.

## Install Container Feature

The container feature needs to be enabled before working with Windows containers. To do so run the following command in an elevated PowerShell session. 

```none
Install-WindowsFeature containers
```

When the feature installation has completed, reboot the computer.

## Install Docker

Docker is required in order to work with Windows containers. Docker consists of the Docker Engine, and the Docker client. For this exercise, both will be installed.

Create a folder for the Docker executables.

```none
New-Item -Type Directory -Path 'C:\Program Files\docker\'
```

Download the Docker daemon.

```none
Invoke-WebRequest https://aka.ms/tp5/b/dockerd -OutFile $env:ProgramFiles\docker\dockerd.exe
```

Download the Docker client.

```none
Invoke-WebRequest https://aka.ms/tp5/b/docker -OutFile $env:ProgramFiles\docker\docker.exe
```

Add the Docker directory to the system path.

```none
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Docker", [EnvironmentVariableTarget]::Machine)
```

Restart the PowerShell session so that the modified path is recognized.

To install Docker as a Windows service, run the following.

```none
dockerd --register-service
```

Once installed, the service can be started.

```none
Start-Service Docker
```

## Install Base Container Images

Before a container can be deployed, a container base OS image needs to be downloaded. The following example will download the Windows Server Core base OS image. This same procedure can be completed to install the Nano Server base image. This same procedure can be completed to install the Nano Server base image. For detailed information on Windows container images, see [Managing Container Images](../management/manage_images.md).
    
First, install the container image package provider.

```none
Install-PackageProvider ContainerImage -Force
```

Next, install the Windows Server Core image. This process can take some time, so teak a break and pick back up once the download has completed.

```none 
Install-ContainerImage -Name WindowsServerCore    
```

After the base image has been installed, the Docker service needs to be restarted.

```none
Restart-Service docker
```

Finally, the image needs to be tagged with a version of ‘latest’. To do so, run the following command.

```none
docker tag windowsservercore:10.0.14300.1000 windowsservercore:latest
```

## Hyper-V Container Host

In order to deploy Hyper-V containers, the Hyper-V role will be required. If the Windows container host is itself a Hyper-V virtual machine, nested virtualization will need to be enabled before installing the Hyper-V role. For more information on nested virtualization, see [Nested Virtualization]( https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/nesting).

### Nested Virtualization

The following script will configure nested virtualization for the container host. This script is run on the Hyper-V machine that is hosting the container host virtual machine. Ensure that the container host virtual machine is turned off when running this script.

```none
#replace with the virtual machine name
$vm = "<virtual-machine>"

#configure virtual processor
Set-VMProcessor -VMName $vm -ExposeVirtualizationExtensions $true -Count 2

#disable dynamic memory
Set-VMMemory $vm -DynamicMemoryEnabled $false

#enable mac spoofing
Get-VMNetworkAdapter -VMName $vm | Set-VMNetworkAdapter -MacAddressSpoofing On
```

### Enable the Hyper-V role

To enable the Hyper-V feature using PowerShell, run the following command in an elevated PowerShell session.

```none
Install-WindowsFeature hyper-v
```

