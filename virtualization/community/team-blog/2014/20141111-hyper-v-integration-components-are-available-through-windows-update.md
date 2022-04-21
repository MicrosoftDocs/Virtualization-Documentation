---
title:      Hyper-V integration components are available through Windows Update
description: Learn about how the Hyper-V integration components will be delivered directly to virtual machines in a Windows update.
author: mattbriggs
ms.author: mabrigg
date:       2014-11-11 02:00:00
ms.date: 11/11/2014
categories: hyper-v
---
# Hyper-V integration components are available through Windows Update

Starting in Windows Technical Preview, Hyper-V integration components will be delivered directly to virtual machines using Windows Update.

Integration components (also called integration services) are the set of synthetic drivers which allow a virtual machine to communicate with the host operating system.  They control services ranging from time sync to guest file copy.  We've been talking to customers about integration component installation and update over the past year to discover that they are a huge pain point during the upgrade process.

Historically, all new versions of Hyper-V came with new integration components. Upgrading the Hyper-V host required upgrading the integration components in the virtual machines as well.  The new integration components were included with the Hyper-V host then they were installed in the virtual machines using vmguest.iso.  This process required restarting the virtual machine and couldn't be batched with other Windows updates.  Since the Hyper-V administrator had to offer vmguest.iso and the virtual machine administrator had to install them, integration component upgrade required the Hyper-V administrator have administrator credentials in the virtual machines -- which isn't always the case.

In Windows Technical Preview, all of that hassle goes away.  From now on, all integration components will be delivered to virtual machined through Windows Update along with other important updates.

For the first time, Hyper-V integration components (integration services) are available through Windows Update for virtual machines running on Windows Technical Preview hosts.

There are updates available today as KB3004908 for virtual machines running:

  * Windows Server 2012
  * Windows Server 2008 R2
  * Windows 8
  * Windows 7



The virtual machine must be connected to Windows Update or a WSUS server.  In the future, integration component updates will have a category ID, for this release, they are listed as Important KB3004908.

Again, these updates will only be available to virtual machines running on Windows Technical Preview hosts.

Enjoy!  
Sarah
