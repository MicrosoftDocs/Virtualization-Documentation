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

Containers are a virtualization technology for packaging and running apps across diverse environments on-premises and in the cloud. Containers enable you to abstract your apps from the environment they run in so that they're easier to develop, deploy, and manage. Containers also start and stop more quickly, making them ideal for applications that need to rapidly adapt to changing demand or cluster nodes going down or coming up.

Microsoft and Windows provide extensive support for containers:

- Develop and test Windows-based or Linux-based containers on Windows 10 with built-in Docker support.
- Deploy containers in the cloud on Azure:
  - Use Azure Kubernetes Service (AKS) to orchestrate deployment and management of numerous containers.
  - Containers are deployed to Azure virtual machines, which act as the Kubernetes cluster nodes.
  - The Azure virtual machines run either a customized Ubuntu Linux operating system image, or a customized Windows Server 2019 image, providing support for both Linux and Windows-based containers.
- Optionally deploy containers on-premises by using [Azure Stack with the AKS Engine](https://docs.microsoft.com/azure-stack/user/azure-stack-kubernetes-aks-engine-overview).

<!--Today's world demands that information be at a user's fingertips and that services maintain zero downtime availability. Time-to-deployment for both new features and critical fixes are tablestakes of the internet-connected society we live in. Now more than ever businesses are building out solutions that must deploy across a variety of locales--the edge, on-prem datacenters, multiple public cloud providers, and more--to meet the needs of their customers and satisfy their own demands for consuming compute to unlock critical business insights. Just as we at Microsoft have built the Azure cloud to help customers meet these needs, we too have also built Windows containers to help our Windows customers deliver on these requirements.

Containers are a technology for packaging and delivering applications on top of the Windows and across any environment. Containers are purpose-built to carry only the dependencies and configuration needed to successfully run the enclosed application. Containers are incredibly portable by nature; they can move across any environment with ease--from a developer's machine, into a private datacenter, and out to the public cloud. 

![](media/about-3-box.png)-->

## How containers work

For anyone familiar with virtual machines, containers and virtual machines may seem similar. A container runs an operating system, has a file system, and can be accessed over a network much like a physical or virtual machine. However, the technology and concepts behind containers are vastly different from virtual machines. Whereas virtual machines sit on top of a layer called the hypervisor which virtualizes the underlying hardware of a machine, containers share the kernel of the host's operating system.

![](media/about-3-box.png)

## Container users

### Containers for developers

Containers help developers build and ship higher-quality applications faster. Developers can create a Docker image that will deploy identically across all environments in seconds. There's a massive and growing ecosystem of applications packaged in Docker containers. DockerHub, a public containerized-application registry maintained by Docker, has published more than 180,000 applications in its public community repository, and that number is still growing.

When a developer containerizes an app, only the app and the components it needs to run are combined into an image. Containers are then created from this image as you need them. You can also use an image as a baseline to create another image, making image creation even faster. Multiple containers can share the same image, which means containers start up very quickly and use fewer resources. For example, a developer can use containers to spin up lightweight and portable app components, also known as microservices, for distributed apps and quickly scale each service separately.

Containers are portable and versatile, can be written in any language, and they're compatible with any machine running Windows Server 2016. Developers can create and test a container locally on their laptop or desktop, then deploy that same container image to their company's private cloud, public cloud, or service provider. The natural agility of containers supports modern app development patterns in large-scale, virtualized cloud environments.

### Containers for IT professionals

Containers help admins create infrastructure that's easier to update and maintain. IT professionals can use containers to provide standardized environments for their development, QA, and production teams. They no longer have to worry about complex installation and configuration procedures. By using containers, systems administrators abstract away differences in OS installations and the underlying infrastructure.

Explain value prop here.

## Containers 101

### Container Images

All containers are created from container images. Container images are a bundle of files organized into a stack of layers that reside on your local machine or in a remote container registry. The container image consists of an OS instance, your application, any runtimes or dependencies of your application, and any other miscellaneous configuration file your application needs to run properly. Microsoft offers several "starter" images (called **base images**) that you may use as a starting point to build your own container image:

* Windows Server Core
* Nano Server
* Windows

> [!TIP]
> Learn more about the [use cases and differences]() between each base image by checking the "Concepts" area of our docs.

As mentioned earlier, container images are composed of a series of layers. Each layer contains a set of files that, when overlaid together, represent your container image. Because of the layered nature of containers, you do not have to always target a base image to build a Windows container. Instead, you could target another image that already carries the framework you want. For example, the .NET team publishes a [.NET core image](https://hub.docker.com/_/microsoft-dotnet-core) that carries the .NET core runtime. It saves users from needing to duplicate the process of installing .NET core--instead they can re-use the layers of this container image. The .NET core image itself is built based upon Nano Server.

### Windows container isolation modes

Windows containers support running in two isolation modes: `process isolation` and `Hyper-V isolation`.

`Process isolation` is how container conventionally run. The application in the container is isolated through process and namespace isolation technologies. These containers are referred to as "process-isolated containers". Process-isolated containers share the kernel with the container host and all containers running on the host. These process-isolated containers don't provide a hostile security boundary and shouldn't be used to isolate untrusted code. Because of the shared kernel space, these containers require the same kernel version and configuration.

`Hyper-V isolation` expands on the isolation provided by Windows containers by running each container in a highly optimized virtual machine. In this configuration, the container host doesn't share its kernel with other containers on the same host. These containers are designed for hostile multitenant hosting with the same security assurances of a virtual machine. Since these containers don't share the kernel with the host or other containers on the host, they can run kernels with different versions and configurations (within supported versions).

Choosing which isolation mode the container will run under is a runtime decision. Containers are built independent of the isolation, and then later at runtime the user gets to choose how it should run. Learn more about [Hyper-V isolation]() in our "Concepts" section of the docs.

## Try containers on Windows

To get started with containers on Windows Server or Windows 10, follow this link.
> [!div class="nextstepaction"]
> [Get started: Configure Your Environment for Containers](../quick-start/set-up-environment.md)
