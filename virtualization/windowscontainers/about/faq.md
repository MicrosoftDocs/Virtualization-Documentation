---
title: Windows Containers FAQ
description: Windows Containers FAQ
keywords: docker, containers
author: scooley
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 25de368c-5a10-40a4-b4aa-ac8c9a9ca022
---

# Frequently Asked Questions

## About Windows containers

**What is a Windows Server Container?**

Windows Server Containers are a lightweight operating system virtualization method used to separate applications or services from other services running on the same container host. To enable this, each container has its own view of the operating system, processes, file system, registry, and IP addresses.  

**What is a Hyper-V Container?**

You can think of a Hyper-V Container as a Windows Server Container running inside of a Hyper-V partition.

Hyper-V Containers offer an additional deployment option between the highly efficient, high-density Windows Server Container and the highly isolated hardware-virtualized Hyper-V virtual machine. For environments where applications from different trust boundaries on the same host, additional isolation may be required. Hyper-V Containers will provide higher isolation using an optimized virtualization and Windows Server operating system that separates containers from each other and from the host operating system. Both container deployment options utilize the same management APIs, tools and image formats, at deployment time, customers can simply choose which deployment mode best meets their requirements.

**What is the difference between Linux and Windows Server Containers?**

Linux and Windows Server Containers are similar -- both implement similar technologies within their kernel and core operating system. The difference comes from the platform and workloads that run within the containers.  
When a customer is using Windows Server Containers, they can integrate with existing Windows technologies such as .NET, ASP.NET, PowerShell and more.

**As a developer, do I have to re-write my app for each type of container?**

No, Windows container images are common across both Windows Server Containers and Hyper-V Containers. The choice of container type is made when you start the container. From a developer standpoint, Windows Server Containers and Hyper-V Containers are two flavors of the same thing.  They offer the same development, programming and management experience, are open and extensible and will include the same level of integration and support via Docker.

A developer can create a container image using a Windows Server Container and deploy it as a Hyper-V Container or vice-versa without any changes other than specifying the appropriate runtime flag.

Windows Server Containers will offer greater density and performance (e.g. lower spin up time, faster runtime performance compared to nested configurations) for when speed is key. Hyper-V Containers offer greater isolation, ensuring that code running in one container can't compromise or impact the host operating system or other containers running on the same host. This is useful for multitenant scenarios (with requirements for hosting untrusted code) including SaaS applications and compute hosting.

**Are Hyper-V/Windows Server Containers an add-on, or will they integrated within Windows Server?**

The container capabilities will be integrated into Windows Server 2016. Stay tuned for more information closer to the general availability.  

**What is the relationship between Windows Server Containers and Drawbridge?**

Drawbridge was one of many research projects that helped us gain valuable insights into containers.  Much of container technology in Windows Server 2016 was born from the experience we had with Drawbridge and we are excited to be bringing world class container technologies to our customers in Windows Server 2016.

**What are the prerequisites for Windows Server Containers and Hyper-V Containers?**

Both Window Server Containers and Hyper-V Containers require Windows Server 2016. These technologies will not work with previous versions of Windows.


## Windows container management

**Will Hyper-V Containers also be available to the Docker ecosystem?**

Yes – Hyper-V Containers will provide the same level of integration and management with Docker as Windows Server Containers.  The goal is to have an open, consistent, cross-platform experience.  
The Docker platform will also greatly simplify and enhance the experience of working across our container options. An application developed using Windows Server Containers can be deployed as a Hyper-V Container without change.


## Microsoft's open ecosystem

**Is Microsoft participating in the Open Container Initiative (OCI)?**

To guarantee the packaging format remains universal, Docker recently organized the Open Container Initiative (OCI), aiming to ensure container packaging remains an open and foundation-led format with Microsoft as one of the founding members.

**Is Microsoft really partnering with Docker?**

Yes.  
Our partnership with Docker enables developers to create, manage and deploy both Windows Server and Linux containers using the same Docker tool set. Developers targeting Windows Server will no longer have to make a choice between using the vast range of Windows Server technologies and building containerized applications.  

Docker is two things, the open source group of projects and Docker the company. We consider this partnership to include both. Docker is successful, in part, because of the vibrant ecosystem that has built up around the Docker container technology. Microsoft is contributing to the Docker Project, enabling support for Windows Server Containers and Hyper-V Containers.  

For more information, see the [New Windows Server containers and Azure support for Docker](http://azure.microsoft.com/blog/2014/10/15/new-windows-server-containers-and-azure-support-for-docker/?WT.mc_id=Blog_ServerCloud_Announce_TTD) blog post.
