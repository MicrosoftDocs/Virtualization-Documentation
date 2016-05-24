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

Before starting the configuration of Windows container on Nano server, you will need a system running Nano Server and also have a remote PowerShell connection with this system.

For more information on deploying Nano Server, see [Getting Started with Nano Server]( https://technet.microsoft.com/en-us/library/mt126167.aspx).

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
```

Download the Docker daemon and copy it to ` $env:programfiles\docker` of the Docker host.

```
# Download Docker Engine
Invoke-WebRequest https://master.dockerproject.org/windows/amd64/dockerd-1.12.0-dev.exe -OutFile .\dockerd.exe
```

Create a Docker daemon configuration file `c:\ProgramData\docker\config\daemon.json`

```none
new-item -Type File c:\ProgramData\docker\config\daemon.json
```

Install Docker as a Windows service, run the following.

```none
& 'C:\Program Files\docker\dockerd.exe' --register-service
```

## 3. Install Base Container Images

Base OS images are used as the base to any Windows Server or Hyper-V container. Base OS images are available with both Windows Server Core and Nano Server as the underlying operating system and can be installed using the container Provider PowerShell module.

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

## 4. Work with Docker on Nano Server

For the best experience, manage Docker on Nano Server from a remote system. In order to do so, the following items need to be completed.

Create a firewall rule for the Docker connection, this will be port `2375` or an insecure connection, or port `2376` for a secure connection.

```none
netsh advfirewall firewall add rule name="Docker daemon " dir=in action=allow protocol=TCP localport=2376
```

Configure the Docker daemon configuration file to accept remote connections. This file is located at `c:\ProgramData\docker\config\daemon.json` on the Nano Server host.

Copying these content into the file will allow the Docker daemon to accept all unsecure requests. This is not advised but can be used for isolated testing.

```none
{
    "hosts": ["tcp://0.0.0.0:2375", "npipe://"]
}
```

The following example will configure a secure remote connection. The TLS certificates will need to be created and copied to the proper locations. For more information see, []().

```none
ADD Example
```

Download the Docker client to the remote management system.

```none
# Create Docker directory
New-Item -Type Directory $env:programfiles\docker

# Download client
Invoke-WebRequest https://master.dockerproject.org/windows/amd64/docker.exe -OutFile $env:programfiles\docker\docker.exe

# Set path environment variable
[Environment]::SetEnvironmentVariable("Path",$Env:Path + ";%programfiles%\docker", "Machine")
```

Once completed the Docker daemon can be accessed with the `Docker -H` parameter.

```