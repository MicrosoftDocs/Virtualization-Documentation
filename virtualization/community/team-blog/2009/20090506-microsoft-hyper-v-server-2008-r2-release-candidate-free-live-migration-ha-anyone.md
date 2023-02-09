---
title: "Microsoft Hyper-V Server 2008 R2 Release Candidate! (Free Live Migration/HA Anyone?)"
description: The Virtualization team is pleased to announce the availability of the Microsoft Hyper-V Server 2008 R2 Release Candidate for download.
author: scooley
ms.author: scooley
date:       2009-05-06 03:07:00
ms.date: 05/06/2009
categories: uncategorized
---
# Microsoft Hyper-V Server 2008 R2 Release Candidate

Virtualization Nation, The Virtualization team is pleased to announce the availability of the **Microsoft Hyper-V Server 2008 R2 Release Candidate** for download. Hyper-V Server 2008 R2, our free standalone hypervisor, represents our continued commitment to providing high performance, hypervisor based virtualization for everyone, especially small and mid-market customers. This release underscores our customer focus by adding key new capabilities such as Live Migration and High Availability (and more.). **_Free Live Migration and High Availability? Really?_** A couple weeks ago, Zane Adam first [blogged](https://techcommunity.microsoft.com/t5/virtualization/live-migration-and-host-clustering-available-at-no-charge-in/ba-p/381567) the news that Hyper-V Server 2008 R2 would include Live Migration and High Availability at no charge. The response from our customers was "AWESOME!! When is the final release?" :-) Understandably, the phone's been ringing off the hook, my inbox has been on overdrive and some folks in the blogosphere have been trying to imply <cough, cough, FUD> that there are some strings attached. So, I wanted to take a moment to provide more details about the upcoming Hyper-V Server 2008 R2 release and free Live Migration & High Availability. **_Hyper-V Server 2008 R2 Availability_** When Hyper-V Server 2008 R2 goes gold and is released to manufacturing (RTM) the bits will be available as a free download. Hyper-V Server 2008 R2 will be available worldwide in 11 languages. _**Microsoft Hyper-V Server 2008 R2 includes Live Migration and High Availability**. **Period**. **No Strings Attached**._ Live Migration is a great solution for planned downtime such as servicing the underlying hardware like adding more memory, storage or applying a BIOS update. Simply Live Migrate the virtual machines to another server (without downtime) shutdown the physical server and perform the maintenance. When the maintenance is complete, Live Migrate the virtual machines back and your done. High Availability is a great solution for unplanned downtime. For example, suppose someone accidentally unplugs the wrong power cable on a server. The virtual machine on the server that just unexpectedly went down will automatically restart on another node without _any user intervention_. Hyper-V Server 2008 R2 includes both these capabilities as well as our new Cluster Shared Volumes (CSV) capabilities to simplify storage management and run multiple virtual machines from a single LUN. **_Managing Hyper-V Server 2008 R2_** Hyper-V Server 2008 R2 Live Migration and High Availability can be managed in a few different ways: 

  1. Failover Cluster Manager/Hyper-V Manager from a Windows Server 2008 R2 Server OR, 
  2. System Center Virtual Machine Manager 2008 R2 OR,
  3. Using the [FREELY (there's that word again) available Failover Cluster Manager/Hyper-V Manager for Windows 7](https://www.microsoft.com/download/).

So, as you can see, there are a few different options depending on your needs and option three **gives you Live Migration and High Availability at zero cost**. BTW: If you decide to go with option #2 System Center Virtual Machine Manager 2008 R2, you certainly can do a lot more such as: 

  * Heterogeneous Virtualization Management 
  * Rich PowerShell Support for Datacenter Automation 
  * Maintenance mode 
  * Virtual Machine Library Support 
  * Templates, Clones, Sysprep Integration 
  * Performance Resource Optimization (PRO)

.and a lot, lot more. But, I digress. **_$$$ Comparison_** Let's take a look at a few cluster configurations and compare costs for Live Migration and High Availability functionality.    | 

**Hyper-V Server 2008 R2**

| 

**VMware vSphere**  
  
---|---|---  
  
3 Node Cluster; 2 Socket Servers

| 

Free

| 

$13,470  
  
3 Node Cluster; 4 Socket Servers

| 

Free

| 

$26,940  
  
5 Node Cluster; 2 Socket Servers

| 

Free

| 

$22,450  
  
5 Node Cluster; 4 Socket Servers

| 

Free

| 

$44,900  
  
You may be wondering, "Did he choose the most expensive VMware configuration?" On the contrary, I chose the _least expensive_ _configuration ($2245 per processor)_ that offers both Live Migration and High Availability. You may be wondering, "Why isn't System Center management represented here?" In this example, I simply wanted to compare the lowest cost for Live Migration and High Availability functionality from Microsoft and VMware with some real world configurations that a small/medium business may use. I will post a follow-up blog that adds management for small/medium businesses. As for enterprise customers, they typically have larger server farms with more sophisticated management requirements. That's another blog for another time. You may also be wondering, "Why isn't the cost of guest operating systems included here?" Simple, neither Microsoft Hyper-V Server 2008 R2 nor VMware include any guest operating system licenses so if you need to run 4 copies of Windows Server, you need to purchase the appropriate license. That cost is the same whether you're running Hyper-V Server 2008 R2 or VMware so I didn't bother to include it. While VMware claims to be more affordable the facts are clear and the value of Microsoft Hyper-V Server 2008 R2 is undeniable. Microsoft offers exceptional value especially for small and mid-market customers who have told us for years how they would like Live Migration/High Availability functionality and simply can't afford it. Those days are over. At this point you may be thinking we're _crazy_ to provide virtualization live migration and high availability at no cost. Well, I wish we could say we were first, but the folks at Xen have been providing free Live Migration and HA for a few months. In fact, the only one still charging for Live Migration and High Availability ($2245+ per socket) is VMware. Now that's crazy. _Jeff Woolsey_ _Principal Group Program Manager_

_Windows Server, Hyper-V_
