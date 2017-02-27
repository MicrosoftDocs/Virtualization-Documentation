---
title: Hypervisor Specifications
description: Hypervisor Specifications
keywords: windows 10, hyper-v
author: theodthompson
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-10-hyperv
ms.service: windows-10-hyperv
ms.assetid: aee64ad0-752f-4075-a115-2d6b983b4f49
---

# Hypervisor Specifications

## Hypervisor Top-Level Functional Specification

The Hyper-V Hypervisor Top-Level Functional Specification (TLFS) describes the hypervisor's externally visible behavior to other operating system components. This specification is meant to be useful for guest operating system developers.
  
> This specification is provided under the Microsoft Open Specification Promise.  Read the following for further details about the [Microsoft Open Specification Promise](https://msdn.microsoft.com/en-us/openspecifications).  

#### Download
Release | Document
--- | ---
Windows Server 2012 R2 (Revision B) | [Hypervisor Top Level Functional Specification v4.0b.pdf](https://github.com/Microsoft/Virtualization-Documentation/raw/master/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v4.0b.pdf)
Windows Server 2012 R2 | [Hypervisor Top Level Functional Specification v4.0.pdf](https://github.com/Microsoft/Virtualization-Documentation/raw/master/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v4.0.pdf)
Windows Server 2012 | [Hypervisor Top Level Functional Specification v3.0.pdf](https://github.com/Microsoft/Virtualization-Documentation/raw/master/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v3.0.pdf)
Windows Server 2008 R2 | [Hypervisor Top Level Functional Specification v2.0.pdf](https://github.com/Microsoft/Virtualization-Documentation/raw/master/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v2.0.pdf)

## Requirements for Implementing the Microsoft Hypervisor Interface

Windows operating systems require a limited set of hypervisor interfaces to run in a guest virtual machine (also known as the "HV#1" interface). In addition, several optional features can be implemented by a Microsoft-compatible hypervisor. These options will change the behavior of Windows in a virtual machine. "Requirements for Implementing the Microsoft Hypervisor Interface" describes both the required and optional features that are implemented by a Microsoft-compatible hypervisor.

#### Download

[Requirements for Implementing the Microsoft Hypervisor Interface.pdf](https://github.com/Microsoft/Virtualization-Documentation/raw/master/tlfs/Requirements%20for%20Implementing%20the%20Microsoft%20Hypervisor%20Interface.pdf)