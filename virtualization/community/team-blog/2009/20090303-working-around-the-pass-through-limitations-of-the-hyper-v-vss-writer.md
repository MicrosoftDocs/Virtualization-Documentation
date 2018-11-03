---
layout:     post
title:      "Working around the pass through limitations of the Hyper-V VSS Writer"
date:       2009-03-03 14:53:00
categories: hyper-v
---
While the Hyper-V VSS writer provides backup admins significant flexibility in their ability to back up VMs in an application-consistent way while running backup applications in the physical machine, it does have a prominent limitation when it comes to VMs with pass-through storage. The VSS Writer excludes pass-through storage from the set of items to be backed up for a VM. Here I am using the term “pass-through” rather loosely, to include local storage which may be configured directly on the virtual machine (which may be iSCSI initiated from the physical machine or FC attached to the physical machine) as well as iSCSI targets that are initiated directly from the guest. Technical issues due to the way we create VSS snapshots as well as challenges while doing the restore operation has kept us from providing this functionality so far. I will not, however, belabor the reader with the details of the technical challenges. Instead, let us look at ways to work around this limitation.

 

 **Approach 1: run backup in guest and backup in host

**

One approach is to run backup applications within the virtual machine along with a backup application in the host. The backup application running in the virtual machine will capture the data residing on the pass through disk while the host side backup application will capture the VHDs and configuration files associated with the VM. The user would then need to run the backup in the virtual machine followed by backup in the host. During the restore process, the reverse process is followed: restore the host-side files and then run the restore inside the virtual machine after booting it up.

 

There are a two problems with this approach. Firstly, having to orchestrate the backup process within the virtual machine with the backup process in the host and doing something similar during restore is going to be challenging for any management entity; be it an IT admin or a management application. Secondly, there is an additional limitation for pass-through disks which are connected to the host via FC: The value-added storage management functionality provided by the storage manufacturer (for example, hardware VSS snapshots) is filtered out from the VM due to the fact that the Hyper-V storage stack filters out custom CDBs. These two combine to make this workaround rather unattractive.

 **

 

**

 **Approach 2: Fixed size VHDs

**

At this point, let us take a moment to look at the motivation behind using pass-through disks for virtual machines. The first reason, stated by many is the enhanced performance available through the use of pass-through storage. The second reason is the ability to use the advanced management capabilities provided by the storage providers for backing up LUNs (iSCSI or FC). 

 

Now, in Windows Server 2008 R2, the performance difference between VHD-based storage and pass-through storage has been reduced a lot. This is particularly true for fixed-size VHDs. In our internal perf labs, we have had test runs where the performance of fixed size VHDs actually matched the performance of pass-through disks. Even in v1, the performance of fixed disks was pretty close to that of pass-through disks. So, instead of configuring the LUN as a pass-through device on the virtual machine, the user could make the LUN online on the physical machine. The user could then create a fixed size VHD that occupies the entire space of the LUN and configure the virtual machine to connect to that VHD. Since the LUN is exposed to the physical machine, the management capabilities provided by the storage provider (e.g: hardware VSS snapshots) are available to be used. In this configuration, the user then does not need to run any backup application inside the virtual machine, as none of the volumes in the virtual machine (by virtue of being backed by VHDs) are excluded from the backup. Additionally, the hardware VSS snapshots and LUN management capabilities provided by the storage manufacturer can be leveraged entirely from the host.
