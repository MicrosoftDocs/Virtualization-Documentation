---
title: Configure Docker in Windows
description: Configure Docker in Windows.
author: PatrickLang
ms.author: jgerend
ms.date: 05/03/2019
ms.topic: overview
ms.assetid: 6885400c-5623-4cde-8012-f6a00019fafa
---
# Docker Engine on Windows

> Applies to: Windows Server 2022, Windows Server 2019, Windows Server 2016

The Docker Engine and client aren't included with Windows and need to be installed and configured individually. Furthermore, the Docker Engine can accept many custom configurations. Some examples include configuring how the daemon accepts incoming requests, default networking options, and debug/log settings. On Windows, these configurations can be specified in a configuration file or by using Windows Service control manager. This document details how to install and configure the Docker Engine, and also provides some examples of commonly used configurations.

## Install Docker

You need Docker in order to work with Windows Containers. Docker consists of the Docker Engine (dockerd.exe), and the Docker client (docker.exe). The easiest way to get everything installed is in the quickstart guide, which will help you get everything set up and run your first container.

- [Install Docker](../quick-start/set-up-environment.md)

For scripted installations, see [Use a script to install Docker EE](https://docs.mirantis.com/docker-enterprise/v3.1/dockeree-products/mcr/mcr-windows.html).

Before you can use Docker, you'll need to install the container images. For more information, see [docs for our container base images](../manage-containers/container-base-images.md).

## Configure Docker with a configuration file

The preferred method for configuring the Docker Engine on Windows is using a configuration file. The configuration file can be found at 'C:\ProgramData\Docker\config\daemon.json'. You can create this file if it doesn't already exist.

>[!NOTE]
>Not every available Docker configuration option applies to Docker on Windows. The following example shows the configuration options that do apply. For more information about Docker Engine configuration, see [Docker daemon configuration file](https://docs.docker.com/engine/reference/commandline/dockerd/#/windows-configuration-file).

```json
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

You only need to add the desired configuration changes to the configuration file. For example, the following sample configures the Docker Engine to accept incoming connections on port 2375. All other configuration options will use default values.

```json
{
    "hosts": ["tcp://0.0.0.0:2375"]
}
```

Likewise, the following sample configures the Docker daemon to keep images and containers in an alternate path. If not specified, the
default is `c:\programdata\docker`.

```json
{   
    "data-root": "d:\\docker"
}
```

The following sample configures the Docker daemon to only accept secured connections over port 2376.

```json
{
    "hosts": ["tcp://0.0.0.0:2376", "npipe://"],
    "tlsverify": true,
    "tlscacert": "C:\\ProgramData\\docker\\certs.d\\ca.pem",
    "tlscert": "C:\\ProgramData\\docker\\certs.d\\server-cert.pem",
    "tlskey": "C:\\ProgramData\\docker\\certs.d\\server-key.pem",
}
```

## Configure Docker on the Docker service

The Docker Engine can also be configured by modifying the Docker service with `sc config`. Using this method, Docker Engine flags are set directly on the Docker service. Run the following command in a command prompt (cmd.exe not PowerShell):

```cmd
sc config docker binpath= "\"C:\Program Files\docker\dockerd.exe\" --run-service -H tcp://0.0.0.0:2375"
```

>[!NOTE]
>You don't need to run this command if your daemon.json file already contains the `"hosts": ["tcp://0.0.0.0:2375"]` entry.

## Common configuration

The following configuration file examples show common Docker configurations. These can be combined into a single configuration file.

### Default network creation

To configure the Docker Engine so that it doesn't create a default NAT network, use the following configuration.

```json
{
    "bridge" : "none"
}
```

For more information, see [Manage Docker Networks](../container-networking/network-drivers-topologies.md).

### Set Docker security group

When you've signed in to the Docker host and are locally running Docker commands, these commands are run through a named pipe. By default, only members of the Administrators group can access the Docker Engine through the named pipe. To specify a security group that has this access, use the `group` flag.

```json
{
    "group" : "docker"
}
```

## Proxy configuration

To set proxy information for `docker search` and `docker pull`, create a Windows environment variable with the name `HTTP_PROXY` or `HTTPS_PROXY`, and a value of the proxy information. This can be completed with PowerShell using a command similar to this:

```powershell
[Environment]::SetEnvironmentVariable("HTTP_PROXY", "http://username:password@proxy:port/", [EnvironmentVariableTarget]::Machine)
```

Once the variable has been set, restart the Docker service.

```powershell
Restart-Service docker
```

For more information, see [Windows Configuration File on Docker.com](https://docs.docker.com/engine/reference/commandline/dockerd/#/windows-configuration-file).

## How to uninstall Docker

This section will tell you how to uninstall Docker and perform a full cleanup of Docker system components from your Windows 10 or Windows Server 2016 system.

>[!NOTE]
>You must run all commands in these instructions from an elevated PowerShell session.

### Prepare your system for Docker's removal

Before you uninstall Docker, make sure no containers are running on your system.

Run the following cmdlets to check for running containers:

```powershell
# Leave swarm mode (this will automatically stop and remove services and overlay networks)
docker swarm leave --force

# Stop all running containers
docker ps --quiet | ForEach-Object {docker stop $_}
```

It's also good practice to remove all containers, container images, networks, and volumes from your system before removing Docker. You can do this by running the following cmdlet:

```powershell
docker system prune --volumes --all
```

### Uninstall Docker

Next, you'll need to actually uninstall Docker.

To uninstall Docker on Windows 10

- Go to **Settings** > **Apps** on your Windows 10 machine
- Under **Apps & Features**, find **Docker for Windows**
- Go to **Docker for Windows** > **Uninstall**

To uninstall Docker on Windows Server 2016:

From an elevated PowerShell session, use the **Uninstall-Package** and **Uninstall-Module** cmdlets to remove the Docker module and its corresponding Package Management Provider from your system, as shown in the following example:

```powershell
Uninstall-Package -Name docker -ProviderName DockerMsftProvider
Uninstall-Module -Name DockerMsftProvider
```

>[!TIP]
>You can find the Package Provider that you used to install Docker with `PS C:\> Get-PackageProvider -Name *Docker*`

### Clean up Docker data and system components

After you uninstall Docker, you'll need to remove Docker's default networks so their configuration won't remain on your system after Docker is gone. You can do this by running the following cmdlet:

```powershell
Get-HNSNetwork | Remove-HNSNetwork
```

To remove Docker's default networks on Windows Server 2016.
```powershell
Get-ContainerNetwork | Remove-ContainerNetwork
```

Run the following cmdlet to remove Docker's program data from your system:

```powershell
Remove-Item "C:\ProgramData\Docker" -Recurse
```

You may also want to remove the Windows optional features associated with Docker/containers on Windows.

This includes the "Containers" feature, which is automatically enabled on any Windows 10 or Windows Server 2016 when Docker is installed. It may also include the "Hyper-V" feature, which is automatically enabled on Windows 10 when Docker is installed, but must be explicitly enabled on Windows Server 2016.

>[!IMPORTANT]
>[The Hyper-V feature](/virtualization/hyper-v-on-windows/about/) is a general virtualization feature that enables much more than just containers. Before disabling the Hyper-V feature, make sure there are no other virtualized components on your system that require Hyper-V.

To remove Windows features on Windows 10:

- Go to **Control Panel** > **Programs** > **Programs and Features** > **Turn Windows features on or off**.
- Find the name of the feature or features you want to disable—in this case, **Containers** and (optionally) **Hyper-V**.
- Uncheck the box next to the name of the feature you want to disable.
- Select **"OK"**

To remove Windows features on Windows Server 2016:

From an elevated PowerShell session, run the following cmdlets to disable the **Containers** and (optionally) **Hyper-V** features from your system:

```powershell
Remove-WindowsFeature Containers
Remove-WindowsFeature Hyper-V
```

### Reboot your system

To finish uninstallation and cleanup, run the following cmdlet from an elevated PowerShell session to reboot your system:

```powershell
Restart-Computer -Force
```