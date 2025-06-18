---
title: Portability for containers in Windows Server
description: Discover the benefits of container portability in Windows Server (Annual Channel) and how it streamlines your workflow.
ms.topic: article
author: meaghanlewis
ms.author: mosagie
ms.date: 01/23/2025

---

# Portability for containers

>Applies to: Windows Server, version 23H2

Portability is a feature of Windows Server Annual Channel for Containers. Portability streamlines the upgrade process, helping you to take full advantage of the enhanced flexibility and compatibility that containers offer. This article provides a detailed explanation of how container image portability is optimized for annual channel container hosts.

Windows Server Annual Channel for Containers is an edition of Windows Server designed for Azure Kubernetes Service and container-focused Windows Server deployments to improve efficiency and provide optimized portability for both Windows and Linux containers. For more information about Annual Channel for containers in Windows Server, see our [TechCommunity announcement](https://techcommunity.microsoft.com/t5/windows-server-news-and-best/windows-server-annual-channel-for-containers/ba-p/3866248).

## How portability works

Windows uses a modular kernel where components often are tightly bound between [user mode and kernel mode](/windows-hardware/drivers/gettingstarted/user-mode-and-kernel-mode). Tightly bound components are helpful graphical interfaces on top of kernel mode drivers, or optimizing performance by reducing kernel mode to user mode context switches. However, it presents a challenge for containers. Portability enables containers running in user mode to run workloads with a different container image version than the host operating system version.

Without portability users could only run workloads with matching image and host versions. For example, a user running a Windows Server 2022 host couldn't run Windows Server 2019 process-isolated containers. Versioning between the host and container image represented a substantial pain point of Windows containerization, making the move to newer versions of a container host challenging. For example, Windows Server 2022 LTSC required all infrastructure and application images were updated to the latest version at the same time as host were updated.

### Application binary interface

The Application Binary Interface, or ABI, allows various programming languages to interact with user and kernel mode interfaces. Client code interaction with a runtime object happens at the lowest level, with client language constructs translated into calls into the object's ABI. Portability for Windows containers introduces a stable ABI for user and kernel interaction. This stable ABI decouples the user and kernel components of the system, and gives the ability to separately update the kernel and user elements of your system.

The containers can run all user mode binaries from their base layer except for the ABI layer.

The following diagram illustrates the communication between user-mode and kernel-mode components.

:::image type="content" source="media/portability/application-binary-interface.png" alt-text="A diagram showing the stabilize ABI boundary. Host processes and services, as well container processes and services, use this abstracted layer to communicate with the underlying shared kernel.":::

## Which versions can I use?

Nano Server, Server Core, and Windows Server container images are only available via the Long-Term Servicing Channel for containers running Windows Server 2019 or later. For more information about supported Windows Server containers images, see [Base image servicing lifecycles](/virtualization/windowscontainers/deploy-containers/base-image-lifecycle).

A Windows Server, version 23H2 container host only supports the Windows Server 2022 Long Term Servicing Channel (LTSC) container image.

Azure Kubernetes Service currently supports Windows Server 2019 and later hosts. Windows Server Annual Channel for Containers is another container OS option that Microsoft offers along with Kubernetes 1.28. You can create new node pools based on the annual channel and keep deploying your Windows Server 2022 container images on those nodes. Microsoft updates the annual channel version and any new Kubernetes releases on an annual basis automatically. However, it's also a good idea to follow the latest LTSC releases to make sure your containers are up to date.

>[!NOTE]
> Although previous container image releases can run on the newer host OS, newer container image operating systems can't run on previous host operating system.

## Related content

- [What is Windows Server Annual Channel for Containers](https://techcommunity.microsoft.com/blog/windowsservernewsandbestpractices/windows-server-annual-channel-for-containers/3866248)
