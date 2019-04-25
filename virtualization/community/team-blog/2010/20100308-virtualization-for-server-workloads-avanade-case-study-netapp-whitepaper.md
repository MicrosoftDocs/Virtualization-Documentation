---
title:      "Virtualization for Server Workloads&#58; Avanade Case Study, NetApp Whitepaper"
date:       2010-03-08 15:18:00
categories: high-availability
---
Our customers often deploy Microsoft server workloads, such as SQL Server, SharePoint and Exchange, on Microsoft Hyper-V and System Center, and want to know how other customers have deployed these workloads and if there are deployment guidelines from specific solution partners that can help optimize for scale and business continuity.

A case in point is our customer [Avanade](http://www.microsoft.com/casestudies/Case_Study_Detail.aspx?CaseStudyID=4000006429). Avanade wanted to reduce their datacenter costs and turned to Microsoft Virtualization, even for their most demanding workloads. Avanade designed a series of tests to evaluate virtualization of SQL Server in production environments. In one test, Avanade was impressed to see Hyper-V support 6,000 Microsoft Dynamics CRM users on the SQL Server 2005 cluster. “We felt extremely comfortable standing behind our corporate strategy to virtualize our biggest workloads—our upgrade to Microsoft SQL Server 2008, Exchange Server 2007—all those applications people were saying just couldn’t be done,” says Andy Schneider, Infrastructure Architect at Avanade. Avanade was able to virtualize its databases and consolidate them on fewer servers ** ** connected to a 50TB storage solution from NetApp. Overall, they reduced servers by 85% and improved performance by 50%.  

Speaking of NetApp, they recently released a whitepaper ([click here](http://media.netapp.com/documents/tr-3804.pdf) for pdf) that discusses their testing with consolidation of multiple workloads: Exchange Server 2007 (2000 heavy users; 250 MB Mailbox), SharePoint 2007 (3000 users; 500MB user quota) and SQL Server 2008 (3000 users using OLTP workloads such as CRM). They used Windows Server 2008 R2 Hyper-V with its Clustered Shared Volume (CSV) technology. They used LiveMigration along with NetApp MetroCluster software for high availability and cross-site disaster recovery. In these their tests, they were able to achieve 100% up-time!  For more details, check out [their blog](http://blogs.netapp.com/msenviro/2010/03/ha_for_hv.html).

Last but not least, I would like to encourage you to join Microsoft and its solution partners at the Windows ITPro[ Business Critical Virtualization](http://www.vconferenceonline.com/shows/spring10/virtualization/?CID%20=ToolkitMSblogs) online conference on March 31st. This in-depth virtual event will provide all you need to know around the best way to virtualize Microsoft applications like SQL Server, SharePoint and Exchange on a highly resilient virtual infrastructure. You can get more information and register for the event [here](http://www.vconferenceonline.com/shows/spring10/virtualization/?CID%20=ToolkitMSblogs).

Vipul Shah  
Sr. Product Manager  
Microsoft Virtualization Marketing
