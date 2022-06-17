---
title: Linux Integration Services 4.1
description: Blog post that announces the availability of Linux Integration Services 4.1 and describes the bug fixes and performance improvements in the update.
author: scooley
ms.author: scooley
date: 2016-03-21 18:46:30
ms.date: 07/31/2019
categories: linux
---

# Linux Integration Services 4.1

We are pleased to announce the availability of Linux Integration Services (LIS) 4.1. This new release expands supported releases to Red Hat Enterprise Linux, CentOS, and Oracle Linux with Red Hat Compatible Kernel 5.2, 5.3, 5.4, and 7.2. In addition to the latest bug fixes and performance improvements for Linux guests running on Hyper-V this release includes the following new features: 

  * Hyper-V Sockets (Windows Server Technical Preview)
  * Manual Memory Hot-Add (Windows Server Technical Preview)
  * SCSI WNN
  * lsvmbus
  * Uninstallation scripts

  See the ReadMe file for more information.   **Download Location**   The Linux Integration Services installation scripts and RPMs are available either as a tar file that can be uploaded to a virtual machine and installed, or an ISO that can be mounted as a CD. The files are available from the Microsoft Download Center here: <https://www.microsoft.com/en-us/download/details.aspx?id=51612>   A ReadMe file has been provided information on installation, upgrade, uninstallation, features, and known issues.   See also the TechNet article “[Linux and FreeBSD Virtual Machines on Hyper-V](https://technet.microsoft.com/library/dn531030.aspx)” for a comparison of LIS features and best practices for use here: <https://technet.microsoft.com/library/dn531030.aspx>   Linux Integration Services code is released under the GNU Public License version 2 (GPLv2) and is freely available at the LIS GitHub project here: <https://github.com/LIS>   **Supported Virtualization Server Operating Systems**   Linux Integration Services (LIS) 4.1 allows Linux guests to use Hyper-V virtualization on the following host operating systems: 

  * Windows Server 2008 R2 (applicable editions)
  * Microsoft Hyper-V Server 2008 R2
  * Windows 8 Pro and 8.1 Pro
  * Windows Server 2012 and 2012 R2
  * Microsoft Hyper-V Server 2012 and 2012 R2
  * Windows Server Technical Preview
  * Microsoft Hyper-V Server Technical Preview
  * Microsoft Azure.

  **Applicable Linux Distributions**   Microsoft provides Linux Integration Services for a broad range of Linux distros as documented in the “[Linux and FreeBSD Virtual Machines on Hyper-V](https://technet.microsoft.com/library/dn531030\(ws.12\).aspx)” topic on TechNet. Per that documentation, many Linux distributions and versions have Linux Integration Services built-in and do not require installation of this separate LIS package from Microsoft. This LIS package is available for a subset of supported distributions in order to provide the best performance and fullest use of Hyper-V features. It can be installed in the listed distribution versions that do not already have LIS built, and can be installed as an upgrade in listed distribution versions that already have LIS built in. LIS 4.1 is applicable to the following guest operating systems: 

  * Red Hat Enterprise Linux 5.2-5.11 32-bit, 32-bit PAE, and 64-bit
  * Red Hat Enterprise Linux 6.0-6.7 32-bit and 64-bit
  * Red Hat Enterprise Linux 7.0-7.2 64-bit
  * CentOS 5.2-5.11 32-bit, 32-bit PAE, and 64-bit
  * CentOS 6.0-6.7 32-bit and 64-bit
  * CentOS 7.0-7.2 64-bit
  * Oracle Linux 6.4-6.7 with Red Hat Compatible Kernel 32-bit and 64-bit
  * Oracle Linux 7.0-7.2 with Red Hat Compatible Kernel 64-bit


