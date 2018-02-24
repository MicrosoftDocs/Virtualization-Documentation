---
title: Windows Hypervisor Platform
description: Windows Hypervisor Platform
keywords: windows 10, hypervisor
author: jterry75
ms.date: 12/19/2017
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.assetid: 05269ce0-a54f-4ad8-af75-2ecf5142b866
---

# Windows Hypervisor Platform

The Windows Hypervisor Platform adds an extended user-mode API for third-party virtualization stacks and applications to create and manage partitions at the hypervisor level, configure memory mappings for the partition, and create and control execution of virtual processors.

> Ex: A client such as QEMU can run on the hypervisor while maintaining its management, configuration, guest/host protocols and guest supported drivers. All while running alongside a Hyper-V managed partition with no overlap.

The following diagram provides a high-level overview of the third-party architecture.

![](./media/windows-hypervisor-platform-architecture.png)
> For more information see: [Windows Hypervisor Platform API](./hypervisor-platform/hypervisor-platform.md)
**Note: A prerelease of this API is available starting in the Windows Insiders Preview Build 17083**

##VM Saved State Dump Provider

The Windows SDK includes an API for accessing raw dumps of a VM saved state. For more information see: [VM Saved State Dump Provider API](./vm-dump-provider/vm-dump-provider.md)

