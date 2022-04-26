---
title:      "Guest Post&#58; Virtual Eggs in One Virtualization Basket?"
description: Guest post from Dave Demlow of Double-Take Software about data virtualization, replication, and backups.
ms.date: 01/27/2009
date: 2009-01-27 01:43:00
categories: cross-platform-management
---

# Guest Post: Virtual Eggs in One Virtualization Basket?

Hi, my name is Dave Demlow and I am the Chief Technology Officer at Double-Take Software. 

[Double-Take Software](http://www.doubletake.com/) has been a leading provider of data replication and failover technologies for Microsoft Windows Server and applications going all the way back to Windows NT 3.51.  So like many of you, we’ve seen many changes in the role that Windows Servers play in the enterprise and in the increased requirements for the availability and protection of Windows-based workloads.  Hyper-V will accelerate those changes but at the same time make it much easier and more cost effective than ever to provide those higher levels of availability to an even broader range of workloads.

As Jeff Woolsey highlighted so well in his post on [Hyper-V Quick Migration](https://blogs.technet.com/virtualization/archive/2008/04/09/hyper-v-quick-migration-vmware-live-migration-part-1.aspx), “ _Virtualization actually creates a major problem: single point of failure_.”   And if the problem with that isn’t crystal clear,” _If that virtualization server goes down and I don ’t have a HA solution in place, I will lose my job **. ”**_

The hypervisor is only one of many possible points of failure to be concerned with.   If the shared storage in a Hyper-V cluster is unavailable due to a site failure, power failure or corruption, ALL of your workloads that rely on that storage or site will also be down. 

Fortunately, Windows Server 2008 provides two enabling technologies, Hyper-V and Failover Clustering, that when used with 3rd party products such as our GeoCluster for Windows or Double-Take for Windows software can create clusters of Hyper-V servers that offer redundancy through _replicated_ storage. Optionally, these can be geographically dispersed to maintain availability of virtualized workloads even when entire sites or datacenters are inoperative also providing for off-site disaster recovery. These are sometimes referred to as “multi-site” or “stretched” clusters and our customers often simply refer to them by our brand name GeoCluster.

As an example, with our GeoCluster product, multiple Hyper-V nodes in a cluster could store independent replicas of each protected virtual machine that are continuously updated as the virtual machine is changed.  An example cluster might have 4 nodes in New York, Chicago, LA and Seattle.   On the New York node, 10 virtual machines  are running and replicating to the other 3 nodes.  In LA, 5 other VMs are running in LA but only replicating to Chicago and so on.   In the event of an unplanned outage, virtual machines could automatically failover to any site with a replica in a pre-set priority order…perhaps the VMs in New York failover to Chicago first, then Seattle then to any surviving site.  The flexibility with software-based replication technologies is extensive, allowing replication between different types of servers, between different storage technologies and allowing very granular selection of which VMs should be replicated and which should not, even on the same disk or LUN. 

While SANs and iSCSI storage are supported in a GeoCluster, cluster nodes can even use direct attached storage of nearly any type.  VMs normally stored on high performance Fibre Channel or SAS drives could be replicated to a node with internal SATA drives to optimize costs. Hardware independence and flexibility are two key benefits of many software based replication and failover solutions such as Double-Take and GeoCluster software.

While the emphasis on multi-site clusters is often to maintain availability of VMs across unexpected site outages, it is also possible to use our GeoCluster product to perform planned migration of running virtual machines with minimal downtime, also known as Quick Migration.   This process works exactly the same as it would between cluster nodes using a shared disk with the additional step that “under the hood” the saved memory state on the previous node is automatically replicated to the destination node before the VM is “resumed” and continues running exactly where it was previously.

In conclusion, if you are concerned about the availability of the virtual eggs in your virtualization basket, consider implementing Windows Server 2008 Hyper-V along with 3rd party multi-site cluster solutions to provide complete infrastructure and datacenter redundancy to maintain availability of your virtualized workloads across server, storage or even site level disasters.

Dave Demlow **

**
