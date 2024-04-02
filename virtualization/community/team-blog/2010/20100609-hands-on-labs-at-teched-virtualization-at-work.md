---
title:      "Hands-On-Labs at TechEd, Virtualization at work!!!"
description: One of the fun parts of being in a team that develops Hyper-V is seeing it in action.
author: scooley
ms.author: scooley
date:       2010-06-09 16:59:06
ms.date: 06/09/2010
categories: community
---
# Hands-On-Labs at TechEd, Virtualization at work

One of the fun parts of being in a team that develops Hyper-V is seeing it in action. Here at TechEd 2010 in New Orleans, Hyper-V and the [System Center Suite](https://www.microsoft.com/system-center) are running the Hands-On-Lab infrastructure. Powering the labs for the 11,000 people here at TechEd are 25 x HP380G6’s. The detailed specs of each server is

·        HP DL 380G6

·        128 GB RAM

·        1.0 TB HDD

·        2 x Intel Xeon E5504, 2 Ghz

The attendees are accessing labs (running as virtual machines) from 350 workstations. There are a total of 192 labs running and on an average each lab takes just over 2 virtual machines. By the first day and a half of the conference, just over 1800 labs were launched leading to 3750 virtual machines being created and destroyed!!. By the way HOL11, Web Development in Microsoft Visual Studio 2010 is the most popular lab so far. 

The infrastructure workloads, all running virtual machines, includes [SQL Server 2008 SP1](https://www.microsoft.com/sql-server/sql-server-2019) for usage and performance statistics, Domain controller and [DHCP](/previous-versions/windows/it-pro/windows-server-2008-R2-and-2008/cc896553(v=ws.10)) for the lab domain, Web server for publishing the labs, [System Center Operations Manager 2007 R2](https://www.microsoft.com/download/details.aspx?id=4561) for monitoring the health of the infrastructure, System Center Configuration Manager 2007 R2 for compliance monitoring and running scripted actions and [System Center Data Protection Manager](https://www.microsoft.com/system-center) for backing up SQL and Hyper-V configurations. 

I’d encourage folks who are here at TechEd to stop by this mini datacenter in Ballroom C and chat with folks there to get more details on the setup. Below are a few pictures of the setup. Enjoy!!

<!--- ![Setup for the mini datacenter in Ballroom C](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6622.IMG_0391.JPG) --->

That's all it takes these days:). 

<!--- ![Setup for the mini datacenter in Ballroom C, part 2](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0333.IMG_0380.JPG) --->

System Center Operations Manager, reporting at work

Vijay Tewari

Principal Program Manager, Windows Server Virtualization
