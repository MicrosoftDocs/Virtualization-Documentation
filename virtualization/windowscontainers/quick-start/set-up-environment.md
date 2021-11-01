---
title: Prep Windows operating system containers
description: Set up Windows 10 or Windows Server for containers, then move on to running your first container image.
keywords: docker, containers, LCOW
author: v-susbo
ms.author: viniap
ms.date: 10/22/2021
ms.topic: quickstart
ms.assetid: bb9bfbe0-5bdc-4984-912f-9c93ea67105f
---
# Get started: Prep Windows for containers

> Applies to: Windows Server 2022, Windows Server 2019, Windows Server 2016

This tutorial describes how to:

- [Set up Windows 10 or Windows Server for containers](#prerequisites)
- [Install Docker](#install-docker)
- [Run your first container image](./run-your-first-container.md)
- [Containerize a simple .NET core application](./building-sample-app.md)

## Prerequisites

### Windows Server

To run containers on Windows Server, you need a physical server or virtual machine running Windows Server 2022, Windows Server (Semi-Annual Channel), Windows Server 2019, or Windows Server 2016.

For testing, you can download a copy of [Windows Server 2022 Evaluation](https://www.microsoft.com/evalcenter/evaluate-windows-server-2022) or a [Windows Server Insider Preview](https://insider.windows.com/for-business-getting-started-server/).

### Windows 10

To run containers on Windows 10, you need the following:

- One physical computer system running Windows 10 Professional or Enterprise with Anniversary Update (version 1607) or later.
- [Hyper-V](/virtualization/hyper-v-on-windows/reference/hyper-v-requirements) should be enabled.

> [!NOTE]
> Starting with the Windows 10 October Update 2018, Microsoft no longer disallows users from running a Windows container in process-isolation mode on Windows 10 Enterprise or Professional for development ot test purposes. See the [FAQ](../about/faq.yml) to learn more.  

Windows Server Containers use Hyper-V isolation by default on Windows 10 to provide developers with the same kernel version and configuration that will be used in production. To learn more about Hyper-V isolation, see [Isolation Modes](../manage-containers/hyperv-container.md).

## Install Docker

> [!NOTE]
> At the end of September 2021, Microsoft announced [updates to the Windows Container Runtime support](https://techcommunity.microsoft.com/t5/containers/updates-to-the-windows-container-runtime-support/ba-p/2788799) to notify customers that we'll no longer produce builds of Docker EE for the DockerMsftProvider API. Customers who want to install a container runtime on Windows server are encouraged to transition to either [containerd](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd), [Moby](https://mobyproject.org/), or the [Mirantis Container Runtime](https://info.mirantis.com/docker-engine-support). By September 2022, these installation documents will be updated to reflect the Microsoft recommended installation process.

The first step is to install Docker, which is required for working with Windows containers. Docker provides a standard runtime environment for containers with a common API and command-line interface (CLI).

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

1. Check the installed version using the following command:
   ```powershell
   Get-Package -Name Docker -ProviderName DockerMsftProvider
   ```
2. Find the current version using the following command:
   ```powershell
   Find-Package -Name Docker -ProviderName DockerMsftProvider
   ```
3. When you're ready to upgrade, run the following command:
   ```powershell
   Install-Package -Name Docker -ProviderName DockerMsftProvider -Update -Force
   ```
4. Finally, run the following command to start Docker: 
   ```powershell
   Start-Service Docker
   ```  
  
# [Windows Admin Center](#tab/Windows-Admin-Center)

You can use Windows Admin Center to properly set up a Windows Server machine as a container host. To get started, ensure you have the latest Containers extension installed on your Windows Admin Center instance. For more information on how to install and configure extensions, check out the Windows Admin Center [documentation](/windows-server/manage/windows-admin-center/overview). With the Containers extension installed, target the Windows Server machine you want to configure and select the Containers option:

![Install Docker](./media/WAC-InstallDocker.png)

Click the **Install** button. Windows Admin Center will start the configuration of Windows Server and Docker in the background. After the process is complete, you can refresh the page and see the other functionalities of the Containers extension.

![Container images](./media/WAC-Images.png)  

# [Windows 10](#tab/Windows-10)

You can install Docker on Windows 10 Professional and Enterprise editions by using the following steps.

1. Download and install [Docker Desktop](https://store.docker.com/editions/community/docker-ce-desktop-windows) and create a Docker account if you don't already have one. You can create a free Docker account for personal or small business users, however, for larger businesses, there is a monthly fee. For more details, see the [Docker documentation](https://docs.docker.com/docker-for-windows/install).

2. During installation, set the default container type to Windows containers. To switch after installation completes, you can use either the Docker item in the Windows system tray (as shown below), or the following command in a PowerShell prompt:

   ```console
   & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon .
   ```

   ![Docker system tray menu showing the "Switch to Windows containers" command](./media/docker-for-win-switch.png)

---
<!-- stop tab view -->

## Next steps

Now that your environment has been configured correctly, follow the link to learn how to run a container.

> [!div class="nextstepaction"]
> [Run your first container](./run-your-first-container.md)
