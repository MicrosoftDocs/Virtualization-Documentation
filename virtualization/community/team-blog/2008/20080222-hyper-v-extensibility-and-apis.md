---
title: Hyper-V Extensibility and APIs
description: post id 3813
keywords: virtualization, virtual server, virtual pc, blog
author: scooley
ms.author: scooley
ms.date: 2/22/2008
ms.topic: article
ms.assetid: 
---

# Hyper-V Extensibility and APIs

Virtualization Nation,  
It's been a while since my last post (sorry about that), but ever since we released the Hyper-V Beta a few months ago, the feedback over Hyper-V is off the charts. We're glad that folks are able to easily evaluate Hyper-V and thrilled with the overwhelmingly positive feedback. Keep it coming! With all of the big news about interoperability, it seemed like a perfect opportunity for me to point out ways that our customers and partners can build solutions with Hyper-V. Here’s a complete list with links to our virtualization managements APIs and virtual hard disk format.

**Virtual hard disk format**. The virtual hard disk (VHD) format is a block based format used to store the contents of a virtual machine.  

**Hyper-V WMI APIs**. Hyper-V uses WMI APIs to create, manage, monitor, configure virtual resources. We expect the Hyper-V WMI APIs to be used widely in a variety of ways such as:

* By third party management vendors who want to manage Hyper-V
* By enterprises who want to integrate with an existing management solution
* Developers who want to automate virtualization in a test/dev environments

> **More about WMI:** Windows Management Instrumentation (WMI) is the Microsoft implementation of Web-Based Enterprise Management (WBEM), which is an industry initiative to develop a standard technology for accessing management information in an enterprise environment. WMI uses the Common Information Model (CIM) industry standard to represent systems, applications, networks, devices, and other managed components. CIM is developed and maintained by the Distributed Management Task Force (DMTF) of which Microsoft is an active participant.

The Hyper-V WMI APIs are publicly available **Hypercall APIs**.  Hypercall APIs are a programmatic interface to the Microsoft hypervisor. A few of the higher level functions include:

* Partition management (created, delete, manage partition state)
* Physical hardware management (system physical address space, logical processors, local APICs)
* Guest physical address spaces
* Intercepts. Parent partition may need to handle certain situations on behalf of a child partition
* Virtual interrupt control.
* Inter-partition communication
* Partition save and restore
* Scheduler. (set scheduler policy management for CPU reserves, caps and weights)
* and more

The Microsoft Hypercall Interface is publicly available [here](https://www.microsoft.com/downloads/details.aspx?FamilyID=91E2E518-C62C-4FF2-8E50-3A37EA4100F5&displaylang=en).

You may be wondering when someone would use the WMI APIs versus the Hypercall APIs. The Hyper-V WMI APIs are for creating, configuring and monitoring virtual resources while the Hypercall APIs are for very special purpose low-level work like IDE/debugger development.

Cheers,   
Jeff

[Original post](https://blogs.technet.microsoft.com/virtualization/2008/02/22/hyper-v-extensibility-and-apis/)