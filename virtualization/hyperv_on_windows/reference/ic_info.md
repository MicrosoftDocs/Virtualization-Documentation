---
title: Hyper-V Integration Services
description: Reference for Hyper-V Integration Services
keywords: windows 10, hyper-v, integration services, integration components
author: scooley
manager: timlt
ms.date: 05/25/2016
ms.topic: article
ms.prod: windows-10-hyperv
ms.service: windows-10-hyperv
ms.assetid: 18930864-476a-40db-aa21-b03dfb4fda98
---

# Hyper-V Integration Services

## Quick Reference

| Name | Windows Service Name | Linux Daemon Name |  Description | Added In | Impact | Notes |
|:---------|:---------|:---------|:---------|:---------|:---------|:---------|
| Hyper-V Heartbeat Service |  vmicheartbeat | hv_utils | Monitors the state of this virtual machine by reporting a heartbeat at regular intervals. This service helps you identify running virtual machines that have stopped responding. | Windows Server 2012, Windows 8 | When disabled, the virtual machine can't report that the guest is operating correctly to the host.  This may impact some kinds of monitoring. |  |
| Hyper-V Guest Shutdown Service | vmicshutdown | hv_utils |  Provides a mechanism to shut down the operating system of this virtual machine from the management interfaces on the physical computer. | Windows Server 2012, Windows 8 | **High Impact**  When disabled, the host can't trigger a shutdown inside the virtual machine.  All shutdowns will be a hard power-off. |  |
| Hyper-V Time Synchronization Service | vmictimesync | hv_utils | Synchronizes the system time of this virtual machine with the system time of the physical computer. | Windows Server 2012, Windows 8 | **High Impact**  When disabled, the virtual machine's clock will drift erratically. |  |
| Hyper-V Data Exchange Service | vmickvpexchange | hv_kvp_daemon | Provides a mechanism to exchange data between the virtual machine and the operating system running on the physical computer. | Windows Server 2012, Windows 8 | | Also called KVP.  Read more [here](https://technet.microsoft.com/en-us/library/dn798287.aspx) |
| Hyper-V Volume Shadow Copy Requestor | vmicvss | hv_vss_daemon | Coordinates the communications that are required to use Volume Shadow Copy Service to back up applications and data on this virtual machine from the operating system on the physical computer. | Windows Server 2012, Windows 8 | When disabled, the virtual machine can not be backed up while running (using VSS). |  | 
| Hyper-V Guest Service Interface | vmicguestinterface | hv_fcopy_daemon | Provides an interface for the Hyper-V host to interact with specific services running inside the virtual machine. | Windows Server 2012 R2, Windows 8.1 | When disabled, the host can not copy files to and from the guest using `Copy-VMFile`.  Read more about the [Copy-VMFile cmdlet](https://technet.microsoft.com/library/dn464282.aspx). | Disabled by default.  PowerShell Direct is available by default.  We recomend using Copy-Item. |
| Hyper-V PowerShell Direct Service | vmicvmsession | | Provides a mechanism to manage virtual machine with PowerShell via VM session without a virtual network. | Windows Server TP3, Windows 10 | Disabling this service prevents the host from being able to connect to the virtual machine with PowerShell Direct.  Read more [here](https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/vmsession). | The service originally was Hyper-V VM Session Service.  This service is under active development.  |  
