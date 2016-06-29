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

## Hyper-V Heartbeat Service

**Windows Service Name:** vmicheartbeat  
**Linux Daemon Name:** hv_utils  
**Description:** Reports a single bit heartbeat at regular intervals to show that the virtual machine is running correctly.  
**Added In:** Windows Server 2012, Windows 8  
**Impact:** When disabled, the virtual machine can't report that the guest is operating correctly.  This may impact some kinds of monitoring and host-side diagnostics.   


## Hyper-V Guest Shutdown Service

**Windows Service Name:** vmicshutdown  
**Linux Daemon Name:** hv_utils  
**Description:** Provides a mechanism to cleanly shut down the virtual machine from the host.  
**Added In:** Windows Server 2012, Windows 8  
**Impact:** **High Impact**  When disabled, the host can't trigger a friendly shutdown inside the virtual machine.  All shutdowns will be a hard power-off.


## Hyper-V Time Synchronization Service
Windows Service Name
Linux Daemon Name
Description
Added In
Impact

 | vmictimesync | hv_utils | Synchronizes the virtual machine's system clock with the system clock of the physical computer. | Windows Server 2012, Windows 8 | **High Impact**  When disabled, the virtual machine's clock will drift erratically. |  |


## Hyper-V Data Exchange Service (KVP)
Windows Service Name
Linux Daemon Name
Description
Added In
Impact

vmickvpexchange | hv_kvp_daemon | Provides a mechanism to exchange basic metadata between the virtual machine and the host. | Windows Server 2012, Windows 8 | | Also called KVP.  Read more [here](https://technet.microsoft.com/en-us/library/dn798287.aspx) |

## Hyper-V Volume Shadow Copy Requestor
Windows Service Name
Linux Daemon Name
Description
Added In
Impact

 | vmicvss | hv_vss_daemon | Allows Volume Shadow Copy Service to back up applications and data on the virtual machine. | Windows Server 2012, Windows 8 | When disabled, the virtual machine can not be backed up while running (using VSS). |  | 

## Hyper-V Guest Service Interface
Windows Service Name
Linux Daemon Name
Description
Added In
Impact

| vmicguestinterface | hv_fcopy_daemon | Provides an interface for the Hyper-V host to bidirectionally copy files to or from the virtual machine. | Windows Server 2012 R2, Windows 8.1 | When disabled, the host can not copy files to and from the guest using `Copy-VMFile`.  Read more about the [Copy-VMFile cmdlet](https://technet.microsoft.com/library/dn464282.aspx). | Depricated in Windows 10.  Disabled by default.  See PowerShell Direct using Copy-Item. |


## Hyper-V PowerShell Direct Service
Windows Service Name
Linux Daemon Name
Description
Added In
Impact

| vmicvmsession | | Provides a mechanism to manage virtual machine with PowerShell via VM session without a virtual network. | Windows Server TP3, Windows 10 | Disabling this service prevents the host from being able to connect to the virtual machine with PowerShell Direct.  Read more [here](https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/vmsession). | The service originally was Hyper-V VM Session Service.  This service is under active development.  |  

## Additional Resources

**Integration service update and maintainance**
* [user guide](../user_guide/managing_ics.md)