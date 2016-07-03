---
title: Deploy Windows Containers on Nano Server
description: Deploy Windows Containers on Nano Server
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 06/17/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: b82acdf9-042d-4b5c-8b67-1a8013fa1435
---

# Container host deployment - Nano Server

**This is preliminary content and subject to change.** 

Before starting the configuration of Windows container on Nano server, you will need a system running Nano Server and also have a remote PowerShell connection with this system. For more information on deploying and connecting with Nano Server, see [Getting Started with Nano Server]( https://technet.microsoft.com/en-us/library/mt126167.aspx).

An evaluation copy of Nano Server can be found [here](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/nano_eula).

## Install Container Feature

Install the Nano Server package management provider.

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

## Install Docker

Docker is required in order to work with Windows containers. Docker consists of the Docker Engine, and the Docker client. Install the Docker daemon and client using these steps.

Create a folder on the Nano Server host for the Docker executables.

```none
New-Item -Type Directory -Path 'C:\Program Files\docker\'
```

Download the Docker daemon and client and copy these into 'C:\Program Files\docker\' of the container host. 

**Note** - Nano Server does not currently support `Invoke-WebRequest`, the downloads will need to be completed from a remote system.

```none
Invoke-WebRequest https://aka.ms/tp5/b/dockerd -OutFile .\dockerd.exe
```

Download the Docker client.

```none
Invoke-WebRequest https://aka.ms/tp5/b/docker -OutFile .\docker.exe
```

Once the Docker daemon and client have been downloaded and copied into the Nano Server container host, run this command on the host to install Docker as a Windows service.

```none
& 'C:\Program Files\docker\dockerd.exe' --register-service
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
& 'C:\Program Files\docker\docker.exe' tag nanoserver:10.0.14300.1016 nanoserver:latest
```

## Manage Docker on Nano Server

For the best experience and as a best practice, manage Docker on Nano Server from a remote system. In order to do so, the following items need to be completed.

**Prepare the Docker Daemon:**

Create a firewall rule on the container host for the Docker connection. This will be port `2375` for an insecure connection, or port `2376` for a secure connection.

```none
netsh advfirewall firewall add rule name="Docker daemon " dir=in action=allow protocol=TCP localport=2376
```

Configure the Docker daemon to accept incoming connection over TCP.

First create a `daemon.json` file at `c:\ProgramData\docker\config\daemon.json`.

```none
new-item -Type File c:\ProgramData\docker\config\daemon.json
```

Next, copy this JSON into the configuration file. This configures the Docker daemon to accept incoming connections over TCP port 2375. This is an insecure connection and is not advised, but can be used for isolated testing.

```none
{
    "hosts": ["tcp://0.0.0.0:2375", "npipe://"]
}
```

The following example will configure a secure remote connection. The TLS certificates will need to be created and copied to the proper locations. For more information see, [Docker Daemon on Windows](./docker_windows.md).

```none
{
    "hosts": ["tcp://0.0.0.0:2376", "npipe://"],
    "tlsverify": true,
    "tlscacert": "C:\\ProgramData\\docker\\certs.d\\ca.pem",
    "tlscert": "C:\\ProgramData\\docker\\certs.d\\server-cert.pem",
    "tlskey": "C:\\ProgramData\\docker\\certs.d\\server-key.pem",
}
```

Restart the Docker service.

```none
Restart-Service docker
```

**Prepare the Docker Client:**

Create a directory to hold the Docker client.

```none
New-Item -Type Directory -Path 'C:\Program Files\docker\'
```

Download the Docker client on the remote management system.

```none
Invoke-WebRequest https://aka.ms/tp5/b/docker -OutFile "C:\Program Files\docker\docker.exe"
```

Add the Docker directory to the system path.

```none
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Docker", [EnvironmentVariableTarget]::Machine)
```

Restart the PowerShell or command session so that the modified path is recognized.

Once completed the remote Docker host can be accessed with the `docker -H` parameter.

```none
docker -H tcp://10.0.0.5:2375 run -it nanoserver cmd
```

An environmental variable `DOCKER_HOST` can be created which will remove the `-H` parameter requirement. The following PowerShell command can be used for this.

```none
$env:DOCKER_HOST = "tcp://<ipaddress of server:2375"
```

With this variable set, the command would now look like this.

```none
docker run -it nanoserver cmd
```

## Hyper-V Container Host

In order to deploy Hyper-V containers, the Hyper-V role will be required. For more information on Hyper-V containers, see [Hyper-V Containers](../management/hyperv_container.md).

If the Windows container host is itself a Hyper-V virtual machine, nested virtualization will need to be enabled. For more information on nested virtualization, see [Nested Virtualization](https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/nesting).


Install the Hyper-V role:

```none
Install-NanoServerPackage Microsoft-NanoServer-Compute-Package
```

The Nano Server host will need to be re-booted after the Hyper-V role has been installed.

```none
Restart-Computer
```



