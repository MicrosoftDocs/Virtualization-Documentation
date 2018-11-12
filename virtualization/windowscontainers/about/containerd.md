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

We're building container primitives that match Linux container primitives in accordance to OCI specs.  We're building a Windows-based version if runc.  We're also contributing to containerd/containerd and containerd/cri to use runhcs on Windows so the windows container ecosystem can mirror the Linux container ecosystem.

This makes it easier for orchestrators like Kubernetes to choose between docker and containerd.

Some set up required :)

![LCOW Process map](media/containerd-process-map.png)