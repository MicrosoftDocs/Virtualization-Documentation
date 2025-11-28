---
title: About Windows containers
author: robinharwood
description: Learn how Windows containers simplify app development and deployment with lightweight, isolated environments. Explore tools like Docker, AKS, and Azure integration.
#customer intent: As an IT professional, I want to learn how to deploy and manage containers on Windows Server so that I can optimize infrastructure utilization.
ms.author: roharwoo
ms.reviewer: vrapolinario
ms.date: 11/28/2025
ms.topic: overview
---

# Windows and containers

> Applies to: Windows Server 2025, Windows Server 2022, Windows Server 2019, Windows Server 2016

Containers are a technology for packaging and running Windows and Linux applications across diverse environments on-premises and in the cloud. Containers provide a lightweight, isolated environment that makes apps easier to develop, deploy, and manage. Containers start and stop quickly, making them ideal for apps that need to rapidly adapt to changing demand. The lightweight nature of containers also makes them a useful tool for increasing the density and utilization of your infrastructure.

![Graphic showing how containers can run in the cloud or on-premises, supporting monolithic apps or microservices written in nearly any language.](media/about-3-box.png)

## The Microsoft container ecosystem

Microsoft provides many tools and platforms to help you develop and deploy apps in containers:

- **Run Windows-based or Linux-based containers on Windows 10** for development and testing using [Docker Desktop](https://docs.docker.com/desktop/), which makes use of containers functionality built-in to Windows. You can also [run containers natively on Windows Server](../quick-start/set-up-environment.md#windows-server-1).

- **Develop, test, publish, and deploy Windows-based containers** using the [powerful container support in Visual Studio](/visualstudio/containers/overview) and [Visual Studio Code](https://code.visualstudio.com/docs/containers/overview), which include support for Docker, Docker Compose, Kubernetes, Helm, and other useful technologies.

- **Publish your apps as container images** to the public DockerHub for others to use, or to a private [Azure Container Registry](https://azure.microsoft.com/products/container-registry/) for your org's own development and deployment, pushing and pulling directly from within Visual Studio and Visual Studio Code.

- **Deploy containers at scale on Azure** or other clouds:
  - Pull your app from a container registry, such as the Azure Container Registry, and then deploy and manage it at scale using an orchestrator such as [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes).

  - Azure Kubernetes Service deploys containers to Azure virtual machines and manages them at scale. You can run dozens, hundreds, or even thousands of containers.
  - Azure virtual machines run either a customized Windows Server image for Windows-based apps, or a customized Ubuntu Linux image for Linux-based apps.

- **Deploy containers on-premises** by using [Azure Kubernetes Service (AKS) enabled by Azure Arc](/azure/aks/aksarc/), [AKS engine on Azure Stack Hub](/azure-stack/user/azure-stack-kubernetes-aks-engine-overview), or [Azure Stack Hub with OpenShift](/azure/virtual-machines/linux/openshift-azure-stack). You can also set up Kubernetes yourself on Windows Server. For more information, see [Kubernetes on Windows](../kubernetes/getting-started-kubernetes-windows.md). Microsoft is also developing support for [Windows containers on RedHat OpenShift Container Platform](https://techcommunity.microsoft.com/blog/networkingblog/managing-windows-containers-with-red-hat-openshift-container-platform-3-11/339821).

## How containers work

A container is an isolated, lightweight package for running an application on the host operating system. Containers run on top of the host operating system's kernel (which you can think of as the buried plumbing of the operating system), as shown in the following diagram.

![Architectural diagram showing how containers run on top of the kernel](media/container-diagram.svg)

While a container shares the host operating system's kernel, the container doesn't get unfettered access to it. Instead, the container gets an isolated–and in some cases virtualized–view of the system. For example, a container can access a virtualized version of the file system and registry, but any changes affect only the container and are discarded when it stops. To save data, the container can mount persistent storage such as an [Azure Disk](https://azure.microsoft.com/products/storage/disks/) or a file share like [Azure Files](https://azure.microsoft.com/products/storage/files/).

A container builds on top of the kernel, but the kernel doesn't provide all of the APIs and services an app needs to run. Most of these APIs and services come from system files (libraries) that run above the kernel in user mode. Because a container is isolated from the host's user mode environment, the container needs its own copy of these user mode system files. These files are packaged into something known as a base image. The base image serves as the foundational layer upon which you build your container, providing it with operating system services not provided by the kernel.

## Containers vs. virtual machines

In contrast to a container, a virtual machine (VM) runs a complete operating system–including its own kernel–as shown in the following diagram.

![Architectural diagram showing how VMs run a complete operating system beside the host operating system](media/virtual-machine-diagram.svg)

Containers and virtual machines each have their uses. In fact, many deployments of containers use virtual machines as the host operating system rather than running directly on the hardware, especially when running containers in the cloud.

For more information on the similarities and differences of these complementary technologies, see [Containers vs. virtual machines](containers-vs-vm.md).

## Container images

You create all containers from container images. A container image is a bundle of files organized into a stack of layers that resides on your local machine or in a remote container registry. A container image consists of the user mode operating system files that your app needs to run. The image also includes your app's runtimes, dependencies, and any configuration files that your app requires.

Microsoft offers several images (called base images) that you can use as a starting point to build your own container image:

- **Windows** - contains the full set of Windows APIs and system services (minus server roles).
- **Windows Server** - contains the full set of Windows APIs and system services.
- **Windows Server Core** - a smaller image that contains a subset of the Windows Server APIs–namely the full .NET framework. It also includes most but not all server roles (for example Fax Server isn't included).
- **Nano Server** - the smallest Windows Server image and includes support for the .NET Core APIs and some server roles.

Container images are composed of a series of layers. Each layer contains a set of files that, when overlaid together, represent your container image. Because of the layered nature of containers, you don't always have to target a base image to build a Windows container. Instead, you can target another image that already carries the framework you want. For example, the .NET team publishes a [.NET core image](https://hub.docker.com/r/microsoft/dotnet) that carries the .NET core runtime. It saves users from needing to duplicate the process of installing .NET core–instead they can reuse the layers of this container image. The .NET core image itself is built based upon Nano Server.

For more information, see [Container Base Images](../manage-containers/container-base-images.md).

## Container users

### Containers for developers

Containers help developers build and ship higher-quality apps, faster. With containers, developers can create a container image that deploys in seconds, identically across environments. Containers act as an easy mechanism to share code across teams and to bootstrap a development environment without impacting your host filesystem.

Containers are portable and versatile, can run apps written in any language, and they're compatible with any machine running Windows 10, version 1607 or later, or Windows Server 2016 or later. Developers can create and test a container locally on their laptop or desktop, and then deploy that same container image to their company's private cloud, public cloud, or service provider. The natural agility of containers supports modern app development patterns in large-scale, virtualized cloud environments. The most useful benefit to developers is perhaps the ability to isolate your environment so that your app always gets the version of libraries that you specify, avoiding conflicts with dependencies.

### Containers for IT professionals

Containers help admins create infrastructure that's easier to update and maintain, and that more fully utilizes hardware resources. IT professionals can use containers to provide standardized environments for their development, QA, and production teams. By using containers, systems administrators abstract away differences in operating system installations and the underlying infrastructure.

You can also use the interactive mode of containers to run conflicting instances of a command line tool on the same system.

## Container orchestration

Orchestrators are a critical piece of infrastructure when setting up a container-based environment. Orchestrators are essential when managing containerized apps at scale. While you can manage a few containers manually using Docker and Windows, apps often make use of five, ten, or even hundreds of containers, making orchestrators indispensable.

Container orchestrators were built to help manage containers at scale and in production. Orchestrators provide functionality for:

Orchestrators help you grow containerized apps at scale, providing functionality for:

- Deploying at scale
- Workload scheduling
- Health monitoring
- Failing over when a node fails
- Scaling up or down
- Networking
- Service discovery
- Coordinating app upgrades
- Cluster node affinity

There are many different orchestrators that you can use with Windows containers; here are the options Microsoft provides:

- [Azure Kubernetes Service (AKS)](/azure/aks/intro-kubernetes) - use a managed Azure Kubernetes service
- [Azure Kubernetes Service (AKS) on Azure Stack HCI](/azure-stack/aks-hci/overview) - use Azure Kubernetes Service on-premises

## Try containers on Windows

To get started with containers on Windows Server or Windows 10, see the following article:
> [!div class="nextstepaction"]
> [Get started: Configure Your Environment for Containers](../quick-start/set-up-environment.md)

For help with deciding which Azure services are right for your scenario, see [Azure container services](https://azure.microsoft.com/product-categories/containers/) and [Choosing what Azure services to use to host your application](/azure/architecture/guide/technology-choices/compute-decision-tree).

## Resources

To view resources for using Windows Server containers, see the following resources:

- For current issues and planned feature upgrades, see the [Windows containers GitHub repository](https://github.com/microsoft/Windows-Containers).

- Check out the blog: [Windows Containers Blog](https://techcommunity.microsoft.com/category/windows-server/blog/containers).

- To contact the Windows Server containers team, send email to the [Windows Containers Customers group](mailto:win-containers@microsoft.com).
  