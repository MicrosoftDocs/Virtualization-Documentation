---
title:      "Update&#58; Capacity Planner for Hyper-V Replica"
author: mattbriggs
ms.author: mabrigg
ms.date: 01/21/2014
categories: hvr
description: This article discusses the updates made to the Capacity Planner for Hyper-V Replica on Windows Server 2012.
---
# Updates to the Capacity Planner for Hyper-V Replica

In May 2013, we [released the first version](https://blogs.technet.com/b/virtualization/archive/2013/05/23/hyper-v-replica-capacity-planner.aspx) of the Capacity Planner for Hyper-V Replica on Windows Server 2012. It allowed administrators to plan their Hyper-V Replica deployments based on the workload, storage, network, and server characteristics. While it is always possible to monitor every single perfmon counter to make an informed decision, a readymade tool always makes life simpler and easier. The big plus comes from the fact that the guidance is based on actual workload and server characteristics, which makes it a level better than static input-based planning models. The tool picks the right counters to monitor, automates the metrics collection process, and generates an easily consumable report. The tool and documentation have been **updated for Windows Server 2012 R2** and can be download from here: <https://www.microsoft.com/en-us/download/details.aspx?id=39057> 

#### What’s new

We received feedback from our customers on how the tool can be made better, and we threw in a few improvements of our own. Here is what the updated Capacity Planner tool has: 

  1. Support for Windows Server 2012 and Windows Server 2012 R2 in a single tool
  2. Support for Extended Replication
  3. Support for virtual disks placed on NTFS, CSVFS, and SMB shares
  4. Monitoring of multiple standalone hosts simultaneously
  5. Improved performance and scale – up to 100 VMs in parallel
  6. Replica site input is optional – for those still in the planning stage of a DR strategy
  7. Report improvements – e.g.: reporting the peak utilization of resources also
  8. Improved guidance in documentation
  9. Improved workflow and user experience

In addition, the documentation has a section on how the tool can be used for capacity planning of [Hyper-V Recovery Manager](http://www.windowsazure.com/en-us/services/recovery-manager/) based on the [‘cloud’ construct](https://technet.microsoft.com/library/gg610625.aspx) of System Center Virtual Machine Manager.   So go ahead, use the tool in your virtual infrastructure and share your feedback and questions through this blog post. We would love to hear your comments! 

_**28-Feb-2014 update:**   _Keith Mayer has an excellent guided hands-on lab demo that can be found [here](https://blogs.technet.com/b/keithmayer/archive/2014/02/27/guided-hands-on-lab-capacity-planner-for-windows-server-2012-hyper-v-replica.aspx). 
