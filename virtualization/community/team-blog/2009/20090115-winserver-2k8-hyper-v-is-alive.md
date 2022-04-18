---
title:      "WinServer 2K8 Hyper-V is alive"
description: This release of WinServer 2K8 Hyper-V, there are a tremendous number of new features and capabilities.
author: scooley
ms.author: scooley
date:       2009-01-15 19:02:00
ms.date: 01/15/2009
categories: hyper-v
---
# WinServer 2K8 Hyper-V is alive

Fellow Virtualization Fans,

Bryon Surace here. I’m a senior program manager on the server virtualization team. Last week Steve Ballmer officially [announced](https://www.microsoft.com/presspass/press/2009/jan09/01-07CES09PR.mspx) the public availability of Windows Server 2008 R2 Beta! So did my friends over at the [Windows Server Division blog](https://blogs.technet.com/windowsserver/archive/2009/01/07/announcing-windows-server-2008-r2-beta.aspx).  With this release, there are a tremendous number of new features and capabilities that I encourage everyone to check out.  However, since I am somewhat partial to virtualization, let’s talk about my Top 5 favorite new Hyper-V features:

 **Bryon ’s Favorite New Hyper-V Feature #1: Live migration of Virtual machines

**

Microsoft is enhancing the product with the ability to “live migrate” a virtual machine. With this, there will be no perceived downtime in the workloads running in the VM, and network connections from and to the VM being migrated will stay connected. This capability will be possible between hosts within a High Availability cluster. In addition, Microsoft is adding  ‘Clustered Shared Volumes’ (CSV) capability to failover clustering that allows multiple virtual hard disks (VHDs) from different virtual machines (VM’s) to be stored on a single LUN, presented as a single continuous namespace. This not only simplifies management of shared storage for a cluster, but provides a significant reduction in the migration time for VM’s being live migrated. 

**Bryon ’s Favorite New Hyper-V Feature #2: Hot Addition/Removal of Virtual Storage

**

Virtualization decouples the software running on a system from the hardware and makes it convenient for customers to deploy and manage their IT environments. With this flexibility it is inevitable that customers also seek the ability to expand and reduce storage coupled with virtual machines. With the next generation of the virtualization platform, Microsoft is adding the ability to hot add and remove VHDs and pass through disks in a virtual machine while it is in operation. This capability opens up a range of possibilities including new storage solutions for backup. 

**Bryon ’s Favorite New Hyper-V Feature #3: Enhanced Virtualization Capabilities in the Hardware

**

Over the years hardware vendors such as AMD and Intel have made significant enhancements (such as AMD-V and Intel VT) to processors and chipsets with capabilities specifically targeting virtualization. Continuing with these enhancements, AMD and Intel are adding capabilities to their processors called Nested Page Tables (NPT) and Extended Page tables (EPT) respectively.  These capabilities improve the performance of translation of memory addresses.

 **Bryon ’s Favorite New Hyper-V Feature #4: VDI Connection Broker

**

## The need for a Virtual Desktop Infrastructure (VDI) is becoming ever more present.  With this in mind, Microsoft is including a Remote Desktop Connection Broker which creates a unified admin experience for traditional session-based remote desktops and virtual machine-based remote desktops in a Virtual Desktop Infrastructure. The two key deployment scenarios supported by the Remote Desktop Connection Broker are persistent (permanent) VMs and pooled (temporary) VMs. Today, most early adopters of VDI deploy persistent VMs as they provide the greatest flexibility to the end user.

 **

 

**

 **Bryon ’s Favorite New Hyper-V Feature #5: Power Management Enhancements

**

Microsoft has updated the Windows Hypervisor with enhancements to reduce the power footprint of virtualized workloads. These capabilities include the use of “core parking” wherein the hypervisor proactively consolidates idle workloads to fewer cores, freeing up processor packages which can then be put into a deep sleep state reducing the power consumption of the server

In addition to my top 5, there are many other great new features including VMQ support and Jumbo Frame support.

Be sure to check out all the great new Hyper-V features in R2 at the [Windows Server 2008 R2 website](http://www.microsoft.com/windowsserver2008/en/us/r2.aspx).

**Virtually Yours,**

**Bryon Surace**

**Senior Program Manager for Microsoft Virtualization**
