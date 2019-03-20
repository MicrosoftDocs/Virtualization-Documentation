---
title:      "Linux Integration Services 4.0 Announcement"
date:       2015-05-01 13:43:00
categories: uncategorized
---
# IntroductionWe are pleased to announce the release of Linux Integration Services (LIS) version 4.0. As part of this release we have expanded the access to Hyper-V features and performance to the latest Red Hat Enterprise Linux, CentOS, and Oracle Linux versions. While Microsoft continues to develop and submit Linux Integration Services to the Linux kernel and work with enterprise Linux distribution vendors to incorporate that code into new releases, this software direct from Microsoft makes those improvements available to long-established Linux installations. This release continues the tradition of great support for open source software making full use of Microsoft virtualization platforms.

# Download Location

The LIS binaries are available either as a tar file that can be uploaded to your virtual machine or as an ISO that can be mounted. The files are available from the Microsoft Download Center here: [](http://www.microsoft.com/en-us/download/details.aspx?id=46842)<http://www.microsoft.com/en-us/download/details.aspx?id=46842>[  
  
](http://www.microsoft.com/en-us/download/details.aspx?id=46842)A ReadMe file has been provided to provide information on the installation procedure, feature set, and issues.  See also the TechNet article “[Linux and FreeBSD Virtual Machines on Hyper-V](https://technet.microsoft.com/en-us/library/dn531030.aspx)” for a comparison of LIS features and best practices for use. As LIS code is released under the GNU Public License version 2 (GPLv2) and are freely available at the [LIS github project](https://github.com/LIS). LIS code is also regularly submitted to the upstream Linux kernel and documented on the [linux kernel mailing list (lkml)](https://lkml.org/).

# Supported Virtualization Server Operating Systems

Linux Integration Services (LIS) 4.0 allows Linux guests to use Hyper-V virtualization on the following host operating systems:

  * Windows Server 2008 R2 (applicable editions)

  * Microsoft Hyper-V Server 2008 R2

  * Windows 8 Pro and 8.1 Pro

  * Windows Server 2012 and 2012 R2

  * Microsoft Hyper-V Server 2012 and 2012 R2

  * Windows Server Technical Preview

  * Microsoft Hyper-V Server Technical Preview

  * Microsoft Azure.




# Applicable Linux Distributions

Microsoft provides Linux Integration Services for a broad range of Linux distros as documented in the [Linux and FreeBSD Virtual Machines on Hyper-V](https://technet.microsoft.com/en-us/library/dn531030.aspx) topic on TechNet. Per that documentation, many Linux distributions and versions have Linux Integration Services built-in and do not require installation of this separate LIS package from Microsoft. This LIS package is available for a subset of supported distributions in order to provide the best performance and fullest use of Hyper-V features. It can be installed in the listed distribution versions that do not already have LIS built, and can be installed as an upgrade in listed distribution versions that already have LIS built-in. LIS 4.0 is applicable to the following guest operating systems:

  * Red Hat Enterprise Linux 5.5-5.11 32-bit, 32-bit PAE, and 64-bit

  * Red Hat Enterprise Linux 6.0-6.6 32-bit and 64-bit

  * Red Hat Enterprise Linux 7.0-7.1 64-bit

  * CentOS 5.5-5.11 32-bit, 32-bit PAE, and 64-bit

  * CentOS 6.0-6.6 32-bit and 64-bit

  * CentOS 7.0-7.1 64-bit

  * Oracle Linux 6.4-6.6 with Red Hat Compatible Kernel 32-bit and 64-bit

  * Oracle Linux 7.0-7.1 with Red Hat Compatible Kernel 64-bit




# Linux Integration Services 4.0 Feature Set

When installed on a virtual machine that is running a supported Linux distribution, LIS 4.0 for Hyper-V provides the additional functionality listed in the table below. 

    * Installable on Red Hat Enterprise Linux 6.6-7.1


    * Installable on CentOS 6.6-7.1


    * Installable on Oracle Linux 6.6-7.1 when running the Red Hat Compatible Kernel


    * Networking and storage performance improvements


    * Dynamic Memory – Hot Add



More details on individual features can be found at [http://technet.microsoft.com/en-us/library/dn531031.aspx](http://technet.microsoft.com/en-us/library/dn531031.aspx)

# Customer Feedback

Customers can provide feedback through the [Linux and FreeBSD Virtual Machines on Hyper-V forum](https://social.technet.microsoft.com/Forums/windowsserver/en-us/home?forum=linuxintegrationservices). We look forward to hearing about your experiences with LIS.
