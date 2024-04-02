---
title:      "What's new in Hyper-V Replica in Windows Server 2012 R2"
author: sethmanheim
ms.author: sethm
ms.date: 10/22/2013
categories: hvr
description: This post discusses the top 8 improvements to Hyper-V Replica in Windows Server 2012 R2.
---
# Top 8 Improvements to Hyper-V Replica in Windows Server 2012 R2
18th October 2013 marked the General Availability of Windows Server 2012 R2. The teams have accomplished an amazing set of features in this short release cycle and Brad's post @ <https://blogs.technet.com/b/in_the_cloud/archive/2013/10/18/today-is-the-ga-for-the-cloud-os.aspx> captures the investments made across the board. We encourage you to update to the latest version and share your feedback.

This post captures the top 8 improvements done to **Hyper-V Replica in Windows Server 2012 R2.** We will be diving deep into each of these features in the coming weeks through blog posts and TechNet articles.

## Seamless Upgrade

You can upgrade from Windows Server 2012 to Windows Server 2012 R2 **without having to re-IR your protected VMs**. With new features such as cross-version live migration, it is easy to maintain your DR story across OS upgrades. You can also choose to upgrade your primary site and replica site at different times as Hyper-V Replica will replicate your virtual machines from a Windows Server 2012 environment to a Windows Server 2012 R2 environment.         

## 30 second replication frequency

Windows Server 2012 allowed customers to replicate their virtual machines at a preset 5minute replication frequency. Our aspirations to bring down this replication frequency was backed by customer's asks on providing the flexibility to set different replication frequencies to different virtual machines. With Windows Server 2012 R2, you can now asynchronously replicate your virtual machines at either **30second, 5mins or 15mins** frequency.   
 
<!-- [![30sec](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3513.30sec_thumb_57C8E14C.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2061.30sec_25CEB011.png)****-->

## Additional Recovery Points

Customers can now have a longer retention with **24 recovery points**. These 24 (up from 16 in Windows Server 2012) recovery points are spaced at an hour 's interval.           
          
<!-- [![Additional recovery points](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/3817.image_thumb_58C361DA.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2772.image_02A3D610.png)**** -->

## Linux guest OS support

Hyper-V Replica, since it's first release has been agnostic to the application and guest OS. However certain capabilities were unavailable on non-Windows guest OS in it's initial avatar. With Windows Server 2012 R2, we are tightly integrated with non-Windows OS to provide file-system consistent snapshots and inject IP addresses as part of the failover workflow.           
****

## Extended Replication

You can now 'extend' your replica copy to a third site using the 'Extended replication' feature. The functionality provides an added layer of protection to recover from your disaster. You can now have a replica copy within your site (eg: ClusterA->ClusterB in your primary datacenter) and extend the replication for the protected VMs from ClusterB->ClusterC (in your secondary data center).   
          
<!-- [![Extended replication](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/8030.image_thumb_47751BA6.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2781.image_513A831E.png) -->

To recover from a disaster in ClusterA, you can now quickly failover to the VMs in ClusterB and continue to protect them to ClusterC. More on extended replication capabilities in the coming weeks.        

## Performance Improvements

Significant architectural investments were made to lower the IOPS and storage resources required on the Replica server. The most important of these was to move away from snapshot-based recovery points to "undo logs" based recovery points. These changes have a profound impact on the way the system scales up and consumes resources, and will be covered in greater detail in the coming weeks.

## Online Resize

****In Windows Server 2012 Hyper-V Replica was closely integrated with the various Hyper-V features such as VM migration, storage migration etc. Windows Server 2012 R2 allows you to resize a running VM and if your VM is protected – you can continue to replicate the virtual machine without having to re-IR the VM.           
****

## Hyper-V Recovery Manager

We are also excited to announce the paid preview of **Hyper-V Recovery Manager (HRM)** (<https://blogs.technet.com/b/scvmm/archive/2013/10/21/announcing-paid-preview-of-windows-azure-hyper-v-recovery-manager.aspx>) **.** This is a Windows Azure Service that allows you to manage and orchestrate various DR workflows between the primary and recovery datacenters. HRM does * **not** * replicate virtual machines to Windows Azure – your data is replicated directly between the primary and recovery datacenter. HRM is the disaster recovery "management head" which is offered as a service on Azure.
