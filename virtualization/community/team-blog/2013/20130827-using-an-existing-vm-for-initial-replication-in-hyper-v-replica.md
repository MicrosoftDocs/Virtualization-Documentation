---
title:      "Using an existing VM for initial replication in Hyper-V Replica"
author: mattbriggs
ms.author: mabrigg
ms.date: 08/27/2013
categories: hvr
description: Reasons for using an existing virtual machine as the initial copy in Hyper-V Replica.
---
# Hyper-V Replica provides three methods to do initial replication:

  1. Send data over the network (Online IR)
  2. Send data [using external media](/virtualization/community/team-blog/2013/20130628-save-network-bandwidth-by-using-out-of-band-initial-replication-method-in-hyper-v-replica) (OOB IR)
  3. Use an existing virtual machine as the initial copy



Each option for initial replication has a specific scenario for which it excels. In this post we will dive into the underlying reasons for including option 3 in Hyper-V Replica, the scenarios where it is advantageous, and cover its usage. This blog post is co-authored by **Shivam Garg** , Senior Program Manager Lead.

 

### Choosing an existing virtual machine

This method of initial replication is rather self-explanatory – it takes an existing VM on the replica site as the baseline to be synced with the primary. However, it’s not enough to pick any virtual machine on the replica site to use as an initial copy. Hyper-V Replica places certain requirements on the VM that can be used in this method of initial replication:

  1. It has to have the same virtual machine ID as that of the primary VM
  2. It should have the same disks (and disk properties) as that of the primary VM



Given the restrictions placed on the existing VM that can act as an initial copy, there are a few clear ways to get such a VM:

  * **Restore the VM from backup**. Historically, the disaster recovery strategy for most companies involved taking backups and restoring the datacenter from these backups. This strategy also implies that there is a mechanism in place to transport the backed-up data to the recovery site. This makes the backed-up copies an excellent start point for Hyper-V Replica ’s disaster recovery process. The data will be older – depending on the backup policies – but it will satisfy the criteria to use this initial replication method. Of course, it is suggested to use the latest backup data so as to keep the delta changes to the minimum.
  * **Export the VM from the primary and import on the replica**. Of course, the exported VM needs to be transported to the other site so this option is similar to out-of-band initial replication using external media.
  * **Use an older Replica VM.** When a replication relationship is removed, the Replica VM remains  – and this VM can be used as the initial copy when replication is enabled again for the same VM in the future.



 

### Syncing the primary and Replica VMs

Although there is a complete VM on the replica side, the Replica VM lags behind the primary VM in terms of the freshness of the data. So as a part of the initial replication process the two VMs have to be brought into sync. This process is very similar to [resynchronization](/virtualization/community/team-blog/2013/20130510-resynchronization-of-virtual-machines-in-hyper-v-replica) and is very IOPS intensive. Depending on the differences between the primary and Replica VHDs, there could also be significant network traffic to transfer the delta changes from the primary site to the replica site.

 

### When to use this initial replication method

The biggest advantage that comes from using an existing VM is that the VHDs are already present on the replica site. But this is also based on the assumption that most of the data is already present in those VHDs. For example, when restoring the VM from backup, the backup copy would be a few hours behind the primary… perhaps a day behind. The assumption is that the delta changes [between the restored VM and the current primary VM] are small enough to be sent over the network. Thus the data difference between the primary VHDs and Replica VHDs should not be too large – otherwise Online IR would be more efficient from an IOPS perspective.

We also need to consider the size of the VHDs. If the primary VM has large VHDs then Online IR might not be preferred to begin with, and OOB IR would be used for initial replication. However, if the set of delta changes that can be sent over the network is small enough then this method could be quicker than OOB IR as well. Thus if the data difference between the primary VHDs and Replica VHDs is large _and the VHDs are also large,_ then it might be simpler to use OOB IR. With large VHDs and a large data difference between primary and Replica VHDs, this replication method will consume a large number of IOPS and choke the network.

Thus a replication scenario that involves (1) _large VHDs_ that to be replicated and (2) a _smaller set of delta changes for syncing_ [when compared to the size of the VHDs] will be an attractive option for using an existing virtual machine for initial replication.

 

### Making this happen with UI and PowerShell

Using this option through the UI is extremely simple – you simply need to select the option with _“ Use an existing virtual machine on the Replica server as the initial copy”_. This option is presented to you during the **Enable Replication** wizard.



When using PowerShell, there is a sequence of 3 commands that need to be executed:

```markdown
    
    PS C:\> Enable-VMReplication -ComputerName replica.contoso.com -VMName Test-VM -AsReplica
    
    
    PS C:\> Enable-VMReplication -ComputerName primary.contoso.com -VMName Test-VM -ReplicaServerName replica.contoso.com -ReplicaServerPort 80 -AuthenticationType Kerberos
    
    
    PS C:\> Start-VMInitialReplication -ComputerName primary.contoso.com -VMName Test-VM -UseBackup
```

The **– UseBackup** option in the **Start-VMInitialReplication** commandlet is the one that indicates the use of an existing VM on the replica site for the purposes of initial replication.

As with the other methods of initial replication, you can also schedule when the initial replication process occurs.

 

#### Working with clusters

If the Replica VM is on a cluster, _ensure that it is made Highly Available (HA) before any further actions are taken_. This is a prerequisite and it enables the VM to be picked up by the Failover Cluster service  – and consequently by the Hyper-V Replica Broker.


 

Failing to do so will throw errors similar to this (Event ID 29410):

Cannot perform the requested Hyper-V Replica operation for virtual machine 'Test-VM' because the virtual machine is not highly available. Make virtual machine highly available using Microsoft Failover Cluster Manager and try again. (Virtual machine ID 6DDC63C1-0135-40CA-B998-A606D91080E9)

 

Also, the replica server used in the commandlets and the UI will be the name of the Hyper-V Replica Broker instance in the cluster (Note: setting the VM _AsReplica_ has to be done with the actual replica host and not the broker on the replica site).
    
```markdown
    
    PS C:\> Enable-VMReplication -ComputerName replicahost.contoso.com -VMName Test-VM –AsReplica
    
    
    PS C:\> Enable-VMReplication -ComputerName primary.contoso.com -VMName Test-VM -ReplicaServerName replicabroker.contoso.com -ReplicaServerPort 80 -AuthenticationType Kerberos
    
    
    PS C:\> Start-VMInitialReplication -ComputerName primary.contoso.com -VMName Test-VM –UseBackup
```    

 

 

 

 

Which initial replication method do you use on your setup? We would be interested in hearing your feedback!
