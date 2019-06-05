---
title: About Docker
description: Learn about Docker.
keywords: docker, containers
author: Heidilohr
ms.author: helohr
ms.date: 05/22/2019
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
---
# About Docker

As you read about containers, you’ll inevitably hear about Docker. The Docker Engine is a container management toolset that packages and delivers container images. The resulting images can be run anywhere as a container, whether it's on-premises, in the cloud, or on a personal machine.

![](media/docker.png)

You can manage a Windows Server container with [Docker](https://www.docker.com) just like any other container.

The concept of namespace isolation and resource governance through a container has been around for a long time, going back to BSD Jails, Solaris Zones, and the basic UNIX change root (chroot) mechanism. Docker lays a solid foundation for development through a common toolset, packaging model, and deployment mechanism that simplify the containerization and distribution of applications. These applications can then run anywhere on any Linux host and in Windows.

A ubiquitous packaging model and deployment technology simplifies management by offering the same management commands against any host, creating a unique opportunity for seamless DevOps. You can also create a Docker image that will deploy identically across any environment in seconds, whether it's a developer’s desktop, a testing machine, or a set of production machines. This has created a massive and growing ecosystem of applications packaged in Docker containers with DockerHub, the public containerized application registry that Docker maintains.

Now, let's talk about that ecosystem of applications and how you can build on Docker concepts to create a development and deployment workflow suited to your needs.

## Get started with Docker

To learn how to build containers with Docker, see [Docker Engine on Windows](../manage-docker/configure-docker-daemon.md). You can also visit [the Docker website](https://www.docker.com) for a more in-depth look at how to use Docker.