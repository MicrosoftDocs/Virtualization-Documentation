---
title:      "Resynchronization of virtual machines in Hyper-V Replica"
date:       2013-05-10 07:27:00
categories: hvr
---
## What is resynchronization and why is it needed?

Hyper-V Replica provides protection to VMs by tracking and replicating changes to the virtual hard disks (VHDs) of the VM. Hyper-V Replica runs 24 hours, 365 days in a year; for any VM that has been enabled for replication it ensures that the data on the primary site and the Replica site are kept as closely in sync as supported. 

To begin with, Hyper-V Replica (HVR) requires that the data on the virtual hard disks (VHDs) of the primary and replica VMs be the same. This is achieved through the process of initial replication, and establishes a baseline on which replicated changes can be applied. However, due to factors beyond the control of the administrator – such as faulty hardware and OS bugchecks – it is possible that the primary and Replica VMs are not in sync.

Thus in a rainy day scenario (details in following section), when HVR determines that the replica VM can no longer be kept in sync with the primary by applying the replicated changes then resynchronization is required. Resynchronization (or Resync) is the process of re-establishing the baseline – by ensuring that the primary and replica VHDs have exactly the same data stored.

_(NOTE: In this post we will use a VM named “RESYNC VM” in all examples and screenshots.)_

## When does resynchronization happen?

It would become quite obvious after going through this table below that Resync is not expected to occur regularly. In fact, in the normal course of replication this is quite a rare event. The VM enters the _“Resynchronization Required”_ state when any one of the conditions are encountered:

#### Site

| 

#### Condition

| 

#### Scenario example  
  
---|---|---  
  
Primary

| 

Modify VHD when VM is turned off

| 

Mount/modify VHD outside the VM, Edit disk, Offline patching  
  
Primary

| 

Size of tracking log files > 50% of total VHD size for a VM

| 

Network outage causes logs to accumulate  
  
Primary

| 

Write failure to tracking log file

| 

VHD and logs are on SMB and connectivity to the SMB storage is flaky.  
  
Primary

| 

Tracking log file is not closed gracefully

| 

Host crash with primary VM running. Applicable to VMs in a cluster also.  
  
Primary

| 

Reverting the volume to an older point in time

Reverting the VM to an older snapshot

| 

Volume/snapshot backup and restore  
  
Secondary

| 

Out-of-sequence or Invalid log file is applied

| 

Restoring a backed-up copy of the Replica VM

Importing an older VM copy, when migration by using export-import

Reverting volume to an older point in time using Volume backup and restore.

Reverting the VM to an older snapshot  
  
When the VM enters the _“Resynchronization Required”_ state, the replication health becomes “Critical” and the VM is scheduled for resynchronization. At the same time, HVR stops tracking the guest writes for the VM and nothing is replicated. 

The replication health will also show this message:

