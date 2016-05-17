---
title: Container Deployment Quick Start
description: Container deployment quick start
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-contianers
ms.service: windows-containers
ms.assetid: 42ea9737-5d0d-447a-96d8-6fd5ed126b25
---

# Quick Start – configure a container host

**This is preliminary content and subject to change.** 

The Windows container feature is available on Windows Server 2016, Nano Server, and Windows 10 insider releases. A Windows container host can be deployed onto physical systems, on-prem virtual machines, and cloud hosted virtual machines. The steps to deploy a container host may vary by operating system, and system type. This document provides the details needed to quickly provision a Windows container host. This document also links through to more detailed instruction on manual deployments for all configuration types.

Use the navigation at the right hand side to select your desired deployment configuration.

## Windows Server

### Install container feature

The container feature can be installed on Windows Server 2016, or Windows Server 2016 Core, using Windows Server Manager or PowerShell.

To install the role using PowerShell, run the following command in an elevated PowerShell session.

```none
Install-WindowsFeature containers
```

### Install Docker

```none
# Download Docker Engine and Docker Client
Invoke-WebRequest https://aka.ms/tp5/dockerd -OutFile $env:programfiles\docker\dockerd.exe
Invoke-WebRequest https://aka.ms/tp5/dockerd -OutFile $env:programfiles\docker\docker.exe

# Add Docker folder to path
$env:Path += ";$env:programfiles\docker"

# Install Docker Engine as a Windows Service
dockerd --register-service
```

## Nano Server

### Install container feature

```none
# Install Nano Server Package Provider
Install-PackageProvider NanoServerPackage

# Install container feature
Install-NanoServerPackage -Name Microsoft-NanoServer-Containers-Package

# Install Hyper-V role (if container host will run Hyper-V containers)
Install-NanoServerPackage -Name Microsoft-NanoServer-Computer <verify>
```

### Install Docker

```none
# Download Docker Engine and Docker Client
Invoke-WebRequest https://aka.ms/tp5/dockerd -OutFile $env:programfiles\docker\dockerd.exe
Invoke-WebRequest https://aka.ms/tp5/dockerd -OutFile $env:programfiles\docker\docker.exe

# Add Docker folder to path
$env:Path += ";$env:programfiles\docker"

# Install Docker Engine as a Windows Service
dockerd --register-service
```

## Windows 10

### Install container feature

To enable the container feature using PowerShell, run the following command in an elevated PowerShell session.

```none
Enable-WindowsOptionalFeature -Online -FeatureName containers –All
```

### Install Hyper-V feature

Because Windows 10 only supports Hyper-V containers, the Hyper-V feature must be enabled. To enable the Hyper-V feature using PowerShell, run the following command in an elevated PowerShell session.

```none
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All
```

### Install Docker

```none
# Download Docker Engine and Docker Client
Invoke-WebRequest https://aka.ms/tp5/dockerd -OutFile $env:programfiles\docker\dockerd.exe
Invoke-WebRequest https://aka.ms/tp5/dockerd -OutFile $env:programfiles\docker\docker.exe

# Add Docker folder to path
$env:Path += ";$env:programfiles\docker"

# Install Docker Engine as a Windows Service
dockerd --register-service
```

## Azure

### Azure template

https://github.com/Azure/azure-quickstart-templates/tree/master/windows-server-containers-preview

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2Fwindows-server-containers-preview%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

## Next Steps

[Docker on Windows Quick Start](./manage_docker.md)
