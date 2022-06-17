---
title:      "Explaining Microsoft RemoteFX"
author: mattbriggs
ms.author: mabrigg
description: Explaining Microsoft RemoteFX
ms.date: 03/17/2010
date:       2010-03-17 15:38:00
categories: application-virtualization
---
# Explaining Microsoft RemoteFX

Hi, my name is Max Herrmann, and I am part of the Windows Server Remote Desktop Services marketing team at Microsoft. [Two years ago, Microsoft acquired Calista Technologies](https://blogs.technet.com/virtualization/archive/2008/01/21/Calista-joins-the-Microsoft-virtualization-product-lineup.aspx) where I came from – a startup that set out to create technology that allows remote workers to enjoy the same rich user experience over a network as with a locally executing desktop. This experience includes full-fidelity video with 100% coverage for all media types and highly-synchronized audio, rich media support including Silverlight and 3D graphics, and of course Windows Aero. Today, [Microsoft announced](https://www.microsoft.com/Presspass/press/2010/mar10/03-18DesktopVirtPR.mspx "MS news release")  during its Desktop Virtualization Hour that Microsoft RemoteFX, a platform feature being developed for Windows Server 2008 R2 SP1 will bring a rich, connected user experience to the virtual desktop market. So what is RemoteFX, and how are Calista and RemoteFX related?

 

Just to be clear, RemoteFX is not a new standalone product from Microsoft. Rather, it describes a set of RDP technologies - most prominently graphics virtualization and the use of advanced codes - that are being added to Windows Server 2008 R2 Service Pack 1; these technologies are based on the IP that Microsoft acquired and continued to develop since acquiring Calista Technologies. So think of Microsoft RemoteFX as the ‘special sauce’ in Remote Desktop Services that users will be able to enjoy when they connect to their virtual and session-based desktops and applications over the network. With Microsoft RemoteFX, users will be able to work remotely in a Windows Aero desktop environment, watch full-motion video, enjoy Silverlight animations, and run 3D applications – all with the fidelity of a local-like performance when connecting over the LAN. Their desktops are actually hosted in the data center as part of a virtual desktop infrastructure (VDI) or a session virtualization environment (formerly known as Terminal Services). With RemoteFX, these users will be able to access their workspace via a standard RDP connection from a broad range of client devices – rich PCs, thin clients and very simple, low-cost devices.

 

Also today, we announced a collaboration agreement with Citrix, which will enable Citrix to integrate and use Microsoft RemoteFX within its XenDesktop suite of products and HDX. Microsoft RemoteFX is designed to integrate with partner solutions, and we expect solutions from Citrix and other partners to enable the fidelity of a RemoteFX-accelerated user experience for a broad range of environments.

 

With SP1 just now being announced (see [Oliver's blog](https://blogs.technet.com/windowsserver/ "Oliver Rist blog on March 18")) but not available for a while, there will be many more details I will be able to share with you as we progress. This is just the beginning of an exciting time for centralized desktop computing and the benefits of the user experience enhancements that Microsoft RemoteFX will deliver for that architecture. Please stay tuned for great things to come, and check in on my blog every once in a while for the latest news. Meanwhile, I would encourage you to read up more on [today’s announcements](/windows-server/virtualization/hyper-v/deploy/deploy-graphics-devices-using-remotefx-vgpu "MS news release").

Max

 **UPDATES:** here are answers to your questions

Q: Will RemoteFx support also OpenGL hardware acceleration which is the 3D high level API used by professional applications like CAD systems or medical applications ?

A: RemoteFX will support certain OpenGL applications. However, as the development of RemoteFX is still ongoing, it is too early to provide any specifics at this point.

 

Q: Are you plan to introduce RemoteFX also for Windows 7 because their are many scenarios where the remote system is not a server but a high end workstation ?

A: RemoteFX has been designed as a Windows Server capability to support the growing demand for multi-user, media-rich centralized desktop environments. Windows 7 will be supported as a virtual guest OS under Hyper-V.

 

 **UPDATE #2**

@[mattspoon](https://blogs.technet.com/user/Profile.aspx?UserID=142267 "mattspoon"): Session virtualization, formerly known as Terminal Services, will also benefit from RemoteFX support in Windows Server 2008 R2 SP1

@[fiddley](https://blogs.technet.com/user/Profile.aspx?UserID=142298 "fiddley"): Windows 7 SP1 will have an updated RDP client to support RDP connections with RemoteFX. Unfortunately, it is too early for us to make any statements about future down level client support.

 @[someone](https://blogs.technet.com/user/Profile.aspx?UserID=9595 "someone"): With Windows Server 2008 R2 SP1, RemoteFX will support both multi-user deployment scenarios in Remote Desktop Services: VDI and session virtualization (formerly known as Terminal Services). There will be an updated RDP client for end points.

 
