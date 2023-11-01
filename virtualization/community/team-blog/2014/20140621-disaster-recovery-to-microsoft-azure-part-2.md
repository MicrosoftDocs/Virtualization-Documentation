---
title:      "Disaster Recovery to Microsoft Azure – Part 2"
author: sethmanheim
ms.author: mabrigg
ms.date: 06/21/2014
date:       2014-06-21 04:34:03
categories: asr
description: This article discusses protecting, replicating, and failover VMs directly to Microsoft Azure, Part 2.
---
# Disaster Recover to Microsoft Azure - Part 2

Continuing from the previous [blog](https://blogs.technet.com/b/virtualization/archive/2014/06/20/disaster-recovery-to-microsoft-azure.aspx) \- check out the recent TechEd NA 2014 talk @ <https://channel9.msdn.com/Events/TechEd/NorthAmerica/2014/DCIM-B322> which includes a cool demo of this product. 

Love it??? Talk about it, try it and share your comments. 

Let’s retrace the journey - in Jan 2014, we announced the General Availability of **Hyper-V Recovery Manager** **(HRM).** HRM  enabled customers to co-ordinate protection and recovery of virtualized workloads between SCVMM managed clouds. Using this Azure service, customers could setup, monitor and orchestrate protection and recovery of their Virtual Machines on top of Windows Server 2012, WS2012 R2 Hyper-V Replica. 

Like Hyper-V Replica, the solution works great when our customers had a secondary location. But what if it isn’t the case. After all, the CAPEX and OPEX cost of building and maintaining multiple datacenters is high. One of the common questions/suggestions/feedback to our team was around using Azure as a secondary data center. Azure provides a world class, reliable, resilient platform – at a fraction of a cost compared to running your workloads or in this case, maintaining a secondary datacenter. 

The rebranded HRM service - **Azure Site Recovery (ASR)** \- delivers this capability. On 6/19, we announced the availability of the preview version of ASR which orchestrates, manages and replicates VMs **to** Azure. 

When a disaster strikes the customer’s on-premises, ASR can “ **failover** ” the replicated VMs **in** Azure. 

And once the customer recovers the on-premises site, ASR can “ **failback** ” the Azure IaaS VMs **to** the customer’s private cloud. We want you to decide which VM runs where and when! 

There is some exciting technology built on top of Azure which enables the scenario and in the coming weeks we will dive deep into the workflows and the technology. 

Top of my head, the key features in the product are: 

  * Replication from a System Center 2012 R2 Virtual Machine Manager cloud **to Azu** r **e** – From a SCVMM 2012 R2 managed private cloud, any VM (we will cover some caveats in subsequent blogs) running on Windows Server 2012 R2 hypervisor can be replicated to Azure.




<!--[![Replication from a System Center 2012 R2 Virtual Machine Manager cloud to Azure](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image0017_thumb_3F5A80E6.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image0017_095601D9.jpg)-->

  * Replication frequency of **30seconds, 5mins or 15mins –** just like the on-premises product, you can replicate to Azure at 30seconds. 



<!--[![Replicate to Azure at 30 seconds](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image0019_thumb_5A2937A3.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image0019_039D78E4.jpg)-->

  * Additional **24 additional recovery points** to choose during failover – You can configure upto 24 additional recovery points at an hourly granularity. 



 

  * **Encryption @ Rest:** You got to love this – we encrypt the data *before* it leaves your on-premises server. We never decrypt the payload till you initiate a failover. You own the encryption key and it’s safe with you. 



<!--[![Encryption at rest](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image00111_thumb_3FEB5F30.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image00111_097AAD2E.jpg)-->

  * Self-service DR with **Planned, Unplanned and Test Failover** – Need I say more – everything is in your hands and at your convenience. 



<!--[![Self-service DR with planned, unplanned, and test failover](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image00113_thumb_05FEACF5.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image00113_7D7B4DAA.jpg)-->

  * One click app-level failover using Recovery Plans 
  * Audit and compliance reporting 
  * .…and many more!



The documentation explaining the end to end workflows is available to help you get started.

The landing page for this service is @ <https://azure.microsoft.com/services/site-recovery/>

If you have questions when using the product, post them @ <https://social.msdn.microsoft.com/Forums/windowsazure/en-US/home?forum=hypervrecovmgr> or in this blog.

Keep watching this blog space for more information on this capability. 
