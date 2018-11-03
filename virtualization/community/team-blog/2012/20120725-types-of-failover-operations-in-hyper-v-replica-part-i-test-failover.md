---
layout:     post
title:      "Types of failover operations in Hyper-V Replica – Part I – Test Failover"
date:       2012-07-25 16:15:00
categories: clustering
---
If you are wondering “ _I have enabled replication and it looks like everything is in progress, but how do I know that I am truly protected_ ”, then keep reading the next few posts as we walk you through the various types of failover, how and when to use them and the gotchas in different deployments.

At a high level, Hyper-V Replica supports three types of Failover:

  * Test Failover 
  * Planned Failover 
  * Unplanned Failover 



Each of these is built to meet specific and different needs. As you might know by now, using Hyper-V Replica you can replicate between different primary and replica site deployments – your primary server could be a standalone server or part of a cluster and similarly your replica server could be a standalone server or part of a cluster. Independent of your deployment, the workflow and the set of features offered are the same and the 3 types of failovers work in all deployments. 

For this article, let’s assume the name of the virtual machine is **_VirtualMachine_Workload_**.

## **Test Failover (TFO)**

#### **1.What** is Test Failover?

Test Failover is an operation initiated on your replica virtual machine which allows you to test the sanity of the virtualized workload without interrupting your production workload or ongoing replication.

#### **2\. When** should I use Test Failover?

Think of Test Failover as an ability to non-disruptively simulate your recovery procedure in an isolated network. You should initiate this operation if you wish to:

  * Run minimal tests to validate if your replication is on track 
  * Train your personnel on what is to be done in case of a disaster. 
  * Test the recovery plan that you have built to test your preparation when disaster does strike. 



#### **3\. How** should I use this feature? 

TFO is performed on the replica virtual machine by right-clicking on the VM and choosing the Test Failover operation (either from the Hyper-V Manager or from the Failover Clustering Manager)

[![TFO-Start](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2570.TFO-Start_thumb_1F817CF3.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8372.TFO-Start_52BB25AB.png)

You are given a choice to pick one of the available recovery points. 

[![TFO](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2526.TFO_thumb_102AC88C.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7317.TFO_07EC6031.jpg)

After this, a NEW virtual machine is spun up on the replica site. The name of the new virtual machine is the name of the replica virtual machine with **“ - Test”** appended. In our example, it would be _VirtualMachine_Workload – Test_

[![TFO-Machines](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/7725.TFO-Machines_thumb_55D4740C.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3603.TFO-Machines_71E2A246.png)

The TFO virtual machine should then be started in an isolated network and client tests can be run against the same to validate replication. You can pre-assign a network and an IP address using the [guest IP address ](http://blogs.technet.com/b/virtualization/archive/2012/05/29/inject-ip-address-into-the-vm-during-failover.aspx)[injection](http://blogs.technet.com/b/virtualization/archive/2012/05/29/inject-ip-address-into-the-vm-during-failover.aspx) feature. Once satisfied that replication is kosher, you should do **“Stop Test Failover”** on the Replica virtual machine, which will clean up the duplicate virtual machine. 

Since Test Failover does NOT impact your production workload and does NOT impact your ongoing replication, it is recommended that you perform TFO regularly. There are a couple of mechanisms which help you track the frequency of this event – BPA rules and [replication health](http://blogs.technet.com/b/virtualization/archive/2012/06/15/interpreting-replication-health-part-1.aspx).

The above procedure can be achieved using Powershell using the following cmdlets.

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/4251.image_thumb_68DB5201.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5228.image_56D4F17D.png)

#### 4\. Anything to watch out for?

  * For any replica virtual machine, the system allows only one TFO operation at a time. This prevents proliferation of test virtual machines. 
  * On a cluster, the replica VM and its associated test failover VM should be on the same node always. If these move to different nodes, the association between the replica VM and test-replica VM is broken. When that happens, the user can do another TFO and this will lead to two test failover VMs for one replica VM. Therefore care should be taken to ensure the replica VM and its test failover VM migrate together. 



The next post will cover [Planned Failover](http://blogs.technet.com/b/virtualization/archive/2012/07/31/types-of-failover-operations-in-hyper-v-replica-part-ii-planned-failover.aspx) and the last in the series will cover the [Unplanned Failover](http://blogs.technet.com/b/virtualization/archive/2012/08/08/types-of-failover-operations-in-hyper-v-replica-part-iii-unplanned-failover.aspx).
