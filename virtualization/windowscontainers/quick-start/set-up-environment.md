---
title: Prepare Windows operating system containers
description: Set up Windows or Windows Server for containers, then run your first container image.
author: brasmith-ms
ms.author: mosagie
ms.date: 01/22/2025
ms.topic: quickstart
ms.assetid: bb9bfbe0-5bdc-4984-912f-9c93ea67105f
---

# Get started: Prep Windows for containers

> Applies to: Windows Server 2025, Windows Server 2022, Windows Server 2019, Windows Server 2016, Windows 10 and Windows 11

## Prerequisites

### Windows 10 and Windows 11

To run containers on Windows 10 or Windows 11, you need the following environment:

- One physical computer system running Windows 10 or Windows 11 Professional or Enterprise with Anniversary Update (version 1607) or later
- [Hyper-V](/virtualization/hyper-v-on-windows/reference/hyper-v-requirements) enabled

Windows Server containers use Hyper-V isolation by default on Windows 10 and Windows 11 to provide developers with the same kernel version and configuration that's used in production. For more information about Hyper-V isolation, see [Isolation Modes](../manage-containers/hyperv-container.md).

### Windows Server

For development environments, to run Windows Server containers, you need a physical server or virtual machine (VM) running Windows Server.

For testing, you can download a copy of [Windows Server 2025 Evaluation](https://www.microsoft.com/evalcenter/evaluate-windows-server-2025) or a [Windows Server Insider Program preview](https://insider.windows.com/for-business-getting-started-server/).

#### Container-ready Azure VMs

For many applications and orchestration paradigms, you need to build and deploy your own custom VMs. With the [transition of support](https://techcommunity.microsoft.com/t5/containers/updates-to-the-windows-container-runtime-support/ba-p/2788799) for the Windows container runtime to Mirantis, the container runtime is no longer provided as part of a marketplace VM offering. The remainder of this guide shows you how to build a VM for Azure with the container runtime installed and ready to go.

Azure continues to offer a complete and fully managed end-to-end experience through Azure Kubernetes Service (AKS) both in the cloud and on-premises. AKS and Azure Kubernetes Service on Azure Stack HCI are fully managed services with lower management overhead than custom deployments. Support for the container runtime is included within the AKS and Azure Kubernetes Service on Azure Stack HCI services under your Azure subscription.

- [Getting Started with Windows on AKS](/azure/aks/windows-container-cli)
- [Getting Started with Windows on AKS-HCI](/azure-stack/aks-hci/kubernetes-walkthrough-powershell)

Azure VM Image Builder and custom script extensions are also options for making the experience of constructing your container-ready Azure VMs as smooth as possible. When you compare these options, keep in mind the following three points. It's up to your organization to decide which aspect to optimize:

- How complex is it to implement?
- What is the cost?
- How does it impact my workload in production?

The following sections discuss the pros and cons of each option and show you how to get started.

##### VM Image Builder

The benefit to using VM Image Builder is that the configuration is done during a build time and doesn't have any effect on your workload at runtime. When the VM scale set instantiates a new VM from your custom image, the image is already prepped, and it's ready to run containers.

VM Image Builder, however, can be more complex to implement than script extensions, and there are more steps involved. Also, the VM Image Builder service is free, but you must pay for the compute, storage, and networking usage that's associated with the build process. For more information, see [Costs](/azure/virtual-machines/image-builder-overview#costs).

For a detailed, step-by-step procedure for building your own Windows Server VM image, see [Create a Windows VM by using Azure VM Image Builder](/azure/virtual-machines/windows/image-builder). To install your container runtime of choice, use the PowerShell scripts in this guide.

> [!TIP]
> Make sure to cache the container images you plan to use locally on the VM. This step helps improve the container start time after deployment. For scripts that help with this step, see [Windows Server](#windows-server-1), later in this quickstart.

##### Custom script extensions

Custom script extensions are quicker to implement than an VM Image Builder solution. The only cost associated with extensions is the nominal price of storing the script in Azure or GitHub. However, the script can only run after a VM is provisioned. As a result, your budget must include extra time to prep the VM at scale-out time.

Using the scripts offered in this guide, configure your VM scale sets to install the container runtime of your choice after provisioning. To use a custom script extension to automate the process of installing apps on Azure VMs, see [Tutorial: Install applications in Virtual Machine Scale Sets with the Azure CLI](/azure/virtual-machine-scale-sets/tutorial-install-apps-cli).

## Install the Container Runtime

### Windows 10 and Windows 11

To install Docker on Windows 10 or Windows 11 Professional and Enterprise editions, take the following steps:

1. Download and install [Docker Desktop](https://store.docker.com/editions/community/docker-ce-desktop-windows) and create a Docker account if you don't already have one. You can create a free Docker account for personal or small business users. However, for larger businesses, there's a monthly fee. For detailed information, see the [Docker documentation](https://docs.docker.com/docker-for-windows/install).

1. During installation, set the default container type to Windows containers. To switch the type after the installation finishes, take one of the following steps:

   - Run the following command in a PowerShell prompt:

     ```console
     & $Env:ProgramFiles\Docker\Docker\DockerCli.exe -SwitchDaemon .
     ```

   - Use the Docker item in the Windows system tray, as shown in the following screenshot:

     ![Docker system tray menu showing the "Switch to Windows containers" command](./media/docker-for-win-switch.png)

### Windows Admin Center

To use Windows Admin Center to properly set up a Windows Server machine as a container host, take the following steps:

1. In Windows Admin Center, ensure that you have the latest Containers extension installed. For more information about installing and configuring extensions, see the [Windows Admin Center documentation](/windows-server/manage/windows-admin-center/overview).

1. Open the Windows Server machine that you want to configure.

1. On the side panel, under **Tools**, select **Containers**.

1. Select **Install**. Windows Admin Center starts the configuration of Windows Server and Docker in the background.

   ![Install Docker](./media/WAC-InstallDocker.png)

1. After the process is complete, refresh the page to see other functionality of the Containers extension.

   ![Container images](./media/WAC-Images.png)

### Windows Server

To run a Windows container, you must have a supported container runtime available on your machine. The runtimes currently supported on Windows are [Moby](https://mobyproject.org/), the [Mirantis Container Runtime](https://info.mirantis.com/docker-engine-support), and [containerd](https://kubernetes.io/docs/setup/production-environment/container-runtimes/#containerd).

This section shows you how to install each runtime on a VM that runs Windows Server. For the Moby and containerd runtimes, you can use PowerShell scripts to complete the installation in a few steps.

<!-- start tab view -->
#### [Docker CE / Moby](#tab/dockerce)

Docker Community Edition (Docker CE) provides a standard runtime environment for containers. The environment offers a common API and command-line interface. The framework and components of Docker CE are managed by the open-source community as part of the [Moby Project](https://mobyproject.org/).

To get started with Docker on Windows Server, use the following command to run the [install-docker-ce.ps1 PowerShell script](https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1). This script configures your environment to enable container-related operating system (OS) features. The script also installs the Docker runtime.

```powershell
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-DockerCE/install-docker-ce.ps1" -o install-docker-ce.ps1
.\install-docker-ce.ps1
```

For detailed information about configuring Docker Engine, see [Docker Engine on Windows](../manage-docker/configure-docker-daemon.md).

#### [Mirantis Container Runtime](#tab/mirantiscontainerruntime)

The Mirantis Container Runtime, formally known as Docker Enterprise Edition (Docker EE), provides the same functionality as Docker CE plus extra features built specifically for enterprise deployments. For instructions for installing this runtime, see [Mirantis Container Runtime](https://www.mirantis.com/software/mirantis-container-runtime/).

#### [Containerd](#tab/containerd)

[Containerd](https://github.com/containerd/containerd) is an industry-standard container runtime with an emphasis on simplicity, robustness, and portability. Containerd is available as a daemon for Linux and Windows. It can manage the complete container lifecycle of its host system. Containerd offers functionality for image transfer and storage, container execution and supervision, low-level storage and network attachments, and other container management tasks.

[nerdctl](https://github.com/containerd/nerdctl) is a Docker-compatible command-line interface for containerd.

Use the following command to run the [install-containerd-runtime.ps1 PowerShell script](https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-ContainerdRuntime/install-containerd-runtime.ps1). This script installs Containerd, nerdctl, and container-related OS features.

```powershell
Invoke-WebRequest -UseBasicParsing "https://raw.githubusercontent.com/microsoft/Windows-Containers/Main/helpful_tools/Install-ContainerdRuntime/install-containerd-runtime.ps1" -o install-containerd-runtime.ps1
.\install-containerd-runtime.ps1
```

The install-containerd-runtime.ps1 script also installs [Windows Container Network Interface (CNI) plug-ins](https://github.com/microsoft/windows-container-networking). But you need to configure the `ctr` and `nerdctl` command-line interface tools to use the CNI configuration that suits you best.

For more information, see the following resources:

- [Instructions for installing containerd on Windows.](https://github.com/containerd/containerd/blob/main/docs/getting-started.md#installing-containerd-on-windows)
- [Instructions for installing and configuring containerd](https://www.jamessturtevant.com/posts/Windows-Containers-on-Windows-10-without-Docker-using-Containerd/#setting-up-network)
- [Instructions for installing nerdctl on Windows](https://github.com/containerd/nerdctl#install)
- [A more advanced community installer for containerd](https://github.com/lippertmarkus/containerd-installer)

---
<!-- stop tab view -->

## Next steps

> [!NOTE]
> For more guidance from the Windows Containers product team, see the [Windows Containers](https://github.com/microsoft/Windows-Containers) repository on GitHub.

Now that your environment is configured correctly, see how to run a container.

> [!div class="nextstepaction"]
> [Run your first container](./run-your-first-container.md)
