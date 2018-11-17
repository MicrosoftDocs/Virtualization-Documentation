---
title: Building the container stack
description: Learn more about new container building blocks available in Windows.
keywords: LCOW, linux containers, docker, containers, containerd, cri, runhcs, runc
author: scooley
ms.date: 11/11/2018
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: a0e62b32-0c4c-4dd4-9956-8056e9abd9e5
---

# Container platform tools in Windows

In Linux environments, tools like Docker and Kubernetes are built on another, more fundamental, container runtime called [runc](https://github.com/opencontainers/runc).  Runc is a Linux command line tool for creating and running containers according to the [OCI container runtime specification](https://github.com/opencontainers/runtime-spec).

To make it easier to extend container tools to run Windows containers and run on a Windows container host, we've introduced a Windows counterpart to runc, [runhcs](https://github.com/Microsoft/hcsshim/tree/master/cmd/runhcs).  Just like runc, runhcs runs containers defined by an OCI spec.  

We're also contributing to containerd/containerd and containerd/cri to use runhcs on Windows so the windows container ecosystem use containerd for both Windows and Linux containers.

To this point, Windows hasn't had a command line tool for creating and running containers - Docker is built directly on a Windows C API called the Host Compute Service (HCS).  Now runhcs is the layer that calls into the HCS directly, other container tools are built on it rather than the HCS directly.

![Containerd based container environments](media/containerd-platform.png)
Some set up required :)

![LCOW Process map](media/containerd-process-map.png)