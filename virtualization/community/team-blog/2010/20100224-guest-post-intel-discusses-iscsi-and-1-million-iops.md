---
title:      "Guest post&#58; Intel discusses iSCSI and 1 million IOPs"
author: sethmanheim
ms.author: mabrigg
description: Intel discusses iSCSI and 1 million IOPs
ms.date: 02/24/2010
date:       2010-02-24 22:48:00
categories: guest-blog-post
---
# Guest post: Intel discusses iSCSI and 1 million IOPs

Hi, I'm Jordan Plawner, storage networking product planner from Intel. 

Today I'm doing a recap of the [Intel Server and Ethernet Adapters and Windows 2008 R2 1m iSCSI IOPs announcement and HyperV performance webcast](https://msevents.microsoft.com/CUI/WebCastEventDetails.aspx?culture=en-US&EventID=1032432957&CountryCode=US "Webcast link").  The number of comments and ongoing discussions by end users have been impressive.  There were two themes that ran through the blog questions and comments that I want to address.

1st:   What does 1 million IOPs on a single 10GbE port performance mean?  What this performance means is that you do not have to worry about iSCSI performance.  There is no server I/O bottleneck.  If you are going with an iSCSI SAN use the native infrastructure built into the server, OS and adapter.  If you are deciding between iSCSI and FC, know that at the very least the performance on the client side is a wash.  Server-side ease-of-use and cost if unquestionably in ISCSI’s favor. 

Over this same time period there have been additional claims of reaching a similar magnitude of IOPs at various I/O sizes by HBA’s.  Most of those use more than 1 8G or 10G port, so read the fine print.   One HBA company claimed 930k IOPs over 1 10GbE port, which pretty much makes the point that performance has far exceed what people need and HBA’s with proprietary protocols do not provide performance benefits.  Intel and Microsoft have stated running the same test on the newest Intel servers to be released this year and preliminary results demonstrated a 33% performance boost.  While it takes years to get such a boost from proprietary solutions and a fork lift infrastructure upgrade, with native iSCSI it takes a short server refresh cycle.

So what then does 1 million iSCSI IOPs mean at 512b mean for your servers running storage over mid-size I/O.    It means;

·        performance is not an issue for iSCSI as it can scale easily to full-line rate

·         low single digit CPU utilization to run typical applications which typically generate less than 10k IOPs

·        if you converging LAN and iSCSI traffic on the same 10G links you will have sufficient bandwidth 

2nd:   What about features?  Lost in the discussion around 1 million IOPs is that the presentation discussed  why the features and usability of native iSCSI make it the superior way to connect a server to a SAN.  For example

·        Scalability: To move Windows Servers with Intel Ethernet from DAS to GbE iSCSI or two ports of GbE iSCSI to four ports or 10GbE also you need to do is to add the Intel Ethernet ports (more GbE or 10G).  No client side infrastructure changes are needed.  It all scales.

·        Compatibility:  Because the native infrastructure is the most commonly used and tested in the storage and server community, when you move from one network configuration to another you will experience the maximum compatibility with the HW.  No worrying about storage and OS compatibility lists and re-qualifying proprietary protocols and limited product offerings.  You are always using the same Microsoft Initiator and Intel Adapter family and Driver stack.

·        Features: Since Intel adapters and the Microsoft ISCSI initiator are so most mature they have the richest and most tested features such as MPIO, MCS (Multiple connections), remote boot, and CPU CRC Digest instruction set.  The typical sensational debate over native initiators vs. proprietary initiators focuses exclusively on performance because it is an easy metric.  It takes more effort to do a feature comparison and then dig into what customers care about.  We talk to end customers all the time and feedback is consistent that the native solutions are the easiest to use and have the richest and most stable features.

·        HyperV:  Talking about how much networking has improved in 2008 R2 HyperV brings up the uncomfortable question of what it was like in previous releases.  Well I see no reason to shy away from the conversation.  HyperV allows you to connect iSCSI guest initiators directly to your SAN, maintaining a virtual 1:1 relationship between applications and storage.   To do this and enable Live Migration there is some networking over head.  It is a small price to pay to enable a dynamic data center.  To be able to close the networking performance delta between physical and virtual servers using Intel VMDq, HyperV VMq  is really impressive.  At mid size I/O the throughput and IOPs were basically the same and you get Live Migration.  Talk about something for nothing. 

Finally, the thinkers out there immediately wondered about SSD’s, 40G, FCoE, DCB (Data Center Bridging; aka DCE or CEE) and target capabilities.  Each topic is another posting but my message is the same; there is no server I/O bottleneck with Native iSCSI and 10G.  It will scale with SSD’s, 40G, and handle converged traffic over DCB and high capacity SAN’s.  As for the controversy of iSCSI vs. FCoE, there is no controversy, only your specific circumstance.  10GbE iSCSI is Enterprise Ready.  If you are expanding an existing FC SAN, FCoE makes sense to consider.  If you need a new SAN, call 1-800-iSCSI.

Jordan
