---
layout:     post
title:      "Free Microsoft iSCSI Target"
date:       2011-04-04 07:40:00
categories: iscsi
---
Virtualization Nation, One common refrain we hear from you is that you appreciate the fact we’re driving down the costs of virtualization and adding more and more capabilities in the box such as Live Migration (LM) and High Availability (HA). We’re happy to do it and we’re just getting started. :) To use both LM and HA, these require shared storage. This shared storage can be in the forms of SAS, iSCSI or Fiber Channel SAN. For many environments this isn't an issue, but there are some specific scenarios where customers need LM and HA and the cost of a dedicated SAN is a blocker. For example, 

  * A branch office environment. It's one thing to setup a dedicated SAN in a datacenter, but what happens when you have 100/500/5000 branch offices? That's a huge multiplier to provide SANs in every one of those branch offices...
  * A small business. Small businesses are especially cost conscious and still want to deploy Hyper-V clustered for the benefits of LM and HA...
  * A test/dev staging environment. Perhaps you want to test your application with LM & HA, but don't have the budget to pay for a SAN.

Wouldn't it be great to have another option? We think so too. Today, as a big THANK YOU to our Windows Server 2008 R2 customers we are taking another step in lowering the barriers and making it even easier to take advantage of Windows Server 2008 R2 Hyper-V High Availability and Live Migration. 

**> > We are making the Microsoft iSCSI Software Target available AS A FREE DOWNLOAD. <<** What does this mean? It means you can install the Microsoft iSCSI software target on a Windows Server 2008 R2 system and use it as shared storage for Live Migration. Interested? Here are a few key pointers. [The full announcement](http://blogs.technet.com/b/josebda/archive/2011/04/04/microsoft-iscsi-software-target-3-3-for-windows-server-2008-r2-available-for-public-download.aspx) about the release of the Microsoft iSCSI Software Target from Jose Barreto The [Microsoft iSCSI Software Target Download](http://www.microsoft.com/downloads/en/details.aspx?FamilyID=45105d7f-8c6c-4666-a305-c8189062a0d0) Configuring the Microsoft iSCSI Software Target with Hyper-V [blog from Jose](http://blogs.technet.com/b/josebda/archive/2009/01/31/step-by-step-using-the-microsoft-iscsi-software-target-with-hyper-v-standalone-full-vhd.aspx) ============================================================================   
**FAQ**  
============================================================================  
Q: The Microsoft iSCSI Software Target is now free. Is it supported in a production environment? A: Yes. The Microsoft iSCSI Software Target is supported in a production environment. The Hyper-V team regularly tests with the MS iSCSI Software Target and it works great with Hyper-V.  
============================================================================  
Q: On what operating systems is the Microsoft iSCSI Software Target supported? A: The Microsoft iSCSI Software Target is supported for Windows Server 2008 R2 Standard, Enterprise and Datacenter Editions.  
============================================================================  
Q: Can the free Microsoft Hyper-V Server 2008 R2 use the free Microsoft iSCSI Software Target? A: Yes and No. Yes, Microsoft Hyper-V Server 2008 R2 can act as a client to access virtual machines via iSCSI. The way to do that is to type **iscsicpl.exe** at the command prompt to bring up the Microsoft iSCSI Initiator (client) and configure it to access an iSCSI Target (server). However, you can't install the Microsoft iSCSI Software Target on a Microsoft Hyper-V Server. The Microsoft iSCSI Software Target requires Windows Server 2008 R2. Jeff Woolsey  
Group Program Manager, Virtualization  
Windows Server & Cloud
