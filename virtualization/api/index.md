---
title: Hyper-V APIs
description: Hyper-V APIs
keywords: windows 10, hypervisor
author: jterry75
ms.date: 12/19/2017
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.assetid: 05269ce0-a54f-4ad8-af75-2ecf5142b866
---
# Hyper-V APIs

Hyper-V APIs give users the freedom to build and manage virtual machines or containers at various levels in the virtualization stack.



## Hyper-V WMI provider

The WMI provider for Hyper-V enable developers, and scripters, to quickly build custom tools, utilities, and enhancements for the virtualization platform. The WMI interfaces can manage all aspects of the Hyper-V services.

> For more information see: [Hyper-V WMI provider (V2)](https://docs.microsoft.com/windows/win32/hyperv_v2/windows-virtualization-portal)


## Host Compute System APIs

The main purpose of the Host Compute System API is to provide platform-level access to VMs and containers on Windows.

The HCS APIs are aimed at developers who want to build applications or management services for VMs or containers. End users are not expected to directly interact with the HCS APIs, the end-user experience (graphical or command line interfaces, higher-level APIs, …) is expected to be provided by the applications or management service that are built on top of the platform APIs.
 
> For more information see: [Host Compute System API](https://docs.microsoft.com/virtualization/api/hcs/overview)


## Windows Hypervisor Platform
 
>**This API is available starting in the Windows April 2018 Update.**

The Windows Hypervisor Platform adds an extended user-mode API for third-party virtualization stacks and applications to create and manage partitions at the hypervisor level, configure memory mappings for the partition, and create and control execution of virtual processors.

> Ex: A client such as QEMU can run on the hypervisor while maintaining its management, configuration, guest/host protocols and guest supported drivers. All while running alongside a Hyper-V managed partition with no overlap.

> For more information see: [Windows Hypervisor Platform API](./hypervisor-platform/hypervisor-platform.md)


## Comparison between WHP, WMI and HCS APIs

WHP APIs required the third-party virtualization stack to run VM, while HCS APIs and WMI APIs are built in virtualization stack of Windows. As the scenerio extended, WMI APIs would provice more management instructions as well as more restrictions and policies.

WMI APIs are really tailored towards high level workflows in server virtualization scenarios, while HCS APIs are designed to manage local VM workflow intentionally that provide more flexibility but more responsibility for application services that need more direct access to containers or local VMs on a single machine.

WMI APIs mainly focus on on-prem server management, which provide high level abstractions that really fit into on-prem server virtualization workflows. For example, when WMI APIs were chosen, the WMI model would be fully applied to VMs, which would add full list of default virtual devices even you only want to create a simple VM. As for HCS APIs, becuase of the broad scope of different use cases for VM outside of server virtualization, like container and WSL, the goal of HCS APIs is to provide more low-level, more granular API service, on the one side to give more flexibility about things like how VM configured, on the other side to assign more management work to the users, which means it doesn't force the specific management model onto the call of the APIs.


## Virtualization Related Tools

### Virtual Hard Disk Interface

The Virtual Hard Disk (VHD) format is a publicly-available image format specification that specifies a virtual hard disk encapsulated in a single file, capable of hosting native file systems while supporting standard disk and file operations. The Windows SDK supports an API to create and manage the virtual disk.

> For more information see: [Virtual Hard Disk Interface](https://docs.microsoft.com/en-us/windows/win32/api/virtdisk/)


### Host Compute Network Service API

Host Compute Network (HCN) service API is a public-facing Win32 API that provides platform-level access to manage the virtual networks, virtual network endpoints, and associated policies. 

> For more information see: [HCN Service API](https://docs.microsoft.com/en-us/windows-server/networking/technologies/hcn/hcn-top)


### Hypervisor Instruction Emulator API

Hypervisor Instruction Emulator API is used to handle the communication between the accelerators and the device emulation that are not provided directly by Windows Hypervisor Platform APIs.

> For more information see: [Hypervisor Instruction Emulator API](./hypervisor-instruction-emulator/hypervisor-instruction-emulator.md)


### VM Saved State Dump Provider

The Windows SDK includes an API for accessing raw dumps of a VM saved state.

 >For more information see: [VM Saved State Dump Provider API](./vm-dump-provider/vm-dump-provider.md)

