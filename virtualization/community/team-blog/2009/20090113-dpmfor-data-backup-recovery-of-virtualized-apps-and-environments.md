---
layout:     post
title:      "DPM for data backup/recovery of virtualized apps and environments"
date:       2009-01-13 12:47:00
categories: cloud-computing
---

We want to congratulate the Microsoft Storage Solutions team for releasing Service Pack 1 for System Center Data Protection Manager 2007.

 

SP1 for DPM 2007 brings some great new capabilities for protecting Hyper-V environments.  Most notably, of course, is the ability to protect guests within Hyper-V environments, often without downtime (for those guests running a Windows operating system that supports VSS).  Also new for DPM with SP1 is the ability to run the DPM server on the Hyper-V host itself, so that the DPM server can protect the guests from the host viewpoint, within the same physical server - to disk, to tape and even to the cloud. 

And unlike other (shall-not-be-named) virtualization platforms’ backup mechanisms, DPM does _not_ require a SAN and does _not_ require 3rd party backup software or add-ons.   It’s an all Microsoft backup and recovery solution for Microsoft’s virtualization platform.

For more details on the SP1 release for DPM 2007, check out:

·         Bala’s executive [viewpoint on DPM 2007 sp1](http://blogs.technet.com/dpm/archive/2009/01/13/announcing-service-pack-1-for-dpm-2007.aspx)

·         Some early SP1 customers are also blogging about their experiences and you can see at these links – [ICON](http://blogs.technet.com/dpm/archive/2009/01/13/customer-blog-post-on-DPM-2007-SP1-ICON.aspx) & [Convergent Computing](http://blogs.technet.com/dpm/archive/2009/01/13/customer-blog-post-on-DPM-2007-SP1-RAND.aspx)

·         A feature overview of [DPM SP1 is located here](http://blogs.technet.com/dpm/archive/2009/01/13/Service-Pack-1-is-for-you.aspx)

The DPM folks have dedicated resources on “ ** _How to protect virtualized environments with DPM 2007_** ” – [http://www.microsoft.com/DPM/virtualization](http://www.microsoft.com/DPM/virtualization). And a very cool podcast showing how to protect Hyper-V with DPM 2007 SP1 - [http://edge.technet.com/Media/DPM-2007-SP1-Protecting-Hyper-V](http://edge.technet.com/Media/DPM-2007-SP1-Protecting-Hyper-V)

Congrats to the DPM crew – and nice job on backing up Hyper-V !!!

Patrick
