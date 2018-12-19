---
layout:     post
title:      "Re&#58; Windows Server 2008 SP2 Hyper-V"
date:       2009-06-17 12:51:00
categories: hyper-v
---
Hi Isaac Roybal here. I’m a technical product manager on the Windows Server team covering Hyper-V.

 

It’s been 3 weeks since the release of [Windows Server 2008 Service Pack 2](http://blogs.technet.com/windowsserver/archive/2009/05/26/windows-server-2008-and-windows-vista-sp2-available-for-download.aspx) (SP2) and we’re seeing great adoption. From a Hyper-V point of view, we’re excited because the final Hyper-V release is an integrated feature in SP2 making it easier and faster to deploy Hyper-V. If you recall, when Windows Server 2008 was released, Hyper-V Beta was included. This meant to get the final Hyper-V release, you needed to go to Windows Update, download and go through the update process.

 

With Windows Server 2008 SP2, Hyper-V final bits are included so there’s no need to pull down individual downloads which speeds up deployments. There are also some notable updates in SP2, including scalability enhancements for running on systems with up to 24 logical processors which enables support for up to 192 running virtual machines, update for Hyper-V when managed with System Center Virtual Machine Manager 2008 and updates for backup/restore of virtual machines with the Volume Shadow Copy Service (VSS).

 

For those of you who have already deployed Hyper-V, SP2 is a simple upgrade. Here are a couple of top-of-mind things to think about when you’re planning your upgrade or fresh install of SP2:

·         In-place upgrades of Windows Server 2008 to Windows Server 2008 SP2 is supported for both the parent partition and child VMs. 

o   If the Hyper-V role was enabled on the parent partition prior to the upgrade to SP2, it will be automatically enabled once the upgrade is completed.

o   Uninstall any prerelease versions of SP2 that might be installed. 

·         If a fresh SP2 install is being done and you’d like to move VMs to it, export the VMs from the originating  Windows Server 2008 host and import them on the SP2 host. 

·         Integration Components (ICs) for the child virtual machines must be updated to the SP2 version. 

o   If you’re doing a fresh install or an upgrade of SP2 on the _parent partition_ , it does _not_ update the integration components inside the virtual machine. Be sure to update the VM ICs after SP2 is installed. 

o   If you have virtual machines created on the Beta version of the Windows Server 2008 Hyper-V role, and you installed the Beta version of the integration components on those machines, you must uninstall the integration components and reinstall the latest SP2 integration components. 

o   When upgrading to SP2 inside a Windows Server 2008 child VM the ICs are automatically upgraded. 

o   If you are running a supported Windows operating system other than Windows Server 2008 as a VM, you need to use vmguest.iso to upgrade the integration components

 

Isaac

 

 **UPDATE**. Responding to question by Ed051042

Yes, your assertion is correct. Follow these steps when upgrading a cluster to SP2:

1.       Evacuate the cluster node of VMs via quick migration (assuming you’ve extra capacity) to other nodes in the cluster.

2.       Upgrade the node to SP2 while it is still part of the cluster

3.       Once the SP2 install is complete, quick migrate those VMs back to node and _update VMs ’ ICs._ The last bit is important.

4.       Follow the same process starting step #1 until entire cluster had been updated to SP2

 

For more info see [KB 174799 ](http://support.microsoft.com/kb/174799) which outlines how to install SPs on a cluster and [Microsoft's Failover and Network Load Balancing Clustering Team Blog](http://blogs.msdn.com/clustering/archive/2009/06/12/9731520.aspx) which explains a rolling upgrade of a cluster. 

 
