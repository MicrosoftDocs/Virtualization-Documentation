---
title: About Windows containers
description: Containers are a technology for packaging and running apps--including Windows apps--across diverse environments on-premises and in the cloud. This topic discusses how Microsoft, Windows, and Azure help you develop and deploy apps in containers, including using Docker and Azure Kubernetes Service.
keywords: docker, containers
author: taylorb-microsoft
ms.date: 10/21/2019
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 8e273856-3620-4e58-9d1a-d1e06550448
---
# Windows and containers

Containers are a technology for packaging and running Windows and Linux applications across diverse environments on-premises and in the cloud. Containers provide a lightweight, isolated environment that makes apps easier to develop, deploy, and manage. Containers start and stop quickly, making them ideal for apps that need to rapidly adapt to changing demand. The lightweight nature of containers also make them a useful tool for increasing the density and utilization of your infrastructure.

![Graphic showing how containers can run in the cloud or on-premises, supporting monolithic apps or microservices written in nearly any language.](media/about-3-box.png)

Microsoft helps you develop and deploy apps in containers:

- <strong>Run Windows-based or Linux-based containers on Windows 10</strong> for development and testing using [Docker Desktop](https://store.docker.com/editions/community/docker-ce-desktop-windows), which makes use of containers functionality built-in to Windows. You can also [run containers natively on Windows Server](../quick-start/set-up-environment.md?tabs=Windows-Server).
- <strong>Develop, test, publish, and deploy Windows-based containers</strong> using the [powerful container support in Visual Studio](https://docs.microsoft.com/visualstudio/containers/overview), which includes support for Docker, Docker Compose, Kubernetes, Helm, and other useful technologies; or with [Visual Studio Code](https://code.visualstudio.com/docs/azure/docker), which supports most of the same technologies.
- <strong>Publish your apps as container images</strong> to the public DockerHub for others to use, or to a private [Azure Container Registry](https://azure.microsoft.com/services/container-registry/) for your org's own development and deployment, pushing and pulling directly from within Visual Studio and Visual Studio Code.
- <strong>Deploy containers at scale on Azure</strong> or other clouds:

  - Pull your app (container image) from a container registry, such as the Azure Container Registry, and then deploy and manage it at scale using an orchestrator such as [Azure Kubernetes Service (AKS)](https://docs.microsoft.com/azure/aks/intro-kubernetes) (in preview for Windows-based apps) or [Azure Service Fabric](https://docs.microsoft.com/azure/service-fabric/).
  - Azure Kubernetes Service deploys containers to Azure virtual machines and manages them at scale, whether that's dozens of containers, hundreds, or even thousands.
  - The Azure virtual machines run either a customized Windows Server image (if you're deploying a Windows-based app), or a customized Ubuntu Linux image (if you're deploying a Linux-based app).
- <strong>Deploy containers on-premises</strong> by using [Azure Stack with the AKS Engine](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-overview) (in preview with Linux containers) or [Azure Stack with OpenShift](https://docs.microsoft.com/azure/virtual-machines/linux/openshift-azure-stack). You can also set up Kubernetes yourself on Windows Server (see [Kubernetes on Windows](../kubernetes/getting-started-kubernetes-windows.md)), and we're working on support for running [Windows containers on RedHat OpenShift Container Platform](https://techcommunity.microsoft.com/t5/Networking-Blog/Managing-Windows-containers-with-Red-Hat-OpenShift-Container/ba-p/339821) as well.

## How containers work

A container is an isolated, lightweight silo for running an application on the host operating system. Containers build on top of the host operating system's kernel (which can be thought of as the buried plumbing of the operating system), as shown in this diagram.

![Architectural diagram showing how containers run on top of the kernel](media/container-diagram.svg)

While a container shares the host operating system's kernel, the container doesn't get unfettered access to it. Instead, the container gets an isolated–and in some cases virtualized–view of the system. For example, a container can access a virtualized version of the file system and registry, but any changes affect only the container and are discarded when it stops. To save data, the container can mount persistent storage such as an [Azure Disk](https://azure.microsoft.com/services/storage/disks/) or a file share (including [Azure Files](https://azure.microsoft.com/services/storage/files/)).

A container builds on top of the kernel, but the kernel doesn't provide all of the APIs and services an app needs to run–most of these are provided by system files (libraries) that run above the kernel in user mode. Because a container is isolated from the host's user mode environment, the container needs its own copy of these user mode system files, which are packaged into something known as a base image. The base image serves as the foundational layer upon which your container is built, providing it with operating system services not provided by the kernel. But we'll talk more about container images later.

<!--
Because the container builds on top of the host operating system's kernel, all user-mode 


Because the container shares only the kernel of the host operating system, it doesn't have access to the APIs and system services needed by apps–those are provided by system libraries that run above the kernel in user mode, isolated from the container.

Because the container shares only the kernel of the host operating system, it doesn't have access to the host operating system's APIs and system services, which run above the kernel in user mode, isolated from the container. To access these APIs and services from within the container, 


So, the container needs its own copy of these system libraries, which are packaged into something known as a base image. The base image serves as the foundational layer upon which your container is built, providing it with operating system services not provided by the kernel. But we'll talk more about container images later.


To get these system libraries, the container is built upon a package that includes 



To get these APIs and system services, the container is built upon a package of operating system files that provide the (user mode libraries) into what's known as a base image. The base image serves as the foundational layer--a miniature operating system--upon which your container is built.




To give the container the ability to do something, the container needs its own copy of these APIs and system services. A container gets these APIs and system services by packaging the operating system files that provide them (user mode libraries) into what's known as a base image. The base image serves as the foundational layer--a miniature operating system--upon which your container is built. 




, which are provided by user mode library files. A container gets these operating system files from a type of package known as a base image, which is the foundational layer upon which your containerized app is built. But we'll talk more about base images and container layers in a bit.




 which are packaged together into the first layer of your container image, known as the base image. 

which are packaged together into a template upon which your containers are based. This is called a base image, but we'll talk more about them later.


into a container image known as a base image. But we'll talk more about container images later.

 A base image is simply a file that packages operating system files

which the container builds upon. But we'll talk more about base images later.

, which are provided by operating system files c

the operating system files that provide 

These files (user mode libraries) are packaged into an image called a base image, which the container builds upon. But we'll talk more about base images later.


some operating system files–the user mode libraries that provide the needed APIs and system services. 


To get these files into the container, the container is based upon a package that includes the needed operating system libraries. This package is called a base image, but we'll talk more about images in a bit.


These libraries are included in a package, called a base image, upon which the container is based. But we'll talk about images in a bit.


To get these into a container, the container is based on a package that includes these system files. This package is called a base image, but we'll talk about images in a bit.

An empty container without a base image is so lightweight that it's missing pretty much all of the system services and APIs needed by apps–it's essentially running directly on top of the kernel. The system services and APIs run in user mode, above the kernel, but due to isolation from the host, the container can't access them.-->

## Containers vs. virtual machines

In contrast to containers, virtual machines (VMs) run a complete operating system–including its own kernel–as shown in this diagram.

![Architectural diagram showing how VMs run a complete operating system beside the host operating system](media/virtual-machine-diagram.svg)

Containers and virtual machines each have their uses–in fact, many deployments of containers use virtual machines as the host operating system rather than running directly on the hardware, especially when running containers in the cloud.

For more details on the similarities and differences of these complementary technologies, see [Containers vs. virtual machines](containers-vs-vm.md).

### Container Images

All containers are created from container images. Container images are a bundle of files organized into a stack of layers that reside on your local machine or in a remote container registry. The container image consists of the user mode operating system files needed to support your app, your app, any runtimes or dependencies of your app, and any other miscellaneous configuration file your app needs to run properly.

Microsoft offers several images (called base images) that you can use as a starting point to build your own container image:

* <strong>Windows</strong> - contains the full set of Windows APIs and system services (minus server roles).
* <strong>Windows Server Core</strong> - a smaller image that contains a subset of the Windows Server APIs namely the full .NET framework. It also includes most server roles, though sadly to few, not Fax Server.
* <strong>Nano Server</strong> - the smallest Windows Server image, with support for the .NET Core APIs and some server roles.
* <strong>Windows 10 IoT Core</strong> - a version of Windows used by hardware manufacturers for small Internet of Things devices that run ARM or x86/x64 processors.

As mentioned earlier, container images are composed of a series of layers. Each layer contains a set of files that, when overlaid together, represent your container image. Because of the layered nature of containers, you don't have to always target a base image to build a Windows container. Instead, you could target another image that already carries the framework you want. For example, the .NET team publishes a [.NET core image](https://hub.docker.com/_/microsoft-dotnet-core) that carries the .NET core runtime. It saves users from needing to duplicate the process of installing .NET core–instead they can re-use the layers of this container image. The .NET core image itself is built based upon Nano Server.

For more details, see [Container Base Images](../manage-containers/container-base-images.md).

## Container users

### Containers for developers

Containers help developers build and ship higher-quality apps, faster. With containers, developers can create a Docker image that will deploy in seconds, identically across environments. Containers act as an easy mechanism to share code across teams and to bootstrap a development environment without impacting your host filesystem.

Containers are portable and versatile, can run apps written in any language, and they're compatible with any machine running Windows 10, version 1607 or later, or Windows 2016 or later. Developers can create and test a container locally on their laptop or desktop, then deploy that same container image to their company's private cloud, public cloud, or service provider. The natural agility of containers supports modern app development patterns in large-scale, virtualized cloud environments.

### Containers for IT professionals

Containers help admins create infrastructure that's easier to update and maintain, and that more fully utilizes hardware resources. IT professionals can use containers to provide standardized environments for their development, QA, and production teams. By using containers, systems administrators abstract away differences in operating system installations and the underlying infrastructure.

## Container orchestration

Orchestrators are a critical piece of infrastructure when embarking on a journey with containers. Managing one or two containers manually can be done successfully on your own with Docker and Windows. However, apps often make use of five, ten, or even hundreds of containers.

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

## Try containers on Windows

To get started with containers on Windows Server or Windows 10, see the following:
> [!div class="nextstepaction"]
> [Get started: Configure Your Environment for Containers](../quick-start/set-up-environment.md)

For help deciding which Azure services are right for your scenario, see [Azure container services](https://azure.microsoft.com/product-categories/containers/) and [Choosing what Azure services to use to host your application](https://docs.microsoft.com/azure/architecture/guide/technology-choices/compute-decision-tree).
