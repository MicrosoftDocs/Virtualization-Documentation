---
layout:     post
title:      "GA of Hyper-V Recovery Manager (HRM)"
date:       2014-01-16 20:26:22
categories: hrm
---
We are excited to announce the General Availability of Hyper-V Recovery Manager or HRM for short. HRM is an Azure hosted service which orchestrates the protection and recovery of virtual machines in your datacenter. Hyper-V Replica replicates your virtual machines from your primary datacenter to your secondary datacenter. To re-emphasize, your VMs are **not replicated to Windows Azure**. HRM is a service hosted in Azure which acts as the “control plane”.

The high level solution is as follows:

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_08F9A01C.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_63015F14.png)

A step by step guide on setting up HRM is available @ <http://www.windowsazure.com/en-us/documentation/articles/hyper-v-recovery-manager-configure-vault/>

If you have questions on HRM, visit the TechNet forum @ <http://social.msdn.microsoft.com/Forums/windowsazure/en-US/home?forum=hypervrecovmgr>

Pricing, SLA details for the service is available @ <http://www.windowsazure.com/en-us/pricing/details/recovery-manager/>

Brad Anderson’s blog on HRM - <http://blogs.technet.com/b/in_the_cloud/archive/2014/01/16/announcing-the-ga-of-windows-azure-hyper-v-recovery-manager.aspx> – provides more details on the solution.
