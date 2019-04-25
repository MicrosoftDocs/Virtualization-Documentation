---
title:      "MMS 2010 Labs&#58; Powered by Hyper-V, System Center & HP..."
date:       2010-05-06 08:32:24
categories: uncategorized
---
(Pardon the interruption on the Dynamic Memory blogs, but I was busy at MMS 2010 and needed to blog this content. I'll have more on DM soon.)

Virtualization Nation, 

We just wrapped up Microsoft Management Summit 2010 (MMS) in Las Vegas. MMS is the premier event of the year for deep technical information and training on the latest IT Management solutions from Microsoft, Partners, and Industry Experts. MMS 2010 was a huge success from a number of standpoints. Starting with sold out attendance (and attendance was way up from last year), compelling keynotes from Bob Muglia and Brad Anderson to the release of new products including:

  * [System Center Essentials 2010](http://www.microsoft.com/systemcenter/en/us/service-manager.aspx)
  * [System Center Data Protection Manager 2010](http://www.microsoft.com/systemcenter/en/us/data-protection-manager.aspx)
  * [System Center Service Manager 2010](http://www.microsoft.com/systemcenter/en/us/service-manager.aspx)



...there was something for everyone. Furthermore, many folks were very pleased to learn that [Opalis](http://www.microsoft.com/systemcenter/en/us/opalis.aspx) (our datacenter orchestration and automation platform) was joining the System Center family. Why is this a big deal? Well, for our customers who have purchased the System Center Datacenter Suite license it means that Opalis is now **_included in the System Center Suite._** That's customer focus. You can find out more about [Opalis here](http://www.microsoft.com/systemcenter/en/us/opalis.aspx).

There was a lot to experience at MMS, but I'd like to focus on something you may or may not have heard about...

**MMS 2010 Labs**

One of the most popular activities at MMS are the MMS Labs. The MMS Labs are very busy and constantly booked. These advanced, usually multi-server, labs are created and configured to walk IT professionals through a variety of tasks such as:

  * Introducing new products (Service Manager Labs were very popular this year) 
  * Exploring new product features 
  * Advanced topics, automation, best practices, tips and tricks 
  * and much more...



In past MMS events, virtualization has been used throughout in a variety of ways and to varying degrees, but this year the team decided to move to an entirely Hyper-V infrastructure. In short:

**_> >  ALL OF THE MMS 2010 LABS WERE VIRTUALIZED USING WINDOWS SERVER 2008 R2 HYPER-V AND MANAGED VIA SYSTEM CENTER  <<_**

.and the results in terms of manageability, flexibility, power usage, shipping costs and more are **staggering**. What do I means, let's start with this factoid: 

**> >  The MMS 2010 Labs delivered ~40,000 Hyper-V VMs for ~80 different labs in 5 days on just _41_ physical servers   <<**

No, that's not a typo, that's just the tip of the iceberg.

**> >  In the past for MMS, we shipped 36 RACKS,**

**~570 servers, to host MMS labs.**

**For MMS 2010, we shipped 3 RACKS.**

**Yes, 3 RACKS with 41 servers.**

**(Ok, technically, 6 half racks because they're easier to ship.** **)   <<**

So, what were these racks filled with?

**Servers**. All servers were configured identically as follows: 

  * 41 HP Proliant DL380G6 servers (Dual socket, quad-core, Nehalem Processors with SMT, 16 LPs per system) each configured with 128 GB of memory and 4 300 GB SAS drive of local storage striped (no SANs were used), These servers were simply incredible. Performance, expandability, performance. 
  * All networking was 1 Gb/E switched (no 10 Gb/E) and demonstrates the efficiency of Remote Desktop Protocol (RDP). Even with hundreds of labs going on simultaneously, network bandwidth was never an issue on 1 Gb/E 
  * Windows Server 2008 R2 Hyper-V and System Center 
  * Virtual machines were configured on average with 3-4 GB of memory each and the majority of labs used multiple VMs per lab.



The power draw on each server when fully loaded was about 200 watts. Maximum power draw for the 41 servers was 8,200 watts. If we do a broad comparison against our previous 570 servers (assuming a similar power draw) the comparison looks like this:

  * 570 servers * 200 watts per server = 114,000 watts 
  * 41 server * 200 watts per server = 8,200 watts



**> >  Power reduction of 13.9x on the servers.  <<** [![clip_image001](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image001_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image001_2.jpg) Figure 1: HP DL380G6 & Hyper-V R2 Rock Solid 

****

**Rich vs. Thin Clients**. On the client side, MMS historically uses rich clients at each station averaging about 120 watts per system. For MMS 2010, thin clients running Windows Embedded 7 (deployed using Windows Deployment Services) were used with each one averaging about 19 watts each. From a power standpoint the comparison looks like this: 

  * Rich clients: 650 clients * 120 watts per client = 78,000 watts 
  * Thin clients: 650 clients * 19 watts per client = 12,350 watts 



**> >  Power reduction of 6.3x on the clients.  <<**

**Shipping**. From a shipping standpoint, thin clients are smaller and weigh less than traditional rich clients. 

**> >  In the past for MMS, we shipped 650 rich clients for MMS labs. From a shipping standpoint this meant about 20 desktops per pallet and a total of ~32 pallets. For MMS 2010, thin clients were used and we were able to _ship 650 thin clients on 3 pallets_. ****Using thin clients instead of rich clients allowed us to use** ** _one less semi for shipping_ to MMS.   <<**

[![clip_image002](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image002_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image002_2.jpg)

That's right, one less _semi_ for shipping labs to MMS. In addition to one less truck, let's not gloss over the savings in terms of the manpower having to lift and carry 650 50 pound workstations...

**Manageability**. Before the show began, there was some initial concern that there was only 15 minutes between lab sessions and would that be enough time to reset  >400 labs (about ~1300 VMs) over 41 servers in 15 minutes? Resetting the labs means reverting the VMs to previous states based on Hyper-V virtual machine differencing disks and snapshots. The initial concern turned out to be totally unwarranted as **_resetting the full lab environment only needed 5 minutes_** giving the team a full 10 minutes to grin from ear to ear, er, I mean "diligently manage lab operations." :-) Speaking of System Center.

**System Center**. Naturally, the MMS team used System Center to manage all the labs, specifically Operations Manager, Virtual Machine Manager and Configuration Manager. 

  * Operations Manager 2007 R2 was used to monitor the health and performance of all the Hyper-V labs running Windows _& Linux_. 
  * Configuration Manager 2007 R2 was to ensure that all of the host systems were configured in a uniform, consistent manner via Desired Configuration Management (DCM) 
  * Virtual Machine Manager 2008 R2 was used to provision and manage the entire virtualized lab delivery infrastructure and monitor and report on all the virtual machines in the system. 



**Flexibility**. Finally, due to overwhelming popularity of the Service Manager labs, the MMS team wanted to add more Service Manager labs to meet the increased demand. With Hyper-V  & System Center, the team was able to easily create a few dozen more Service Manager labs to meet the demand on the fly. **In short, MMS 2010 Labs was a huge success.**

Finally, I'd like to thank our platinum sponsor, HP, for their support and the tremendous hardware.

Cheers, -Jeff 

P.S. I've included a few screenshots below. 

[![clip_image003](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image003_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image003_2.jpg)

[![clip_image004](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image004_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image004_2.jpg)      [![clip_image005](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image005_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image005_2.jpg)

**Pictures Anyone?**

Here's one of the 6 Hyper-V half racks...

[![MMS 2010 Half Rack](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image006_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image006_2.jpg)

Figure 2: Brings a tear to me eye... 

Here's a picture of all the Hyper-V hosts. Over 40,000 MMS Labs were served from 6 half racks of servers. 

[![MMS 2010 Lab Servers](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image007_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image007_2.jpg)

Figure 3: MMS 2010 Lab Servers... 

 

Operations Manager 2007 R2 Dashboard View for all of the labs. 

[![Operations Manager Monitoring](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image008_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image008_2.jpg)

 

Operations Manager 2007 R2 more detailed view providing end-to-end management; managing the hardware, the parent partition and the apps running within the guests. 

[![Ops Manager VM Monitoring](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image009_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image009_2.jpg)

[![clip_image010](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image010_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image010_2.jpg)

[![clip_image011](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image011_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image011_2.jpg)      [![clip_image012](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image012_thumb.jpg)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/229cf3cda7d3_E41A/clip_image012_2.jpg)
