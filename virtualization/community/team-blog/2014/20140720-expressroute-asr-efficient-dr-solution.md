---
layout:     post
title:      "ExpressRoute + ASR = Efficient DR solution"
date:       2014-07-20 13:00:00
categories: asr
---
Microsoft recently announced the availability of Azure **ExpressRoute** which enabled our customers to create a private connection between their on-premises to Microsoft Azure. This ensured that the data to Azure used an alternate path to the internet where a connection to Azure could be established through an Exchange Provider or through a Network Service Provider. With ExpressRoute customers can connect in a private peering setup to both Azure Public Cloud Services as well as Private Virtual Networks. 

This opened up a new set of scenarios which otherwise was gated on the network infrastructure (or lack of it) – key among them were continuous, replication scenarios such as Azure Site Recovery. At scale, when replicating 10’s-100’s of VMs to Azure using **Azure Site Recovery (ASR)** , you can quickly send TBs of data over ExpressRoute. 

You can find tons of documentation on ExpressRoute and it’s capabilities @ <https://azure.microsoft.com/en-us/services/expressroute/> and TechEd talks in Channel9 @ <https://channel9.msdn.com/Search?term=expressroute#ch9Search>. ExpressRoute truly extends your datacenter to Azure and organizations can view Azure as “yet-another-branch-office”. 

ASR was truly excited with this announcement which couldn’t have come at a better time. Microsoft’s internal IT (MSIT) and Network Infrastructure Services (NIS), being the very first adopters of ExpressRoute has rolled out ExpressRoute as a Network Service, which enables true hybrid cloud experience for all internal customers. 

My partners in MSIT ( **Arvind Rao & Vik Chhabra**) helped me get ExpressRoute connected setup and I got a chance to play around with ASR from one of the Microsoft buildings at Puget Sound. The setup which was loaned to me by MSIT looks similar to this (except that MSIT owns both the infrastructure and the network): 

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_41A29FA3.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_148B2224.png)

At a high level, ASR replicates VM (initial and subsequent changes to the VM) to your storage account directly. The “replication” traffic is sent over the green line to “Azure public resources” such as Azure blob store. Once the VMs are failed over, we create IaaS VMs in Azure using the replicated data. Any traffic back to the corporate network (CorpNet) or from CorpNet to the IaaS VM goes over the red line in the above picture. 

The results were **fabulous** to say the least! High throughput was observed during initial and delta replication. Once the VMs were failed over, the traffic to our internal CorpNet and high throughput was observed for that as well. The key takeaway: Once ER was setup, ASR just worked. There was no extra configuration which was required from ASR’s perspective. 

How high is “high throughput” - in a setup, where I had 3 replicating VMs, the below picture captures the network throughput when initial replication was in progress:  

[![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image0015_thumb_1D797C9A.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image0015_374B2218.jpg)

A whooping 1.5Gbps network upload speed to Azure – **go ExpressRoute, go!**

To get the above network throughput, a registry key needs to be set in *each* of the Hyper-V servers

[![clip_image001](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image001_thumb_70BCF16D.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/clip_image001_0A8E96EC.jpg)

The “UploadThreadsPerVM” controls the number of threads which is used when replicating each VM. In an “overprovisioned” network, this registry key needs to be changed from it’s default values. We support a maximum of 32 threads per replicating VM. 

In summary, ASR combined with ExpressRoute provides a powerful, compelling, efficient disaster recovery scenario to Microsoft Azure. ExpressRoute removes traditional blockers in networking when sending massive amounts of data to Azure – disaster recovery being one such scenario. And ASR removes traditional blockers of providing an easy, cost effective DR solution to a public cloud infrastructure such as Microsoft Azure. 

You can find more details on ASR @ <http://azure.microsoft.com/en-us/services/site-recovery/>. The documentation explaining the end to end workflows is available @ <http://azure.microsoft.com/en-us/documentation/articles/hyper-v-recovery-manager-azure/>. And if you have questions when using the product, post them @ <http://social.msdn.microsoft.com/Forums/windowsazure/en-US/home?forum=hypervrecovmgr> or in this blog. 

You can also share your feedback on your favorite features/gaps @ <http://feedback.azure.com/forums/256299-site-recovery>. As always, we love to hear from you!
