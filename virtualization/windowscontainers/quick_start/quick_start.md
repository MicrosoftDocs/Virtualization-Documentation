---
title: Windows Containers Quick Start
description: Windows containers quick start.
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-contianers
ms.service: windows-containers
ms.assetid: 4878f5d2-014f-4f3c-9933-97f03348a147
---

# Windows Containers Quick Start

**This is preliminary content and subject to change.** 

The windows container quick start introduces the product and container terminology, steps through simple container deployment examples, and also provides reference for more advanced topics. If you are new to containers or even Windows containers, walking through each step of this quick start will provide you with practical hands on experiences with the technology.

## What are Containers

They are an isolated, resource controlled, and portable operating environment.

Basically, a container is an isolated place where an application can run without affecting the rest of the system, and without the system affecting the application. Containers are the next evolution in virtualization.

If you were inside a container, it would look very much like you were inside a freshly installed physical computer or a virtual machine. And, to [Docker](https://www.docker.com/), a Windows container can be managed in the same way as any other container.

## Windows Container Types

Windows Containers include two different container types, or runtimes.

**Windows Server Containers** – provide application isolation through process and namespace isolation technology. A Windows Server container shares a kernel with the container host and all containers running on the host.

**Hyper-V Containers** – expand on the isolation provided by Windows Server Containers by running each container in a highly optimized virtual machine. In this configuration the kernel of the container host is not shared with the Hyper-V Containers.

## Container Fundamentals

When you begin working with containers you will notice many similarities between a container and a virtual machine. A container runs an operating system, has a file system and can be accessed over a network just as if it was a physical or virtual computer system. That said, the technology and concepts behind containers are very different from that of virtual machines. The following key concepts will be helpful as you begin creating and working with Windows Containers. 

**Container Host:** Physical or Virtual computer system configured with the Windows Container feature. The container host will run one or more Windows Containers.

**Container Image:** As modifications are made to a containers file system or registry, such as with software installation they are captured in a sandbox.  In many cases you may want to capture this state such that new containers can be created that inherit these changes. That’s what an image is – once the container has stopped you can either discard that sandbox or you can convert it into a new container image. For example, let’s imagine that you have deployed a container from the Windows Server Core OS image. You then install MySQL into this container. Creating a new image from this container would act as a deployable version of the container. This image would only contain the changes made (MySQL), however would work as a layer on top of the Container OS Image.

**Container OS Image:** Containers are deployed from images. The container OS image is the first layer in potentially many image layers that make up a container. This image provides the operating system environment. A Container OS Image is Immutable, it cannot be modified.

**Container Repository:** Each time a container image is created the container image and its dependencies are stored in a local repository. These images can be reused many times on the container host. The container images can also be stored in a public or private registry  such as DockerHub so that they can be used across many different container host.

**Container Registry:** 

## Next Step:

[Windows Server Container Quick Start](./windows_containers_101.md)  
[Windows 10 Container Quick Start](./windows_10_containers_101.md)

