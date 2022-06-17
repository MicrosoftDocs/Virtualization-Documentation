---
title:      "Microsoft RemoteFX&#58; Closing the User Experience Gap"
description: Microsoft RemoteFX and how it can further help close the user experience gap between physical and virtual desktops.
author: mabriggs
ms.author: mabrigg
date:       2010-04-24 17:24:00
ms.date: 04/24/2010
categories: calista-technologies
---
# "Microsoft RemoteFX&#58; Closing the User Experience Gap"

Hi, Max Herrmann here again, from the Windows Server RDS team at Microsoft. Last month, [I blogged about Microsoft RemoteFX](https://blogs.technet.com/virtualization/archive/2010/03/17/explaining-microsoft-remotefx.aspx) – a key RDS platform capability that we will introduce with Windows Server 2008 R2 SP1 and which is designed to provide a media-rich, local-like user experience for virtual and session-based desktops and applications. The announcement of Microsoft RemoteFX created a lot of excitement in the market, especially among software and hardware [partners who are already working on value-added solutions](https://blogs.msdn.com/rds/archive/2010/03/22/partners-support-microsoft-remotefx.aspx). So why is Microsoft RemoteFX important? Because its support for full-fidelity video as well as rich media and 3D graphics helps close the gap between the user experience of a local user sitting at their physical desktop and that of a remote user connected to a virtual desktop.

Today, I want to introduce another aspect of Microsoft RemoteFX and how it can further help close the user experience gap between physical and virtual desktops: Customers looking to deploy a virtual desktop infrastructure (VDI) expect their users to be able to plug any peripheral device into their client device and have it "just work" within a virtual desktop as if it was a physical desktop. 

The situation today is that the Remote Desktop Protocol (RDP) only provides certain kinds of high-level redirection (such as printer redirection, disk drive redirection, PnP device redirection, etc). However,  due to the wide variety of device types and variances in the quality and availability of drivers, it is impossible to provide a consistent high-level device redirection solution for every device across every platform used with RDP. As a result, device-specific solutions for each type of device are necessary.

A much better solution is to redirect devices at the USB level (or to be more specific, the USB request block, or URB level). With that type of solution, which we have chosen for  VDI desktops, no device drivers are needed on the client device, and we can provide a universal interface that works with any USB device on any of our supported platforms. This solution is able to successfully redirect most of the devices users wish to use, including audio in/out devices, storage devices, HID devices (tablets, keyboards, etc.), and printers and scanners.

As with the above described rich media enhancements, [where host-side rendering with RemoteFX will be additive to existing client-side rendering in RDP](https://blogs.msdn.com/rds/archive/2010/03/26/microsoft-remotefx-the-problem-we-are-solving.aspx), RemoteFX USB redirection will also add to existing device redirection capabilities in RDP, rather than replacing them.

Whether you are one of the many customers having already successfully deployed a centralized desktop architecture with Terminal Services in the past, or you are looking to make the move to VDI or session virtualization with Remote Desktop Services in Windows Server 2008 R2 SP1, the new RemoteFX capabilities will greatly enhance the user experience for your remote users.

[As I was saying in one of my previous blogs](https://blogs.technet.com/virtualization/archive/2010/03/17/explaining-microsoft-remotefx.aspx), this is just the beginning of an exciting time for centralized desktop computing and the benefits of the user experience enhancements that Microsoft RemoteFX will be delivering. So please do check in on my blog every once in a while to find out what else is new and cool about Microsoft RemoteFX.

Max
