---
title: Windows Server 2008 RC0/Virtualization CTP FAQ
description: post id 3863
keywords: virtualization, blog
author: scooley
ms.author: scooley
ms.date: 9/28/2007
ms.topic: article
ms.assetid: dbee1926-1204-4513-9961-9918d12edea0
---

# Windows Server 2008 RC0/Virtualization CTP FAQ

Greeting folks, Jeff Woolsey here from the Virtualization team.

It’s been a busy week at Microsoft and the Windows Server 2008 RC0 release is off to a great start! If you haven’t downloaded it yet, you can find it [here](https://www.microsoft.com/windowsserver2008/audsel.mspx) In addition to all of the new Windows Server 2008 capabilities (Server Core, Read-Only Domain Controllers, IIS 7.0, Network Access Protection, Terminal Services RemoteApp for starters), Windows Server virtualization (aka Viridian) is getting just a wee bit of notice too :-).

In fact, check out what eWeek has to say.  With so many people trying out Windows Server 2008 RC0 and the Virtualization technical preview, my inbox is overflowing from customers all over the world with overwhelmingly positive feedback and questions. (BTW: Hello to folks I’ve communicated this week from Germany, Japan, South Africa and Brazil… :-)) So, I wanted to answer some of the top questions with my own FAQ.

Cheers,  
Jeff

## Windows Server Virtualization Preview FAQ

Q: Where are the Release Notes and the Microsoft Step-by-Step Installation Guide for the Windows Server Virtualization Preview?

A: Here you go!  [Release notes](https://www.microsoft.com/download/) and a Step-by-Step Installation Guide.

--------------------------------------------------------------------------------------------------------------

Q: Can I install Windows Server 2008 with a Server Core installation and enable the virtualization role?

A: The Windows Server Virtualization Preview only runs with a Full Installation of Windows Server 2008 RC0 at this time.

--------------------------------------------------------------------------------------------------------------

Q: Can I install a Server Core Installation of Windows Server 2008 _within_ a virtual machine?

A: Absolutely, works great!

--------------------------------------------------------------------------------------------------------------

Q: Can you install the Integration Components on a Server Core installation of Windows Server 2008?

A: Yes, you can, but since there ’s no GUI, you must do it from the command line. Here are the steps:

  1. Start the virtual machine and log in with administrative privileges.
  2. Go to the Action menu (on the VM connection window) and select **Insert Integration Services Setup Disk.**
  3. From the Command Prompt within the virtual machine, type the following:
     1. For x64 guests type: **cd D:supportamd64setup.exe**
     2. For x86 guests type: **cd D:supportx86setup.exe**
  4. Now just proceed through setup.

--------------------------------------------------------------------------------------------------------------

Q: I just installed Windows Server 2003/2008 RC0 x64 Editions within a virtual machine, but the drivers for the virtual network adapter aren’t found. What’s the solution?

A: You need to install the Windows Server virtualization Integration Components.

  1. Start the virtual machine and log in with administrative privileges.
  2. Go to the Action menu (on the VM connection window) and select **Insert Integration Services Setup Disk.**
  3. Proceed through **Setup**.

--------------------------------------------------------------------------------------------------------------

Q: I just installed Windows XP and/or Vista in a virtual machine. I ’m trying to install the Integration Components, but I receive an error that the virtualization guest components are only supported on Windows Server 2003 and Windows Server 2008.

A: For the Windows Server virtualization Technology Preview release, Integration Components are only provided for the following operating systems:

  1. Window Server 2003 (x86)
  2. Windows Server 2003 (x64)
  3. Window Server 2008 (x86)
  4. Windows Server 2008 (x64)

--------------------------------------------------------------------------------------------------------------

Q: What’s the difference between the "**Network Adapter**" and the "**Legacy Network Adapter**"?

A: The "**Network Adapter**" is Microsoft’s new synthetic network adapter. This is a high performance, purely synthetic device. The driver for this synthetic device is included with the Integration Components.

The "**Legacy Network Adapter**" is a network adapter that _emulates_ the DEC/Intel 21140 Ethernet adapter and is provided for legacy guest OS support.

--------------------------------------------------------------------------------------------------------------

Q: I’ve downloaded an international version of Windows Server 2008 RC0 (e.g., French, German, Spanish, Italian, Japanese) and when I try and run the .MSU files to enable the Windows Server virtualization role I receive the following error: "This update does not apply to your system."  
Is there a solution?

A: The Windows Server Virtualization Preview only runs with English Windows Server 2008 RC0 at this time.

--------------------------------------------------------------------------------------------------------------

Q: I’m attempting to install Novell Suse Linux 10 and I receive the following error: "Kernel panic – not syncing: IO-APIC + time doesn’t work.  Try booting with the ‘noapic’ option."

A: This is a known issue at this time.

--------------------------------------------------------------------------------------------------------------

Q: Are Integration Components available for Linux?

A: Not at this time.

--------------------------------------------------------------------------------------------------------------

[Original post](https://blogs.technet.microsoft.com/virtualization/2007/09/28/windows-server-2008-rc0virtualization-ctp-faq/)