---
title: Container Deployment Quick Start
description: Container deployment quick start
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 42ea9737-5d0d-447a-96d8-6fd5ed126b25
---

# Quick Start – configure a container host

**This is preliminary content and subject to change.** 

The Windows container feature is available on Windows Server 2016, Nano Server, and Windows 10 insider releases. A Windows container host can be deployed onto physical systems, on-premises virtual machines, and cloud hosted virtual machines. The steps to deploy a container host may vary by operating system, and system type. This document provides the details needed to quickly provision a Windows container host.

Use the navigation at the right hand side to select your desired deployment configuration.

## Windows Server

### Install container feature

The container feature can be installed on Windows Server 2016, or Windows Server 2016 Core, using Windows Server Manager or PowerShell.

To install the feature using PowerShell, run the following command in an elevated PowerShell session.

```none
Install-WindowsFeature containers
```

If Hyper-V containers will be deployed, the Hyper-V role will be required. If the container host is also a Hyper-V virtual machine, nested virtualization will need to be enabled. To do so, turn off the virtual machine and run the following commands. Once complete, turn the virtual machine back on.

This step can be skipped if the host is not virtualized, or will not be running Hyper-V containers.

```none
# Replace with the virtual machine name
$vm = "<virtual-machine>"

# Configure virtual processor
Set-VMProcessor -VMName $vm -ExposeVirtualizationExtensions $true -Count 2

# Disable dynamic memory
Set-VMMemory $vm -DynamicMemoryEnabled $false

# Enable mac spoofing
Get-VMNetworkAdapter -VMName $vm | Set-VMNetworkAdapter -MacAddressSpoofing On
```

Back in the virtual machine, the Hyper-V role can now be installed. Do so with the following command. This process will require a reboot.

```none
Install-WindowsFeature hyper-v
```

### Install Docker

Docker is required to manage Windows Containers, however needs to be installed separately. The following PowerShell commands will install and perform basic configuration of the Docker engine. For detailed information on configuring the Docker engine, including securing the Docker engine on Windows see, [Docker Daemon on Windows](../docker/docker_daemon_windows.md).

```none
# Create Docker directory
New-Item -Type Directory $env:programfiles\docker

# Download Docker Engine
Invoke-WebRequest https://master.dockerproject.org/windows/amd64/dockerd-1.12.0-dev.exe -OutFile $env:programfiles\docker\dockerd.exe

# Add Docker folder to the path
$env:Path += ";$env:programfiles\docker"

# Install Docker Engine as a Windows Service
dockerd --register-service
```

The following command will download the Docker client.

```none
# Download Docker Client
Invoke-WebRequest https://master.dockerproject.org/windows/amd64/docker.exe -OutFile $env:programfiles\docker\docker.exe
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


If Hyper-V containers will be deployed, the Hyper-V role will be required. If the container host is also a Hyper-V virtual machine, nested virtualization will need to be enabled. To do so, turn off the virtual machine and run the following commands. Once complete, turn the virtual machine back on.

This step can be skipped if the host is not virtualized, or will not be running Hyper-V containers.

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

Back in the virtual machine, the Hyper-V role can now be installed. Do so with the following command.

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

## Scripted Deployments

Scripts are available that will deploy Windows containers hosts. These scripts will eventually be deprecated. 

### New Virtual Machine

To deploy a new Hyper-V virtual machine, and configure this virtual machine as a Windows container host, run the following commands. This needs to be run on an existing Hyper-V host. 

```none
# Download configuration script.

wget -uri https://aka.ms/tp5/New-ContainerHost -OutFile c:\New-ContainerHost.ps1

# Run the configuration script – remove the Hyper-V parameter if Hyper-V containers will not be deployed.

powershell.exe -NoProfile -ExecutionPolicy Bypass c:\New-ContainerHost.ps1 -VMName MyContainerHost -WindowsImage ServerDatacenterCore –Hyperv
```

### Existing System

To configure an existing system as a Windows container host, run the following commands.

```none
# Download configuration script.

wget -uri https://aka.ms/tp5/Install-ContainerHost -OutFile C:\Install-ContainerHost.ps1

# Run the configuration script – remove the Hyper-V parameter if Hyper-V containers will not be deployed.

powershell.exe -NoProfile -ExecutionPolicy Bypass C:\Install-ContainerHost.ps1 -HyperV
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
 
## Next Steps

[Windows Server Containers - Quick Start](./manage_docker.md)

