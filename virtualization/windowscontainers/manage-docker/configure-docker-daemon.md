---
title: Configure Docker in Windows
description: Configure Docker in Windows
keywords: docker, containers
author: PatrickLang
ms.date: 08/23/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 6885400c-5623-4cde-8012-f6a00019fafa
---

# Docker Engine on Windows

The Docker Engine and client are not included with Windows and will need to be installed and configured individually. Furthermore, the Docker Engine can accept many custom configurations. Some examples include configuring how the daemon accepts incoming requests, default networking options, and debug/log settings. On Windows, these configurations can be specified in a configuration file or by using Windows Service control manager. This document will detail how to install and configure the Docker Engine, and will also provide some examples of commonly used configurations.


## Install Docker
Docker is required in order to work with Windows Containers. Docker consists of the Docker Engine (dockerd.exe), and the Docker client (docker.exe). The easiest way to get everything installed is in the quick start guides. They will help you get everything set up and run your first container. 

* [Windows Containers on Windows Server 2016](../quick-start/quick-start-windows-server.md)
* [Windows Containers on Windows 10](../quick-start/quick-start-windows-10.md)

### Manual Installation
If you would like to use an in-development version of the Docker Engine and client instead, you can use the steps that follow. This will install both the Docker Engine and client. If you are a developer testing new features or using a Windows Insider build, you may need to use an in-development version of Docker. Otherwise, follow the steps in the Install Docker section above to get the latest released versions.

> If you have installed Docker for Windows, be sure to remove it before you follow these manual installation steps. 

Download the Docker Engine

The latest version may always be found at https://master.dockerproject.org . This sample uses the latest from the master branch. 

```powershell
Invoke-WebRequest "https://master.dockerproject.org/windows/x86_64/docker.zip" -OutFile "$env:TEMP\docker.zip" -UseBasicParsing
```

Expand the zip archive into Program Files.

```powershell
Expand-Archive -Path "$env:TEMP\docker.zip" -DestinationPath $env:ProgramFiles
```

Add the Docker directory to the system path. When complete, restart the PowerShell session so that the modified path is recognized.

```powershell
# Add path to this PowerShell session immediately
$env:path += ";$env:ProgramFiles\Docker"

# For persistent use after a reboot
$existingMachinePath = [Environment]::GetEnvironmentVariable("Path",[System.EnvironmentVariableTarget]::Machine)
[Environment]::SetEnvironmentVariable("Path", $existingMachinePath + ";$env:ProgramFiles\Docker", [EnvironmentVariableTarget]::Machine)
```

To install Docker as a Windows service, run the following.

```
dockerd --register-service
```

Once installed, the service can be started.

```powershell
Start-Service Docker
```

Before Docker can be used container images will need to be installed. For more information see, [the quick start guide for using images](../quick-start/quick-start-images.md).

## Configure Docker with Configuration File

The preferred method for configuring the Docker Engine on Windows is using a configuration file. The configuration file can be found at 'C:\ProgramData\Docker\config\daemon.json'. If this file does not already exist, it can be created.

