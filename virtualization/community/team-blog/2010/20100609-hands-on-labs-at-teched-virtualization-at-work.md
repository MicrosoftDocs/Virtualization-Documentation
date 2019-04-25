---
title:      "Hands-On-Labs at TechEd, Virtualization at work!!!"
date:       2010-06-09 16:59:06
categories: community
---
One of the fun parts of being in a team that develops Hyper-V is seeing it in action. Here at TechEd 2010 in New Orleans, Hyper-V and the [System Center Suite](http://www.microsoft.com/systemcenter/en/us/default.aspx) are running the Hands-On-Lab infrastructure. Powering the labs for the 11,000 people here at TechEd are 25 x HP380G6’s. The detailed specs of each server is

·        [HP DL 380G6](http://h10010.www1.hp.com/wwpc/us/en/sm/WF05a/15351-15351-3328412-241644-241475-3884082.html)

·        128 GB RAM

·        1.0 TB HDD

·        2 x [Intel Xeon E5504, 2 Ghz](http://ark.intel.com/Product.aspx?id=40711)

The attendees are accessing labs (running as virtual machines) from 350 workstations. There are a total of 192 labs running and on an average each lab takes just over 2 virtual machines. By the first day and a half of the conference, just over 1800 labs were launched leading to 3750 virtual machines being created and destroyed!!. By the way HOL11, Web Development in Microsoft Visual Studio 2010 is the most popular lab so far. 

The infrastructure workloads, all running virtual machines, includes [SQL Server 2008 SP1](http://www.microsoft.com/sqlserver/2008/en/us/default.aspx) for usage and performance statistics, [Domain controller](http://www.microsoft.com/windowsserver2008/en/us/ad-main.aspx) and [DHCP](http://technet.microsoft.com/en-us/library/cc896553\(WS.10\).aspx) for the lab domain, [Web server](http://www.microsoft.com/windowsserver2008/en/us/default.aspx) for publishing the labs, [System Center Operations Manager 2007 R2](http://technet.microsoft.com/en-us/systemcenter/om/dd239186.aspx) for monitoring the health of the infrastructure, System [Center Configuration Manager 2007 R2](http://technet.microsoft.com/en-us/systemcenter/cm/cc761485.aspx) for compliance monitoring and running scripted actions and [System Center Data Protection Manager](http://www.microsoft.com/systemcenter/en/us/data-protection-manager.aspx) for backing up SQL and Hyper-V configurations. 

I’d encourage folks who are here at TechEd to stop by this mini datacenter in Ballroom C and chat with folks there to get more details on the setup. Below are a few pictures of the setup. Enjoy!!

![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/6622.IMG_0391.JPG)

That's all it takes these days:). 

![](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0333.IMG_0380.JPG)

System Center Operations Manager, reporting at work

Vijay Tewari

Principal Program Manager, Windows Server Virtualization
