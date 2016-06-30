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

| Name | Windows Service Name | Linux Daemon Name |  Description | Impact on VM when disabled |
|:---------|:---------|:---------|:---------|:---------|
| [Hyper-V Heartbeat Service](#hyper-v-heartbeat-service) |  vmicheartbeat | hv_utils | Reports a single bit heartbeat at regular intervals to show that the virtual machine is running correctly. | Varies |
| [Hyper-V Guest Shutdown Service](#hyper-v-guest-shutdown-service) | vmicshutdown | hv_utils |  Provides a mechanism to cleanly shut down the virtual machine from the host. | **High** |
| [Hyper-V Time Synchronization Service](#hyper-v-time-synchronization-service) | vmictimesync | hv_utils | Synchronizes the virtual machine's system clock with the system clock of the physical computer. | **High** |
| [Hyper-V Data Exchange Service (KVP)](#hyper-v-data-exchange-service-kvp) | vmickvpexchange | hv_kvp_daemon | Provides a mechanism to exchange basic metadata b etween the virtual machine and the host. | Medium |
| [Hyper-V Volume Shadow Copy Requestor](#hyper-v-volume-shadow-copy-requestor) | vmicvss | hv_vss_daemon | Allows Volume Shadow Copy Service to back up applications and data on the virtual machine. | Varies |
| [Hyper-V Guest Service Interface](#hyper-v-powershell-direct-service) | vmicguestinterface | hv_fcopy_daemon | Provides an interface for the Hyper-V host to bidirectionally copy files to or from the virtual machine. | Low |
| [Hyper-V PowerShell Direct Service](#hyper-v-powershell-direct-service) | vmicvmsession | | Provides a mechanism to manage virtual machine with PowerShell via VM session without a virtual network. | Low |  


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

**Windows Service Name:** vmictimesync  
**Linux Daemon Name:** hv_utils  
**Description:** Synchronizes the virtual machine's system clock with the system clock of the physical computer.  
**Added In:** Windows Server 2012, Windows 8  
**Impact:** **High Impact**  When disabled, the virtual machine's clock will drift erratically.  


## Hyper-V Data Exchange Service (KVP)

**Windows Service Name:** vmickvpexchange  
**Linux Daemon Name:** hv_kvp_daemon  
**Description:** Provides a mechanism to exchange basic metadata between the virtual machine and the host.  
**Added In:** Windows Server 2012, Windows 8  
**Impact:** When disabled, virtual machines running Windows 8 or Windows Server 2012 or earlier will not recieve updates to Hyper-V integration services.  Disabling data exchange may also impact some kinds of monitoring and host-side diagnostics.

**Notes:**  
Also called KVP.  Read more [here](https://technet.microsoft.com/en-us/library/dn798287.aspx).


## Hyper-V Volume Shadow Copy Requestor

**Windows Service Name:** vmicvss  
**Linux Daemon Name:** hv_vss_daemon  
**Description:** Allows Volume Shadow Copy Service to back up applications and data on the virtual machine.  
**Added In:** Windows Server 2012, Windows 8  
**Impact:** When disabled, the virtual machine can not be backed up while running (using VSS).  


## Hyper-V Guest Service Interface

**Windows Service Name:** vmicguestinterface  
**Linux Daemon Name:** hv_fcopy_daemon  
**Description:** Provides an interface for the Hyper-V host to bidirectionally copy files to or from the virtual machine.  
**Added In:** Windows Server 2012 R2, Windows 8.1
**Impact:** When disabled, the host can not copy files to and from the guest using `Copy-VMFile`.  Read more about the [Copy-VMFile cmdlet](https://technet.microsoft.com/library/dn464282.aspx).  

**Notes:**  
Depricated in Windows 10.  Disabled by default.  See PowerShell Direct using Copy-Item.


## Hyper-V PowerShell Direct Service

**Windows Service Name:** vmicvmsession  
**Linux Daemon Name:** n/a  
**Description:** Provides a mechanism to manage virtual machine with PowerShell via VM session without a virtual network.    
**Added In:** Windows Server TP3, Windows 10    
**Impact:** Disabling this service prevents the host from being able to connect to the virtual machine with PowerShell Direct.  

**Notes:**  
The service name was originally was Hyper-V VM Session Service.  This service is under active development.

[Read more about PowerShell Direct](../user_guide/vmsession.md).  

**User Guides:**  
* [Running script in a virtual machine](../user_guide/vmsession.md#run-a-script-or-command-with-invoke-command)
* [Copying files to and from a virtual machine](../user_guide/vmsession.md#copy-files-with-new-pssession-and-copy-item)


## Additional Resources

**Integration service update and maintainance**
* [user guide](../user_guide/managing_ics.md)