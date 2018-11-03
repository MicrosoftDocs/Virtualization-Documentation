---
layout:     post
title:      "Interpreting Replication Health – Part 1"
date:       2012-06-15 03:33:00
categories: hvr
---
In Windows Server 2012 Release Candidate, Hyper-V administrators can monitor the ‘health’ of the replicating VMs using the **Replication Health** attribute **.** This ** ** property allows administrators to answer common questions such as:

  * When did the primary and replica VMs last synchronize?

  * What is the average size of the replica file?

  * Were there any errors encountered during replication which requires your attention? etc. 




The two-part FAQ post explains the concept of Replication Health and provides guidance on how to interpret the attribute values.

#### Q1: How do I view the health of the replicating VM?

  * Click on the replicating VM and choose ‘ **View Replication Health …**’ from either the Hyper-V Manager or Failover Cluster Manager

[![image31_thumb2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2677.image31_thumb2_thumb_2F6D4B7A.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5807.image31_thumb2_102813F6.png) |   | [![image18_thumb5](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/0488.image18_thumb5_thumb_00408145.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3618.image18_thumb5_40E03D03.png)  
---|---|---  
  
[![image_thumb\[1\]](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6740.image_thumb1_thumb_17FCDA0D.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8015.image_thumb1_589C95CB.png)

  * (or) Click on the **Replication** tab in the bottom pane of the Hyper-V Manager to get a summary view



 

[![image_thumb21](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/0181.image_thumb21_thumb_78DC4DDD.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8400.image_thumb21_74CF6F5A.png)

#### Q2: What is the ‘Replication State’ and what are the values?

**Replication state** shows the **current** state of the replicating VM. It indicates whether the VM is being replicated, whether initial replication is pending etc.

**ReplicationState** can be queried from:

  * UI – As seen in the above picture
  * PowerShell – Using the **Measure-VMReplication** cmdlet.
  * WMI – From ** **[ **Msvm_ComputerSystem**](http://msdn.microsoft.com/en-us/library/hh850116\(v=vs.85\)) **** class where ReplicationState is a property



The table below captures the states as seen in WMI, UI and PowerShell.

**WMI**

| 

**UI**

| 

**PowerShell**

| 

**Notes**  
  
---|---|---|---  
  
0

| 

Not enabled

| 

NA

| 

VM is **not** enabled for replication.  
  
1

| 

Pending Initial Replication

| 

ReadyForInitialReplication

| 

Replication relationship has been created but **Initial Replication** has not been initiated. This is seen on the primary VM only.  
  
2

| 

Pending Initial Replication

| 

WaitingForInitialReplication

| 

The replica VM enters this state when a replication relationship has been created but **Initial Replication** has not been initiated (or) **Initial Replication** is in progress.

The primary VM enters this state when **Initial Replication** is in progress.  
  
3

| 

Replication Enabled

| 

Replicating

| 

This state (on  both the primary and replica VM) indicates that the replication is ‘ **Normal** ’.  
  
4

           | 

Prepared for planned failover

| 

SyncedReplicationComplete

| 

This state is applicable only for the primary VM. It indicates that **Planned Failover** is complete and that the VM is locked from powering up.  
  
5

| 

Failover Complete

| 

FailOverWaitingCompletion

| 

**Failover** has been initiated on the replica VM but has not been completed. The Failover operation is considered to be complete only when the VM is either reverse replicated (or) when additional recovery points are removed.  
  
6

| 

Failover Complete

| 

FailedOver

| 

The replica VM enters this state once the **Failover** operation has been completed.  
  
7

| 

Replication Paused

| 

Suspended

| 

The VM enters this state when replication is **Paused**. This state is applicable on both the primary and replica VM  
  
8

| 

Replication Error

| 

Error

| 

This state is applicable on both the primary and replica VM and indicates that replication is not occurring on either VM. Usually administrator intervention is required to restore replication.  
  
9

| 

Resynchronization required

| 

WaitingForStartResynchronize

| 

The primary VM enters this state when it needs to be resynchronized.  
  
10

| 

Resynchronizing

| 

Resynchronizing

| 

Resynchronization has been initiated on the primary VM.  
  
11

| 

Resynchronize Suspended

| 

ResynchronizeSuspended

| 

If the primary VM suspends the resynchronization operation, the VM enters this state.  
  
 

#### Q3: Isn’t Replication State sufficient to track whether replication is in progress, why do I need Replication Health?

Good question! While Replication State is comprehensive, it provides the **current** replication status  – it does not provide any ‘trending' information or warnings to watch out for. 

On the other hand, **Replication Health** provides an aggregated view of events in a certain interval. Hyper-V Replica uses inbuilt heuristics to warn the administrator that replication is sub-optimal.

Let’s consider an example where your organization’s network connectivity is over burdened between 2am to 6am everyday. This could result in a sub-optimal replication of the VM (i.e replication is not occurring every 5mins or the replica VM is behind the primary VM by more than an hour). When you check the **Replication State** of the VM at 10am everyday, it would indicate that replication is normal (Replication Enabled, as described in the above table).

However, this does not paint a true picture as your replica is behind the primary VM. **Replication Health** on the other hand would either be set to Warning or Critical which would prompt you to debug the issue further.

**Q4: Ah, so what are the possible values for Replication Health? **

Hyper-V Replica aggregates these events into 3 potential values which can be queried from:

  * UI – As seen in Q1 (above)
  * PowerShell – Using the **Measure-VMReplication** cmdlet.
  * WMI – From ** **[ **Msvm_ComputerSystem,**](http://msdn.microsoft.com/en-us/library/hh850116\(v=vs.85\)) where ReplicationHealth is a property



The table below captures the states as seen in WMI, UI and PowerShell.

**WMI**

| 

**UI**

| 

**PowerShell**

| 

**Notes**  
  
---|---|---|---  
  
0

| 

Not enabled

| 

NA

| 

This state is observed when the VM which is not enabled for replication.  
  
1

| 

Normal

| 

Normal

| 

Replication is normal, see Q7 for more details.  
  
2

| 

Warning

| 

Warning

| 

Replication is not normal. See Q6 for more details on how to interpret this state.  
  
3

| 

Critical

| 

Critical

| 

Replication is not normal or optimal. Administrators need to intervene to fix and resume the replication. See Q5 for more details.  
  
 

#### Q5: When is Replication Health considered ‘Critical’?

The Replication Health is flagged as Critical if one of the following occurs:

  * If the primary server is unable to send replication traffic to the Replica server (say due to network connectivity issues, storage issues on the primary or replica or if the primary VM requires resynchronization)
  * If replication is paused on the replica VM



In the Replication Health pane, click on ‘ **View Events** ’ to see a filtered set of events corresponding to this VM which helps you root-cause the issue.

[![image_thumb5](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6835.image_thumb5_thumb_1098A6A6.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7506.image_thumb5_4A8558E1.png)

 

#### Q6: When is Replication Health flagged as ‘Warning’?

The Replication Health is shown as Warning when the replication is ‘not optimal’. The conditions which would result in a Warning health include:

  * >20% of replication cycles have been missed in a monitoring interval – Common reasons which lead to this condition include insufficient network bandwidth, storage IOPS bottleneck on your replica server.
  * More than an hour has elapsed since the last send replica (on the primary VM) was sent or the last received replica (on the replica VM) was received – This could result in a loss of more than 60mins worth of data loss if the replica VM is failed over (due to a disaster)
  * If Initial Replication has not been completed
  * If Failover has been initiated, but ‘reverse replication’ has not been initiated
  * If the primary VM’s replication is paused.



**Q7: So does ‘Normal’ mean that the replication is on track?**

Correct, this health indicates that replication has the following characteristics:

  * Less than or equal to 20% of the replication cycles are missed
  * The last synchronization point was less than an hour
  * The average latency is less than or equal to 5mins

**Primary VM** | [![image_thumb2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2100.image_thumb2_thumb_75F12BEE.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6320.image_thumb2_328699DB.png)  
---|---  
  |    
**Replica VM** | [![image_thumb41](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7065.image_thumb41_thumb_09A336E5.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/6087.image_thumb41_1C559FEB.png)  
        

#### That’s neat! Tell me more…

We will cover further details such as PowerShell cmdlets, tips to extend the platform capability to monitor the health by setting up alerts, interpreting the attribute in the Replication Health view, concept of a monitoring interval, monitoring start time etc., in the [next post](http://blogs.technet.com/b/virtualization/archive/2012/06/21/interpreting-replication-health-part-2.aspx).
