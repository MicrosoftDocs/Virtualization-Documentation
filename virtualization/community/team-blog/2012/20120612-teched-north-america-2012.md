---
title:      "TechEd North America 2012"
date:       2012-06-12 22:52:39
categories: hvr
---
[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1106.image_thumb_0BB375C8.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1108.image_19EF5E07.png) | 

Posting this on behalf of **Jeff Woolsey** who delivered an amazing demo in the Day 1 Keynote address by **Satya Nadella.**

The video is available [**here**](http://northamerica.msteched.com/#fbid=L8HIhUFmQC7) and the transcript for the keynote address is available [**here**](http://www.microsoft.com/en-us/news/Speeches/2012/06-11TechEdDay1.aspx).  
  
---|---  
  
Some key takeaways from Jeff's presentation:

  * 64 virtual processors in a VM
  * **985,000 IOPs** from a single Windows Server 2012 Hyper-V VM 
    * 4k Random IO; Queue Depth 32, 40 concurrent threads
    * VMware tops out at 300,000 per VM; needs 6 VMs to achieve this
  * Offloaded Data Transfer ODX (file copies of **1 GigaBYTE** **per second** ). Yes folks, copy a 10 GB file in 10 seconds.
    * Works with SANs and the new Windows Server 2012 File Server
  * Cisco Nexus 1000v for Hyper-V
  * PowerShell as the engine for Run Book Automation with Hyper-V Replica
  * Extending on premise private cloud to service provider


