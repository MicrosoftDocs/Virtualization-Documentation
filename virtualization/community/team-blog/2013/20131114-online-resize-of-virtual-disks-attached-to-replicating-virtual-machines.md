---
title:      "Online resize of virtual disks attached to replicating virtual machines"
author: mattbriggs
ms.author: mabrigg
ms.date: 11/14/2013
categories: hvr
description: How to resize a virtual disk while the VM is running and its benefits.
---
# Resizing virtual disks attached to replicating virtual machines

In Windows Server 2012 R2, Hyper-V added the ability to [resize the virtual disks attached to a running virtual machine](https://technet.microsoft.com/library/dn282286.aspx) without having to shutdown the virtual machine. In this blog post we will talk about how this feature works with Hyper-V Replica, the benefits of this capability, and how to make the most of it.

### Works better with Hyper-V Replica

There is an obvious benefit in having the ability to resize a virtual disk while the VM is running – there is no need for downtime of the VM workload. There is however a subtle nuance and very key benefit for virtual machines that have also been enabled for replication – _there is no need to resync the VM after modifying the disk, and definitely no need to delete and re-enable replication!_

There is some history to this that needs explaining. Starting with Windows Server 2012, Hyper-V Replica provided a way to track the changes that a guest OS was making on the disks attached to the VM – and then replicated these changes to provide DR. However the tracking and replication was applicable only to _running_ VMs. This meant that when a VM was switched off, Hyper-V Replica had no way to track and replicate any changes that might be done to the virtual disks _outside of the guest_. To guarantee that the replica VM was always in sync with the primary, Hyper-V Replica put the virtual machine into _“Resynchronization Required”_ state if it suspected that the primary virtual disks had been modified offline.

So in Windows Server 2012, the immediate consequence of resizing your disk offline is also that the VM will go into resync when started up again. Resyncing the VM could get very expensive in terms of IOPS consumption and you would lose any additional recovery points that were already created. 

Naturally, we made sure that it all went away in the Windows Server 2012 R2 release - no workload downtime, no resync, no loss of additional recovery points!

### Making it happen – workflows for replicating VMs

The resize of the virtual disks need to be done on each site separately, and resizing the primary site virtual disks doesn’t automatically resize the replica site virtual disks. Here is the suggested workflow for making this happen:

  1. On the primary site, select the virtual disk that needs to be resized and use the _Edit disk wizard_ to increase/decrease the size of the disk. You can also use the [Resize-VHD](https://technet.microsoft.com/library/hh848535.aspx) PowerShell commandlet. At this point, replication isn’t really impacted and continues uninterrupted. This is because the newly created space shows up as “Unallocated”. That is, it has not been formatted and presented to the guest workload to use, and so there are no writes to that region that need to be tracked and replicated.

  2. On the replica site, select the corresponding virtual disk and resize it using the _Edit disk wizard_ or the Resize-VHD PowerShell commandlet. Not resizing the replica site virtual disk can cause replication errors in the future – and we will cover that in greater detail.

  3. Use _Disk Management_ or an equivalent tool in the guest VM to consume this unallocated space.




Voila! That’s it. Nothing extraordinary required for replicating VMs. Sounds too good to be true? Well, it is :). In fact, you can automate steps 1 and 2 using some nifty PowerShell scripting.
    
```markdown
    param (
    
    
        [string]$vmname  = $(throw "-VMName is required"),
    
    
        [string]$vhdpath = $(throw "-VHDPath is required"),
    
    
        [long]$size   = $(throw "-Size is required")
    
    
    )
    
    
     
    
    
    #Resize the disk on the primary site
    
    
    Resize-VHD -Path $vhdpath -SizeBytes $size -Verbose
    
    
     
    
    
    $replinfo      = Get-VMReplication -VMName $vmname
    
    
    $replicaserver = $replinfo.CurrentReplicaServerName
    
    
    $id            = $replinfo.Id
    
    
    $vhdname       = $vhdpath.Substring($vhdpath.LastIndexOf("\"))
    
    
     
    
    
    #Find the VM on the replica site, find the right disk, and resize it
    
    
    Invoke-Command -ComputerName $replicaserver -Verbose -ScriptBlock {
    
    
        $vhds = Get-VHD -VMId $Using:id
    
    
        foreach( $disk in $vhds ) {
    
    
            if($disk.Path.contains($Using:vhdname)) {
    
    
                Resize-VHD -Path $disk.Path -SizeBytes $Using:size -Verbose
    
    
            }
    
    
        }
    
    
    }
```

### Handling error scenarios

If the resized virtual disk on the primary is consumed before the replica has been resized, then you can expect the replica site to throw up errors. This is because the changes on the primary site cannot be applied correctly on the replica site. Fortunately, the error message is friendly enough to put you on the right track to fixing it: “ _An out-of-bounds write was encountered on the Replica virtual machine. The primary server VHD might have been resized. Ensure that the disk sizes of the Primary and Replica virtual machines are the same.”_

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2337.image_thumb_37016519.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7585.image_5DCCEAA8.png)

The fix is just as simple:

  1. Resize the virtual disk on the Replica site (as was meant to be done). 
  2. Resume replication on the VM from the Primary site – it will replicate and apply pending logs, without triggering resynchronization.



A similar situation will be encountered if the VM is put into resync after the resize operation. The resync operation will not proceed as the two disks have different sizes. Ensuring that the Replica disk is resized appropriately and resuming replication will be sufficient for resynchronization to continue.

### Nuances during failover

If you keep additional recovery points for your replicating VM, there are some key points to be noted:

  1. Expanding a virtual disk that is replicating will have no impact on failover. However, the size of the disk will not be reduced if you fail over to an older point that was created before the expand operation.
  2. Shrinking a virtual disk that is replicating _will have an impact_ on failover. Attempting to fail over to an older point that was created before the shrink operation will result in an error.



This behavior is seen because failing over to an older point only changes the content on the disk – and not the disk itself. Irrespective, in all cases, failing over to the latest point is not impacted by the resize operations.


Hope this post has been useful! We welcome you to share your experience and feedback with us. 
