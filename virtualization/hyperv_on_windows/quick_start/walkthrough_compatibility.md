---
title: Windows 10 Hyper-V System Requirements
description: Windows 10 Hyper-V System Requirements
keywords: windows 10, hyper-v
author: scooley
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-10-hyperv
ms.service: windows-10-hyperv
ms.assetid: 6e5e6b01-7a9d-4123-8cc7-f986e10cd372
---

# Windows 10 Hyper-V System Requirements

Hyper-V on Windows 10 only works under a specific set of operating system and hardware configurations. This document shows the Hyper-V requirements, and how you can check your system for compatibility.

## Operating System Requirements

The Hyper-V role can be enabled on these versions of Windows 10:

- Windows 10 Enterprise
- Windows 10 Professional
- Windows 10 Education

The Hyper-V role **cannot** be installed on:

- Windows 10 Home
- Windows 10 Mobile
- Windows 10 Mobile Enterprise

>Windows 10 Home edition can be upgraded to Windows 10 Professional. To do so open up **Settings** > **Update and Security** > **Activation**. Here you can visit the store and purchase an upgrade.

## Hardware Requirements

Although this document does not provide a complete list of Hyper-V compatible hardware, the following items are necessary:
	
- 64-bit Processor with Second Level Address Translation (SLAT).
- CPU support for VM Monitor Mode Extension (VT-c on Intel CPU's).
- Minimum of 4 GB memory. As virtual machines share memory with the Hyper-V host, you will need to provide enough memory to handle the expected virtual workload.

The following items will need to be enabled in the system BIOS:
- Virtualization Technology - may have a different label depending on motherboard manufacturer.
- Hardware Enforced Data Execution Prevention.

## Verify Hardware Compatibility

To verify compatibility, open up PowerShell or a command prompt (cmd.exe) and type **systeminfo.exe**. If all listed Hyper-V requirements have a value of **Yes**, your system can run the Hyper-V role. If any item returns **No**, check the requirements listed in this document and make adjustments where possible.

![](media/SystemInfo_upd.png)

If you run **systeminfo.exe** on an existing Hyper-V host, the Hyper-V Requirements section reads:

```
Hyper-V Requirements: A hypervisor has been detected. Features required for Hyper-V are not be displayed.
```

## Next Step - Install Hyper-V
[Install Hyper-V](walkthrough_install.md)
