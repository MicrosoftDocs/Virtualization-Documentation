---
title:      "Windows Server 2008 R2 & Hyper-V Server 2008 R2 RTM!!!!"
date:       2009-07-22 16:40:00
categories: high-availability
---
Virtualization Nation,

Today is a really big day at Microsoft and more importantly for **_our customers_**. Both [Windows Server 2008 R2](http://blogs.technet.com/virtualization/archive/2009/01/16/winserver-2k8-hyper-v-is-alive.aspx) and [Microsoft Hyper-V Server 2008 R2 (our FREE standalone Hyper-V Server)](http://blogs.technet.com/virtualization/archive/2009/05/06/microsoft-hyper-v-server-2008-r2-release-candidate-free-live-migration-ha-anyone.aspx) have both been Released To Manufacturing (RTM)!! If you haven't seen the [announcement on the main Windows Server blog, be sure to check it out](http://blogs.technet.com/windowsserver/archive/2009/07/22/windows-server-2008-r2-rtm.aspx). In this blog, I'm going to focus on the **Windows Server 2008 R2 Hyper-V release** , I will follow-up with a blog on the standalone Microsoft Hyper-V Server 2008 R2 soon.

These R2 releases continue to highlight one of our core goals for Hyper-V. Simply:

**We believe everyone should have access to high performance hypervisor based virtualization. Period.**

Virtualization shouldn't only be available to the largest enterprises with the largest budgets and we're delivering on that goal. We're pleased and humbled to announce that in the first 12 months of Hyper-V R1 availability with Windows Server 2008, **_there have been over 1+ million downloads of Hyper-V R1 Gold (RTM) software, making Hyper-V the fastest growing bare metal hypervisor in x86 history._**

To our customers: Our deepest and sincerest thanks. We appreciate your support and are pleased to present Hyper-V R2 based on **_your input_**.

**Hyper-V R2: Customer Focus**

After the initial Hyper-V R1 release, we went back to our valued customers and asked them quite simply, "We have a very long list of potential features, help us prioritize. What are the features you want most?" Here's what our customers told us.

**"Keep Reducing Costs"**

Server consolidation continues to be the driving force behind virtualization and the fundamental reason is to **_reduce costs_**. In this economy, customers need to maximize their investments. [Green IT](http://www.microsoft.com/environment/our_commitment/articles/green_guide.aspx) has been important the past few years, but we've seen an even greater focus in the last year. In addition, it doesn't matter how small or how large your business is, __everyone pays a power bill__ , it's a constant cost, so anything we can do to reduce power use has an impact on everyone's bottom line.

With Hyper-V R1, we already help customers reduce their cost for power, here are a few examples: 

> _**"With virtualization, we will save about 50 percent of our annual energy budget for cooling and electricity."**_ -Lukoil CEEB 
> 
> _**"The work that Microsoft has done in these areas-particularly the ability to shift workloads across CPUs-is doing wonders for reducing our energy consumption."** _ Secure Endpoints 
> 
> _**"89% Energy Savings with Microsoft Virtualization"[-Kroll Factual Data](http://www.microsoft.com/casestudies/Case_Study_Detail.aspx?CaseStudyID=4000004036)**_

With Hyper-V R2, we continue to drive down power usage when servers are idle (usually nights and weekends) **AND now we drive down server power usage _even under load_ throughout the day through new enhancements like Core Parking, Timer Coalescing and more.**

**Bottom Line: Windows Server 2008 R2 continues to drive down power usage and lower power costs.**

**"Protect Our Investments"**

Today, the majority of servers ship with up to 16 logical processors. However, our customers watch the industry closely and point out that AMD and Intel are continuing to increase core counts quickly. In addition, Intel has reintroduced Symmetric Multi-Threading (SMT) with their Nehalem processors which doubles the thread count. As our customers plan their capital investments over the next 12-24 months, they want to make sure to invest in a virtualization platform _today_ that will take advantage of the latest hardware capabilities _tomorrow_. Hyper-V R2 is that platform. 

**CPU**. From a compute standpoint, Hyper-V R2 scales to run on systems with up 64 logical processors (up to 384 running virtual machines) and takes advantage of the latest processor enhancements such as [AMD's Rapid Virtualization Indexing (RVI)](http://blogs.amd.com/virtualization/2009/03/23/rapid-virtualization-indexing-with-windows-server-2008-r2-hyper-v/) and [Intel's Extended Page Tables (EPT).](http://blogs.technet.com/virtualization/archive/2008/10/28/Guest-Post_3A00_-Intel-Inside-for-Hyper_2D00_V-Virtualization.aspx) This provides performance improvements across the board when these processor capabilities are present. It also means that when folks decide to move up to larger servers with more counts Hyper-V R2 is ready out of the box. [No core tax here.](http://blogs.technet.com/virtualization/archive/2009/06/28/Beware-the-VMware-Core-Tax-and-More.aspx) (BTW: Let me point out that Hyper-V R2 works with RVI and EPT, but does not _require_ it. If you have older hardware without those capabilities, Hyper-V R2 will run just fine on those too.) 

**Networking**. From a networking standpoint, Hyper-V includes significant networking improvements. For 1 Gb/E networks, Hyper-V R2 now includes Jumbo Frame Support. For 10 Gb/E networks, Hyper-V R2 adds support for Chimney support and Virtual Machine Queue (VMQ). These two technologies allows Hyper-V R2 to take advantage of network offload technologies so instead of a core on the CPU processing network packets, these packets can be shunted to the offload engine on the 10 Gb NIC which helps free up processor usage and improves performance. Support for these technologies ensures the most efficient use of your server resources. For our customers who haven't made the investment in 10 Gb/E quite yet, no worries. Hyper-V R2 is ready when you are. 

**Storage**. In Hyper-V R1, we focused most of our performance efforts for storage on **fixed virtual hard disks (VHDs).** We did this primarily because fixed disks pre-allocate their storage upfront when you create the disk and help prevent a situation where you could run out of storage at a later time. Because we focused our performance efforts on fixed virtual hard disks, Hyper-V R1 performance for VMs with fixed VHDs was stellar and we recommended using fixed virtual hard disks in production environments. In fact, Hyper-V R1 can achieve as high as ~94% throughput of native. 

Because we focused on fixed VHDs in R1 and knew that would be our recommendation for production environments, we didn't spend as much time focusing on dynamically expanding virtual hard disks in R1. While customers understand our recommendation for using fixed virtual hard disks, many of them told us that they'd like to use dynamically expanding virtual hard disks because they are more efficient in terms of storage, only growing as needed. 

You got it. 

In Hyper-V R2, we spent time analyzing and optimizing the code path for dynamically expanding VHDs and found areas where we could significantly improve performance. In some cases we achieved a **15x improvement** for dynamically expanding virtual hard disks. No, that's not a typo. With dynamically expanding VHDs we can achieve up to about ~87% performance of native throughput.   While we were at it, we took another look at the fixed VHD code path and improved it further so that fixed VHD performance is now on par with native performance. 

In the end, we still recommend fixed disks for production use with Hyper-V R2 because it pre-allocates disk usage upfront, but if you want to use dynamically expanding virtual hard disks and are willing to take a small performance hit, Hyper-V R2 is a must. 

**"Help Me Find The Right Hyper-V Hardware**." Customers told us that they wanted to make sure that they were investing in "the right hardware" to use with Hyper-V. We made that easy with Hyper-V R1, but it's worth pointing out again. **There's no special certification for Hyper-V. Just make sure that the hardware you're investing in (servers, storage, etc) have the Windows Server 2008 Logo and now, the new Windows Server 2008 R2 Logo and you're set**. You can find certified hardware online at the [Windows Server Catalog](http://www.windowsservercatalog.com/default.aspx) and the logos look like this: 

![Certified for Microsoft Windows Server 2008 R2](http://www.windowsservercatalog.com/img/cfw2k8R2-62x78.gif)  ![Certified for Microsoft Windows Server 2008](http://www.windowsservercatalog.com/img/dfw2k8-62x90.gif)

**"Help Us Obtain Broader Support For Our Applications in Virtual Machines"**

One customer pain point we hear in the virtualization world is that "ISV X" doesn't support their application in a virtual machine. This impedes adoption and frustrates customers who see the tremendous benefits virtualization provides. We've heard this repeatedly from our valued customers who are trying to convince our ISV partners that virtualization adoption is only rising. As a company, we've been consistently messaging how important virtualization is to our customers and demonstrating that through our significant investments in all areas of virtualization whether it's Hyper-V, App-V, MED-V, Virtualized Desktops, Remote Desktop Services etc. 

In response to rapid customer adoption of Hyper-V and the customer requirement that virtualization be treated as the standard way to deploy workloads, not the exception, the Windows Server 2008 R2 Logo program now reflects that customer requirement. 

**_Specifically, for applications to receive the Windows Server 2008 R2 Logo, all applications must be tested and pass the Logo tests when running within virtual machine running on Microsoft Hyper-V._**

**_(_** _Note: If an application cannot be tested in this configuration ISVs must work with a Microsoft approved testing vendor to learn about alternate test paths. For example, an application needs access to a specific hardware device not present in a virtual machine.)_

**"Continue to Improve Interoperability"**

Today, we currently distribute Linux Integration Components (ICs) for SUSE Linux Enterprise Server (SLES) 10 SP2 x86 & x64 which improves performance when run within a Hyper-V VM. While our customers appreciate SLES support, they have also requested support for Red Hat as a guest OS. So, with the Windows Server 2008 R2 release of the ICs, we're adding support for both SLES 11 and Red Hat Enterprise Linux (RHEL) 5.2 and 5.3 for both x86 and x64. 

While SLES and RHEL are the two most requested Linux distros supported within Hyper-V by far, we get requests now and then for other community supported distributions. 

We wanted to do more. 

Thus, [the big Monday announcement](http://www.microsoft.com/presspass/features/2009/Jul09/07-20LinuxQA.mspx). In case you missed it, on Monday, _we released 20,000 lines of device driver code to the Linux community under GPLv2_. The code, which includes three Linux device drivers, has been submitted to the Linux kernel community for inclusion in the Linux tree. The drivers will be available to the Linux community and customers alike, and will enhance the performance of the Linux operating system when virtualized on Hyper-V R1/Hyper-V R2. 

I've read numerous articles and blogs on the Linux IC GPL announcement (most using phrases like "pigs with wings" or "hell experiencing snow flurries") and while there has been some interesting conjecture out there, let me be clear: Microsoft is committed to interoperability and providing our customers the solutions that meet their needs. Releasing these device drivers for Linux is another example of that commitment. 

**"Increase Flexibility"**

**Live Migration**. Customers appreciate the flexibility that virtualization provides (deploy virtualized workloads in a fraction of the time versus physical) and wanted us to continue to improve in this area. To that end, the number #1 customer requested feature was Live Migration. 

Done. Included. **_[Live Migration Built-In](http://blogs.technet.com/virtualization/archive/2009/05/06/microsoft-hyper-v-server-2008-r2-release-candidate-free-live-migration-ha-anyone.aspx)_**.

We weren't done there. One thing that customers would always follow-up with is, "Do the processors have to be _exactly the same?_ Can you ease that restriction a little?" 

You got it. 

**Processor Compatibility Mode**. With Hyper-V R2's new processor compatibility mode, we're able to easily LIVE MIGRATE between four different generations of Intel hardware. From an Intel Pentium 4 VT circa 2005 to an Intel Core i7 circa 2009.

![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/TechEdWindowsServer2008R2ShippingfortheH_146F6/image_2.png)

Just by checking a checkbox: 

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/WindowsServer2008R2HyperVRTM_926B/image_thumb_1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/WindowsServer2008R2HyperVRTM_926B/image_4.png)

That's flexibility. You can also move virtual machines between different generations of AMD processors as well. Just so we're clear: Processor Compatibility still means AMD<->AMD and Intel<->Intel. It does **not** mean you can Live Migrate between different processor vendors AMD <->Intel or vice versa. For more info about processor compatibility mode, check out my earlier blog post [here](http://blogs.technet.com/virtualization/archive/2009/05/12/tech-ed-windows-server-2008-r2-hyper-v-news.aspx). 

**Dynamic Storage**. Another request to increase flexibility from our customers was to be able to hot add/remove virtual storage. Think about it, you're running a virtualized SQL server or file server and you need additional storage, but don't want to bring down the VM. No problem, with Hyper-V R2 you can hot add/remove storage while the VM is running __without downtime__. 

**"Virtualized Desktops"**

One area of interest that's been percolating the last few years is the concept of Virtualized Desktops. At a high level, virtualized desktops is the concept of using a virtualization server to serve virtual machines running client operating systems like Windows XP or Vista. There are a few reasons customers are interested in this model such as to centralize management operations or to securely manage IP for remote developers. This model is very much like using Remote Desktop Services (formerly Terminal Services), except instead of Remote Desktop sessions, users are provisioned virtual machines. 

From a Hyper-V standpoint, we've supported Windows XP and Vista as Hyper-V guests since the R1 release and with Hyper-V R2 we've added support for Windows 7 (x86 & x64 with up to 4 virtual processors per VM). However, Hyper-V support for client operating systems is only one piece of the puzzle. To improve this experience for our customers, the Remote Desktop Services team made significant enhancements in Windows Server 2008 R2 such as. 

**Connection Broker**. Windows Server 2008 R2 includes a Connection Broker so that when a user logs in they can be brokered to their appropriate Virtual Machine **OR** Remote Desktop session on the back end. Yes, that's right. The Windows Server 2008 R2 broker actually brokers **_both Virtual Machines and Remote Desktops_**! This provides customers the flexibility to choose the solution based on their business requirements as opposed to being shoehorned into one technology.

**RDP Protocol Enhancements**. Windows Server 2008 R2 includes major enhancements for the Remote Desktop Protocol (RDP) that greatly improve the user experience such as: 

  1. Multi-monitor support 
  2. Bi-directional audio support (VoIP anyone?) 
  3. Aero Glass Support 
  4. Enhanced Bitmap Acceleration



Read that again. That's huge.

One big reason is that in the past, RDP was more focused on lower bandwidth connections. Customers have since told us they're willing to use more network bandwidth to provide a richer, greater fidelity user experience.

How good is the remoting? I recently tested the new RDP enhancements by doing the following. I used my **three year old laptop** running Windows 7 RTM and the built-in Remote Desktop Connection client. I went to the Experience tab and set Performance for WAN settings.

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/WindowsServer2008R2HyperVRTM_926B/image_thumb_3.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/WindowsServer2008R2HyperVRTM_926B/image_8.png)

I then remoted into a virtual machine running Windows 7 (the VM was allocated 1 GB of memory) and then fired up _**three videos running within the VM simultaneously.** _ Specifically ** _,_**

  * a TV show streaming over the Internet using the Hulu desktop application (the show was “The Greatest Generation” by Tom Brokaw. Highly recommended.) 
  * a large resolution QuickTime movie preview also streaming 
  * an online Silverlight demo



Here's a screenshot from my laptop running the Window 7 inbox RDP client and this all just worked using my little old 1 Gb/E switch.

**These RDP enhancements are big folks. Really big**.

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/WindowsServer2008R2HyperVRTM_926B/image_thumb_2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/WindowsServer2008R2HyperVRTM_926B/image_6.png) 

**_Windows Server 2008 R2 Hyper-V_**

With our customers input first and foremost, we developed Hyper-V R2 to meet their requirements.

**Live Migration **![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/WindowsServer2008R2HyperVRTM_926B/image_thumb.png)****

  * #1 Customer Requested Feature 
  * [Processor Compatibility Mode](http://blogs.technet.com/virtualization/archive/2009/05/12/tech-ed-windows-server-2008-r2-hyper-v-news.aspx)



**New Processor Support**

  * Improved Performance 
  * Lower Power Costs



**[Enhanced Scalability (4x Improvement)](http://blogs.technet.com/virtualization/archive/2009/05/12/tech-ed-windows-server-2008-r2-hyper-v-news.aspx)**

  * [Support for 64 Logical Processors](http://blogs.technet.com/virtualization/archive/2009/05/12/tech-ed-windows-server-2008-r2-hyper-v-news.aspx)
  * Support for up to 384 Running VMs or up to 512 virtual processors 
  * Greater VM Density 
  * Lower TCO



**Networking Enhancements**

  * Improved Network Performance 
  * 10 Gb/E Ready



**Dynamic Virtual Machine Capabilities**

  * Live Migration 
  * Hot Add/Remove Virtual Storage



  **Usability Enhancements**

  * [SCONFIG for Server Core](http://blogs.technet.com/virtualization/archive/2009/07/07/windows-server-2008-r2-core-introducing-sconfig.aspx)



In short, Windows Server 2008 R2 Hyper-V delivers more of everything:

  * Capabilities 
  * Efficiency 
  * Performance 
  * Scalability 
  * Flexibility 
  * Ease of use



**_Windows Server 2008 R2: Customers Win_**

Ultimately, Windows Server 2008 R2 delivers the richest overall platform by offering:

  * Hyper-V 
  * Remote Desktop Services 
  * Rich RDP enhancements 
  * Powerful Hardware and Scaling Capabilities 
  * Reduced Power Consumption 
  * Connection Broker for a Virtual Desktop Infrastructure (VDI) 
  * Ubiquitous Remote Access 
  * Improved Branch Office Performance and Management 
  * Simplified Management for SMBs 
  * Remote Application and Desktop Access 



and its numerous roles such as:

  * Active Directory 
  * Application Server 
  * DHCP 
  * DNS 
  * Fax 
  * File 
  * Network Policy & Access Services 
  * Print 
  * and many more



In the end, Windows Server 2008 R2 delivers in spades and ultimately, our customers win.

Cheers,

_Jeff Woolsey_

_Principal Group Program Manager_

_Windows Server, Hyper-V_

_Correction: I had a comment stating that VMware View only brokered VMs which was not correct and have since removed it.  VMware View does, in fact, broker both VMs and Remote Desktop sessions. -JW_
