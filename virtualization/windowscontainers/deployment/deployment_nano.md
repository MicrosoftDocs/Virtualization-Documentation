---
title: Deploy Windows Containers on Nano Server
description: Deploy Windows Containers on Nano Server
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 07/06/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: b82acdf9-042d-4b5c-8b67-1a8013fa1435
---

# Container host deployment - Nano Server

**This is preliminary content and subject to change.** 

This document will step through a very basic Nano Server deployment with the Windows container feature. This is an advanced topic and assumes a general understanding of Windows and Windows containers. For an introduction to Windows containers, see [Windows Containers Quick Start](../quick_start/quick_start.md).

## Prepare Nano Server

The following section will detail the deployment of a very basic Nano Server configuration. For a more through explanation of deployment and configuration options for Nano Server, see [Getting Started with Nano Server] (https://technet.microsoft.com/en-us/library/mt126167.aspx).

### Create Nano Server VM

First download the Nano Server evaluation VHD from [this location](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/nano_eula). Create a virtual machine from this VHD, start the virtual machine, and connect to it using the Hyper-V connect option, or equivalent based on the virtualization platform being used.

Next, the administrative password will need to be set. To do so pre `F11` on the Nano Server recovery console. This will provide the change password dialog.

### Create Remote PowerShell Session

Because Nano Server does not have interactive log on capabilities, all management will be completed from a remote PowerShell session. To create the remote session, get the IP address of the system using the networking section of the Nano Server recovery console, and then run the following commands on the remote host. Replace IPADDRESS with the actual IP address of Nano Server system.

Add the Nano Server system to trusted hosts.

```none
set-item WSMan:\localhost\Client\TrustedHosts IPADDRESS -Force
```

Create the remote PowerShell session.

```none
Enter-PSSession -ComputerName IPADDRESS -Credential ~\Administrator
```

When these steps have been completed, you will be in remote PowerShell session with the Nano Server system. The remainder of this document, unless noted otherwise, will take place from the remote session.


## Install Container Feature

The Nano Server package management provider allows roles and features to be installed on Nano Server. Install the provider using this command.

```none
Install-PackageProvider NanoServerPackage
```

After the package provide has been installed, install the container feature.

```none
Install-NanoServerPackage -Name Microsoft-NanoServer-Containers-Package
```

The Nano Server host will need to be re-booted after the container features has been installed. 

```none
Restart-Computer
```

Once it is back up, re-establish the remote PowerShell connection.

## Install Docker

Docker is required in order to work with Windows containers. Docker consists of the Docker Engine, and the Docker client. Install the Docker Engine and client using these steps.

Create a folder on the Nano Server host for the Docker executables.

```none
New-Item -Type Directory -Path $env:ProgramFiles'\docker\'
```

Download the Docker Engine and client and copy these into 'C:\Program Files\docker\' of the container host. 

**Note** - Nano Server does not currently support `Invoke-WebRequest`, the downloads will need to be completed from a remote system and then copied to the Nano Server host.

```none
Invoke-WebRequest https://aka.ms/tp5/b/dockerd -OutFile .\dockerd.exe
```

Download the Docker client.

```none
Invoke-WebRequest https://aka.ms/tp5/b/docker -OutFile .\docker.exe
```

Once the Docker Engine and client have been downloaded, copy them to the 'C:\Program Files\docker\' folder in the Nano Server container host. The Nano Server firewall will need to be configured to allow incoming SMB connections. This can be completed using PowerShell or the Nano Server recovery console. 

```none
Set-NetFirewallRule -Name FPS-SMB-In-TCP -Enabled True
```

The files can now be copied using and standard SMB file copy methods.

With the dockerd.exe file copied to the host, run this command to install Docker as a Windows service.

```none
& $env:ProgramFiles'\docker\dockerd.exe' --register-service
```

Start the Docker service.

```none
Start-Service Docker
```

## Install Base Container Images

Base OS images are used as the base to any Windows Server or Hyper-V container. Base OS images are available with both Windows Server Core and Nano Server as the underlying operating system and can be installed using the container image provider. For detailed information on Windows container images, see [Managing Container Images](../management/manage_images.md).

The following command can be used to install the container image provider.

```none
Install-PackageProvider ContainerImage -Force
```

To download and install the Nano Server base image, run the following:

```none
Install-ContainerImage -Name NanoServer
```

**Note** - At this time, only the Nano Server base image is compatible with a Nano Server container host.

Restart the Docker service.

```none
Restart-Service Docker
```

Tag the Nano Server base image as latest.

```none
& $env:ProgramFiles'\docker\docker.exe' tag nanoserver:10.0.14300.1016 nanoserver:latest
```

## Manage Docker on Nano Server

For the best experience, and as a best practice, manage Docker on Nano Server from a remote system. In order to do so, the following items need to be completed.

### Prepare Container Host

Create a firewall rule on the container host for the Docker connection. This will be port `2375` for an unsecure connection, or port `2376` for a secure connection.

```none
netsh advfirewall firewall add rule name="Docker daemon " dir=in action=allow protocol=TCP localport=2376
```

Configure the Docker Engine to accept incoming connection over TCP.

First create a `daemon.json` file at `c:\ProgramData\docker\config\daemon.json` on the Nano Server host.

```none
new-item -Type File c:\ProgramData\docker\config\daemon.json
```

Next, run the following command to add connection configuration to the `daemon.json` file. This configures the Docker Engine to accept incoming connections over TCP port 2375. This is an unsecure connection and is not advised, but can be used for isolated testing. For more information on securing this connection, see [Protect the Docker Daemon on Docker.com](https://docs.docker.com/engine/security/https/).

```none
Add-Content 'c:\programdata\docker\config\daemon.json' '{ "hosts": ["tcp://0.0.0.0:2375", "npipe://"] }'
```

Restart the Docker service.

```none
Restart-Service docker
```

### Prepare Remote Client

On the remote system where you will be working, create a directory to hold the Docker client.

```none
New-Item -Type Directory -Path 'C:\Program Files\docker\'
```

Download the Docker client into this directory.

```none
Invoke-WebRequest https://aka.ms/tp5/b/docker -OutFile "$env:ProgramFiles\docker\docker.exe"
```

Add the Docker directory to the system path.

```none
$env:Path += ";$env:ProgramFiles\Docker"
```

Restart the PowerShell or command session so that the modified path is recognized.

Once completed the remote Docker host can be accessed with the `docker -H` parameter.

```none
docker -H tcp://<IPADDRESS>:2375 run -it nanoserver cmd
```

An environmental variable `DOCKER_HOST` can be created which will remove the `-H` parameter requirement. The following PowerShell command can be used for this.

```none
$env:DOCKER_HOST = "tcp://<ipaddress of server>:2375"
```

With this variable set, the command would now look like this.

```none
docker run -it nanoserver cmd
```

## Hyper-V Container Host

In order to deploy Hyper-V containers, the Hyper-V role will be required on the container host. For more information on Hyper-V containers, see [Hyper-V Containers](../management/hyperv_container.md).

If the Windows container host is itself a Hyper-V virtual machine, nested virtualization will need to be enabled. For more information on nested virtualization, see [Nested Virtualization](https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/nesting).


Install the Hyper-V role on the Nano Server container host.

```none
Install-NanoServerPackage Microsoft-NanoServer-Compute-Package
```

The Nano Server host will need to be re-booted after the Hyper-V role has been installed.

```none
Restart-Computer
```