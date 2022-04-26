---
title:      "Types of failover operations in Hyper-V Replica–Part III - Unplanned Failover"
author: mattbriggs
ms.author: mabrigg
ms.date: 08/08/2012
date:       2012-08-08 12:21:56
categories: disaster-recovery
description: Types of failover operations in Hyper-V Replica–Part III - Unplanned Failover
---
# Unplanned failover in Hyper-V Replica

In the first two parts of this 3-part series, you learnt about [Test Failover](https://blogs.technet.com/b/virtualization/archive/2012/07/26/types-of-failover-operations-in-hyper-v-replica.aspx) (TFO) and [Planned Failover](https://blogs.technet.com/b/virtualization/archive/2012/07/31/types-of-failover-operations-in-hyper-v-replica-part-ii-planned-failover.aspx) (PFO). In this closing part of the series, I will talk about unplanned failover and summarize the differences of these 3.

### 1\. What is Unplanned Failover? 

Unplanned Failover is an operation initiated on the replica VM when the primary VM/site is hit by a disaster. During Unplanned Failover, a check is done using Remote WMI to see if the primary VM is running.This is to protect against accidental administrator actions on the replica VM. This check prevents a ‘split-brain’ scenario where both the production and the replica VMs are running.

### 2\. When should I use Unplanned Failover? 

Unplanned Failover is used in the following cases 

  * My primary site is experiencing unexpected power outage or a natural disaster 
  * My primary site/VM has had a virus attack and I want to restore my business quickly with minimal data loss by restoring my replica VM



### 3\. How should I use Unplanned Failover?

Unplanned failover is performed on the replica virtual machine by right-clicking on the VM and choosing the **Failover** operation (either from the Hyper-V Manager or from the Failover Clustering Manager).

[![clip_image001](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5344.clip_image001_thumb_397A690F.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4762.clip_image001_56CA9F77.jpg)

If you have turned on recovery history, Unplanned Failover can be performed against a previous point-in-time. This is usually done in case the most recent point is either corrupt or not application consistent. Once you failover, you should run some tests to check that the point-in-time is good. If the point-in-time has issues, you can cancel the failover using **“Cancel Failover”** on the replica VM. Then you can choose a different point-in-time and do a Failover.

After you have validated that the failed over VM is kosher, you should do a **‘Complete’** of the failover by performing an action on the replica virtual machine – this will ensure that the recovery points are merged.

The above procedure can be achieved using Powershell using the following cmdlets. Use Complete-VMFailover only after ensuring that the failed over VM serves the purpose.
    
```markdown
 1: $snapshots = Get-VMSnapshot -VMName VirtualMachine_Workload -SnapshotType Replica
    
    
 2:  
    
    
 3: Start-VMFailover -Confirm:$false -VMRecoverySnapshot $snapshots[0]
    
    
 4:  
    
    
 5: Complete-VMFailover -VMName VirtualMachine_Workload -Confirm:$false
```

****

**Characteristics**

The table below calls out the characteristics of the 3 failovers 

  | 

**Test Failover**

| 

**Planned Failover**

| 

**Unplanned Failover**  
  
---|---|---|---  
  
Operation initiated on

| 

Replica VM

| 

Initiated on the primary VM and completed on the replica VM

| 

Replica VM  
  
Is a duplicate VM created during the operation?

| 

Yes

| 

No

| 

No  
  
How long is the operation run?

| 

Short

| 

Depends on maintenance window or regulation requirement

| 

Depends on when the primary is brought back up  
  
Recommended frequency

| 

Once a month

| 

Once in 6 months

| 

Never (ok, fine – whenever you have a disaster![Smile](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2744.wlEmoticon-smile_5D36C706.png))  
  
What happens to the replication of the primary VM during the duration of this operation

| 

Continues

| 

Continues. In this operation, a role-reversal happens, the primary VM becomes the replica VM and replication continues back to the primary site (that initiated the operation).

| 

Stopped  
  
Is there data loss?

| 

None

| 

None

| 

There can be data loss  
  
Is there down time? | 

None

| 

Planned downtime

| 

Unplanned downtime  
  
When to use

| 

  * Run minimal tests to validate if your replication is on track 
  * Train your personnel on what is to be done in case of a disaster. 
  * Test the recovery plan that you have built to test your preparation when disaster does strike. 

| 

  * Perform host maintenance on your primary and would like to run from the replica site.
  * Your primary site is expecting some power outage – you want to move over to the replica site.
  * There’s an impending typhoon – you want to proactively take action to ensure business continuity.
  * Your compliance requirements mandate that every quarter, you run your workloads from the replica site for a week.

| 

  * Your primary site is experiencing unexpected power outage or a natural disaster 
  * Your primary site/VM has had a virus attack and you want to restore your business quickly with minimal data loss by restoring your replica VM

  
  
**Summary**

In closing, use **Test Failover** frequently to check the fidelity of your replication and test your recovery plans. Use **Planned Failover** occasionally for either planned maintenance or disaster simulation or compliance reasons. Use **Unplanned Failover** when your primary site is hit by a disaster.
