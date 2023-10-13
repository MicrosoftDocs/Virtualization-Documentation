---
title:      "Backup of a Replica VM"
author: sethmanheim
ms.author: mabrigg
ms.date: 04/24/2014
date:       2014-04-24 04:21:00
categories: hvr
description: This blog discusses reasons to backup a Replica VM.
---
# Backup of a Replica VM

This blog post covers the scenarios and motivations that drive the backup of a Replica VM, and product guidance to administrators. 

## Why backup a Replica VM?

Ever since the advent of Hyper-V Replica in Windows Server 2012, customers have been interested in backing up the Replica VM. Traditionally, IT administrators have taken backups of the VM that contains the running workload (the primary VM) and backup products have been built to cater to this need. So when a significant proportion of customers talked about the backup of Replica VMs, we were intrigued. There are a few key scenarios where backup of a Replica VM becomes useful: 

  1. **Reduce the impact of backup on the running workload:    **Taking the backup of a VM involves the creation of a snapshot/diff-disk to baseline the changes that need to be backed up. For the duration of the backup job, the workload is running on a diff-disk and there is an impact on the system when that happens. By offloading the backup to the Replica site, the running workload is no longer impacted by the backup operation. Of course, this is applicable only to deployments where the backup copy is stored on the remote site. For example, the daily backup operation might store the data locally for quicker restore times, but monthly or quarterly backup for long-term retention that are stored remotely can be done from the Replica VM. 
  2. **Limited bandwidth between sites:**    This is typical of Branch Office-Head Office (BO-HO) kind of deployments where there are multiple smaller remote branch office sites and a larger central Head Office site. The backup data for the branch offices is stored in the head office, and an appropriate amount of bandwidth is provisioned by administrators to transfer the backup data between the two sites. The introduction of disaster recovery using Hyper-V Replica creates another stream of network traffic, and administrators have to re-evaluate their network infrastructure. In most cases, administrators either could not or were not willing to increase the bandwidth between sites to accommodate both backup and DR traffic. However they did come to the realization that backup and DR were independently sending copies of the same data over the network – and this was an area that could be optimized. With Hyper-V Replica creating a VM in the Head Office site, administrators could save on the network transfer by backing up the Replica VM locally rather than backing up the primary VM and sending the data over the network. 
  3. **Backup of all VMs in the Hoster datacenter:**    Some customers use the Hoster datacenter as the Replica site, with the intention of not building a secondary datacenter of their own. Hosters have SLAs around the protection of all customer VMs in their datacenters – typically once a day backup. Thus the backup of Replica VMs becomes a requirement for the success of their business.

Thus various customer segments found that the backup of a Replica VM has value for their specific scenarios. 

## Data consistency

A key aspect of the backup operation is related to the consistency of the backed-up data. Customers have a clear prioritization and preference when it comes to data consistency of backed up VMs: 

  1. Application-consistent backup 
  2. Crash-consistent backup

And this prioritization applied to Replica VMs as well. Conversations with customers indicated that they were comfortable with crash-consistency for a Replica VM, if application-consistency was not possible. Of course, anything less than crash-consistency was not acceptable and customers preferred that backups fail rather than have inconsistent data getting backed up. 

#### Attempting application-consistency

Typical backup products try to ensure application-consistency of the data being backed up (using the VSS framework) – and this works out well when the VM is running. However, the Replica VM is always turned off until a failover is initiated, and VSS is unable to guarantee application-consistent backup for a Replica VM. Thus getting application-consistent backup of a Replica VM is not possible. 

#### Guaranteeing crash-consistency

In order to ensure that customers backing up Replica VMs always get crash-consistent data, a set of changes were introduced in Windows Server 2012 R2 that failed the backup operation if consistency could not be guaranteed. The virtual disk could be inconsistent when any one of the below conditions are encountered, and in these cases backup is expected to fail. 

  1. HRL logs are being applied to the Replica VM 
  2. Previous HRL log apply operation was cancelled or interrupted 
  3. Previous HRL log apply operation failed 
  4. Replica VM health is Critical 
  5. VM is in the _Resynchronization Required_ state or the _Resynchronization in progress_ state 
  6. Migration of Replica VM is in progress 
  7. Initial replication is in progress (between the primary site and secondary site) 
  8. Failover is in progress



#### Dealing with failures

These are largely treated as transient error states and the _backup product is expected to retry the backup operation_ based on its own retry policies. With 30 second replication and apply being supported in Windows Server 2012 R2, the backup operation is expected to collide with HRL log apply more frequently  – resulting in error scenario 1 mentioned above. A robust retry mechanism is needed to ensure a high backup success rate. In case the backup product is unable to retry or cope with failures then an option is to explicitly pause the replication before the backup is scheduled to run.  

## Key Takeaways

#### Impact on administrators 

  1. Backup of Replica VMs is better with Windows Server 2012 R2. 
  2. Only crash-consistent backup of a Replica VM is guaranteed. 
  3. A robust retry mechanism needs to be configured in the backup product to deal with failures. Or ensure that replication is paused when backup is scheduled.



#### Impact on backup vendors

  1. The changes introduced in Windows Server 2012 R2 would benefit customers using any backup product to take backup of Replica VMs. 
  2. A robust retry mechanism would need to be built to deal with Replica VM failure. 
  3. For specific details on how Data Protection Manager (DPM) deals with the backup of Replica VMs, refer to [this blog post](https://blogs.technet.com/b/dpm/archive/2014/04/25/backing-up-of-replica-vms-using-dpm.aspx).

 

_Update 25-Apr-2014:   The DPM-specific details on this post have been moved to the [DPM blog](https://blogs.technet.com/b/dpm/archive/2014/04/25/backing-up-of-replica-vms-using-dpm.aspx). _
