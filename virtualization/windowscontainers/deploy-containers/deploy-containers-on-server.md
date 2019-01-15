---
title: Deploy Windows Containers on Windows Server
description: Deploy Windows Containers on Windows Server
keywords: docker, containers
author: taylorb-microsoft
ms.date: 09/26/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: ba4eb594-0cdb-4148-81ac-a83b4bc337bc
---

# Container Host Deployment - Windows Server

Deploying a Windows container host has different steps depending on the operating system and the host system type (physical or virtual). This document details deploying a Windows container host to either Windows Server 2016 or Windows Server Core 2016 on a physical or virtual system.

## Install Docker

Docker is required in order to work with Windows containers. Docker consists of the Docker Engine, and the Docker client. 

To install Docker we'll use the [OneGet provider PowerShell module](https://github.com/OneGet/MicrosoftDockerProvider). The provider will enable the containers feature on your machine and install Docker - this will require a reboot. 

Open an elevated PowerShell session and run the following commands.

Install the OneGet PowerShell module.

```PowerShell
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
```

Use OneGet to install the latest version of Docker.

```PowerShell
Install-Package -Name docker -ProviderName DockerMsftProvider
```

When the installation is complete, reboot the computer.

```PowerShell
Restart-Computer -Force
```

## Install a Specific Version of Docker

There are currently two channels available for Docker EE for Windows Server:

* `17.06` - Use this version if you're using Docker Enterprise Edition (Docker Engine, UCP, DTR). `17.06` is the default.
* `18.03` - Use this version if you're running Docker EE Engine alone.

To install a specific version, use the `RequiredVersion` flag:

```PowerShell
Install-Package -Name docker -ProviderName DockerMsftProvider -Force -RequiredVersion 18.03
```

Installing specific Docker EE versions may require an update to previously installed DockerMsftProvider modules. To Update:

```PowerShell
Update-Module DockerMsftProvider
```

## Update Docker

If you need to update Docker EE Engine from an earlier channel to a later channel, use both the `-Update` and `-RequiredVersion` flags:

```PowerShell
Install-Package -Name docker -ProviderName DockerMsftProvider -Update -Force -RequiredVersion 18.03
```

## Install Base Container Images

Before working with Windows Containers, a base image needs to be installed. Base images are available with either Windows Server Core or Nano Server as the container operating system. For detailed information on Docker container images, see [Build your own images on docker.com](https://docs.docker.com/engine/tutorials/dockerimages/).

With the release of Windows Server 2019, Microsoft-sourced container images are moving to a new registry called the Microsoft Container Registry. Container images published by Microsoft should continue to be discovered via Docker Hub. For new container images published with Windows Server 2019 and beyond, you should look to pull them from the MCR. For older container images published before Windows Server 2019, you should continue to pull them from Docker's registry.

### Windows Server 2019 and newer

To install the 'Windows Server Core' base image run the following:

```PowerShell
docker pull mcr.microsoft.com/windows/servercore:ltsc2019
```

To install the 'Nano Server' base image run the following:

```PowerShell
docker pull mcr.microsoft.com/windows/nanoserver:1809
```

### Windows Server 2016 (versions 1607-1803)

To install the Windows Server Core base image run the following:

```PowerShell
docker pull microsoft/windowsservercore
```

To install the Nano Server base image run the following:

```PowerShell
docker pull microsoft/nanoserver
```

> Please read the Windows Containers OS Image EULA which can be found here – [EULA](../images-eula.md).

## Hyper-V isolated container Host

In order to run Hyper-V isolated containers, the Hyper-V role is required. If the Windows container host is itself a Hyper-V virtual machine, nested virtualization will need to be enabled before installing the Hyper-V role. For more information on nested virtualization, see [Nested Virtualization]( https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/nesting).

### Nested Virtualization

The following script will configure nested virtualization for the container host. This script is run on the parent Hyper-V machine. Ensure that the container host virtual machine is turned off when running this script.

```PowerShell
#replace with the virtual machine name
$vm = "<virtual-machine>"

#configure virtual processor
Set-VMProcessor -VMName $vm -ExposeVirtualizationExtensions $true -Count 2

#disable dynamic memory
Set-VMMemory -VMName $vm -DynamicMemoryEnabled $false

#enable mac spoofing
Get-VMNetworkAdapter -VMName $vm | Set-VMNetworkAdapter -MacAddressSpoofing On
```

### Enable the Hyper-V role

To enable the Hyper-V feature using PowerShell, run the following command in an elevated PowerShell session.

```PowerShell
Install-WindowsFeature hyper-v
```
