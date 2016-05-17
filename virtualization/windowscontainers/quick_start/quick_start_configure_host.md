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

The Windows container feature is available on Windows Server 2016, Nano Server, and Windows 10 insider releases. A Windows container host can be deployed onto physical systems, on-prem virtual machines, and cloud hosted virtual machines. The steps to deploy a container host may vary by operating system, and system type. This document provides the details needed to quickly provision a Windows container host.

Use the navigation at the right hand side to select your desired deployment configuration.

## Windows Server

### Install container feature

The container feature can be installed on Windows Server 2016, or Windows Server 2016 Core, using Windows Server Manager or PowerShell.

To install the feature using PowerShell, run the following command in an elevated PowerShell session.

```none
Install-WindowsFeature containers
```

If Hyper-V containers will be deployed, the Hyper-V role will be required. The following Powershell command can be used to install the role.

```none
Install-WindowsFeature hyper-v
```

If the container host is also a Hyper-V virtual machine, and will be hosting Hyper-V containers, nested virtualization will need to be configured. For details on this configuration see, [Nested Virtualization]( https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/nesting).


### Install Docker

Docker is required to manage Windows Containers, however needs to be installed separately. The following PowerShell commands will install and perform basic configuration of the Docker engine and Docker client. For detailed information on configuring the Docker engine, including securing the Docker engine on Windows see, [Docker Daemon on Windows](../docker/docker_daemon_windows.md).

```none
# Download Docker Engine
Invoke-WebRequest https://aka.ms/tp5/dockerd -OutFile $env:programfiles\docker\dockerd.exe

# Add Docker folder to the path
$env:Path += ";$env:programfiles\docker"

# Install Docker Engine as a Windows Service
dockerd --register-service
```

The following command will download the Docker client.

```none
# Download Docker Client
Invoke-WebRequest https://aka.ms/tp5/docker -OutFile $env:programfiles\docker\docker.exe
```


### Install Base OS Image

