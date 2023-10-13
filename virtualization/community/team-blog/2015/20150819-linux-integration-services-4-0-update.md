---
title: Linux Integration Services 4.0 Update
description: Learn more about the 4.0.11 update for Linux Integration Services on Hyper-V and Microsoft Azure.
author: sethmanheim
ms.author: mabrigg
date:       2015-08-19 17:00:00
ms.date: 08/19/2015
categories: lis-hyperv-linux
ms.prod: windows-server
ms.technology: hyper-v
---
# Linux Integration Services 4.0 Update

We are pleased to announce an update to Linux Integration Services (LIS) version 4.0: version 4.0.11. This updated release expands to Red Hat Enterprise Linux 6.7, CentOS 6.7, and Oracle Linux Red Hat Compatible Kernel 6.7. In addition to some bug fixes, this release continues improvements to networking performance on Hyper-V and Microsoft Azure.

## Download Location

The LIS binaries are available either as a tar file that can be uploaded to your virtual machine or as an ISO that can be mounted. The files are available from the Microsoft Download Center here: <https://www.microsoft.com/download/)

A ReadMe file has been provided to provide information on the installation procedure, feature set, and issues.

See also the TechNet article “[Linux and FreeBSD Virtual Machines on Hyper-V](https://technet.microsoft.com/library/dn531030.aspx)” for a comparison of LIS features and best practices for use.  
  
As LIS code is released under the GNU Public License version 2 (GPLv2) and are freely available at the [LIS GitHub project](https://github.com/LIS). LIS code is also regularly submitted to the upstream Linux kernel and documented on the [Linux kernel mailing list (lkml)](https://lkml.org/).

## Supported Virtualization Server Operating Systems

Linux Integration Services (LIS) 4.0 allows Linux guests to use Hyper-V virtualization on the following host operating systems:

  * Windows Server 2008 R2 (applicable editions)
  * Microsoft Hyper-V Server 2008 R2
  * Windows 8 Pro, 8.1 Pro, 10 and 10 Pro
  * Windows Server 2012 and 2012 R2
  * Microsoft Hyper-V Server 2012 and 2012 R2
  * Windows Server Technical Preview
  * Microsoft Hyper-V Server Technical Preview
  * Microsoft Azure



## Applicable Linux Distributions

Microsoft provides Linux Integration Services for a broad range of Linux distros as documented in the [Linux and FreeBSD Virtual Machines on Hyper-V topic](https://technet.microsoft.com/library/dn531030.aspx) on TechNet. Per that documentation, many Linux distributions and versions have Linux Integration Services built-in and do not require installation of this separate LIS package from Microsoft. This LIS package is available for a subset of supported distributions in order to provide the best performance and fullest use of Hyper-V features. It can be installed in the listed distribution versions that do not already have LIS built, and can be installed as an upgrade in listed distribution versions that already have LIS built-in.  
  
This update adds support for Red Hat Enterprise Linux 6.7, CentOS 6.7, and Oracle Linux 6.7. LIS 4.0 is applicable to the following guest operating systems:

  * Red Hat Enterprise Linux 5.5-5.11 32-bit, 32-bit PAE, and 64-bit
  * Red Hat Enterprise Linux 6.0-6.7 32-bit and 64-bit
  * Red Hat Enterprise Linux 7.0-7.1 64-bit
  * CentOS 5.5-5.11 32-bit, 32-bit PAE, and 64-bit
  * CentOS 6.0-6.7 32-bit and 64-bit
  * CentOS 7.0-7.1 64-bit
  * Oracle Linux 6.4-6.7 with Red Hat Compatible Kernel 32-bit and 64-bit
  * Oracle Linux 7.0-7.1 with Red Hat Compatible Kernel 64-bit



## Linux Integration Services 4.0 Feature Set

When installed on a virtual machine that is running a supported Linux distribution, LIS 4.0 for Hyper-V provides the additional functionality over LIS 3.5 listed in the table below.

  * Installable on Red Hat Enterprise Linux 6.6, 6.7, and 7.1
  * Installable on CentOS 6.6, 6.7, and 7.1
  * Installable on Oracle Linux 6.6, 6.7, and 7.1 when running the Red Hat Compatible Kernel
  * Networking and storage performance improvements
  * Dynamic Memory – Hot Add



More details on individual features can be found at <https://technet.microsoft.com/library/dn531031.aspx>

## Customer Feedback

Customers can provide feedback through the [Linux and FreeBSD Virtual Machines on Hyper-V forum](https://social.technet.microsoft.com/Forums/windowsserver/en-us/home?forum=linuxintegrationservices) and via Microsoft Windows Server Uservoice. We look forward to hearing about your experiences with LIS.

Thanks! --jrp (Josh Poulson)
