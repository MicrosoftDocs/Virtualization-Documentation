---
title:      "Optimizing Hyper-V Replica HTTPS traffic using Riverbed SteelHead"
author: sethmanheim
ms.author: sethm
ms.date: 05/08/2014
date:       2014-05-08 10:54:59
categories: hvr
description: This article discusses how to use Riverbed SteelHead to optimize Hyper-V Replica HTTPS traffic.
---
# Hyper-V Replica and Riverbed SteelHead

Hyper-V Replica support both Kerberos based authentication and certificate based authentication – the former sends the replication traffic between the two servers/sites over HTTP while the latter sends it over HTTPS. Network is a precious commodity and any optimization delivered has a huge impact on the organization's TCO and the Recovery Point Objective (RPO). 

Around a year back, we partnered with the folks from [Riverbed](https://www.riverbed.com/products-solutions/products/wan-optimization-steelhead/) in Microsoft's EEC lab, to publish a whitepaper which detailed the bandwidth optimization of replication traffic sent over HTTP. 

A few months back, we decided to revisit the setup with the latest release of RiOS (Riverbed OS which runs in the Riverbed appliance). Using the resources and appliances from EEC and Riverbed, a set of experiments were performed to study the network optimizations delivered by the Riverbed SteelHead appliance. Optimizing SSL traffic has been a tough nut to crack and we saw some really impressive numbers.  The whitepaper documenting the results and technology is available [**here**](https://www.microsoft.com/download/details.aspx?id=42627) **.**

At a high level, in order to optimize HTTPS traffic, the Riverbed SteelHead appliance decrypts the packet from the client (the primary server). It then optimizes the payload and encrypts the payload before sending it to the server side SteelHead appliance over the internet/WAN. The server-side SteelHead appliance decrypts the payload, de-optimizes the traffic and re-encrypts it. The server side appliance finally sends it to the destination server (the replica server) which proceeds to decrypt the replication traffic. The diagram is taken from Riverbed's user manual and explains the above technology: 

<!--[![Riverbed SteelHead manual](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_1C67CBAA.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_7FCB4FD6.png)-->

When Hyper-V Replica's inbuilt compression is disabled, the reduction delivered over WAN was ~80%

<!--[![Reduction over WAN without compression](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_644DFFE6.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_627B196E.png)-->

When Hyper-V Replica's inbuilt compression is enabled, the reduction delivered over WAN was ~30% 

<!--[![Reduction over WAN with compression](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_thumb_4BE30DEB.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/image_3C3DE178.png)-->

It's worth calling out that the % reduction delivered depends on a number of factors such as workload read, write pattern, sparseness of the disk etc but the numbers were quite impressive. 

In summary, both Hyper-V Replica and the SteelHead devices were easy to configure and worked "out-of the box". Neither product required specific configurations to light up the scenario. The Riverbed appliance delivered ~30% on compressed, encrypted Hyper-V Replica traffic and ~80% on uncompressed, encrypted Hyper-V Replica traffic.
