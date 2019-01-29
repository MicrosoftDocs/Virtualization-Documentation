---
title:      "Windows 7 and Windows Server 2008 R2 SP1 Add New Virtualization Innovations"
date:       2011-02-09 02:00:00
categories: aslr
---
Virtualization Nation,

On behalf of the Windows Server and Cloud teams at Microsoft, I’m pleased to announce that today we released Service Pack 1 for Windows Server 2008 R2 and Windows 7 – adding two new virtualization capabilities: RemoteFX and Dynamic Memory.  SP1 will be made generally available for download on February 22. To learn more about RemoteFX, take a look at [Michael’s Kleef’s](http://bit.ly/ecIxKo) blog. I’ll cover Dynamic Memory and a few other updates you’ll want to understand. 

Let’s start with Dynamic Memory. An enhancement to Hyper-V R2, Dynamic Memory pools all the memory available on a physical host. Dynamic Memory then dynamically distributes available memory, as it is needed, to virtual machines running on that host. Then with Dynamic Memory Balancing, virtual machines will be able to receive new memory allocations, based on changes in workload, without a service interruption. In short, Dynamic Memory is exactly what it’s named (I wrote a six part blog series on Dynamic Memory here: Part [1](http://blogs.technet.com/virtualization/archive/2010/03/18/dynamic-memory-coming-to-hyper-v.aspx), [2](http://blogs.technet.com/virtualization/archive/2010/03/25/dynamic-memory-coming-to-hyper-v-part-2.aspx), [3](http://blogs.technet.com/virtualization/archive/2010/04/07/dynamic-memory-coming-to-hyper-v-part-3.aspx), [4](http://blogs.technet.com/b/virtualization/archive/2010/04/21/dynamic-memory-coming-to-hyper-v-part-4.aspx), [5](http://blogs.technet.com/b/virtualization/archive/2010/05/20/dynamic-memory-coming-to-hyper-v-part-5.aspx), and [6](http://blogs.technet.com/b/virtualization/archive/2010/07/12/dynamic-memory-coming-to-hyper-v-part-6.aspx)). 

**Why is Dynamic Memory so important?**

  
High praise from the folks over at [brianmadden.com](http://www.brianmadden.com/blogs/guestbloggers/archive/2011/01/27/a-closer-look-at-the-new-quot-dynamic-memory-quot-feature-of-hyper-v-is-it-worth-it-for-vdi.aspx):

_I do think that, looking at memory management from a VDI perspective, Hyper-V fits the bill just as well as ESX does, if not better._

_Is Hyper-V Dynamic Memory any good for VDI? Definitely! I love it._

_Making the most of Dynamic Memory can really be worth your while. In fact[Microsoft has seen improvements of up to 40% (!) in density for VDI workloads](http://blogs.technet.com/b/virtualization/archive/2010/11/08/hyper-v-dynamic-memory-test-for-vdi-density.aspx)._

_With VMware it's also easier to oversubscribe the physical memory of the host (note how I didn't use the word overcommit!) and I think that's a risk in most current VDI deployments. No matter how you slice it or dice it, when RAM is oversubscribed it introduces a higher probability of paging. This in return means a huge increase in IOPS. I guess it should go without saying that this is something you should avoid at all costs in VDI environments._

Dynamic Memory takes Hyper-V to a whole new level. Dynamic Memory lets you increase virtual machine density with the resources you already have—without sacrificing performance or scalability. Ultimately it helps customers get the most bang for their technology bucks, which is a critical part of Microsoft’s virtualization and infrastructure strategy. Without that, you’ll keep pouring money into complex solutions you might not need. 

**Dynamic Memory and Virtual Desktop Infrastructure  
** Along the lines of determining what’s critical, in our lab testing, with Windows 7 SP1 as the guest operating system in a Virtual Desktop Infrastructure (VDI) scenario, we saw a [40% increase in density from Windows Server 2008 R2 RTM to SP1](http://blogs.technet.com/b/virtualization/archive/2010/11/08/hyper-v-dynamic-memory-test-for-vdi-density.aspx). We achieved this increase simply by enabling Dynamic Memory. More importantly, this increase in density didn’t require the user to make changes to the guest operating system at the expense of security, as is the case with competitive offerings.

Full stop. I want to reemphasize that last sentence.

Let me explain. In our testing of Dynamic Memory, we’ve also been reviewing VDI deployments and best practice guidance offered by VMware and others. We’ve seen some interesting ideas, but unfortunately we’ve also seen some questionable (if not terrible) suggestions such as this one that we’ve heard from a number of VMware folks: Disable Address Space Layout Randomization (ASLR).

**The Importance of ASLR  
** ASLR is a feature that makes it more difficult for malware to load system DLLs and executables at a different location every time the system boots, as a way to find out where APIs are located. Early in the boot process, the Memory Manager picks a random DLL image-load bias from one of 256 64KB-aligned addresses in the 16MB region at the top of the user-mode address space. As DLLs that have the new dynamic-relocation flag in their image header load into a process, the Memory Manager packs them into memory starting at the image-load bias address and working its way down.

ASLR is an important security protection mechanism introduced in Windows Server 2008 and Windows Vista. ASLR has helped protect customers from malware and has been further improved in Windows Server 2008 R2 and Windows 7. Best of all, you don’t need to do anything to take advantage of ASLR: It’s enabled by default, it’s transparent to the end user and it just works. In fact, [third parties agree that Windows 7](http://www.pcworld.com/businesscenter/article/182917/pros_and_cons_of_windows_7_security.html) has taken another massive leap forward:

_Sophos Senior Security Advisor Chet Wisniewski says "ASLR was massively improved in Windows 7. This means that libraries (DLL ’s) are loaded into random memory addresses each time you boot. Malware often depends on specific files being in certain memory locations and this technology helps stop buffer overflows from working properly."_

_  
_**For the record, Microsoft does not recommend disabling ASLR**. So, why would anyone recommend disabling ASLR? Read on.

**Project VRC  
** Let’s take a look at a report performed by an independent third party, [Project Virtual Reality Check (VRC). ](http://www.projectvrc.nl/)

The folks at Project VRC have developed their own test methodology and have been working in the industry to better understand the complexities of virtual desktop and remote desktop session capacity planning and deployment. In their latest tests, “Project VRC Phase III ([here](http://www.projectvrc.nl/index.php?option=com_docman&task=cat_view&gid=39&Itemid=11)),” the Project VRC team specifically tested enabling and disabling ASLR to see how it impacted VMware’s density. So what did they find?

_**Project VRC Phase III, Page 35  
** It must be noted that Project VRC does not blindly recommend disabling ASLR. This is an important security feature, and it is enabled by default since Windows Vista and Windows [Server] 2008 (Windows XP and Windows [S]erver 2003 do not support ASLR). However, with VDI workloads, the impact could be potentially larger. Every desktop session is running an individual desktop OS instance. In comparison to Terminal Services, a VDI workload runs a magnitude of OS’s more to serve desktops to end-users. Potentially the performance impact of ASLR could be larger. _

_Project VRC evaluated the impact of ASLR on a Windows 7 desktop workload (120 VM ’s pre-booted, 1GB memory, 1vCPU per VM, 2GB Page file fixed, VRC optimizations, ESX 4.0 Update 2, HIMP=100): _

![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/1616.VMware%20overcommit.jpg)  
Figure 1: VMware overcommit doesn’t work well with ASLR

_By disabling ASLR, the VSImax score was 16% higher. In comparison to the 4% increase witnessed on Terminal Services, the increase in capacity with Windows 7 VDI workloads is significantly higher. This does not come as a total surprise: the amount of VM ’s running is also significantly higher. Although it is difficult to generally recommend disabling ASLR, the impact on Windows 7 is considerable._

In short, VMware recommends disabling a fundamental security feature in Windows because their Memory Overcommit doesn’t work well with ASLR. Not a good idea. Let’s see how Hyper-V R2 SP1 Dynamic Memory fares.

**Hyper-V R2 SP1 Dynamic Memory & ASLR  
**We decided to perform _similar_ tests ( not identical so please don’t make a direct comparison with the VMware data; the hardware was different) using the same Project VRC Phase III test methodology. The point of this test was to compare running Windows 7 as a Hyper-V guest with and without ASLR enabled in the guest OS and to compare the delta of running with ASLR enabled. With VMware there was a considerable delta. What about with Hyper-V?

Here are the results:

![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0676.Figure%202.jpg)

Figure 2: Hyper-V works great with ASLR

You can see that with Hyper-V and ASLR, the results are virtually identical whether ASLR is on or off. That’s because **_Dynamic Memory was designed from the ground up to work with ASLR and other advanced memory technologies_**. You won ’t hear anyone from Microsoft suggest you turn off ASLR.

Personally, I am convinced Dynamic Memory is a big step forward. I say this because it literally changes the way I create and deploy virtual machines (VMs). I assign the VM its startup value and then I simply don’t worry any more. Dynamic Memory effectively solves the problem of “how much memory do I assign to my server?” as discussed [here](http://blogs.technet.com/b/virtualization/archive/2010/03/25/dynamic-memory-coming-to-hyper-v-part-2.aspx). The approach is both efficient and elegant.

I should also point out that Hyper-V Dynamic Memory will be available in Microsoft Hyper-V Server 2008 R2 SP1, the free download of the stand-alone hypervisor-based virtualization product.

In addition to SP1, we’ve been very busy with our virtualization technology updates and want to be sure you’re aware of the latest:

**Higher Virtual Processor to Logical Processor Ratios** : If you’re running Windows Server 2008 R2 SP1 and running Windows 7 as the guest, we’ve upped the ratio of virtual processors to logical processor from 8:1 to 12:1. This is simply more goodness for VDI deployments. This change is documented [here](http://technet.microsoft.com/en-us/library/ee405267\(WS.10\).aspx). 

**Higher Cluster Density and Limits** : Back in June 2010, the Microsoft Failover Cluster team upped the support limit to 384 virtual machines per node to match the Hyper-V maximum of up to 384 virtual machines per server. In addition, the overall number of running VMs per cluster has been bumped to 1000 VMs in a cluster. Read more [here](http://blogs.technet.com/b/puneetvig/archive/2010/07/27/hyper-v-r2-cluster-scalability.aspx). 

**[New Linux Integration Services](http://blogs.technet.com/b/virtualization/archive/2010/07/29/linux-integration-services-v2-1-now-available.aspx)** : Back in July 2010, we released new Linux Integration Services, which added support for more Linux distributions and new capabilities, including:

  * **Symmetric Multi-Processing (SMP) Support** : Supported Linux distributions can use up to 4 virtual processors (VP) per virtual machine.
  * **Synthetic devices** : Linux Integration Services supports the Hyper-V synthetic network controller and the synthetic storage controller.
  * **Fastpath Boot Support for Hyper-V** : Boot devices take advantage of the block Virtualization Service Client (VSC) to provide enhanced performance.
  * **Timesync** : The clock inside the virtual machine will remain synchronized with the clock on the host.
  * **Integrated Shutdown** : Virtual machines running Linux can be gracefully shut down from either Hyper-V Manager or System Center Virtual Machine Manager.
  * **Heartbeat** : Allows the host to detect whether the guest is running and responsive.
  * **Pluggable Time Source** : A pluggable clock source module is included to provide a more accurate time source to the guest.



And while this was happening, we’ve been powering our own tradeshows (examples: [MMS 2010](http://blogs.technet.com/b/virtualization/archive/2010/05/06/mms-2010-labs-powered-by-hyper-v-system-center-hp.aspx), [TechEd 2010](http://blogs.technet.com/b/virtualization/archive/2010/06/10/hands-on-labs-at-teched-virtualization-at-work.aspx)) with Hyper-V and System Center—with tremendous benefits.

In my next blog, I’ll discuss some points you should consider make when determining what guest OS to deploy for VDI.

Cheers,

Jeff Woolsey  
Group Program Manager, Hyper-V  
Windows Server & Cloud

=====================================================================

P.S. Here are the links with descriptions to the six part series titled Dynamic Memory Coming to Hyper-V, and an article detailing 40% greater virtual machine density with DM.

Part 1: Dynamic Memory announcement. This blog announces the new Hyper-V Dynamic Memory in Hyper-V R2 SP1. It also discusses the explicit requirements that we received from our customers. <http://blogs.technet.com/virtualization/archive/2010/03/18/dynamic-memory-coming-to-hyper-v.aspx>

Part 2: Capacity Planning from a Memory Standpoint. This blog discusses the difficulties behind the deceptively simple question, “how much memory does this workload require?” Examines what issues our customers face with regard to memory capacity planning and why. <http://blogs.technet.com/virtualization/archive/2010/03/25/dynamic-memory-coming-to-hyper-v-part-2.aspx>

Part 3: Page Sharing. A deep dive into the importance of the TLB, large memory pages, how page sharing works, SuperFetch and more. If you’re looking for the reasons why we haven’t invested in Page Sharing, this is the blog. <http://blogs.technet.com/virtualization/archive/2010/04/07/dynamic-memory-coming-to-hyper-v-part-3.aspx>

Part 4: Page Sharing Follow-Up. Questions answered about Page Sharing and ASLR and other factors to its efficacy. <http://blogs.technet.com/b/virtualization/archive/2010/04/21/dynamic-memory-coming-to-hyper-v-part-4.aspx>

Part 5: Second Level Paging. What it is, why you really want to avoid this in a virtualized environment and the performance impact it can have. <http://blogs.technet.com/b/virtualization/archive/2010/05/20/dynamic-memory-coming-to-hyper-v-part-5.aspx>

Part 6: Hyper-V Dynamic Memory. What it is, what each of the per virtual machine settings do in depth and how this all ties together with our customer requirements. <http://blogs.technet.com/b/virtualization/archive/2010/07/12/dynamic-memory-coming-to-hyper-v-part-6.aspx>

Hyper-V Dynamic Memory Density. An in depth test of Hyper-V Dynamic Memory easily achieving 40% greater density. <http://blogs.technet.com/b/virtualization/archive/2010/11/08/hyper-v-dynamic-memory-test-for-vdi-density.aspx>

 
