---
title:      "Microsoft’s new VDI licensing&#58; VDI Suites"
author: mattbriggs
ms.author: mabrigg
ms.date: 07/13/2009
description: Learn about VDI suites.
date:       2009-07-13 17:48:00
categories: application-virtualization
---
# Microsoft's new VDI licensing; VDI Suites


Hi, my name is [Manlio Vecchiet,](https://blogs.technet.com/windowsserver/archive/2008/10/30/TechEd-EMEA_3A00_-Terminal-Services-renamed-Remote-Desktop-Services.aspx) and I am a director of product management on the Windows Server marketing team.  I'm in New Orleans right now attending the [Microsoft Worldwide Partner Conference (WPC)](https://partner.microsoft.com/global/40018508?wt.mc_id=econpdsrchmsn&wt.srch=1), and wanted to update you on new licenses we’ll offer for hosted virtual desktops, or virtual desktop infrastructure (VDI).

When deciding whether to implement or even pilot VDI, most customers look for technical integration of the key VDI building blocks: 

·         the hypervisor, 

·         management of the virtual machines and the (physical) VDI host, 

·         a brokering and remoting infrastructure, and

·         an application delivery technology for dynamic provisioning of applications to virtual desktops. 

But customers also look for a simple and cost-effective way to license this scenario, as they will compare the technical and business benefits of VDI with more traditional desktop deployment options, such as session-based desktops and rich clients. Today we introduced [two new licenses for VDI](https://www.microsoft.com/virtualization/products/desktop/default.mspx "MS.com product site") – the **Microsoft Virtual Desktop Infrastructure Standard Suite** and the **Microsoft Virtual Desktop Infrastructure Premium Suite**. These licenses make it  simple for customers to purchase the comprehensive Microsoft VDI technologies while providing excellent value compared with competing VDI offerings. The new VDI suite licenses will be available via Microsoft volume licensing in calendar Q4. 

This is a pretty big deal, so let me explain what we mean by comprehensive, simple and excellent value. First, both new offerings include licenses for all the **** key technology components mentioned above when used in a VDI scenario: Hyper-V Server, System Center Virtual Machine Manager, System Center Configuration Manager, System Center Operations Manager, Remote Desktop Services (CAL) and MDOP. The Premium VDI Suite even includes additional use rights for Remote Desktop Services (RDS) as well as App-V for RDS, to enable mixed environments with not only VM-based remote desktops, but also session-based desktops and applications. With these two new offerings, the only additional license you will need to correctly license a VDI environment from Microsoft is Virtual Enterprise Centralized Desktop or VECD (you will need VECD even to deploy VDI on a non-Microsoft platform)

By now, you are probably wondering how the licensing of these new VDI Suites will work given their standalone components have very different license schemes. The two new VDI Suites are designed to match the VECD license (which is a device subscription), so the math has become very simple now: As with VECD, the number of VDI Suite licenses equals the total number of client devices that accesses the VDI environment. The subscription-based license will ensure that customers always have access to the latest versions of the software.

But now comes actually the best part. At only $21 per year per device, the VDI Standard Suite is about one-third the cost **** of a corresponding VMware View edition (the comparison is based on the cost of licenses and software maintenance over a five-year period, which many customers tell me that’s what they base their desktop infrastructure investments on). Similarly, our VDI Premium Suite is about half the price of the premier VMware VDI offering, and it also offers the capability to deploy session-based desktops and applications, in addition to VM-based desktops. And for those customers who are still missing a feature or need an enterprise-ready solution, you can add a 3rd party connection broker for Hyper-V such as Citrix XenDesktop - and most likely still pay less than if you chose to deploy VMware. In fact, Citrix today [announced](http://www.citrix.com/English/NE/news/news.asp?newsID=1855682) continued alliance in the area of desktop virtualization. 

If you would like to see a demo of Microsoft VDI solution running on Windows Server 2008 R2, please come to the Microsoft booth at WPC if you’re attending the conference.  For all others, please post your comments in the section below.

Manlio

**UPDATE** : to answer morriswj's question. I'm excited, too, about this new single licensing for VDI’s server infrastructure, which will complement VECD for a VDI deployment. Regarding High Availability, it is included in [MS Hyper-V Server 2008 R2](https://www.microsoft.com/hyper-v-server/en/us/r2.aspx "MS Hyper-V Server 2008 R2 download") (the no-cost, standalone hypervisor) and will therefore be available as part of the VDI Suite offering. No other license other than VDI Suite (Standard or Premium) and VECD will be required for a highly available VDI deployment.

**UPDATE 2** : I'm responding to the question from cstalhood, and the similar question in Brian Madden's post today. For session virtualization using WS08 R2 Remote Desktop Services (RDS), you don’t need the VECD license. The Premium VDI Suite license includes full rights of the RDS CAL, in addition to the other components for a VDI solution. The Premium VDI Suite license, when available in Q4, will be available as a device subscription, while RDS CAL (the new name for TS CAL) is available as a perpetual user _or_ device license. After all, some customers don ’t want to buy on a subscription basis. 
