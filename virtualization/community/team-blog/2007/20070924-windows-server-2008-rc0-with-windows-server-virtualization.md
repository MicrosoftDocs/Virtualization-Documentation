---
title: Windows server 2008 rc0 with windows server virtualization
description: post id 3873
keywords: virtualization, virtual server, blog
author: scooley
ms.author: scooley
ms.date: 9/24/2007
ms.topic: article
ms.prod: virtualization
ms.assetid: a7aa4cca-133e-4159-8b63-9a56dcd388bb
---

# Windows server 2008 rc0 with windows server virtualization

Greeting Folks,

Jeff Woolsey here from the Microsoft Virtualization Team. It’s a great week here at Microsoft and there’s a lot going on.

First, I HAVE to mention **Halo 3**. :-) Every review I ’ve read as been extremely positive and it looks like the Halo team knocked one out of the park, _AGAIN._ Congratulations to them all! Over here in Server, we have a release of our own, none other than **Windows Server 2008 RC0**. RC0 is a big release because it means we're entering the home stretch for Windows Server 2008 and because it includes the first technology preview of our new hypervisor based virtualization technology, Windows Server virtualization (WSV).

The announcement is [here](https://www.microsoft.com/presspass/features/2007/sep07/09-24windowserverrc0.mspx) and the Windows Server 2008 RC0 download is [here](https://www.microsoft.com/windowsserver2008/audsel.mspx)

With the announcement that the Windows Server 2008 and the Technology Preview is available, I’ve already received an inbox full of email from folks asking how they can try it out. I’ll send a pointer to the official release notes and the step-by-step setup guide shortly, but I want to get the word out so I’ve written up my own abridged version.  This is my own quick setup guide and isn’t a replacement for the Release Notes and official Window Server Virtualization Step-by-Step Setup Guide.  Finally, as excited as everyone is about this release, please remember that this is Technology Preview and is not recommended for production use.

Cheers,  
Jeff

****

**_WSV Customer Technology Preview (CTP) Setup Guide_** **System Requirements:**

* Windows Server virtualization **requires** an x64-based processor, hardware-assisted virtualization (AMD-V or Intel VT), and hardware data execution protection.
* Ensure your BIOS is up-to-date and has:
  * Hardware Assisted Virtualization is **enabled in the BIOS**
  * Data Execution Prevention **enabled in the BIOS**
    * No Execute (NX) bit on AMD systems
    * Execute Disable (XD) bit on Intel systems

> NOTE: If any of these features were disabled in the BIOS, be sure to _POWER OFF the system_ (not just reboot) to ensure they are properly enabled.

**High Level Setup:**

1. Install a **Full Installation of Windows Server 2008 Enterprise x64 Edition**.
   1. WSV is also included with Windows Server 2008 Standard and Datacenter Editions; however, the majority of our testing has been on Enterprise Edition at this time so we recommend using the Enterprise Edition.
   2. Currently, WSV doesn’t work with Server Core installation, but will work with Server Core in a future release.
2. Go to the following folder on the disk: **~:Windowswsv**
3. You will see two .MSU files: **Windows6.0-KB939853-x64** and **Windows6.0-KB939854-x64**.
    1. Double click on **Windows6.0-KB939853-x64.msu** and proceed through the installation process.
    2. Double click on **Windows6.0-KB939854-x64.msu** and proceed through the installation process.
4. Go to the Start menu and launch **Server Manager**.
5. Go to the Roles Summary and click **Add Roles.**
6. Proceed through the wizard and select to install **Windows Server virtualization.**
7. Complete the wizard and **RESTART** when prompted.
8. After the restart, installation will continue and complete.
9. When installation is complete, you can now go to: Start Menu-->Administration Tools and launch the **Windows Virtualization Management** MMC Console. From the MMC, you can now create virtual machines!

> NOTE: It is CRITICIAL that you perform steps 2 & 3, otherwise the option to install the Windows Server virtualization role won’t be available in the Role Manager.

[Original post](https://blogs.technet.microsoft.com/virtualization/2007/09/24/windows-server-2008-rc0-with-windows-server-virtualization/)