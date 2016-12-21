---
title: Windows Containers Quick Start
description: Windows containers quick start.
keywords: docker, containers
author: enderb-ms
ms.date: 05/26/2016
ms.topic: article
ms.prod: windows-contianers
ms.service: windows-containers
ms.assetid: 4878f5d2-014f-4f3c-9933-97f03348a147
---

# Windows Containers Quick Start

The Windows container quick start introduces the product and container terminology, steps through simple container deployment examples, and also provides reference for more advanced topics. If you are new to containers or Windows containers, walking through each step of this quick start will provide you with practical hands on experiences with the technology.

## 1. What are Containers

They are an isolated, resource controlled, and portable operating environment.

Basically, a container is an isolated place where an application can run without affecting the rest of the system, and without the system affecting the application. Containers are the next evolution in virtualization.

If you were inside a container, it would look very much like you were inside a freshly installed physical computer or a virtual machine. And, to [Docker](https://www.docker.com/), a Windows container can be managed in the same way as any other container.

## 2. Windows Container Types

Windows Containers include two different container types, or runtimes.

**Windows Server Containers** – provide application isolation through process and namespace isolation technology. A Windows Server container shares a kernel with the container host and all containers running on the host.

**Hyper-V Containers** – expand on the isolation provided by Windows Server Containers by running each container in a highly optimized virtual machine. In this configuration the kernel of the container host is not shared with other Hyper-V Containers.

## 3. Container Fundamentals

When you begin working with containers you will notice many similarities between a container and a virtual machine. A container runs an operating system, has a file system and can be accessed over a network just as if it was a physical or virtual computer system. That said, the technology and concepts behind containers are very different from that of virtual machines. The following key concepts will be helpful as you begin creating and working with Windows Containers. 

**Container Host:** - Physical or Virtual computer system configured with the Windows Container feature.

**Container OS Image:** - Containers are deployed from images. The container OS image is the first layer in potentially many image layers that make up a container. This image provides the operating system environment.

**Container Image:** - A container image contains the base operating system, application, and all application dependencies needed to quickly deploy a container. 

**Container Registry:** - Container images are stored in a container registry, and can be downloaded on demand. 

**Dockerfile:** - Dockerfiles are used to automate the creation of container images.

## Next Step:

[Windows Server Container Quick Start](quick-start-windows-server.md)  

[Windows 10 Container Quick Start](quick-start-windows-10.md)

