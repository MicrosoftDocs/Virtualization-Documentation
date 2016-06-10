---
title: Configure Docker in Windows
description: Configure Docker in Windows
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 06/02/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 6885400c-5623-4cde-8012-f6a00019fafa
---

The Docker daemon includes many different configuration options. Some examples include configuring how the daemon accepts incoming requests, default networking options, and debug / log settings. On Windows, these configurations can be specified in a configuration file or by using Windows Service control manager. This document will detail how to configure the docker daemon with both methods, and also provide some examples of commonly used configurations.

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