Container OS images can be found and installed using the ContainerImage PowerShell module. Before using this module, it will need to be installed. The following command can be used to install the module. For more information on using the Container Image OneGet PowerShell module see, [Container Image Provider](https://github.com/PowerShell/ContainerProvider). 

```none
Install-PackageProvider ContainerImage -Force
```

Once installed, a list of Base OS images can be returned using `Find-ContainerImage`.


To download and install the Nano Server base OS image, run the following.

```none
Install-ContainerImage -Name NanoServer
```

Likewise, this command will download and install the Windows Server Core base OS image.

```none
Install-ContainerImage -Name WindowsServerCore
```

After installing the Windows Server Core or Nano Server Base OS images, these will need to be tagged with a version of ‘latest’. To do so, use the `docker tag` command. For more information on `docker tag` see [Tag, push, and pull you images on docker.com](https://docs.docker.com/mac/step_six/). 

```none
docker tag <image id> windowsservercore:latest
``` 

## Nano Server

### Install container feature

In order to configure the Windows container feature on Nano Server, a remote PowerShell session must be created with the Nano Server. To do so, run the following commands on a remote management system. Note – replace the IP address with the IP address of the Nano Server.

```none
Set-Item WSMan:\localhost\Client\TrustedHosts 10.0.0.5
```

```none
Enter-PSSession -ComputerName 10.0.0.5 -Credential ~\Administrator
```

Once the remote session has been created, the following commands can be used to install the Windows container feature.


```none
# Install Nano Server Package Provider
Install-PackageProvider NanoServerPackage

# Install container feature
Install-NanoServerPackage -Name Microsoft-NanoServer-Containers-Package
```

If Hyper-V containers will be deployed, the Hyper-V role will be required. The following Powershell command can be used to install the role.

```none
Install-NanoServerPackage -Name Microsoft-NanoServer-Computer <verify>
```

If the container host is also a Hyper-V virtual machine, and will be hosting Hyper-V containers, nested virtualization will need to be configured. For details on this configuration see, [Nested Virtualization]( https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/nesting).

### Install Docker

Docker is required to manage Windows Containers, however needs to be installed separately. The following PowerShell commands will install and perform basic configuration of the Docker engine and Docker client. For detailed information on configuring the Docker engine, including securing the Docker engine on Windows see, [Docker Daemon on Windows](../docker/docker_daemon_windows.md).

Nano Server does not currently support the `Invoke-WebRequest` command. Run this commands on a remote system and copy `dockerd.exe` and `docker.exe` to `c:\program files\docker` of the Nano Server container host.

```none
# Download Docker Engine and Docker Client
Invoke-WebRequest https://aka.ms/tp5/dockerd -OutFile ./dockerd.exe
Invoke-WebRequest https://aka.ms/tp5/dockerd -OutFile ./docker.exe
```

Run the following commands to add the Docker program folder to the Windows path and then to configure the Docker service.

```none
# Add Docker folder to path
$env:Path += ";$env:programfiles\docker"

# Install Docker Engine as a Windows Service
dockerd --register-service
```

### Install Base OS Image

Container OS images can be found and installed using the ContainerImage PowerShell module. Before using this module, it will need to be installed. The following command can be used to install the module. For more information on using the Container Image OneGet PowerShell module see, [Container Image Provider](https://github.com/PowerShell/ContainerProvider). 

```none
Install-PackageProvider ContainerImage -Force
```

To download and install the Nano Server base OS image, run the following.

```none
Install-ContainerImage -Name NanoServer
```


After installing the Nano Server Base OS image, it will need to be tagged with a version of ‘latest’. To do so, use the `docker tag` command. For more information on `docker tag` see [Tag, push, and pull you images on docker.com](https://docs.docker.com/mac/step_six/). 

```none
docker tag <image id> nanoserver:latest
``` 

## Windows 10

### Install container feature

To enable the container feature using PowerShell, run the following command in an elevated PowerShell session.

```none
Enable-WindowsOptionalFeature -Online -FeatureName containers –All
```

Because Windows 10 only supports Hyper-V containers, the Hyper-V feature must be enabled. To enable the Hyper-V feature using PowerShell, run the following command in an elevated PowerShell session.

```none
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Hyper-V –All
```

### Install Docker

Docker is required to manage Windows Containers, however needs to be installed separately. The following PowerShell commands will install and perform basic configuration of the Docker engine and Docker client. For detailed information on configuring the Docker engine, including securing the Docker engine on Windows see, [Docker Daemon on Windows](../docker/docker_daemon_windows.md).

```none
# Download Docker Engine
Invoke-WebRequest https://aka.ms/tp5/dockerd -OutFile $env:programfiles\docker\dockerd.exe

# Add Docker folder to the path
$env:Path += ";$env:programfiles\docker"

# Install Docker Engine as a Windows Service
dockerd --register-service
```

The following command will download the Docker client.

```none
# Download Docker Client
Invoke-WebRequest https://aka.ms/tp5/docker -OutFile $env:programfiles\docker\docker.exe
```

### Install Base OS Image

Container OS images can be found and installed using the ContainerImage PowerShell module. Before using this module, it will need to be installed. The following command can be used to install the module. For more information on using the Container Image OneGet PowerShell module see, [Container Image Provider](https://github.com/PowerShell/ContainerProvider). 

```none
Install-PackageProvider ContainerImage -Force
```

To download and install the Nano Server base OS image, run the following.

```none
Install-ContainerImage -Name NanoServer
```

After installing the Nano Server Base OS image, it will need to be tagged with a version of ‘latest’. To do so, use the `docker tag` command. For more information on `docker tag` see [Tag, push, and pull you images on docker.com](https://docs.docker.com/mac/step_six/). 

```none
docker tag <image id> nanoserver:latest
``` 

## Azure

### Azure template

The Windows container feature can be configured in Azure using the methods detailed in previous sections of this document. Additionally, the following template can be used to deploy a Windows container ready virtual machine.

> Azure does not support Hyper-V containers.

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FAzure%2Fazure-quickstart-templates%2Fmaster%2Fwindows-server-containers-preview%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

## Next Steps

[Docker on Windows Quick Start](./manage_docker.md)
