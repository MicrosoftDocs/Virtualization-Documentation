---
title: Container Ecosystem
description: Building a Container Ecosystem.
keywords: metadata, containers
author: scooley
manager: timlt
ms.date: 04/20/2016
ms.topic: about-article
ms.prod: windows-contianers
ms.service: windows-containers
ms.assetid: 29fbe13a-228a-4eaa-9d4d-90ae60da5965
---

# Building a Container Ecosystem

To understand why building a container ecosystem is so important, let's first talk about Docker.

## Docker’s Appeal

The concept of containers (namespace isolation and resource governance) has been around for a long time, going back to BSD Jails, Solaris Zones and the basic UNIX chroot (change root) mechanism.   What Docker has done is provide a common toolset, packaging model, and deployment mechanism.  By doing so, Docker greatly simplified the containerization and distribution of applications.  Those applications can then run anywhere on any Linux host, a capability we're providing on Windows as well.

This ubiquitous technology not only simplifies management by offering the same management commands against any host, it also creates a unique opportunity for seamless DevOps.

From a developer’s desktop to a testing machine to a set of production machines, a Docker image can be created that will deploy identically across any environment in seconds. This story has created a massive and growing ecosystem of applications packaged in Docker containers, with DockerHub, the public containerized-application registry that Docker maintains.

Docker provides a great foundation for development.

Now let's talk about that ecosystem of applications and how you can build on Docker concepts to create a development and deployment workflow suited to your needs.


## Components in a container ecosystem

Windows Containers are a key component of a large container ecosystem. We’re working across the industry to deliver developer choice at each layer of the solution stack.

The container ecosystem provides ways to manage containers, share containers and develop apps that run in containers.

![](media/containerEcosystem.png)

Microsoft wants to empower developer choice and productivity as they build these next-gen apps.  Our goal is to fuel developer productivity which means enabling applications to target any Microsoft cloud without having to modify, rewrite, or reconfigure code.

Microsoft is committed to being open and ecosystem friendly.  We actively support the coming together of multiple developer ecosystems of interest – such as Windows and Linux – to drive innovation.

Over the coming months, we will be providing more information about additional partners in this developing ecosystem.
