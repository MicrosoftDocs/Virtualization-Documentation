---
title:      "Hyper-V Replica and Riverbed"
date:       2013-03-11 09:51:00
categories: hvr
---
As part of setting up a replication relationship, Hyper-V Replica transfers the initial VHDs over the network – depending on the size of the VHD, this operation can be time consuming and also impacts your production network. Once initial replication is completed, Hyper-V Replica tracks the changes to the virtual machine and frequently sends the changes to the replica site. This can also impact the network as well based on the workload characteristics. 

While Hyper-V Replica has an inbuilt compression engine, customers have repeatedly asked about the product’s co-existence with WAN optimizers. Many organizations have WAN optimizers between their two sites and are curious to understand impact of WAN optimizers on the replication traffic. We partnered with the **Microsoft Enterprise Engineering Center (**[ **EEC**](http://www.microsoft.com/en-us/eec/default.aspx) **)** and [**Riverbed**](http://www.riverbed.com/us/) **®** WAN optimizers to run a series of experiments which captures the network bandwidth optimization delivered by Riverbed in a Hyper-V Replica deployment. The results of these runs is captured in a whitepaper which is available here - [**http://www.microsoft.com/en-us/download/details.aspx?id=36786**](http://www.microsoft.com/en-us/download/details.aspx?id=36786 "http://www.microsoft.com/en-us/download/details.aspx?id=36786") 

  Key Takeaways:

  * Hyper-V Replica and the Riverbed devices did not require any specialized/extra configuration to interact with each other. Each component “just-worked” out of the box!
  * The bandwidth optimizations are a function of the VHD size, sparseness etc. When HVR’s inbuilt compression was turned off, the Riverbed devices were able to optimize the network traffic significantly across different VHDs, VMs. Even after enabling HVR’s inbuilt compression, the Riverbed devices were able to further optimize the compressed traffic. 



