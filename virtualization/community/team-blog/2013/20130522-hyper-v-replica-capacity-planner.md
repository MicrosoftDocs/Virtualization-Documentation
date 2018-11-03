---
layout:     post
title:      "Hyper-V Replica Capacity Planner"
date:       2013-05-22 22:06:35
categories: hvr
---
Customers have frequently asked us for capacity planning guidance before deploying Hyper-V Replica – e.g.: “How much network bandwidth is required between the primary and replica site”, “How much storage is required on the primary and replica site”, “What is the storage impact by enabling multiple recovery points” etc.

The answer to the above and many other capacity planning questions is “It depends” – it depends on the workload, it depends on the IOPS headroom, it depends on the available storage etc. While one can monitor every single perfmon counter to make an informed decision, it is sometimes easier to have a readymade tool.

The Capacity Planner for Hyper-V Replica which was released on 5/22, allows you to plan your Hyper-V Replica deployment based on the workload, storage, network and server characteristics. The guidance is based on results gathered through our internal testing across different workloads.

You can download the tool and it’s documentation from here - <http://www.microsoft.com/en-us/download/details.aspx?id=39057>

Instructions:

1) Download the tool (exe) and documentation

2) Read the documentation first and then try out the tool. You should familiarize yourself with some nuances listed in the documentation before using the tool. 

So go ahead, use the tool in your virtual infrastructure and share your feedback and questions through this blog post or in the community [forum](http://social.technet.microsoft.com/Forums/en-US/winserverhyperv/threads). We would love to hear your comments! 
