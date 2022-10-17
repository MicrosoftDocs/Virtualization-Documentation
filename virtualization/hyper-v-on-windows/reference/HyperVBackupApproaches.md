---
title: Hyper-V Backup Approaches
description: Provides and describes the approaches for utilizing Hyper-V to create backup virtual machines.
author: scooley
ms.author: scooley
ms.date: 05/29/2020
ms.topic: article
ms.prod: windows-10-hyperv
---
# Hyper-V Backup Approaches
Hyper-V allows you to backup virtual machines, from the host operating system, without the need to run custom backup software inside the virtual machine.  There are several approaches that are available for developers to utilize depending on their needs.
## Hyper-V VSS Writer
Hyper-V implements a VSS writer on all versions of Windows Server where Hyper-V is supported.  This VSS writer allows developers to utilize the existing VSS infrastructure to backup virtual machines.  However, it is designed for small scale backup operations where all virtual machines on a server are backed up simultaneously.

## Hyper-V WMI Based Backup
Starting in Windows Server 2016, Hyper-V started supporting backup through the Hyper-V WMI API.  This approach still utilizes VSS inside the virtual machine for backup purposes, but no longer uses VSS in the host operating system.  Instead, a combination of reference points and resilient change tracking (RCT) is used to allow developers to access the information about backed up virtual machines in an efficient manner.  This approach is more scalable than using VSS in the host, however it is only available on Windows Server 2016 and later.

There is also an example on how to use these APIs available here:
https://www.powershellgallery.com/packages/xHyper-VBackup
## Methods for reading backups from WMI Based Backup
When creating virtual machine backups using Hyper-V WMI, there are three methods for reading the actual data from the backup.  Each has unique advantages and disadvantages.
### WMI Export
Developers can export the backup data through the Hyper-V WMI interfaces (as used in the above example).  Hyper-V will compile the changes into a virtual hard drive and copy the file to the requested location.  This method is easy to use, works for all scenarios and is remotable.  However, the virtual hard drive generated often creates a large amount of data to transfer over the network.
### Win32 APIs
Developers can use the SetVirtualDiskInformation, GetVirtualDiskInformation and QueryChangesVirtualDisk APIs on the Virtual Hard Disk Win32 API set as documented [here](/windows/desktop/api/_vhd/).
Note that to use these APIs, Hyper-V WMI still needs to be used to create reference points on associated virtual machines.  These Win32 APIs then allow for efficient access to the data of the backed up virtual machine.  The Win32 APIs do have several limitations:
* They can only be accessed locally
* They do not support reading data from shared virtual hard disk files
* They return data addresses that are relative to the internal structure of the virtual hard disk

### Remote Shared Virtual Disk Protocol
Finally, if a developer needs to efficiently access backup data information from a shared virtual hard disk file – they will need to use the Remote Shared Virtual Disk Protocol.  This protocol is documented [here](/openspecs/windows_protocols/ms-rsvd/c865c326-47d6-4a91-a62d-0e8f26007d15).
