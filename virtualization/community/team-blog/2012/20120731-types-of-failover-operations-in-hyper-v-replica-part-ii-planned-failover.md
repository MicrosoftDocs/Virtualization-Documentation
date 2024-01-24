---
title:      "Types of failover operations in Hyper-V Replica–Part II - Planned Failover"
author: sethmanheim
ms.author: sethm
ms.date: 07/31/2012
date:       2012-07-31 04:13:33
categories: disaster-recovery
description: Types of failover operations in Hyper-V Replica–Part II - Planned Failover
---
# Planned failover in Hyper-V Replica

In the [first part](https://blogs.technet.com/b/virtualization/archive/2012/07/26/types-of-failover-operations-in-hyper-v-replica.aspx) of this 3-part series, you learnt about Test Failover. In this part, I will talk about the Planned Failover (PFO). 

#### 1\. What is Planned Failover? 

PFO is an operation initiated on the primary VM which allows you to do an e2e validation of your recovery plan. PFO requires the VM to be shut down to ensure consistency.

PFO is *NOT* a substitute for High Availability which is achieved through clustering. PFO allows you to keep your business running with minimal downtime even during planned downtimes and guarantees zero data loss. 

#### 2\. When should I use Planned Failover? 

Planned Failover is used in the following cases 

  * I want to perform host maintenance on my primary and would like to run from the replica site. 
  * My primary site is expecting some power outage – I want to move over to the replica site. 
  * There's an impending typhoon – I want to proactively take action to ensure business continuity. 
  * My compliance requirements mandate that every quarter, I run my workloads from the replica site for a week. 



#### 3\. How should I use Planned Failover? 

After turning off the primary virtual machine, PFO is performed on the primary virtual machine by right-clicking on the VM and choosing the **Failover** operation (either from the Hyper-V Manager or from the Failover Clustering Manager).

[![clip_image002](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8510.clip_image002_thumb_16461DFD.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6036.clip_image002_41F45748.png)

Please note – for the PFO to work from UI, remote WMI has to be enabled on the replica site and the user running the PFO should have the necessary privileges. More on remote WMI in a later blog.

#### 4\. How does Planned Failover work?

PFO does the following

  * Performs pre-requisite checks to ensure the operation can succeed. These pre-requisite checks are: 
    * As PFO is a "planned" activity with zero data, the primary virtual machine should be shut down before initiating the operation. 
    * Once the VM is failed over in the replica site, Hyper-V Replica starts replicating the changes back to the primary server. For this to work, the primary server should be configured to receive replication from the Hyper-V Replica Broker on the replica side if the replica is a cluster or the replica server if the replica is a standalone. 
  * Sends the last set of tracked changes which ensures zero data loss. 
  * Reverses the direction of replication – so if you were replicating from **_Cluster-P_** (on the primary site) ** __** to **_Cluster-R_** (on the replica site), then the replication will happen from **_Cluster-R_** to **_Cluster-P_**. The primary virtual machine will become the replica virtual machine and vice-versa and all the recovery points are merged. This step is done at the end of PFO. 
  * If you have selected to start the virtual machine, the virtual machine is started on the **_Cluster-R_** site at the end of the operation. This boots off the latest point. You might decide not to start the virtual machine if the virtual machine is part of a multi-tiered application. 



The above procedure can be achieved using Powershell using the following cmdlets. 

Run these cmdlets on the primary side.
    
```markdown
 1: Stop-VM VirtualMachine_Workload
    
    
 2:  
    
    
 3: Start-VMFailover -VMName VirtualMachine_Workload –prepare
```

Run these cmdlets on the replica side.
    
```markdown
 1: Start-VMFailover -VMName VirtualMachine_Workload
    
    
 2:  
    
    
 3: Set-VMReplication -reverse -VMName VirtualMachine_Workload
    
    
 4:  
    
    
 5: Start-VM VirtualMachine_Workload
```

On a cluster, these cmdlets should be run against the node which is currently owning the virtual machine.

In the last part of this series, I will talk about [Unplanned Failover](https://blogs.technet.com/b/virtualization/archive/2012/08/08/types-of-failover-operations-in-hyper-v-replica-part-iii-unplanned-failover.aspx) and summarize the differences between these 3 failovers. Stay tuned!

* * *
