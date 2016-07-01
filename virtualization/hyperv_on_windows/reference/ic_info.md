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

Integration services (often called integration components), are services that allow the virtual machine to communicate with the Hyper-V host. Many of these services are conveniences while others can be quite important to the virtual machine's ability to function correctly.

This article is a reference for each integration service available in Windows.  It will also act as a starting point for any information related to specific integration services or their history.


## Quick Reference

| Name | Windows Service Name | Linux Daemon Name |  Description | Impact on VM when disabled |
|:---------|:---------|:---------|:---------|:---------|
| [Hyper-V Heartbeat Service](#hyper-v-heartbeat-service) |  vmicheartbeat | hv_utils | Reports that the virtual machine is running correctly. | Varies |
| [Hyper-V Guest Shutdown Service](#hyper-v-guest-shutdown-service) | vmicshutdown | hv_utils |  Allows the host to trigger virtual machines shutdown. | **High** |
| [Hyper-V Time Synchronization Service](#hyper-v-time-synchronization-service) | vmictimesync | hv_utils | Synchronizes the virtual machine's clock with the host computer's clock. | **High** |
| [Hyper-V Data Exchange Service (KVP)](#hyper-v-data-exchange-service-kvp) | vmickvpexchange | hv_kvp_daemon | Provides a way to exchange basic metadata b etween the virtual machine and the host. | Medium |
| [Hyper-V Volume Shadow Copy Requestor](#hyper-v-volume-shadow-copy-requestor) | vmicvss | hv_vss_daemon | Allows Volume Shadow Copy Service to back up the virtual machine with out shutting it down. | Varies |
| [Hyper-V Guest Service Interface](#hyper-v-powershell-direct-service) | vmicguestinterface | hv_fcopy_daemon | Provides an interface for the Hyper-V host to copy files to or from the virtual machine. | Low |
| [Hyper-V PowerShell Direct Service](#hyper-v-powershell-direct-service) | vmicvmsession | not available | Provides a way to manage virtual machine with PowerShell without a network connection. | Low |  


## Hyper-V Heartbeat Service

**Windows Service Name:** vmicheartbeat  
**Linux Daemon Name:** hv_utils  
**Description:** Tells the Hyper-V host that the virtual machine has an operating system installed and that it booted correctly.  
**Added In:** Windows Server 2012, Windows 8  
**Impact:** When disabled, the virtual machine can't report that the operating system inside of the virtual machine is operating correctly.  This may impact some kinds of monitoring and host-side diagnostics.  

The heartbeat service makes it possible to answer basic questions like "did the virtual machine boot?".  

When Hyper-V reports that a virtual machine state is "running" (see the example below), it means Hyper-V set aside resources for a virtual machine; it does not mean that there is an operating system installed or functioning.  This is where heartbeat becomes useful.  The heartbeat service tells Hyper-V that the operating system inside the virtual machine has booted.  

### Check heartbeat with PowerShell

Run the following PowerShell command as Administrator to see a virtual machine's heartbeat:
``` PowerShell
Get-VM -VMName $VMName | select Name, State, Status
```

Your output should look something like this:
```
Name    State    Status
----    -----    ------
DemoVM  Running  Operating normally
```

The `Status` field is determined by the heartbeat service.



## Hyper-V Guest Shutdown Service

**Windows Service Name:** vmicshutdown  
**Linux Daemon Name:** hv_utils  
**Description:** Allows the Hyper-V host to request that the virtual machine shutdown.  The host can always force the virtual machine to turn off, but that is like flipping the powerswitch as opposed to selecting shutdown.
**Added In:** Windows Server 2012, Windows 8  
**Impact:** **High Impact**  When disabled, the host can't trigger a friendly shutdown inside the virtual machine.  All shutdowns will be a hard power-off wich could cause data loss or data corruption.


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

The data exchange service (sometimes called KVP) shares small amounts of machine information between virtual machine and the Hyper-V host using key-value pairs (KVP) through the Windows registry.  The same mechanism can also be used to share customized data between the virtual machine and the host.

Key-value pairs consist of a “key” and a “value”. Both the key and the value are strings, no other data types are supported. When a key-value pair is created or changed, it is visible to the guest and the host. The key-value pair information is transferred across the Hyper-V VMbus and does not require any kind of network connection between the guest and the Hyper-V host. 

The data exchange service is a great tool for preserving information about the virtual machine -- for interactive data sharing or data transfer, use [PowerShell Direct](#hyper-v-powershell-direct-service). 


**User Guides:**  
* [Using key-value pairs to share information between the host and guest on Hyper-V](https://technet.microsoft.com/en-us/library/dn798287.aspx).


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