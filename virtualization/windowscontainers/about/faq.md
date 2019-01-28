---
title: Windows Containers FAQ
description: Windows Containers FAQ
keywords: docker, containers
author: PatrickLang
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 25de368c-5a10-40a4-b4aa-ac8c9a9ca022
---

# Frequently Asked Questions

## General

### What is WCOW? What is LCOW?

WCOW is an abbreviation for Windows Containers on Windows and LCOW is an abbreviation for Linux Containers on Windows.

### What is the difference between Linux and Windows Server Containers?

Linux and Windows Server Containers are similar -- both implement similar technologies within their kernel and core operating system. The difference comes from the platform and workloads that run within the containers.  
When a customer is using Windows Server Containers, they can integrate with existing Windows technologies such as .NET, ASP.NET, PowerShell, and more.

### As a developer, do I have to re-write my app for each type of container?

No, Windows container images are common across both Windows Server Containers and Hyper-V Containers. The choice of container type is made when you start the container. From a developer standpoint, Windows Server Containers and Hyper-V Containers are two flavors of the same thing. They offer the same development, programming and management experience, are open and extensible and will include the same level of integration and support via Docker.

A developer can create a container image using a Windows Server Container and deploy it as a Hyper-V Container or vice-versa without any changes other than specifying the appropriate runtime flag.

Windows Server Containers will offer greater density and performance (e.g. lower spin up time, faster runtime performance compared to nested configurations) for when speed is key. Hyper-V Containers offer greater isolation, ensuring that code running in one container can't compromise or impact the host operating system or other containers running on the same host. This is useful for multitenant scenarios (with requirements for hosting untrusted code) including SaaS applications and compute hosting.

### What are the prerequisites for running containers on Windows?

Containers were introduced to the platform starting in Windows Server 2016. You must be running either Windows Server 2016 or Windows 10 Anniversary update (version 1607) or newer to use containers.

### Can I run Windows containers in process-isolated mode on Windows 10 Enterprise or Professional?

Beginning with Windows 10 October 2018 Update, we no longer disallow a user from running a Windows container with process isolation. You must directly request for process isolation by using the `--isolation=process` flag when running your containers via `docker run`.

If this is something you're interested in, you need to make sure your host is running Windows 10 build 17763+ and you have a docker version with Engine 18.09 or newer.

> [!WARNING]
> This feature is only meant for development/testing. You should continue to use Windows Server as the host for production deployments.
>
> By using this feature, you must also ensure that your host and container version tags match, otherwise the container may fail to start or can exhibit undefined behavior.

## Windows container management

### How do I make my container images available on air-gapped machines?

The Windows container base images contain artifacts whose distribution is restricted by license. When you build on these images and push them to a private or public registry, you'll notice the base layer is never pushed. Instead, we use the concept of a foreign layer which points to the real base layer residing in Azure cloud storage.

This can present an issue when you have an air-gapped machine that can _only_ pull images from the address of _your_ private container registry. Attempts to follow the foreign layer to get the base image would fail in this case. To override the foreign layer behavior, you can use the `--allow-nondistributable-artifacts` flag in the Docker daemon.

> [!IMPORTANT]
> Usage of this flag shall not preclude your obligation to comply with the terms of the Windows container base image license; you must not post Windows content for public or 3rd party redistribution. Usage within your own environment is allowed.

## Microsoft's open ecosystem

### Is Microsoft participating in the Open Container Initiative (OCI)?

To guarantee the packaging format remains universal, Docker recently organized the Open Container Initiative (OCI), aiming to ensure container packaging remains an open and foundation-led format with Microsoft as one of the founding members.

> [!TIP]
> Have a recommendation for an addition to the FAQ? We encourage you to a new feedback issue below or open a PR against these docs with your recommendations!
