---
title:      "Out-of-band Initial Replication (OOB IR) and Deduplication"
author: sethmanheim
ms.author: mabrigg
ms.date: 07/11/2014
date:       2014-07-11 09:50:00
categories: disaster-recovery
description: This article discusses creating an entire Replica site from scratch with constraints.
---
# Out-of-band Initial Replication (OOB IR) and Deduplication

A recent conversation with a customer brought out the question:   **What is the best way to create an entire Replica site from scratch?** At the surface this seems simple enough – configure initial replication to send the data over the network for the VMs one after another in sequence. For this specific customer however, there were some additional constraints placed:

  1. The network bandwidth was less than 10Mbps and it primarily catered to their daily business needs (email etc…). Adding more network was not possible within their budget. This came as quite a surprise because despite the incredible download speeds that are encountered these days, there are still places in the world where it isn't as cost effective to purchase those speeds. 
  2. The VMs were of size between 150GB and 300GB each. This made it rather impractical to send the data over the wire. In the best case, it would have taken 34 hours for a single VM of size 150GB.



This left OOB IR as the only realistic way to transfer data. But at 300GB per VM, it is easy to exhaust a removable drive of 1TB. That left us thinking about deduplication – after all, [deduplication is supported on the Replica site](https://blogs.technet.com/b/virtualization/archive/2013/12/23/using-dedupe-with-hyper-v-replica-for-storage-savings.aspx). So why not use it for deduplicating OOB IR data?

So I tested this out in my lab environment with a removable USB drive, and a bunch of VMs created out of the same Windows Server 2012 VHDX file. The expectation was that at least 20% to 40% of the data would be same in the VMs, and the overall deduplication rate would be quite high and we could fit a good number of VMs into the removable USB drive.

I started this experiment by attaching the removable drive to my server and attempted to enable deduplication on the associated volume in Server Manager.

##### Interesting discovery #1:  Deduplication is not allowed on volumes on removable disks

Whoops! This seems like a fundamental block to our scenario – how do you build deduplicated OOB IR, if the deduplication is not supported on removable media? This limitation is officially documented here: <https://technet.microsoft.com/library/hh831700.aspx>, and says _“Volumes that are candidates for deduplication must conform to the following requirements:   Must be exposed to the operating system as non-removable drives. Remotely-mapped drives are not supported.”_

Fortunately my colleague [**Paul Despe**](https://social.technet.microsoft.com/profile/Paul%20Despe) in the Windows Server Data Deduplication team came to the rescue. There is a (slightly) convoluted way to get the data on the removable drive _and_ deduplicated. Here goes:

  * Create a dynamically expanding VHDX file. The size doesn’t matter too much as you can always start off with the default and expand if required.



<!--[![Dynamically expanding VHDX file](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_1D8D60E6.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_15763491.png)-->

  * Using _Disk Management,_ bring the disk online, initialize it, create a single volume, and format it with NTFS. You should be able to see the new volume in your Explorer window. I used Y:\ as the drive letter.



<!--[![New volume in Explorer window](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_02E5E62F.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_73434A6C.png)-->

  * Mount this VHDX on the server you are using to do the OOB IR process. 
  * If you go to _Server Manager_ and view this volume (Y:\\), you will see that it is backed by a fixed disk.



<!--[![View volume](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_26A42F2B.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_5084A360.png)-->

  * In the volume view, enable deduplication on this volume by right-clicking and selecting **‘Configure Data Deduplication’**. Set the **‘Deduplicate files older than (in days)’** field to zero.



<!--[![Enable duplication with Configure Data Deduplication](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_5A028338.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_263A8CE7.png)-->

<!--[![Deduplicate files older than (in days) field](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_42013381.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_4C32CDEE.png)-->

You can also enable deduplication in PowerShell with the following commandlets:
    
```markdown
PS C:\> Enable-DedupVolume Y: -UsageType HyperV
    
    
PS C:\> Set-DedupVolume Y: -MinimumFileAgeDays 0
```

Now you are set to start the OOB IR process and take advantage of the deduplicated volume. This is what I saw after 1 VM was enabled for replication with OOB IR:

<!--[![1 V M enabled for replication with O O B I R Image 1](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_0C8D92BE.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_6F84E3F5.png)-->

<!--[![1 V M enabled for replication with O O B I R Image 2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_4BCD8B65.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_03804596.png)-->

That’s about 32.6GB of storage used. Wait… shouldn’t there be a reduction in size because of deduplication?

##### Interesting discovery #2:  Deduplication doesn’t work on-the-fly

Ah… so if you were expecting that the VHD data would arrive into the volume in deduplicated form, this is going to be a bit of a surprise. At the first go, the VHD data will be present in the volume _in its original size._ Deduplication happens as post-facto as a job that crunches the data and reduces the size of the VHD after it has been fully copied as a part of the OOB IR process. This is because deduplication needs an exclusive handle on the file in order to go about doing its work.

The good part is that you can trigger the job on-demand and start the deduplication as soon as the first VHD is copied. You can do that by using the PowerShell commandlet provided:
    
```markdown
PS C:\> Start-DedupJob Y: -Type Optimization
```

There are other parameters provided by the commandlet that allow you to control the deduplication job. You can explore the various options in the TechNet documentation: [here](/powershell/module/deduplication/start-dedupjob).

This is what I got after the deduplication job completed:

<!--[![Screen after completing deduplication job]](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_6AA920A5.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_1FB31F25.png)-->

That’s a 54% saving with just one VM – a very good start!

##### Deduplication rate with more virtual machines

After this I threw in a few more virtual machines with completely different applications installed and here is the observed savings after each step:

<!--[![Observed savings](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_091882F1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_59C70D66.png)-->

I think the excellent results speak for themselves! Notice how between VM2 and VM3, almost all of the data (~9GB) has been absorbed by deduplication with an increase of only 300MB! As the deduplication team as published on TechNet, VDI VMs would have a high degree of similarity in their disks and would result in a much higher deduplication rate. A random mix of VMs yields surprisingly good results as well.

##### Final steps

Once you are done with the OOB IR and deduplication of your VMs, you need to do the following steps:

  1. Ensure that no deduplication job is running on the volume 
  2. Eject the fixed disk – this should disconnect the VHD from the host 
  3. Compact the VHD using the **“Edit Virtual Hard Disk Wizard”**. At the time I disconnected the VHD from the host, the size of the VHD was 36.38GB. After compacting it the size came down to 28.13GB… and this is more in line with the actual disk consumed that you see in the graph above 
  4. Copy the VHD to the Replica site, mount it on the Replica host, and complete the OOB IR process!



 

Hope this blog post helps with setting up your own Hyper-V Replica sites from scratch using OOB IR! Try it out and let us know your feedback.
