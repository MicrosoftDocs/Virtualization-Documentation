---
title: About Windows containers
description: Learn about Windows containers.
keywords: docker, containers
author: taylorb-microsoft
ms.date: 09/11/2019
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 8e273856-3620-4e58-9d1a-d1e06550448
---
# Windows and containers

Containers are a technology for packaging and running apps--including Windows apps--across diverse environments on-premises and in the cloud. Containers provide a lightweight, isolated environment that makes apps easier to develop, deploy, and manage. Containers start and stop quickly, making them ideal for applications that need to rapidly adapt to changing demand or cluster node availability. Another benefit of the lightweight nature of containers is increased density when compared to apps running in virtual machines or on physical hardware.

![](media/about-3-box.png)

Microsoft and Windows help you develop and deploy apps in containers:

- <strong>Run Windows-based or Linux-based containers on Windows 10</strong> for development and testing by using [Docker Desktop](https://store.docker.com/editions/community/docker-ce-desktop-windows), which uses containers functionality built-in to Windows. Later, you can deploy to Windows Server, which also natively supports running containers.
- <strong>Develop, test, publish, and deploy Windows-based containers</strong> using the [powerful container support in Visual Studio](https://docs.microsoft.com/visualstudio/containers/overview), which includes support for Docker, Docker Compose, Kubernetes, Helm, and other useful technologies; or with [Visual Studio Code](https://code.visualstudio.com/docs/azure/docker), which supports most of the same technologies.
- <strong>Publish your apps as container images</strong> to the public DockerHub for others to use, or to the private [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) for your org's own development and deployment, pushing and pulling directly from within VisualStudio and VisualStudio Code.
- <strong>Deploy containers at scale in the cloud</strong> on Azure or other clouds:

  - Pull your app (container image) from a container registry, such as the Azure Container Registry, and then deploy and manage it at scale using an orchestrator such as [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/azure/aks/intro-kubernetes) (in preview for Windows-based apps) or [Azure Service Fabric](https://docs.microsoft.com/azure/service-fabric/).
  - Containers are deployed to Azure virtual machines, which act as the Kubernetes cluster nodes.
  - The Azure virtual machines run either a customized Ubuntu Linux operating system image (if you're deploying a Linux-based app), or a customized Windows Server 2019 image (if you're deploying a Windows-based app).
- <strong>Optionally deploy containers on-premises</strong> by using [Azure Stack with the AKS Engine](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-overview) (in preview). You can also set up Kubernetes yourself on Windows Server, though the process is more complex.


<!--
Containers are a technology for packaging and delivering applications on top of the Windows across any environment. Containers are purpose-built to carry only the dependencies and configuration needed to successfully run the enclosed application. Containers are incredibly portable by nature; they can move across any environment with ease--from a developer's machine, into a private datacenter, and out to the public cloud.

Today's world demands that information be at a user's fingertips and that services maintain zero downtime availability. Time-to-deployment for both new features and critical fixes are tablestakes of the internet-connected society we live in. Now more than ever businesses are building out solutions that must deploy across a variety of locales--the edge, on-prem datacenters, multiple public cloud providers, and more--to meet the needs of their customers and satisfy their own demands for consuming compute to unlock critical business insights. Just as we at Microsoft have built the Azure cloud to help customers meet these needs, we too have also built Windows containers to help our Windows customers deliver on these requirements.

![](media/about-3-box.png)-->

## How containers work

A container is an isolated, lightweight environment for running apps. The container environment bypasses most of the Windows operating system, and communicates directly with its kernel (which can be thought of as the deep plumbing of an operating system), as shown in this diagram.

![](media/container-arch.png)
*Maybe update this diagram to add a second container and the hypervisor?*

Because so much of the operating system is bypassed, containers typically add back some of the higher-level (user mode) operating system services that apps can't function without, such as programming APIs. These are shown in the diagram above inside the container as *Services*.

This is in contrast to virtual machines, which require a complete operating system inside the virtual machine--including the kernel, as shown in this diagram.

*Create a VM diagram here:*

- OS (Host)
    - Applications
    - Services
    - Kernel
- Virtual machine/OS (Guest 1)
    - Applications
    - Services
    - Kernel
- Virtual machine/OS (Guest 2)
    - Applications
    - Services
    - Kernel
- Hypervisor
- Hardware

|     | Virtual machine  | Container  |
| --- | ---------------- | ---------- |
| Isolation| Provides complete isolation from the host operating system and other VMs. This is useful when a strong security boundary is critical, such as hosting apps from competing companies on the same server or cluster. | Typically provides lightweight isolation from other containers, but doesn't provide a strong security boundary from other apps or the host. (You can increase the security boundary by using Hyper-V isolation mode which uses a lightweight VM to isolate all containers from the host while still providing most of the benefits of containers). |
| Deployment | Deploy individual VMs with Windows Admin Center or Hyper-V Manager; deploy multiple VMs by using PowerShell or System Center Virtual Machine Manager. | Deploy individual containers with Docker; deploy multiple containers by using an orchestrator such as Azure Kubernetes Service. |
| Operating system | Runs a complete operating system including the kernel, thus requiring more system resources (CPU, memory, and storage). | Runs a lightweight operating system that includes just essential system services and can be tailored to be just large enough for your app, thus using fewer system resources. |
| Persistent storage | Use a virtual hard disk (VHD) for local storage for a single VM, or an SMB file share for storage shared by multiple servers | Use Azure Disks for local storage for a single node, or Azure Files (SMB shares) for storage shared by multiple nodes or servers. |
| Load balancing | Virtual machine load balancing moves running VMs to other servers in a failover cluster. | Containers themselves don't move; instead the app state can be stored in shared storage and an orchestrator can automatically start or stop containers on cluster nodes to manage changes in load and availability. |
| Fault tolerance | VMs can fail over to another server in a cluster.  | If a cluster node fails, any containers running on it are rapidly recreated by an orchestrator on another cluster node. Apps that persist data (stateful apps) can retrieve the data from shared storage. |
| Networking | Uses virtual network adapters. | Also use virtual network adapters. |

<!--

Some Linux containerized apps can function without an operating system in the container, but this only works if the apps can directly make kernel-mode system calls and don't need any higher level system services, so even Linux containers typically include a base image with some amount of operating system services.


Containers connect more-or-less directly to a deep layer of the host operating system--the kernel--

To understand containers, it can be helpful to compare them with virtual machines, which are a complementary virtualization technology:

- Virtual machines provide a complete virtualization of a computer, running an operating system in the virtual machine as if it were on physical hardware. Your apps run in the VM.
- Containers provide an isolated environment in which to run an app, but remove much of the 



- Containers provide an isolated environment, but 
- 
- 
- partial virtualization of the operating system so that each container doesn't need to run an entire operating system. Instead, the containers include a lightweight operating system that consists only of the user mode where apps run, sharing the kernel with the host operating system.
 


Containers are natively supported in Windows, similar to Win32 (desktop) apps, with Windows managing all low-level resources. Containers, like virtual machines, are isolated from the host operating system so that they have a restricted view of the file system, Windows registry, and other system resources. This provides a consistent environment for running apps across systems, and optionally provides security boundaries when using the Hyper-V isolation mode (which we talk about later).

-->


## Container users

## How containers work

<!--Containers provide an isolated environment for your application to run within. A container runs an operating system, has a file system, and can be accessed over a network much like a physical or virtual machine. However, the technology and concepts behind containers are vastly different from virtual machines. Whereas virtual machines sit on top of a layer called the hypervisor which virtualizes the underlying hardware of a machine, containers share the kernel of the host's operating system.

![](media/container-arch.png)

That means Microsoft built containers into the Windows OS itself. Similar to how applications can depend on the OS to manage low-level resource control and scheduling, the OS also can provide containers as an isolated environment by which your app can execute in. Windows takes care of setting up the container environment--isolating the view of the filesystem, isolating the view of the Windows registry, restricting which apps are seen running in a container, etc. There is no hypervisor involved--just the Windows host OS itself. -->

### Container Images

All containers are created from container images. Container images are a bundle of files organized into a stack of layers that reside on your local machine or in a remote container registry. The container image consists of a lightweight operating system, your application, any runtimes or dependencies of your application, and any other miscellaneous configuration file your application needs to run properly.

Microsoft offers several starter images (called **base images**) that you can use as a starting point to build your own container image:

* Windows Server Core
* Nano Server
* Windows

> [!TIP]
> Learn more about the [use cases and differences]() between each base image by checking the "Concepts" area of our docs.

As mentioned earlier, container images are composed of a series of layers. Each layer contains a set of files that, when overlaid together, represent your container image. Because of the layered nature of containers, you do not have to always target a base image to build a Windows container. Instead, you could target another image that already carries the framework you want. For example, the .NET team publishes a [.NET core image](https://hub.docker.com/_/microsoft-dotnet-core) that carries the .NET core runtime. It saves users from needing to duplicate the process of installing .NET core--instead they can re-use the layers of this container image. The .NET core image itself is built based upon Nano Server.

## Container users

### Containers for developers

Containers help developers build and ship higher-quality applications, faster. With containers, developers can create a Docker image that will deploy identically across all environments in a matter of seconds. Containers act as an easy mechanism to share code across teams and to bootstrap a development environment without impacting your host filesystem.

Containers are portable and versatile, can be written in any language, and they're compatible with any machine running Windows Server 2016 and Windows 10, version 1607 or later. Developers can create and test a container locally on their laptop or desktop, then deploy that same container image to their company's private cloud, public cloud, or service provider. The natural agility of containers supports modern app development patterns in large-scale, virtualized cloud environments.

### Containers for IT professionals

Containers help admins create infrastructure that's easier to update and maintain. IT professionals can use containers to provide standardized environments for their development, QA, and production teams. They no longer have to worry about complex installation and configuration procedures. By using containers, systems administrators abstract away differences in OS installations and the underlying infrastructure.

Explain value prop here.

## Container Tooling and Ecosystem

Mention here.

## Container Orchestration

Orchestrators are a critical piece of infrastructure that you should be mindful of when embarking on a journey with containers. Managing one or two containers manually can be done successfully on your own. However, most applications are composed of more than just one or two containers. Most applications could be powered by five, ten, or even hundreds of containers. Container orchestrators were built to help manage containers at scale and in production. Orchestrators provide functionality for:

> [!div class="checklist"]
> * Workload scheduling
> * Affinity
> * Health monitoring
> * Failover
> * Scaling
> * Networking
> * Service discovery
> * Coordinated app upgrades

To learn more about container orchestrators with Windows containers, visit the [Kubernetes on Windows](../kubernetes/getting-started-kubernetes-windows.md) tutorial.

## Windows Containers in Azure

Microsoft Azure provides comprehensive end-to-end services to help you get up and running with Windows containers. You can use Azure container instances to run containers without needing to worry about the underlying infrastructure, use Azure Kubernetes Service to take advantage of a fully managed Kubernetes solution with just a few clicks, and more.

<ul class="hubpage cardsM cols cols4" style="display: flex;">
    <li>
        <a href="https://docs.microsoft.com/en-us/azure/app-service/app-service-web-get-started-windows-container" data-linktype="external">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
	                    <div class="cardImageOuter">
                            <div class="cardImage centered">
                                <img src="media/appservice.svg" alt="" data-linktype="relative-path" style="width: 64px; height: 64px;">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>App Service</h3>
                            <hr>
                            <p>Deploy web apps or APIs using containers in a PaaS environment</p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li>
        <a href="https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-containers" data-linktype="external">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
	                    <div class="cardImageOuter">
                            <div class="cardImage centered">
                                <img src="media/fabric.svg" alt="" data-linktype="relative-path" style="width: 64px; height: 64px;">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>Service Fabric</h3>
                            <hr>
                            <p>Modernize .NET applications to microservices using Windows Server containers</p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li>
        <a href="https://docs.microsoft.com/en-us/azure/aks/windows-container-cli" data-linktype="external">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
	                    <div class="cardImageOuter">
                            <div class="cardImage centered">
                                <img src="media/containerservice.svg" alt="" data-linktype="relative-path" style="width: 64px; height: 64px;">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>Kubernetes Service</h3>
                            <hr>
                            <p>Scale and orchestrate Linux containers using Kubernetes</p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
    <li>
        <a href="https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview#linux-and-windows-containers" data-linktype="external">
            <div class="cardSize">
                <div class="cardPadding">
                    <div class="card">
	                    <div class="cardImageOuter">
                            <div class="cardImage centered">
                                <img src="media/containerinstances.svg" alt="" data-linktype="relative-path" style="width: 64px; height: 64px;">
                            </div>
                        </div>
                        <div class="cardText">
                            <h3>Container Instances</h3>
                            <hr>
                            <p>Elastically burst from your Azure Kubernetes Service (AKS) cluster</p>
                        </div>
                    </div>
                </div>
            </div>
        </a>
    </li>
</ul>

## Try containers on Windows

To get started with containers on Windows Server or Windows 10, follow this link.
> [!div class="nextstepaction"]
> [Get started: Configure Your Environment for Containers](../quick-start/set-up-environment.md)
