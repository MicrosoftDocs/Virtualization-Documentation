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
# Virtualization Platforms
Virtualization platforms give users the freedom to build and manage virtual machines or contiainers at various levels in the virtualization stack.

# Windows Hypervisor Platform
 
>**This API is available starting in the Windows April 2018 Update.**

The Windows Hypervisor Platform adds an extended user-mode API for third-party virtualization stacks and applications to create and manage partitions at the hypervisor level, configure memory mappings for the partition, and create and control execution of virtual processors.

> Ex: A client such as QEMU can run on the hypervisor while maintaining its management, configuration, guest/host protocols and guest supported drivers. All while running alongside a Hyper-V managed partition with no overlap.

The following diagram provides a high-level overview of the third-party architecture.

![](./media/windows-hypervisor-platform-architecture.png)
> For more information see: [Windows Hypervisor Platform API](./hypervisor-platform/hypervisor-platform.md)

## Host Compute System
The main purpose of the Host Compute System API is to provide platform-level access to VMs and containers on Windows.

The HCS APIs are aimed at developers who want to build applications or management services for VMs or containers. End users are not expected to directly interact with the HCS APIs, the end-user experience (graphical or command line interfaces, higher-level APIs, …) is expected to be provided by the applications or management service that are built on top of the platform APIs.
 
> For more information see: [Host Compute System API](./hcs/hcs.md)

## VM Saved State Dump Provider

The Windows SDK includes an API for accessing raw dumps of a VM saved state.
 >For more information see: [VM Saved State Dump Provider API](./vm-dump-provider/vm-dump-provider.md)

