---
title:      "Hyper-V Replica&#58; Extend Replication"
author: sethmanheim
ms.author: sethm
ms.date: 12/09/2013
categories: hvr
description: Enabling the Hyper-V Extend Replication in Windows Server 2012 R2.
---
# Hyper-V Extend Replication

With Hyper-V Extend Replication feature in Windows Server 2012 R2, customers can have multiple copies of data to protect them from different outage scenarios. For example, as a customer I might choose to keep my second DR site in the same campus or a few miles away while I want to keep my third copy of data across the continents to give added protection for my workloads. Hyper-V Replica **Extend replication** exactly addresses this problem by providing one more copy of workload at an extended site apart from replica site. As mentioned in [What's new in Hyper-V Replica in Windows Server 2012 R2](https://techcommunity.microsoft.com/t5/virtualization/what-8217-s-new-in-hyper-v-replica-in-windows-server-2012-r2/ba-p/382119), user can extend the replication from Replica site and continue to protect the virtualized work loads even in case of disaster at primary site!! 

This is so cool and exactly what I was looking for. But how do I enable this feature in Windows Server 2012 R2? Well, I will walk you through different ways in which you can enable replication and you will be amazed to see how similar is the experience is to enable replication wizard.

## Extend Replication through UI:

Before you Extend Replication to third site, you need to establish the replication between a primary server and replica server. Once that is done, go to replica site and from Hyper-V UI manager select the VM for which you want to extend the replication. Right click on VM and select " **Replication- >Extend Replication …". **This will open Extend Replication Wizard which is similar to Enable Replication Wizard. Few points to be taken care are: 

1\. In **Configure Replication frequency** screen , note that Extend Replication only supports 5 minute and 15 minute Replication frequency. Also note that replication frequency of extend replication should be at least equal to or greater than primary replication relationship.

2\. In **Configure Additional Recovery Points** screen, you can mention the recovery points you need on the extended replica server. Please note that you cannot configure App-Consistent snapshot frequency in this wizard.  

Click **Finish** and you are done!! Isn't it very similar to Enable Replication Wizard???

If you are working with clusters, in replica site go to Failover Cluster manager UI and select the VM for which you want to extend replication from Roles tab in the UI. Right Click on VM and select " **Replication- >Extend Replication**".  Configure the extended replica cluster/server in the same way as you did above.

## Extend Replication using PowerShell:

You can use the same PowerShell cmdlet which you used for enabling Replication to create extended replication relationship. However as stated above, you can only choose a replication frequency of either 5 minutes or 15 minutes.

_**Enable-VMReplication –VMName `<vmname>` -ReplicaServerName <extended_server_name> -ReplicaServerPort <Auth_port> -AuthenticationType <Certificate/Kerberos> -ReplicationFrequencySec <300/900> [--other optional parameters if needed—]**_

## Status and Health of Extended Replication:

Once you extend replication from replica site, you can check Replication tab in Replica Site Hyper-V UI and you will see details about extend replication being present along with Primary Relation ship. 

<!--[![Replication tab](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2543.image_thumb_342CCD41.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1373.image_6283C23D.png)-->

You can also check-up Health Statistics of Extended Replication from Hyper-V UI. Go to VM in Replica site and right click and select "Replication->View replication Health" . Extended Replication health statistics are displayed under a separate tab named "Extended Replication".

<!--[![Extended replication health statistics](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/5428.image_thumb_1985528A.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3583.image_6CDA07FF.png)-->

You can also query PowerShell on the replica site to see details about Extended Replication Relationship.

_**Measure-VMReplication –VMName `<name>` -ReplicationRelationshipType Extended | select ***_

This is all great. But how do I carry out failover in case of Extended Replication? I will reserve that to my next blog post. Until then happy extended Replication.