Note – not every available Docker configuration option is applicable to Docker on Windows. The below example shows those that are. For complete documentation on Docker Engine configuration, see [Docker daemon configuration file](https://docs.docker.com/engine/reference/commandline/dockerd/#/windows-configuration-file).

```
{
    "authorization-plugins": [],
    "dns": [],
    "dns-opts": [],
    "dns-search": [],
    "exec-opts": [],
    "storage-driver": "",
    "storage-opts": [],
    "labels": [],
    "log-driver": "", 
    "mtu": 0,
    "pidfile": "",
    "data-root": "",
    "cluster-store": "",
    "cluster-advertise": "",
    "debug": true,
    "hosts": [],
    "log-level": "",
    "tlsverify": true,
    "tlscacert": "",
    "tlscert": "",
    "tlskey": "",
    "group": "",
    "default-ulimits": {},
    "bridge": "",
    "fixed-cidr": "",
    "raw-logs": false,
    "registry-mirrors": [],
    "insecure-registries": [],
    "disable-legacy-registry": false
}
```

Only the desired configuration changes need to be added to the configuration file. For example, this sample configures the Docker Engine to accept incoming connections on port 2375. All other configuration options will use default values.

```
{
    "hosts": ["tcp://0.0.0.0:2375"]
}
```

Likewise this sample configures the Docker daemon to keep images and containers in an alternate path. If not specified, the
default is c:\programdata\docker.

```
{    
    "data-root": "d:\\docker"
}
```

Likewise, this sample configures the Docker daemon to only accept secured connections over port 2376.

```
{
    "hosts": ["tcp://0.0.0.0:2376", "npipe://"],
    "tlsverify": true,
    "tlscacert": "C:\\ProgramData\\docker\\certs.d\\ca.pem",
    "tlscert": "C:\\ProgramData\\docker\\certs.d\\server-cert.pem",
    "tlskey": "C:\\ProgramData\\docker\\certs.d\\server-key.pem",
}
```

## Configure Docker on the Docker Service

The Docker Engine can also be configured by modifying the Docker service using `sc config`. Using this method, Docker Engine flags are set directly on the Docker service. Run the following command in a command prompt (cmd.exe not PowerShell):


```
sc config docker binpath= "\"C:\Program Files\docker\dockerd.exe\" --run-service -H tcp://0.0.0.0:2375"
```

Note: You do not need to run this command if your daemon.json file already contains the `"hosts": ["tcp://0.0.0.0:2375"]` entry.

## Common Configuration

The following configuration file examples show common Docker configurations. These can be combined into a single configuration file.

### Default Network Creation 

To configure the Docker Engine so that a default NAT network is not created, use the following. For more information, see [Manage Docker Networks](../manage-containers/container-networking.md).

```
{
    "bridge" : "none"
}
```

### Set Docker Security Group

When logged into the Docker host and running Docker commands locally, these commands are run through a named pipe. By default, only members of the Administrators group can access the Docker Engine through the named pipe. To specify a security group that has this access, use the `group` flag.

```
{
    "group" : "docker"
}
```

## Proxy Configuration

To set proxy information for `docker search` and `docker pull`, create a Windows environment variable with the name `HTTP_PROXY` or `HTTPS_PROXY`, and a value of the proxy information. This can be completed with PowerShell using a command similar to this:

```powershell
[Environment]::SetEnvironmentVariable("HTTP_PROXY", "http://username:password@proxy:port/", [EnvironmentVariableTarget]::Machine)
```

Once the variable has been set, restart the Docker service.

```powershell
Restart-Service docker
```

For more information see, [Windows Configuration File on Docker.com](https://docs.docker.com/engine/reference/commandline/dockerd/#/windows-configuration-file).

## Uninstall Docker
*Use the steps in this section to uninstall Docker and perform a full cleanup of Docker system components from your Windows 10 or Windows Server 2016 system.*

> Note: All commands in the steps below must be run from an **elevated** PowerShell session.

### STEP 1: Prepare your system for Docker's removal 
If you haven't already, it's good practice to make sure no containers are running on your system before removing Docker. Here are some useful commands for doing that:
```
# Leave swarm mode (this will automatically stop and remove services and overlay networks)
docker swarm leave --force

# Stop all running containers
docker ps --quiet | ForEach-Object {docker stop $_}
```
It's also good practice to remove all containers, container images, networks and volumes from your system before removing Docker:
```
docker system prune --volumes --all
```

### STEP 2: Uninstall Docker 

#### ***Steps to uninstall Docker on Windows 10:***
- Go to **"Settings" > "Apps"** on your Windows 10 machine
- Under **"Apps & Features"**, find **"Docker for Windows"**
- Click **"Docker for Windows" > "Uninstall"**

#### ***Steps to uninstall Docker on Windows Server 2016:***
From an elevated PowerShell session, use the `Uninstall-Package` and `Uninstall-Module` cmdlets to remove the Docker module and its corresponding Package Management Provider from your system. 
> Tip: You can find the Package Provider that you used to install Docker with `PS C:\> Get-PackageProvider -Name *Docker*`

*For example*:
```
Uninstall-Package -Name docker -ProviderName DockerMsftProvider
Uninstall-Module -Name DockerMsftProvider
```

### STEP 3: Cleanup Docker data and system components
Remove Docker's default networks, so that their configuration won't stick around on your system once Docker is gone:
```
Get-HNSNetwork | Remove-HNSNetwork
```
Remove Docker's program data from your system:
```
Remove-Item "C:\ProgramData\Docker" -Recurse
```
You may also want to remove the Windows optional features associated with Docker/containers on Windows. At a minimum, this includes the "Containers" feature, which is automatically enabled on any Windows 10 or Windows Server 2016 when Docker is installed. It may also include the Hyper-V feature, which is automatically enabled on Windows 10 when Docker is installed, but must be explicitly enabled on Windows Server 2016.
> **Important note:** [The Hyper-V feature](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/about/) is a general virtualization feature that enables much more than just containers! Before disabling the Hyper-V feature, make sure there are no other virtualized components on your system that require it! For example, you probably don't want to disable the Hyper-V feature if you have any virtual machines on your system that are running using Hyper-V.

#### ***Steps to remove Windows features on Windows 10:***
- Go to **"Control Panel" > "Programs" > "Programs and Features" > "Turn Windows features on or off"** on your Windows 10 machine
- Find the name of the feature/s you would like to disable--in this case, **"Containers"** and (optionally) **"Hyper-V"**
- Uncheck the box next to the name of the feature you would like to disable
- Click **"OK"**

#### ***Steps to remove Windows features on Windows Server 2016:***

### STEP 4: Reboot your system
From an elevated PowerShell session, run:
```
Restart-Computer -Force
```
