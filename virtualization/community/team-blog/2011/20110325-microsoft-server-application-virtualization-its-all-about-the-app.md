---
layout:     post
title:      "Microsoft Server Application Virtualization – It’s all about the App"
date:       2011-03-25 03:47:00
categories: server-app-v
---
At MMS 2011 this week, Brad Anderson, Corporate Vice President, Management and Security Division, talked about how, with private cloud computing, it is all about application. One of the associated product announcements was the release of System Center Virtual Machine Manager 2012 Beta. One of the features of this beta release is Microsoft Server Application Virtualization. Server Application Virtualization (or Server App-V for short) allows you to separate the application configuration and state from the underlying operating system.   
Server App-V packages server applications into “XCopyable” images, which can then be easily and efficiently deployed and started using Virtual Machine Manager without an installation process. This can all be accomplished without requiring changes to the application code, thus mitigating the need for you to rewrite or re-architect the application. This virtualization process separates the application and its associated state from the operating system thereby offering a simplified approach to application deployment and servicing.   
By virtualizing your on-premises applications with Server App-V, you will be able to decrease the complexity of application and OS updates and deployment.  This capability is delivered through System Center Virtual Machine Manager 2012 Beta enabling private cloud computing. By abstracting the application from the operating system, an organization will have fewer application and OS images to maintain, thereby reducing the associated administrative effort and expense. On deployment, we will dynamically compose the application using the Server App-V package, the OS and hardware profiles, and the Virtual Hard Disk (VHD). You will no longer need to maintain VM Templates for every application you will deploy.   
By now, it should be easy to see why Microsoft believes Server App-V is a core technology for the next generation of our datacenter and cloud management capabilities, and is central to the “service centric” approach to management that will be enabled with the System Center 2012 releases.   
Back in December 2010, we also announced a [private CTP (Community Technology Preview) of Server Application Virtualization targeted at delivering application virtualization](http://blogs.technet.com/b/systemcenter/archive/2010/12/22/microsoft-server-application-virtualization-ctp-released-run-more-of-your-applications-on-windows-azure.aspx) capabilities on Windows Azure.  This (along with the Windows Azure VM role) offers an opportunity to move some existing applications to Windows Azure.  Specifically for Server App-V this means packaging an existing application and running it directly on the Windows Azure worker role. This capability is not part of the System Center Virtual Machine Manager 2012 Beta and to reiterate is available today only in a private CTP.   
**Which applications can Server Application Virtualization virtualize as part of System Center 2012?** Microsoft is prioritizing business applications such as ERP applications. As with Microsoft Application Virtualization for the desktop there is not a list of applications that Server Application Virtualization will support.   However, there are a number of architectural attributes that the initial release of this technology has been optimized for. These attributes include: 

  * State persisted to local disk
  * Windows Services
  * IIS Applications
  * Registry
  * COM+/DCOM
  * Text-based Configuration Files
  * WMI Providers
  * SQL Server Reporting Services
  * Local users and groups
  * Java

Applications that do not have these attributes may be supported in later versions. The following applications or architectural attributes will not be supported in V1: 
  * Virtualization of Windows core component (IIS, DHCP, DNS, etc).
  * J2EE Application Servers
  * SQL Server
  * Exchange Server

So, today, we encourage you to download the [System Center Virtual Machine Manager 2012 Beta](http://www.microsoft.com/systemcenter/vmm2012) and give Server Application Virtualization a try against your existing applications!  We look forward to your feedback. 

 
