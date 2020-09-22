---
title: Prep Windows operating system containers
description: Set up Windows 10 or Windows Server for containers, then move on to running your first container image.
keywords: docker, containers, LCOW
author: cwilhit
ms.author: crwilhit
ms.date: 11/12/2019
ms.topic: quickstart
ms.assetid: bb9bfbe0-5bdc-4984-912f-9c93ea67105f
---
# Get started: Prep Windows for containers

This tutorial describes how to:

- Set up Windows 10 or Windows Server for containers
- Run your first container image
- Containerize a simple .NET core application

## Prerequisites

<!-- start tab view -->
# [Windows Server](#tab/Windows-Server)

To run containers on Windows Server, you need a physical server or virtual machine running Windows Server (Semi-Annual Channel), Windows Server 2019, or Windows Server 2016.

For testing, you can download a copy of [Windows Server 2019 Evaluation](https://www.microsoft.com/evalcenter/evaluate-windows-server-2019 ) or a [Windows Server Insider Preview](https://insider.windows.com/for-business-getting-started-server/).

# [Windows 10](#tab/Windows-10-Client)

To run containers on Windows 10, you need the following:

- One physical computer system running Windows 10 Professional or Enterprise with Anniversary Update (version 1607) or later.
- [Hyper-V](/virtualization/hyper-v-on-windows/reference/hyper-v-requirements) should be enabled.

> [!NOTE]
>  Starting with the Windows 10 October Update 2018, we no longer disallow users from running a Windows container in process-isolation mode on Windows 10 Enterprise or Professional for dev/test purposes. See the [FAQ](../about/faq.md) to learn more.
>
> Windows Server Containers use Hyper-V isolation by default on Windows 10 in order to provide developers with the same kernel version and configuration that will be used in production. Learn more about Hyper-V isolation in the [Concepts](../manage-containers/hyperv-container.md) area of our docs.

---
<!-- stop tab view -->

## Install Docker

The first step is to install Docker, which is required for working with Windows containers. Docker provides a standard runtime environment for containers, with a common API and command-line interface (CLI).

For more configuration details, see [Docker Engine on Windows](../manage-docker/configure-docker-daemon.md).

<!-- start tab view -->
# [Windows Server](#tab/Windows-Server)

To install Docker on Windows Server, you can use a [OneGet provider PowerShell module](https://github.com/oneget/oneget) published by Microsoft called the [DockerMicrosoftProvider](https://github.com/OneGet/MicrosoftDockerProvider). This provider enables the containers feature in Windows and installs the Docker engine and client. Here's how:

1. Open an elevated PowerShell session and install the Docker-Microsoft PackageManagement Provider from the [PowerShell Gallery](https://www.powershellgallery.com/packages/DockerMsftProvider).

   ```powershell
   Install-Module -Name DockerMsftProvider -Repository PSGallery -Force
   ```

   If you're prompted to install the NuGet provider, type `Y` to install it as well.

2. Use the PackageManagement PowerShell module to install the latest version of Docker.

   ```powershell
   Install-Package -Name docker -ProviderName DockerMsftProvider
   ```

   When PowerShell asks you whether to trust the package source 'DockerDefault', type `A` to continue the installation.
3. After the installation completes, restart the computer.

   ```powershell
   Restart-Computer -Force
   ```

If you want to update Docker later:

- Check the installed version with `Get-Package -Name Docker -ProviderName DockerMsftProvider`
- Find the current version with `Find-Package -Name Docker -ProviderName DockerMsftProvider`
- When you're ready, upgrade with `Install-Package -Name Docker -ProviderName DockerMsftProvider -Update -Force`, followed by `Start-Service Docker`

# [Windows 10](#tab/Windows-10-Client)

You can install Docker on Windows 10 Professional and Enterprise editions by using the following steps.

1. Download and install [Docker Desktop](https://store.docker.com/editions/community/docker-ce-desktop-windows), creating a free Docker account if you don't have one already. For more details, see the [Docker documentation](https://docs.docker.com/docker-for-windows/install).

2. During installation, set the default container type to Windows containers. To switch after installation completes, you can use either the Docker item in the Windows system tray (as shown below), or the following command in a PowerShell prompt:

   ```console
   & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon .
   ```

![Docker system tray menu showing the "Switch to Windows containers" command.](./media/docker-for-win-switch.png)

---
<!-- stop tab view -->

## Next steps

Now that your environment has been configured correctly, follow the link to learn how to run a container.

> [!div class="nextstepaction"]
> [Run your first container](./run-your-first-container.md)