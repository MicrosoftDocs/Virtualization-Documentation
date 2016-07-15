---
title: Configure Docker in Windows
description: Configure Docker in Windows
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 07/15/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 6885400c-5623-4cde-8012-f6a00019fafa
---

# Docker Daemon on Windows

The Docker engine is not included with Windows and will need to be installed and configured individually. Furthermore, the Docker daemon can accept many custom configurations. Some examples include configuring how the daemon accepts incoming requests, default networking options, and debug / log settings. On Windows, these configurations can be specified in a configuration file or by using Windows Service control manager. This document will detail how to install and configure the docker daemon, and will also provide some examples of commonly used configurations.

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

Add the Docker directory to the system path. When complete, restart the PowerShell session so that the modified path is recognized.

```none
[Environment]::SetEnvironmentVariable("Path", $env:Path + ";C:\Program Files\Docker", [EnvironmentVariableTarget]::Machine)
```

To install Docker as a Windows service, run the following.

```none
dockerd --register-service
```

Once installed, the service can be started.

```none
Start-Service Docker
```

Before Docker can be used container images will need to be installed. For more information see, [Manage Container Images](../management/manage_images.md).

## Docker Configuration File

The preferred method for configuring the Docker daemon on Windows is using a configuration file. The configuration file can be found at 'c:\ProgramData\docker\config\daemon.json'. If this file does not already exist, it can be created.

Note – not every available Docker configuration option is applicable to Docker on Windows. The below example shows those that are. For complete documentation on Docker daemon configuration, including for Linux, see [Docker Daemon]( https://docs.docker.com/v1.10/engine/reference/commandline/daemon/).

```none
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
    "graph": "",
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

Only the desired configuration changes need to be added to the configuration file. For example, this sample configures the Docker daemon to accept incoming connections on port 2375. All other configuration options will use default values.

```none
{
    "hosts": ["tcp://0.0.0.0:2375"]
}
```

Likewise, this sample configures the Docker daemon to only accept secured connections over port 2376.

```none
{
    "hosts": ["tcp://0.0.0.0:2376", "npipe://"],
    "tlsverify": true,
    "tlscacert": "C:\\ProgramData\\docker\\certs.d\\ca.pem",
    "tlscert": "C:\\ProgramData\\docker\\certs.d\\server-cert.pem",
    "tlskey": "C:\\ProgramData\\docker\\certs.d\\server-key.pem",
}
```

## Service Control Manager

The Docker daemon can also be configured by modifying the Docker service using `sc config`. Using this method, Docker daemon flags are set directly on the Docker service.


```none
sc config docker binpath= "\"C:\Program Files\docker\dockerd.exe\" --run-service -H tcp://0.0.0.0:2375"
```

## Common Configuration

The following configuration file examples show common Docker configurations. These can be combined into a single configuration file.

### Default Network Creation 

To configure the Docker daemon so that a default NAT network is not created, use the following. For more information, see [Manage Docker Networks](../management/container_networking.md).

```none
{
    "bridge" : "none"
}
```

### Set Docker Security Group

When logged into the Docker host and running Docker commands locally, these commands are run through a named pipe. By default, only members of the Administrators group can access the Docker daemon through the named pipe. To specify a security group that has this access, use the `group` flag.

```none
{
    "group" : "docker"
}
```

## Proxy Configuration

To set proxy information for `docker search` and `docker pull`, create a Windows environment variable with the name `HTTP_PROXY` or `HTTPS_PROXY`, and a value of the proxy information. This can be completed with PowerShell using a command similar to this:

```none
[Environment]::SetEnvironmentVariable("HTTP_PROXY”, “http://username:password@proxy:port/”, [EnvironmentVariableTarget]::Machine)
```

Once the variable has been set, restart the Docker service.

```none
restart-service docker
```

For more information see, [Daemon Socket Options on Docker.com](https://docs.docker.com/v1.10/engine/reference/commandline/daemon/#daemon-socket-option).

## Collecting Logs
The Docker daemon logs to the Windows 'Application' event log, rather than to a file. These logs can easily be read, sorted, and filtered using Windows PowerShell

For example, this will show the Docker daemon logs from the last 5 minutes starting with the oldest.
```
Get-EventLog -LogName Application -Source Docker -After (Get-Date).AddMinutes(-5) | Sort-Object Time 
```

This could also easily be piped into a CSV file to be read by another tool or spreadsheet.
```
Get-EventLog -LogName Application -Source Docker -After (Get-Date).AddMinutes(-30)  | Sort-Object Time | Export-CSV ~/last30minutes.csv ```
