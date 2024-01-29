---
title:      "Measuring Replication Health in a cluster"
author: sethmanheim
ms.author: sethm
ms.date: 12/30/2013
categories: hvr
description: This article covers how to view replication health statistics in a cluster.
---
# Replication Health Statistics

As part of running a mini-scale run in my lab, I had to frequently monitor the replication health and also note down the replication statistics. The statistics is available by right clicking on the VM (in the Hyper-V Manager or Failover Cluster Manager) and choosing the **Replication** submenu and clicking on the **View Replication Health…** option.

 <!--[![View replication health](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_715D2FC2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_5F7E0B44.png) -->

Clicking on the above option, displays the replication statistics which I am looking for. 

<!--[![Replication statistics](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_7B47428F.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_69D45106.png)-->

Clicking on the 'Reset Statistics' clears the statistics collected so far and resets the start ("From time" field) time. 

In a large deployment, it's not practical to right click on each VM to get the health statistics.  Hyper-V PowerShell cmdlets help in simplifying the task. I had two requirements:

  * Requirement #1: Get a report of the average size of the log files which were being sent during the VMs replication interval 
  * Requirement #2: Snap all the VMs replication statistics to the same start time ("From time") field and reset the statistics 



**Measure-VMReplication** provides the replication statistics for each of the replicating VMs. As I am only interested in the average replication size, the following cmdlet provides the required information.

Measure-VMReplication | select VMName,AvgReplSize

Like most of the other PowerShell cmdlets Measure-VMReplication takes the computer name as an input. To get the replication stats for all the VMs in the cluster, I would need to enumerate the nodes of the cluster and pipe the output to this cmdlet. The **Get-ClusterNode** is used to get the nodes of the cluster. 
    
```markdown
$ClusterName =  "<Name of your cluster>"
    
    
Get-ClusterNode -Cluster $ClusterName
```

We can pipe the output of each node of the cluster and the replication health of the VMs present on that node

```markdown
Get-ClusterNode -Cluster $ClusterName | foreach-object {Measure-VMReplication -ComputerName $_ | Select VMName, AvgReplSize, PrimaryServerName, CurrentReplicaServerName | ft}
```

Requirement #1 is met, now let's look at requirement #2. To snap all the replicating VMs statistics to a common start time, I used the **Reset-VMReplicationStatistics** which takes the VMName as an input. However if Reset-VMReplicationStatistics is used on a non-replicating VM, the cmdlet errors out with the following error message:
    
```markdown
 Reset-VMReplicationStatistics :  'Reset-VMReplicationStatistics' is not applicable on virtual machine 'IOMeterBase'.
    
    
    The name of the virtual machine is IOMeterBase and its ID is c1922e67-7a8b-4f36-a868-5174e7b6821a.
    
    
    At line:1 char:1
    
    
    + Reset-VMReplicationStatistics -vmname IOMeterBase
    
    
    + ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    
        + CategoryInfo          : InvalidOperation: (Microsoft.Hyper...l.VMReplication:VMReplication) [Reset-VMReplicationStatistics], VirtualizationOperationFailedException
    
    
        + FullyQualifiedErrorId : InvalidOperation,Microsoft.HyperV.PowerShell.Commands.ResetVMReplicationStatisticsCommand
```

It's a touch messy and to address the issue, we would need to isolate the replicating VMs in a given server. This can be done by querying only for those VMs whose **ReplicationMode** is set (to either Primary or Replica). The output of **Get-VM** is shown below 
    
```markdown
PS C:\> get-vm | select vmname, ReplicationMode | fl
    
    
     
    
    
VMName          : Cluster22-TPCC3
    
    
ReplicationMode : Primary
    
    
     
    
    
VMName          : IOMeterBase
    
    
ReplicationMode : None
```    

Cluster22-TPCC3 is a replicating VM (Primary VM) while replication has not been enabled on IOMeterBase VM. Putting things together, to get all the replicating VMs in the cluster use the Get-VM cmdlet and filter on ReplicationMode (Primary or Replica. You could also use the not-equal to operation get both primary and replica VMs)

```markdown
Get-ClusterNode -Cluster $ClusterName | ForEach-Object {Get-VM -ComputerName $_ | Where-Object {$_.ReplicationMode -eq "Primary"}}
```

To reset the statistics, pipe the above cmdlet to Reset-VMReplicationStatistics

```markdown
PS C:\> Get-ClusterNode -Cluster $ClusterName | ForEach-Object {Get-VM -ComputerName $_ | Where-Object {$_.ReplicationMode -eq "Primary"} | Reset-VMReplicationStatistics}
```

Wasn't that a lot easier than right clicking on each VM in your cluster and clicking on the 'Reset Statistics' button? :)
