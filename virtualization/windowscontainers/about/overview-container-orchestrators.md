---
title: Windows Container Orchestration Overview
description: Learn about Windows container orchestrators.
keywords: docker, containers
author: Heidilohr
ms.author: helohr
ms.date: 05/22/2019
ms.topic: overview
ms.prod: windows-containers
ms.service: windows-containers
---
# Windows Container Orchestration Overview

Because of their small size and application orientation, containers are perfect for agile delivery environments and microservice-based architectures. However, an environment that uses containers and microservices can have hundreds or thousands of components to keep track of. You might be able to manually manage a few dozen virtual machines or physical servers, but there's no way to properly manage a production-scale container environment without automation. This task should fall to your orchestrator, which is a process that automates and manages a large number of containers and how they interact with each other.

Orchestrators perform the following tasks:

- Scheduling: When given a container image and a resource request, the orchestrator finds a suitable machine on which to run the container.
- Affinity/Anti-affinity: Specify whether a set of containers should run near each other for performance or far apart for availability.
- Health monitoring: Watch for container failures and automatically reschedule them.
- Failover: Keep track of what's running on each machine and reschedule containers from failed machines to healthy nodes.
- Scaling: Add or remove container instances to match demand, manually or automatically.
- Networking: Provide an overlay network that coordinates containers to communicate across multiple host machines.
- Service discovery: Enable containers to locate each other automatically even as they move between host machines and change IP addresses.
- Coordinated application upgrades: Manage container upgrades to avoid application down time and enable rollback if something goes wrong.

## Orchestrator types

Azure offers two container orchestrators: Azure Kubernetes Service (AKS) and Service Fabric.

[Azure Kubernetes Service (AKS)](/azure/aks/) makes it simple to create, configure, and manage a cluster of virtual machines preconfigured to run containerized applications. This enables you to use your existing skills and draw upon a large and growing body of community expertise to deploy and manage container-based applications on Microsoft Azure. By using AKS, you can take advantage of the enterprise-grade features of Azure while still maintaining application portability through Kubernetes and the Docker image format.

[Azure Service Fabric](/azure/service-fabric/) is a distributed systems platform that makes it easy to package, deploy, and manage scalable and reliable microservices and containers. Service Fabric addresses the significant challenges in developing and managing cloud native applications. Developers and administrators can avoid complex infrastructure problems and focus on implementing mission-critical, demanding workloads that are scalable, reliable, and manageable. Service Fabric represents the next-generation platform for building and managing these enterprise-class, tier-1, cloud-scale applications running in containers.

## Getting started

To get started deploying Azure Kubernetes service, see the [Kubernetes setup guide](../kubernetes/getting-started-kubernetes-windows.md).

To get started deploying Azure Service Fabric, see the [Service Fabric quickstart](/azure/service-fabric/service-fabric-quickstart-containers.md).
