---
title: Windows and Linux Containers on Windows 10
description: Container deployment quick start
keywords: docker, containers, LCOW
author: cwilhit
ms.date: 09/11/2019
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: bb9bfbe0-5bdc-4984-912f-9c93ea67105f
---

# Get Started: Configure Your Environment for Containers

This quickstart demonstrates how to:

> [!div class="checklist"]
> * Set up your environment for containers
> * Run your first container image
> * Containerize a simple .NET core application

## Prerequisites

<!-- start tab view -->
# [Windows Server](#tab/Windows-Server)

Please make sure you meet the following requirements:

- One computer system (physical or virtual) running Windows Server 2016 or later.

> [!NOTE]
> If you are using Windows Server 2019 Insider Preview, please update to [Window Server 2019 Evaluation](https://www.microsoft.com/evalcenter/evaluate-windows-server-2019 ).

# [Windows 10 Professional and Enterprise](#tab/Windows-10-Client)

Please make sure you meet the following requirements:

- One physical computer system running Windows 10 Professional or Enterprise with Anniversary Update (version 1607) or later.
- [Hyper-V](https://docs.microsoft.com/virtualization/hyper-v-on-windows/reference/hyper-v-requirements) should be enabled.

> [!NOTE]
>  Starting with the Windows 10 October Update 2018, we no longer disallow users from running a Windows container in process-isolation mode on Windows 10 Enterprise or Professional for dev/test purposes. See the [FAQ](../about/faq.md) to learn more. 
> 
> Windows Server Containers use Hyper-V isolation by default on Windows 10 in order to provide developers with the same kernel version and configuration that will be used in production. Learn more about Hyper-V isolation in the [Concepts](../manage-containers/hyperv-container.md) area of our docs.

---
<!-- stop tab view -->

## Install Docker

Docker is the definitive toolchain for working with Windows containers. Docker offers a CLI for users to manage containers on a given host, build containers, remove containers, and more. Learn more about Docker in the [Concepts](../manage-containers/configure-docker-daemon.md) area of our docs.

<!-- start tab view -->
# [Windows Server](#tab/Windows-Server)

On Windows Server, Docker is installed through a [OneGet provider PowerShell module](https://github.com/oneget/oneget) published by Microsoft called the [DockerMicrosoftProvider](https://github.com/OneGet/MicrosoftDockerProvider). This provider:

- enables the containers feature on your machine
- installs the Docker engine and client on your machine.

To install Docker, open an elevated PowerShell session and install the Docker-Microsoft PackageManagement Provider from the [PowerShell Gallery](https://www.powershellgallery.com/packages/DockerMsftProvider).

```powershell
Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
```

Next, use the PackageManagement PowerShell module to install the latest version of Docker.

```powershell
Install-Package -Name docker -ProviderName DockerMsftProvider
```

When PowerShell asks you whether to trust the package source 'DockerDefault', type `A` to continue the installation. After the installation complete, you must reboot the computer.

```powershell
Restart-Computer -Force
```

> [!TIP]
> If you want to update Docker later:
>  - Check the installed version with `Get-Package -Name Docker -ProviderName DockerMsftProvider`
>  - Find the current version with `Find-Package -Name Docker -ProviderName DockerMsftProvider`
>  - When you're ready, upgrade with `Install-Package -Name Docker -ProviderName DockerMsftProvider -Update -Force`, followed by `Start-Service Docker`

# [Windows 10 Professional and Enterprise](#tab/Windows-10-Client)

On Windows 10 Professional And Enterprise, Docker is installed through a classic installer. Download [Docker Desktop](https://store.docker.com/editions/community/docker-ce-desktop-windows) and run the installer. You will be required to login. Create an account if you don't have one already. More detailed installation instructions are available in the [Docker documentation](https://docs.docker.com/docker-for-windows/install).

After installation, Docker Desktop defaults to running Linux containers. Switch to Windows containers using either the Docker tray-menu or by running the following command in a PowerShell prompt:

```console
& $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon .
```

![](./media/docker-for-win-switch.png)

---
<!-- stop tab view -->

## Next Steps

Now that your environment has been configured correctly, follow the link to learn how to pull and run a container.

> [!div class="nextstepaction"]
> [Run your first container](./run-your-first-container.md)
