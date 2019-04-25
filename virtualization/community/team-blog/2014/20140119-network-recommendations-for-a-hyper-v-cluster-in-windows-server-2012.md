---
title:      "Network Recommendations for a Hyper-V Cluster in Windows Server 2012"
date:       2014-01-19 06:23:00
categories: hvr
---
We recently published a TechNet document <http://technet.microsoft.com/library/dn550728.aspx> which provides guidance on configuring your network for a Hyper-V Cluster in Windows Server 2012.

A snip of the summary from the document:

 _Windows Server 2012 supports the concept of converged networking, where different types of network traffic share the same Ethernet network infrastructure. In previous versions of Windows Server, the typical recommendation for a failover cluster was to dedicate separate physical network adapters to different traffic types. Improvements in Windows Server 2012, such as Hyper-V QoS and the ability to add virtual network adapters to the management operating system enable you to consolidate the network traffic on fewer physical adapters. Combined with traffic isolation methods such as VLANs, you can isolate and control the network traffic._

There are some major improvements from the Windows Server 2008 R2 [guidance](http://technet.microsoft.com/en-us/library/ff428137\(WS.10\).aspx) and there is a lot of emphasis on converged networking. The document also provides a practical example which isolates different kinds of traffic and assigns bandwidth ‘weight’.
