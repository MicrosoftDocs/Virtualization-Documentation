---
title: Windows Server Container Orchestration
description: Ochistration options for Windows Server Containers.
keywords: docker, containers, ochistration
author: taylorb-microsoft
manager: timlt
ms.date: 12/13/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 6c6979e0-3548-4f22-ad53-f1cd92a514c1
---
DRAFT
# Container Orchestration
Orchestration is a key component of developing for and with containers and nearly required for successfully running containers in production.  The orchestrator is responsible for understanding the relationship between one or more containers that operate as a service or application, the underlying container hosts and the other resources (storage, networking etc…) within the environment.  For those coming from the world of virtual machines you might think of orchestrator as being quite like tools such as System Center Virtual Machine Manager, VMware VCenter or OpenStack.
There are several orchestration options available to Windows Server Containers with even more already under development.  The choice of which orchestrator to use comes down to the environment you deploy in, the operational models you use and an element of personal choice.
## Docker Datacenter and Swarm Mode

## Kubernetes
Getting Started: [Windows Server Container Documentation on http://kubernetes.io/](http://kubernetes.io/docs/getting-started-guides/windows/)
## Microsoft Service Fabric
