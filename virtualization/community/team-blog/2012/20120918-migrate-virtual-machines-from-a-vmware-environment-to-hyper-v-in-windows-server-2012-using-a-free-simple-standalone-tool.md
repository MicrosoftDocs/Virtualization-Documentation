---
title:      "Migrate virtual machines from a VMware environment to Hyper-V in Windows Server 2012 using a free, simple, standalone tool"
author: mattbriggs
ms.author: mabrigg
ms.date: 09/18/2012
date:       2012-09-18 20:04:00
categories: uncategorized
description: Migrate virtual machines from a VMware environment to Hyper-V in Windows Server 2012 using a free, simple, standalone tool
---
# Migrate virtual machines to the Hyper-V host in Windows Server 2012

Windows Server 2012 is generally available for evaluation and purchase by all customers around the world. Additionally, there is great news for organizations that are looking for a way to migrate virtual machines hosted on VMware vSphere to the Hyper-V host in Windows Server 2012. The production (RTW) version of the Microsoft Virtual Machine Converter (MVMC) and the Beta version of the VMware console plugin version are both available to download. We extend a huge thank you to our beta participants who have taken the time to evaluate the pre-release versions of the tools and provided us with extremely valuable feedback. MVMC is one resource available as part of the [Switch to Hyper-V program](https://blogs.technet.com/b/server-cloud/archive/2012/07/16/go-beyond-virtualization-with-the-quot-switch-to-hyper-v-quot-program.aspx) announced at Microsoft’s Worldwide Partner Conference earlier this year. The Switch to Hyper-V program helps partners and customers go beyond virtualization to true cloud computing by providing guidance, resources, and tools that take the risk out of virtual migrations, reduce the time and effort required, and define best practices.  
  
Click on the links provided below to download MVMC and the MVMC Plug-In for vSphere Client 

  * [MVMC Standalone solution (Production Release)](http://go.microsoft.com/fwlink/?LinkID=247805)
  * [MVMC Plug-In for VMware vSphere Client Beta](https://connect.microsoft.com/site14/InvitationUse.aspx?ProgramID=7594&InvitationID=MVMC-PK9Q-BR47)

In case you haven’t had a chance to evaluate the pre-release versions of these tools, MVMC provides a Microsoft-supported, freely available, standalone solution and a VMware console plugin solution. In each case, it converts VMware virtual machines (VMs) and VMware virtual disks (VMDKs) to Hyper-V virtual machines and Hyper-V virtual hard disks (VHDs). The virtual machine conversion capability can be invoked through a graphical user interface (GUI) or a command- line interface. The wizard-driven GUI has all of 5 simple screens where user input is required and you are ready to convert a virtual machine from vSphere to Hyper-V. It doesn’t get more simple than that!   
MVMC converts VMware virtual machines created with: 

  * VMware vSphere 4.1
  * VMware vSphere 5.0
  * VMware vSphere 4.0 if the host is managed by vCenter 4.1 or vCenter 5.0. You have to connect to vCenter 4.1 or 5.0 through MVMC for virtual machines on vSphere 4.0 to be converted.

  
To virtual machines for: 

  * Windows Server® 2012 Hyper-V
  * Microsoft Hyper-V Server 2012
  * Windows Server 2008 R2 SP1 Hyper-V
  * Microsoft Hyper-V Server 2008 R2 SP1

Hope you have a great experience using MVMC. 

  
Cheers,  
Microsoft Virtual Machine Converter Team 
