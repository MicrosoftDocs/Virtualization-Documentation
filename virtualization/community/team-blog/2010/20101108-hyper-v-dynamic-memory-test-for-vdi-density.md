---
layout:     post
title:      "Hyper-V Dynamic Memory test for VDI density"
date:       2010-11-08 01:30:00
categories: dell
---
Hi, I’m Michael Kleef, senior technical product manager within the Windows Server and Cloud division. 

As Brad Anderson and I discussed at the [TechEd Europe keynote today](http://www.msteched.com/), Dynamic Memory, a new feature in Windows Server 2008 R2 SP1, can increase Virtual Desktop Infrastructure (VDI) densities by 40% compared to Hyper-V in Windows Server 2008 R2 and also well above a leading industry solution. It’s also not just a benefit to VDI. Our Technology Adoption Program (TAP) customer data also highlights that other server workloads benefit from Dynamic Memory with gains of between 25% and 50% depending on the specific workload and usage pattern.

This data point came from a series of tests, on different hardware vendor platforms, that we have run at scale in our test labs in Redmond. To provide some additional technical details, I want to take a moment to explain what we focused on in testing and provide a high level summary of the test methodology we used, and the results we found. In the near future, we expect to release a whitepaper that goes into more detail of the tests including specific opportunities to increase performance and response.

**Scope**

[ From previous capacity planning data](http://www.microsoft.com/downloads/en/details.aspx?displaylang=en&FamilyID=bd24503e-b8b7-4b5b-9a86-af03ac5332c8) we already knew that Disk IO is the first bottleneck to be hit in VDI performance, followed by memory as a ceiling to density (not necessarily performance), and finally processor, last of all. 

Our primary goal was simply to understand how Dynamic Memory influences the memory ceiling to density, and realistically, by how much. Secondary goals were to understand how [XenDesktop 4](http://www.citrix.com/English/ps2/products/product.asp?contentID=163057%20&ntref=mainxdvanityurl) functioned with Hyper-V R2 SP1 and its different approach to storage using Citrix Provisioning Services.

**Test Framework**

As part of this test we wanted to avoid using internal Microsoft test tools and instead use an industry standard test framework that the bulk of the industry is currently using. We chose [Login Consultants LoginVSI](http://www.loginconsultants.com/) test framework. More details can be [found here](http://www.loginconsultants.com/index.php?option=com_content&task=view&id=231&Itemid=279), though essentially this test toolkit attempts to mirror a user behavior through automation by starting various applications, entering data, pausing, printing, opening web content and then looping the test as many times as necessary to gain an idea of maximum system performance. It provides for different user profiles from light use, to medium and heavy user use. We chose the medium use profile, as this is primarily what others in the industry tend to test against.

In our first pass of the tests, we set up a basic test infrastructure to get an early glimpse into how we performed.

 We initially used a HP DL 380 G5 server with a Dual Quad Hyperthreaded (Nehalem) processors, 110GB of RAM and an iSCSI target that had a 42 disk shared storage array. The storage was configured as RAID 0 for maximum read and write throughput. While this server has 110GB, we did want to limit its scope to 96GB RAM. The reason for this is the price/performance curve right now is optimal at the 96GB RAM level. Beyond 96GB the price for DIMMs increases exponentially – and additionally we knew we were going to test other servers that have 96GB – so we wanted a consistent memory comparison on multiple hardware platforms. 

Once we had tested against the HP server, we planned to re-run the same tests against Dell’s newest blade servers. 

We tested Dell’s M1000e blade chassis, configured with 16 M610 blades and each having Dual Hex Core (Westmere) hyper-threaded processors, 96GB RAM and a pair of 500GB SAS drives. This was connected to a pair of Dell EqualLogic 10GBe SANs – one SAN having 16 SAS drives, and the other having 8 SSD drives.

 

![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6278.e1000.jpg) 

 

**Figure 1:** The density tests we ran against the Dell blades had several phases:

·        The first phase was to replicate the same test we ran on the HP hardware, to confirm the initial density results. 

·        The second phase was to introduce Citrix XenDesktop onto the single blade to understand single blade scale[, with different storage architecture](http://community.citrix.com/display/ocb/2010/08/06/Saving+IOPS+with+Provisioning+Services).

·        The third phase was to re-test the [Dell Reference Architecture](http://citrixandmicrosoft.com/Docs/WhitePapers/DELL_MSFT_CTRX_VRD_RA_vFinal.pdf) (RA) using Hyper-V R2 and Citrix XenDesktop and see what the resultant difference in density was. We tested their 1000 user reference architecture portion of that RA.

**Summary Results**

I don’t want this blog post to labor beyond the top line points and so I’ll save the details for the whitepaper that will come later, including full performance monitor traces. I will keep the summary results to the two core interest areas – how dynamic memory affected density and whether response was affected. If you are at TechEd Europe, I will be presenting on VDI and will be sharing quite a bit of detail in the below results. The session code for that is VIR305 and is scheduled for the 11th November at 9am.

**_Memory Results_**

With all tests based on installed memory of 96GB, we wanted to ensure there was sufficient spare capacity to allow for bursts in memory usage. We chose to stay around the Dell RA spare capacity of around 10GB, to keep that as a consistent of the baseline measurement of Hyper-V R2 RTM. That meant we needed to stay around an 87GB maximum allocation.

Previously in that reference architecture, Dell achieved 85 VMs, with each Windows 7 VM configured with 1GB RAM, the recommended minimum for Windows 7.

However because we are now using Dynamic Memory we can change the VM start-up to 512MB of RAM and allow dynamic memory to allocate as necessary. This change is [already documented on TechNet](http://technet.microsoft.com/en-us/library/ff817651\(WS.10\).aspx) and will be supported at release. 

By allowing Dynamic Memory to take control of memory allocation, this total load on the single server test up to 120VMs with a 40% increase in density. Each VM averaged around 700MB RAM running the LoginVSI workload and these results were consistently confirmed on the Dell blade testing also. When we scaled this out on the complete Dell RA, we took a reference architecture that _previously ran on 12 blades, down to 8_ , with an easily calculable corresponding drop in cost per user/VM.

**_System Response_**

There’s no point in scaling up significantly, if the hypervisor and hardware can’t sustain the resultant IO pressure that is added by 40% more VMs. On the below HP DL 380 response chart produced by LoginVSI, we comfortably achieved 120 VMs, without any processor issues. This result is heavily dependent on the SAN infrastructure to sustain the required [IOPS](http://en.wikipedia.org/wiki/IOPS), and in this instance we also never saw an excessive disk queue length that would indicate an inability to keep up with load. In this test we also never hit VSIMax, which is an indicator of maximum server capacity. 

 

 ![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5078.chart2.png)

**Figure 2: LoginVSI test chart –HP DL 380 G5 reference test**

This test result was reproduced with the Dell M610 blades [and improved with Citrix XenDesktop as we scaled out the solution using Provisioning Services](http://community.citrix.com/display/ocb/2010/08/06/Saving+IOPS+with+Provisioning+Services).

**Closing**

Dynamic Memory can add significant density to all workloads. While today we have shown you how VDI benefits significantly from Dynamic Memory, shortly you will see case studies from us that show in various workloads customers can expect to see between 25% to 50% increases in density in production deployments. For further information on Dynamic Memory, Jeff Woolsey [has made some great comments on this already](http://blogs.technet.com/b/virtualization/archive/2010/04/07/dynamic-memory-coming-to-hyper-v-part-3.aspx), and just how much better its architecture is in comparison to the competition.

Watch out for the whitepaper which we will also announce via this blog in the near future.

 

Michael Kleef

 
