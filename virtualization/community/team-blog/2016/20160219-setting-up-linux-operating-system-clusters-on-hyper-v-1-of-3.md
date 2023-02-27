---
title: Setting up Linux Operating System Clusters on Hyper-V (1 of 3)
description: Follow along with part 1 of this three-part walk-through about setting up Linux operating system clusters on Hyper-V.
author: dcui
ms.author: decui
date:       2016-02-19 23:16:50
ms.date: 02/19/2016
categories: cluster
---
# Setting up Linux Operating System Clusters on Hyper-V (1 of 3)

Author: Dexuan Cui 

## **Background**

When Linux is running on physical hardware, multiple computers may be configured in a Linux operating system cluster to provide high availability and load balancing in case of a hardware failure. Different clustering packages are available for different Linux distros, but for Red Hat Enterprise Linux (RHEL) and CentOS, [Red Hat Cluster Suite](https://access.redhat.com/documentation/red_hat_enterprise_linux/5/html/cluster_suite_overview/s1-rhcs-intro-cso "Red Hat Cluster Suite") is a popular choice to achieve these goals. A cluster consists of two or more nodes, where each node is an instance of RHEL or CentOS. Such a cluster usually requires some kind of shared storage, such as iSCSI or fibre channel, that is accessible from all of the nodes. What happens when Linux is running in a virtual machine guest on a hypervisor, such as you might be using in your on-premises datacenter? It may still make sense to use a Linux OS cluster for high availability and load balancing. But how can you create shared storage in such an environment so that it is accessible to all of the Linux guests that will participate in the cluster? This series of blog posts answers these questions. 

## **Overview**

This series of blog posts walks through setting up Microsoft’s Hyper-V to create shared storage that can be used by Linux clustering software. Then it walks through setting up Red Hat Cluster Suite in that environment to create a five-node Linux OS cluster. Finally, it demonstrates an example application running in the cluster environment, and how a failover works. The shared storage is created using Hyper-V’s [Shared VHDX](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn281956(v=ws.11)) feature, which [allows the VM users to create a VHDX file, and share that file among the guest cluster nodes as if the shared VHDX file were a shared Serial Attached SCSI disk](http://searchvirtualstorage.techtarget.com/answer/How-does-the-shared-VHDX-file-feature-in-Windows-Server-2012-R2-work). When the Shared VHDX feature is used, the .vhdx file itself still must reside in a location where it is accessible to all the nodes of a cluster. This means it must reside in a CSV (Cluster Shared Volume) partition or in an SMB 3.0 file share. For the example in this blog post series, we’ll use a host CSV partition, which requires a host cluster with an iSCSI target (server). Note: To understand how clustering works, we need to first understand 3 important concepts in clustering: [split-brain, quorum and fencing](https://techthoughts.typepad.com/managing_computers/2007/10/split-brain-quo.html): 

  * “Split-brain” is the idea that a cluster can have communication failures, which can cause it to split into subclusters
  * “Fencing” is the way of ensuring that one can safely proceed in these cases
  * “Quorum” is the idea of determining which subcluster can fence the others and proceed to recover the cluster services

These three concepts will be referenced in the remainder of this blog post series. The walk-through will be in three blog posts: 
  1. Set up a Hyper-V host cluster and prepare for shared VHDX. Then set up five CentOS 6.7 VMs in the host cluster that use the shared VHDX. These five CentOS VMs will form the Linux OS cluster.
  2. Set up a Linux OS cluster with the CentOS 6.7 VMs running RHCS and the [GFS2 file system](https://en.wikipedia.org/wiki/GFS2).
  3. Set up a web server on one of the CentOS 6.7 nodes, and demonstrate various failover cases. Then Summary and conclusions.

Let’s get started! 

## **Set up a host cluster and prepare for Shared VHDX**

(Refer to [Deploy a Hyper-V Cluster](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/jj863389(v=ws.11)), [Deploy a Guest Cluster Using a Shared Virtual Hard Disk](/previous-versions/windows/it-pro/windows-server-2012-R2-and-2012/dn265980(v=ws.11))) Here we first setup an iSCSI target (server) on iscsi01 and then set up a 2-node Hyper-V host cluster on hyperv01 and hyperv02. Both nodes of the Hyper-V host cluster are running Windows Server 2012 R2 Hyper-V, with access to the iSCSI shared storage. 

  1. Setup an iSCSI target on iscsi01. (Refer to [Installing and Configuring target iSCSI server on Windows Server 2012](https://blogs.technet.com/b/meamcs/archive/2012/03/30/installing-and-configuring-target-iscsi-server-on-windows-server-8-beta.aspx).) We don’t have to buy a real iSCSI hardware. Windows Server 2012 R2 can emulate an iSCSI target based on .vhdx files.
So we install “File and Storage Service” on iscsi01 using Server Manager -> Configure this local server -> Add roles and features -> Role-based or feature-based installation -> … -> Server Roles -> File and Storage Service -> iSCSI Target Server(add). Then in Server Manager -> File and Storage Service -> iSCSI, use “New iSCSI Virtual Disk…” to create 2 .vhdx files: iscsi-1.vhdx (200GB) and iscsi-2.vhdx (1GB). In “iSCSI TARGETS”, allow hyperv01 and hyperv02 as Initiators (iSCSI clients). 
  2. On hyperv01 and hyperv02, use “iSCSI Initiator” to connect to the 2 LUNs of iscsi01. Now in “Disk Management” of both the hosts, 2 new disks should appear and one’s size is 200GB and the other’s size is 1GB.
In one host only, for example hyperv02, in “Disk Management”, we create and format a NTFS partition in the 200GB disk (remember to choose "Do not assign a drive letter or drive path"). 
  3. On hyperv01 and hyperv02, install “Failover Cluster Manager”
Server Manager -> Configure this local server -> Add roles and features -> Role-based or feature-based installation -> … -> Feature -> Failover Clustering. 
  4. On hyperv02, with Failover Cluster Manager -> “Create Cluster”, we create a host cluster with the 2 host nodes.
Using “Storage -> Disks | Add Disk”, we add the 2 new disks: the 200GB one is used as “Cluster Shared Volume” and the 1GB one is used as Disk Witness in Quorum. To set the 1GB disk as the Quorum Disk, after “Storage -> Disks | Add Disk”, right click the host node, choose More Actions -> Configure Cluster Quorum Settings… -> Next -> Select the quorum witness -> Configure a disk witness-> …. 
  5. Now, on both the 2 hosts, a new special shared directory C:\ClusterStorage\Volume1\ appears.



## **Set up CentOS 6.7 VMs in the host cluster with Shared VHDX**

  1. On hyperv02, with Failover Cluster Manager -> “Roles| Virtual Machines | New Virtual Machine” we create five CentOS 6.7 VMs. For the purposes of this walk through, these five VMs are given names “my-vm1”, “my-vm2”, etc., and these are the names you’ll see used in the rest of the walk through.
Make sure to choose “Store the virtual machine in a different location” and choose C:\ClusterStorage\Volume1\\. In other words, my-vm1’s configuration file and .vhdx file are stored in C:\ClusterStorage\Volume1\my-vm1\Virtual Machines\ and C:\ClusterStorage\Volume1\my-vm1\Virtual Hard Disks\\. You can spread out the five VMs across the two Hyper-V hosts however you like, as both hosts have equivalent access to C:\ClusterStorage\Volume1\\. The schematic diagram above shows three VMs on hyperv01 and two VMs on hyperv02, but the specific layout does not affect the operation of the Linux OS cluster or the subsequent examples in this walk through. 
  2. Use Static IP addresses and update /etc/hosts in all 5 VMs _
Note: contact your network administrator to make sure the static IPs are reserved for this use._ So on my-vm1 in /etc/sysconfig/network-scripts/ifcfg-eth0, we have 

```code
        DEVICE=eth0
    TYPE=Ethernet
    UUID=2b5e2f5a-3001-4e12-bf0c-d3d74b0b28e1
    **ONBOOT=yes** **NM_CONTROLLED=no** **BOOTPROTO=static** **IPADDR=10.156.76.74** **NETMASK=255.255.252.0** **GATEWAY=10.156.76.1** DEFROUTE=yes
    PEERDNS=yes
    PEERROUTES=yes
    IPV4_FAILURE_FATAL=yes
    IPV6INIT=no
    NAME="System eth0"
```

And in /etc/hosts, we have 

```code
        127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4
    ::1       localhost localhost.localdomain localhost6 localhost6.localdomain6
    
        10.156.76.74      my-vm1
    10.156.76.92      my-vm2
    10.156.76.48      my-vm3
    10.156.76.79      my-vm4
    10.156.76.75      my-vm5
```

  3. On hyperv02, in my-vm1’s “Settings | SCSI Controller”, add a 100GB Hard Drive by using the “New Virtual Hard Disk Wizard”. Remember to store the .vhdx file in the shared host storage, e.g., **C:\ClusterStorage\Volume1\** 100GB-shared-vhdx.vhdx and remember to enable the “ **Advanced Features | Enable virtual hard disk sharing** ”. Next we add the .vhdx file to the other 4 VMs with disk sharing enabled too. In all the 5 VMs, the disk will show as /dev/sdb. Later, we’ll create a clustering file system (GFS2) in it.
  4. Similarly, we add another shared disk of 1GB (C:\ClusterStorage\Volume1\quorum_disk.vhdx) with the Shared VHDX feaure to all the 5 VMs. The small disk will show as /dev/sdc in the VMs and later we’ll use it as a Quorum Disk in RHCS.

 

## **Wrap Up**

This completes the first phase of setting up Linux OS clusters. The Hyper-V hosts are running and configured, and we have five CentOS VMs running on those Hyper-V hosts. We have a Hyper-V Cluster Shared Volume (CSV) that is located on an iSCSI target, and containing the virtual hard disks for each of the five VMs. The next blog post will describe how to actually setup the Linux OS clusters using the Red Hat Cluster Suite.   ~ Dexuan Cui
