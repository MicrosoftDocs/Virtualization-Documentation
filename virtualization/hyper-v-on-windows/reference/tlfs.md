---
title: Hypervisor Specifications
description: Hypervisor Specifications
keywords: windows 10, hyper-v
author: allenma
ms.date: 06/26/2018
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
Windows Server 2016 (Revision C) | [Hypervisor Top Level Functional Specification v5.0c.pdf](https://github.com/MicrosoftDocs/Virtualization-Documentation/raw/live/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v5.0C.pdf)
Windows Server 2012 R2 (Revision B) | [Hypervisor Top Level Functional Specification v4.0b.pdf](https://github.com/Microsoft/Virtualization-Documentation/raw/master/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v4.0b.pdf)
Windows Server 2012 | [Hypervisor Top Level Functional Specification v3.0.pdf](https://github.com/Microsoft/Virtualization-Documentation/raw/master/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v3.0.pdf)
Windows Server 2008 R2 | [Hypervisor Top Level Functional Specification v2.0.pdf](https://github.com/Microsoft/Virtualization-Documentation/raw/master/tlfs/Hypervisor%20Top%20Level%20Functional%20Specification%20v2.0.pdf)

## Requirements for Implementing the Microsoft Hypervisor Interface

The TLFS fully describes all aspects of the Microsoft-specific hypervisor architecture, which is declared to guest virtual machines as the "HV#1" interface.  However, not all interfaces described in the TLFS are required to be implemented by third-party hypervisor wishing to declare conformance with the Microsoft HV#1 hypervisor specification. The document "Requirements for Implementing the Microsoft Hypervisor Interface" describes the minimal set of hypervisor interfaces which must be implemented by any hypervisor which claims compatibility with the Microsoft HV#1 interface.

#### Download

[Requirements for Implementing the Microsoft Hypervisor Interface.pdf](https://github.com/Microsoft/Virtualization-Documentation/raw/master/tlfs/Requirements%20for%20Implementing%20the%20Microsoft%20Hypervisor%20Interface.pdf)
