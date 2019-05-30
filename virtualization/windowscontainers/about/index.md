---
title: About Windows containers
description: Learn about Windows containers.
keywords: docker, containers
author: taylorb-microsoft
ms.date: 05/22/2019
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 8e273856-3620-4e58-9d1a-d1e06550448

---
# About Windows containers

Imagine a kitchen. Inside this single room is everything you need to cook a meal: the oven, pans, sink, and so on. This is our container.

![An illustration of a fully furnished kitchen with yellow wallpaper inside of a black box.](media/box1.png)

Now imagine putting this kitchen inside a building as easily as sliding a book into a bookshelf. Since everything the kitchen needs to function is already there, all we need to start cooking is to connect the electricity and plumbing.

![An apartment building made of two stacks of black boxes. Four of these boxes are the same yellow boxes used in the kitchen example and are in random places throughout the building, while the rest are either multicolored living rooms or are empty and greyed out.](media/apartment.png)

Why stop there? You can customize your building any way you like; fill it with many kinds of rooms, fill it with identical rooms, or have a mix of the two.

Containers act like this room by running an app the way we'd cook in our kitchen. A container puts an app and everything that app needs to run into its own isolated box. As a result, the isolated app has no knowledge of any other apps or processes that exist outside its container. Because the container has everything the app needs to run, the container can be moved anywhere, using only the resources its host provisions without touching any resources provisioned for other containers.

The following video will tell you more about what Windows containers can do for you, as well as how Microsoft's partnership with Docker helps create a frictionless environment for open-source container development:

<iframe width="800" height="450" src="https://www.youtube.com/embed/Ryx3o0rD5lY" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

## Container fundamentals

Let's get to know some terms you'll find useful as you start to work with Windows containers:

- Container host: A physical or virtual computer system configured with the Windows container feature. The container host will run one or more Windows containers.
- Sandbox: The layer that captures all changes you make to the container while it's running (such as file system modifications, registry modifications, or software installations).
- Base image: The first layer in the image layers of a container that provides the container's operating system environment. A base image can't be modified.
- Container image: A read-only template of instructions for creating a container. Images can be based on a basic, unaltered operating system environment, but can also be created from the sandbox of a modified container. These modified images layer their changes on top of the base image layer, and these layers can be copied and reapplied to other base images to create a new image with those same changes.
- Container repository: The local repository that stores your container image and its dependencies each time you create a new image. You can reuse stored images as many times as you want on the container host. You can also store the container images in a public or private registry, such as Docker Hub, so they can be used across many different container hosts.
- Container orchestrator: a process that automates and manages a large number of containers and how they interact with each other. To learn more, see [About Windows container orchestrators](overview-container-orchestrators.md).
- Docker: an automated process that packages and delivers container images. To learn more, see the [Docker overview](docker-overview.md), [Docker Engine on Windows](../manage-docker/configure-docker-daemon.md) or visit the [Docker website](https://www.docker.com).

![A flow chart that shows how containers are created. The application and base images are used to create a sandbox and a new application image, which are layered on top of the base image to build a new container.](media/containerfund.png)

Someone familiar with virtual machines might think containers and virtual machines seem similar. A container runs an operating system, has a file system, and can be accessed over a network much like a physical or virtual computer system. However, the technology and concepts behind containers are vastly different from virtual machines. To learn more about these concepts, read Mark Russinovich's [blog post](https://azure.microsoft.com/blog/containers-docker-windows-and-trends/) that explains the differences in more detail.

### Windows container types

Another thing you should know is that there are two different container types, also known as runtimes.

Windows Server containers provide application isolation through process and namespace isolation technology, which is why these containers are also referred to as process-isolated containers. A Windows Server container shares a kernel with the container host and all containers running on the host. These process-isolated containers don't provide a hostile security boundary and shouldn't be used to isolate untrusted code. Because of the shared kernel space, these containers require the same kernel version and configuration.

Hyper-V isolation expands on the isolation provided by Windows Server containers by running each container in a highly optimized virtual machine. In this configuration, the container host doesn't share its kernel with other containers on the same host. These containers are designed for hostile multitenant hosting with the same security assurances of a virtual machine. Since these containers don't share the kernel with the host or other containers on the host, they can run kernels with different versions and configurations (within supported versions). For example, all Windows containers on Windows 10 use Hyper-V isolation to utilize the Windows Server kernel version and configuration.

Running a container on Windows with or without Hyper-V isolation is a runtime decision. You can initially create the container with Hyper-V isolation, and then later at runtime choose to run it as a Windows Server container instead.

## Container users

### Containers for developers

Containers help developers build and ship higher-quality applications faster. Developers can create a Docker image that will deploy identically across all environments in seconds. There's a massive and growing ecosystem of applications packaged in Docker containers. DockerHub, a public containerized-application registry maintained by Docker, has published more than 180,000 applications in its public community repository, and that number is still growing.

When a developer containerizes an app, only the app and the components it needs to run are combined into an image. Containers are then created from this image as you need them. You can also use an image as a baseline to create another image, making image creation even faster. Multiple containers can share the same image, which means containers start up very quickly and use fewer resources. For example, a developer can use containers to spin up lightweight and portable app components, also known as microservices, for distributed apps and quickly scale each service separately.

Containers are portable and versatile, can be written in any language, and they're compatible with any machine running Windows Server 2016. Developers can create and test a container locally on their laptop or desktop, then deploy that same container image to their company's private cloud, public cloud, or service provider. The natural agility of containers supports modern app development patterns in large-scale, virtualized cloud environments.

### Containers for IT professionals

Containers help admins create infrastructure that's easier to update and maintain. IT professionals can use containers to provide standardized environments for their development, QA, and production teams. They no longer have to worry about complex installation and configuration procedures. By using containers, systems administrators abstract away differences in OS installations and the underlying infrastructure.

## Containers 101 video presentation

The following video presentation will give you a more in-depth overview of the history and implementation of Windows containers.

<iframe src="https://channel9.msdn.com/Blogs/containers/Containers-101-with-Microsoft-and-Docker/player" width="800" height="450" allowFullScreen="true" frameBorder="0" scrolling="no"></iframe>

## Try Windows Server containers

Ready to begin leveraging the awesome power of containers? The following articles will help you get started:

To set up a container on Windows Server, see the [Windows Server quickstart](../quick-start/quick-start-windows-server.md).

To set up a container on Windows 10, see the [Windows 10 quickstart](../quick-start/quick-start-windows-10.md).