---
title: About Windows containers
description: Containers are a technology for packaging and running apps--including Windows apps--across diverse environments on-premises and in the cloud. This topic discusses how Microsoft, Windows, and Azure help you develop and deploy apps in containers, including using Docker and Azure Kubernetes Service.
keywords: docker, containers
author: taylorb-microsoft
ms.date: 10/07/2019
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 8e273856-3620-4e58-9d1a-d1e06550448
---
# Windows and containers

Containers are a technology for packaging and running apps–including Windows apps–across diverse environments on-premises and in the cloud. Containers provide a lightweight, isolated environment that makes apps easier to develop, deploy, and manage. Containers start and stop quickly, making them ideal for applications that need to rapidly adapt to changing demand or cluster node availability. The lightweight nature of containers also make them a useful tool for increasing the density and utilization of your infrastructure.

![](media/about-3-box.png)

Microsoft, Windows, and Azure help you develop and deploy applications in containers:

- <strong>Run Windows-based or Linux-based containers on Windows 10</strong> for development and testing using [Docker Desktop](https://store.docker.com/editions/community/docker-ce-desktop-windows), which makes use of containers functionality built-in to Windows. Later, you can deploy to Windows Server, which also natively supports running containers.
- <strong>Develop, test, publish, and deploy Windows-based containers</strong> using the [powerful container support in Visual Studio](https://docs.microsoft.com/visualstudio/containers/overview), which includes support for Docker, Docker Compose, Kubernetes, Helm, and other useful technologies; or with [Visual Studio Code](https://code.visualstudio.com/docs/azure/docker), which supports most of the same technologies.
- <strong>Publish your apps as container images</strong> to the public DockerHub for others to use, or to the private [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) for your org's own development and deployment, pushing and pulling directly from within VisualStudio and VisualStudio Code.
- <strong>Deploy containers at scale on Azure</strong> or other clouds:

  - Pull your app (container image) from a container registry, such as the Azure Container Registry, and then deploy and manage it at scale using an orchestrator such as [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/azure/aks/intro-kubernetes) (in preview for Windows-based apps) or [Azure Service Fabric](https://docs.microsoft.com/azure/service-fabric/).
  - Azure Kubernetes Service deploys containers to Azure virtual machines, which act as the Kubernetes cluster nodes.
  - The Azure virtual machines run either a customized Windows Server 2019 image (if you're deploying a Windows-based app), or a customized Ubuntu Linux image (if you're deploying a Linux-based app).
- <strong>Deploy containers on-premises</strong> by using [Azure Stack with the AKS Engine](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-overview) (in preview). You can also set up Kubernetes yourself on Windows Server--for more, see [Kubernetes on Windows](../kubernetes/getting-started-kubernetes-windows.md).


<!--
Containers are a technology for packaging and delivering applications on top of the Windows across any environment. Containers are purpose-built to carry only the dependencies and configuration needed to successfully run the enclosed application. Containers are incredibly portable by nature; they can move across any environment with ease--from a developer's machine, into a private datacenter, and out to the public cloud.

Today's world demands that information be at a user's fingertips and that services maintain zero downtime availability. Time-to-deployment for both new features and critical fixes are tablestakes of the internet-connected society we live in. Now more than ever businesses are building out solutions that must deploy across a variety of locales--the edge, on-prem datacenters, multiple public cloud providers, and more--to meet the needs of their customers and satisfy their own demands for consuming compute to unlock critical business insights. Just as we at Microsoft have built the Azure cloud to help customers meet these needs, we too have also built Windows containers to help our Windows customers deliver on these requirements.

![](media/about-3-box.png)-->

## How containers work

A container is an isolated, lightweight silo for running an app on the host operating system. Containers build on top of the host operating system's kernel (which can be thought of as the buried plumbing of the operating system), as shown in this diagram.

![](media/container-arch.png)
*Maybe update this diagram to add a second container*

However, containers don't get unfettered access to the kernel. Instead, containers communicate through an isolation layer that creates a virtualized and temporary view of the system registry and file system. The app can write to the virtualized registry or file system, but the changes are kept within the container and discarded when the container stops. To persist data from a container, you can write to a file share or Azure Disk.

Empty containers are so lightweight that they're missing pretty much all of the system services and APIs needed by apps–it's essentially running an app directly on top of the kernel. But because the kernel doesn't provide APIs that apps can use, and containerized apps are isolated from the host's user-mode APIs and system services, the apps can't do anything... yet.

To give the containerized app the ability to do something, the container needs its own copy of the operating system's APIs and system services that the app needs to function. To get these, your container is based on a package that includes the appropriate operating system files (user mode libraries). This package is called a base image, but we'll talk more about container images more in a little bit.




<!--
some of these user-mode operating system pieces, such as system services and APIs.


Because the kernel doesn't provide APIs that apps can consume, and the containers are isolated from the host so can't consume the APIs running on the host in user mode outside the container--the app can't do anything. Not yet, anyway.

To give the containerized app the ability to do anything, the container needs some of these user-mode operating system pieces, such as system services and APIs.

user-mode operating system system services and APIs. 

you need to add some of these APIs and system services to the container. since the container can't access them in the host operating system (part of the isolation provided by containers). To do so, you use a base image (package) that includes the operating system APIs and services that your app relies upon. These are shown in the diagram above inside the container as *Services*. For example, you could use a base image that includes Windows Server Nano Server, a streamlined version of Windows, but we'll talk more about base images in a little bit.
-->

This is in contrast to virtual machines (VMs), which run a complete operating system inside the virtual machine, as shown in this diagram.

![](media/virtual-machine.png)

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

Containers and virtual machines each have their uses–in fact, most deployments of containers in the cloud use virtual machines as the host operating system rather than running directly on the cloud hardware. The following table shows some of the similarities and differences of these complementary technologies.

|     | Virtual machine  | Container  |
| --- | ---------------- | ---------- |
| Isolation| Provides complete isolation from the host operating system and other VMs. This is useful when a strong security boundary is critical, such as hosting apps from competing companies on the same server or cluster. | Typically provides lightweight isolation from the host and other containers, but doesn't provide as strong a security boundary as a VM. (You can increase the security by using Hyper-V isolation mode to isolate each container in a lightweight VM). |
| Operating system | Runs a complete operating system including the kernel, thus requiring more system resources (CPU, memory, and storage). | Runs the user mode portion of an operating system, and can be tailored to contain just the needed services for your app, using fewer system resources. |
| Guest compatibility | Runs just about any operating system inside the virtual machine | Runs on the same operating system version as the host (Hyper-V isolation enables you to run earlier versions of the same OS in a lightweight VM environment)
| Deployment | Deploy individual VMs by using Windows Admin Center or Hyper-V Manager; deploy multiple VMs by using PowerShell or System Center Virtual Machine Manager. | Deploy individual containers by using Docker via command line; deploy multiple containers by using an orchestrator such as Azure Kubernetes Service. |
| Persistent storage | Use a virtual hard disk (VHD) for local storage for a single VM, or an SMB file share for storage shared by multiple servers | Use Azure Disks for local storage for a single node, or Azure Files (SMB shares) for storage shared by multiple nodes or servers. |
| Load balancing | Virtual machine load balancing moves running VMs to other servers in a failover cluster. | Containers themselves don't move; instead the app state can be stored in shared storage and an orchestrator can automatically start or stop containers on cluster nodes to manage changes in load and availability. |
| Fault tolerance | VMs can fail over to another server in a cluster, with the VM's operating system restarting on the new server.  | If a cluster node fails, any containers running on it are rapidly recreated by an orchestrator on another cluster node. Apps that persist data (stateful apps) can retrieve the data from shared storage. |
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

<!--
## Container users

## How containers work
Containers provide an isolated environment for your application to run within. A container runs an operating system, has a file system, and can be accessed over a network much like a physical or virtual machine. However, the technology and concepts behind containers are vastly different from virtual machines. Whereas virtual machines sit on top of a layer called the hypervisor which virtualizes the underlying hardware of a machine, containers share the kernel of the host's operating system.

![](media/container-arch.png)

That means Microsoft built containers into the Windows OS itself. Similar to how applications can depend on the OS to manage low-level resource control and scheduling, the OS also can provide containers as an isolated environment by which your app can execute in. Windows takes care of setting up the container environment--isolating the view of the filesystem, isolating the view of the Windows registry, restricting which apps are seen running in a container, etc. There is no hypervisor involved--just the Windows host OS itself. -->

### Container Images

All containers are created from container images. Container images are a bundle of files organized into a stack of layers that reside on your local machine or in a remote container registry. The container image consists of the user mode operating system files needed to support your application, your application, any runtimes or dependencies of your application, and any other miscellaneous configuration file your application needs to run properly.

Microsoft offers several images (called **base images**) that you can use as a starting point to build your own container image:

* <strong>Windows</strong> - contains the full Windows Server API set.
* <strong>Windows Server Core</strong> - a smaller image that contains a subset of the Windows Server APIs, namely the full .NET framework.
* <strong>Nano Server</strong> - the smallest Windows Server image, with support for the .NET Core APIs.
* <strong>Windows 10 IoT Core</strong> - a version of Windows used by hardware manufacturers for small Internet of Things devices that run ARM or x86/x64 processors.

As mentioned earlier, container images are composed of a series of layers. Each layer contains a set of files that, when overlaid together, represent your container image. Because of the layered nature of containers, you don't have to always target a base image to build a Windows container. Instead, you could target another image that already carries the framework you want. For example, the .NET team publishes a [.NET core image](https://hub.docker.com/_/microsoft-dotnet-core) that carries the .NET core runtime. It saves users from needing to duplicate the process of installing .NET core–instead they can re-use the layers of this container image. The .NET core image itself is built based upon Nano Server.

For more details, see [Container Base Images](../manage-containers/container-base-images.md).

## Container users

### Containers for developers

Containers help developers build and ship higher-quality applications, faster. With containers, developers can create a Docker image that will deploy in seconds, identically across environments. Containers act as an easy mechanism to share code across teams and to bootstrap a development environment without impacting your host filesystem.

Containers are portable and versatile, can be written in any language, and they're compatible with any machine running Windows 10, version 1607 or later, or Windows 2016 or later. Developers can create and test a container locally on their laptop or desktop, then deploy that same container image to their company's private cloud, public cloud, or service provider. The natural agility of containers supports modern app development patterns in large-scale, virtualized cloud environments.

### Containers for IT professionals

Containers help admins create infrastructure that's easier to update and maintain, and that more fully utilizes hardware resources. IT professionals can use containers to provide standardized environments for their development, QA, and production teams. By using containers, systems administrators abstract away differences in operating system installations and the underlying infrastructure.

<!--## Container Tooling and Ecosystem

Mention here.-->

## Container orchestration

Orchestrators are a critical piece of infrastructure that you should be mindful of when embarking on a journey with containers. Managing one or two containers manually can be done successfully on your own with Docker and Windows. However, most applications are composed of more than just one or two containers. Most applications could be powered by five, ten, or even hundreds of containers.

Container orchestrators were built to help manage containers at scale and in production. Orchestrators provide functionality for:

> [!div class="checklist"]
> * Deploying at scale
> * Workload scheduling
> * Health monitoring
> * Failover when a node fails
> * Scaling up or down
> * Networking
> * Service discovery
> * Coordinated app upgrades
> * Cluster node affinity

There are many different orchestrators that you can use with Windows containers; here are the options Microsoft provides:
- [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/azure/aks/intro-kubernetes) - use a managed Azure Kubernetes service
- [Azure Service Fabric](https://docs.microsoft.com/azure/service-fabric/) - use a managed service
- [Azure Stack with the AKS Engine](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-overview) - use Azure Kubernetes Service on-premises
- [Kubernetes on Windows](../kubernetes/getting-started-kubernetes-windows.md) - set up Kubernetes yourself on Windows

<!--## Windows Containers in Azure

Microsoft Azure provides comprehensive end-to-end services to help you get up and running with Windows containers. You can use Azure container instances to run containers without needing to worry about the underlying infrastructure, use Azure Kubernetes Service to take advantage of a fully managed Kubernetes solution, and more.




<ul class="columns is-multiline has-margin-left-none has-margin-bottom-none has-padding-top-medium">
    <li class="column is-one-quarter has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="https://docs.microsoft.com/en-us/azure/app-service/app-service-web-get-started-windows-container" data-linktype="external">
            <article class="card has-outline-hover is-relative is-fullheight">
                    <div class="cardImageOuter has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                        <div class="cardImage centered has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                            <img src="media/appservice.svg" alt="" data-linktype="relative-path">
                        </div>
                    </div>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">App Service</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Deploy web apps or APIs using containers in a PaaS environment</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
    <li class="column is-one-quarter has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="https://docs.microsoft.com/en-us/azure/service-fabric/service-fabric-quickstart-containers" data-linktype="external">
            <article class="card has-outline-hover is-relative is-fullheight">
                    <div class="cardImageOuter has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                        <div class="cardImage centered has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                            <img src="media/fabric.svg" alt="" data-linktype="relative-path">
                        </div>
                    </div>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Service Fabric</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Modernize .NET applications to microservices using Windows Server containers</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
    <li class="column is-one-quarter has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="https://docs.microsoft.com/en-us/azure/aks/windows-container-cli" data-linktype="external">
            <article class="card has-outline-hover is-relative is-fullheight">
                    <div class="cardImageOuter has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                        <div class="cardImage centered has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                            <img src="media/containerservice.svg" alt="" data-linktype="relative-path">
                        </div>
                    </div>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Kubernetes Service</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Scale and orchestrate Linux containers using Kubernetes</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
    <li class="column is-one-quarter has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="https://docs.microsoft.com/en-us/azure/container-instances/container-instances-overview#linux-and-windows-containers" data-linktype="external">
            <article class="card has-outline-hover is-relative is-fullheight">
                    <div class="cardImageOuter has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                        <div class="cardImage centered has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                            <img src="media/containerinstances.svg" alt="" data-linktype="relative-path">
                        </div>
                    </div>
                <div class="card-content has-text-overflow-ellipsis">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Container Instances</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Elastically burst from your Azure Kubernetes Service (AKS) cluster</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
</ul>
-->

## Try containers on Windows

To get started with containers on Windows Server or Windows 10, see the following:
> [!div class="nextstepaction"]
> [Get started: Configure Your Environment for Containers](../quick-start/set-up-environment.md)


For help deciding which Azure services are right for your scenario, see [Azure container services](https://azure.microsoft.com/product-categories/containers/) and [Choosing what Azure services to use to host your application](https://docs.microsoft.com/azure/architecture/guide/technology-choices/compute-decision-tree).