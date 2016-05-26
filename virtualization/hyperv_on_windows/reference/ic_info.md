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

| Name | Windows Service Name | Linux Daemon Name |  Description | Added In | Notes |
|:---------|:---------|:---------|:---------|:---------|:---------|
| Hyper-V Guest Service Interface | vmicguestinterface |  | Provides an interface for the Hyper-V host to interact with specific services running inside the virtual machine. |
| Hyper-V Heartbeat Service |  vmicheartbeat |  | Monitors the state of this virtual machine by reporting a heartbeat at regular intervals. This service helps you identify running virtual machines that have stopped responding. | 
| Hyper-V Data Exchange Service | vmickvpexchange |  |
| Hyper-V Remote Desktop Virtualization  Service |  vmicrdv |  | Provides a platform for communication between the virtual machine and the operating system running on the physical computer. |  |
| Hyper-V Guest Shutdown Service | vmicshutdown |  |    
| Hyper-V Time Synchronization Service | vmictimesync |  | Synchronizes the system time of this virtual machine with the system time of the physical computer. |  
| Hyper-V VM Session Service | vmicvmsession | | Provides a mechanism to manage virtual machine with PowerShell via VM session without a virtual network. |  |
| Hyper-V Volume Shadow Copy Requestor | vmicvss | | Coordinates the communications that are required to use Volume Shadow Copy Service to back up applications and data on this virtual machine from the operating system on the physical computer. |             
