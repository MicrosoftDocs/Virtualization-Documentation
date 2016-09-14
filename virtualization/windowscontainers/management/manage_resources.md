---
title: Container Resource Management
description: Manage container resources with Windows containers.
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: b2192e64-9d74-474e-8af0-2d8b3ad1deee
redirect_url: https://docs.docker.com/engine/reference/run/
---

# Container Resource Management

**This is preliminary content and subject to change.** 

Windows containers include the ability to manage how much CPU, disk IO, network and memory resources containers can consume. Constraining container resource consumptions allows host resources to be used efficiently, and prevents over consumption. This document will detail managing container resources with Docker.

## Manage Resources with Docker 

We offer the ability to manage a subset of container resources through Docker. Specifically, we allow users to specify how the cpu is shared amongst containers. 

### CPU

CPU shares amongst containers can be managed at runtime via the --cpu-shares flag. By default, all containers enjoy an equal proportion of CPU time. To change the relative share of CPU that containers use run the --cpu-shares flag with a value from 1-10000. By default, all containers receive a weight of 5000. For more information on CPU share constraint see the [Docker Run Reference]( https://docs.docker.com/engine/reference/run/#cpu-share-constraint). 

```none 
docker run -it --cpu-shares 2 --name dockerdemo windowsservercore cmd
```

## Known Issues

- CPU and IO Resource Controls are not currently supported with Hyper-V containers.
- IO Resource Controls are not currently supported with container data volumes.