[![resync 002](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5516.resync-002_thumb_7BE1F016.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3010.resync-002_45713E14.png)

## Initiating and scheduling resynchronization

Depending on the VM setting, the user might have to trigger the resynchronization operation explicitly. When that is required, follow the instructions as given in the replication health screen:

  1. Right-click on the VM for the options
  2. Under **Replication** , select the **Resume Replication** option



You will be presented with the screen to schedule the resynchronization operation:

[![resync 003](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6355.resync-003_thumb_73833C21.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4426.resync-003_3905AB9C.png)

To start the resync operation from PowerShell, use the [**Resume-VMReplication**](http://technet.microsoft.com/en-us/library/hh848510.aspx) commandlet:
    
    
    Resume-VMReplication –VMName “RESYNC VM” -Resynchronize –ResynchronizeStartTime “04/15/2013 12:00:00”

User-initiated resynchronization is also possible, but unless absolutely necessary it should be avoided. In order to explicitly force resynchronization on a VM that is not in the _“Resynchronization Required”_ state, first suspend the replication and then initiate resync:
    
    
    Suspend-VMReplication -VMName  "RESYNC VM"
    
    
    Resume-VMReplication -VMName "RESYNC VM" -Resynchronize

The scheduling of the resynchronization operation can be configured for each VM:

  1. On the primary site, open the Hyper-V Manager
  2. Right-click on the desired VM, and select the **Settings…** option
  3. In the left hand pane under **Replication** , select the **Resynchronization** option



[![resync 006](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6622.resync-006_thumb_54D17398.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7713.resync-006_0EBE25D4.png)

The default option is to schedule the resynchronization operation during off-peak hours. The resource intensive nature of the operation makes such scheduling useful, and aims to reduce the impact on running VMs. 

The same can be configured in PowerShell using the [**Set-VMReplication**](http://technet.microsoft.com/en-us/library/hh848543.aspx) commandlet:
    
    
    # Manual resync
    
    
    Set-VMReplication -VMName  "RESYNC VM" -AutoResynchronizeEnabled 0
    
    
     
    
    
    # Automatic resync
    
    
    Set-VMReplication –VMName "RESYNC VM" -AutoResynchronizeEnabled 1 -AutoResynchronizeIntervalStart 00:00:00 -AutoResynchronizeIntervalEnd 23:59:59
    
    
     
    
    
    # Scheduled resync
    
    
    Set-VMReplication –VMName "RESYNC VM" -AutoResynchronizeEnabled 1 -AutoResynchronizeIntervalStart 00:00:00 -AutoResynchronizeIntervalEnd 06:00:00

To see the resynchronization settings in PowerShell, use the [**Get-VMReplication**](http://technet.microsoft.com/en-us/library/hh848570.aspx) commandlet and look for the _AutoResynchronizeEnabled_ , _AutoResynchronizeIntervalStart_ , and _AutoResynchronizeIntervalEnd_ fields: 
    
    
    Get-VMReplication -VMname "RESYNC VM" | fl *

## The process of resynchronization

When the resync operation is triggered – either automatically or by the user – the following high-level sub-operations are executed in sequence:

  1. **Check the VHD characteristics of primary and replica VMs:** before resync can be done, these have to match. Hyper-V Replica checks the geometry and size of the disk before starting resync. Top on the list of exceptions to watch out for are size mismatches – caused by resizing either a primary or replica VHD without appropriately resizing the other one.
  2. **Start tracking the VHDs:**
    1. The guest writes are tracked into the log file, but these changes are not replicated until resync is completed.
    2. It is important to note that if resync takes too long then you might hit the “50% of total VHD size for a VM” condition and end up sending the VM into the _“Resynchronization Required”_ state again. 
    3. Event number 29242 is logged that specifies the VM, VHDs, start block, and end block. 
  3. **Create a diff disks for the replica VHDs:** this allows the resync operation to be cancelled without leaving the underlying VHD in an inconsistent state. The diff disk with all the resync-ed changes is then merged back into the VHD at the end of the resync operation.
  4. **Compare and sync the VHDs:** the comparison of the VHDs is done block-by-block and only the blocks that differ are sent across the network. This can reduce the data sent over the network, depending on how different the two VHDs are. While this operation is going on:
    1. ___Pause Replication_ **** will stop the current resync operation. Doing _Resume Replication_ later will continue the resync comparisons from where it left off. 
    2. Planned failover or Test failover will not be possible.
    3. At any point the user can always do Unplanned Failover, but this will cancel the resync operation.
    4. Resync can be cancelled at any point. This will keep the VM in the _“Resynchronization Required”_ state, and the next time replication is resumed, it will start from the beginning.
  5. **Completion of compare and sync:** HVR logs event number 29244 once the compare and sync operation is done, and it specifies the VHD, VM, blocks sent, time taken, and result of the operation.
  6. **Merge the resync changes to the VHD: ** after this operation completes, the resync operation cannot be cancelled or undone.
  7. **Delete the recovery points:** this is a significant side-effect of resync. The recovery points are built upon the VHD as a baseline. However, resync effectively changes that baseline and makes the data stored in those recovery points invalid. After resync completes, the recovery points are built again over a period of time.



## Resynchronization performance

Resynchronization performance was tested and compared against the performance of Online Initial Replication (IR). The setup consisted of a standalone server with 4 running VMs – 2 File Servers and 2 SQL servers running typical workloads. Two VMs were replicated to a standalone Replica server. The network bandwidth was varied to see the impact. Data size that was replicated during Online IR was approximately 80GB.

  | **Network speed** ****| **Online IR size** ****| **Online IR time** ****| **Resync size** ****| **Resync time**  
---|---|---|---|---|---  
Resync – offline scheduling | 1 Gbps | ~80 GB | ~1.5 hrs | ~5.5 GB | ~2 hrs  
Resync – immediate | 1 Gbps | ~80 GB | ~1 hr | ~100 MB | ~1 hr  
  |   |   |   |   |    
Resync – offline scheduling  | 1.5 Mbps | ~80 GB | 4 days | ~10 GB | ~1 day  
Resync – immediate | 1.5 Mbps | ~80 GB | 4 days | ~ 78 MB | ~1 hour  
  
The tests indicate that resync is preferable to Online IR in low speed networks. When the two sites are connected by a high speed network, resync works well for low churn workloads.

There is also a perfmon counter for measuring the resynchronized bytes: **\Hyper-V Replica VM\Resynchronized Bytes**.

## Conclusion

The disks going out of sync is a rainy-day event in Hyper-V Replica. However with the Resynchronization operation, this is handled gracefully within the product to optimize the administrative overhead and the resources used in bringing the disks back into sync. 
