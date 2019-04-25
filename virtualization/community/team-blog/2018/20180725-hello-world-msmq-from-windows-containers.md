---
title: Hello World MSMQ
keywords: virtualization, containers, windows containers, dda, devices, blog
author: cwilhit
ms.date: 7/25/2018
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.assetid: 
---

# Hello World, MSMQ!

![MSMQ Hackathon Group picture](https://msdnshared.blob.core.windows.net/media/2018/07/Hackathon-team-photo-2.jpg)

Hello from Microsoft Hackathon!  

**What are we hacking?** Containerizing MSMQ! Let me tell you more.  MSMQ (Microsoft Message Queuing) is one of the top asks from Enterprise customers who are lifting and shifting traditional apps with Windows Containers. We are hearing that in our conversations with customers directly, especially with major financial institutions. It is a blocker in their containerization journey. We are also seeing the same ask in online communities like the following on User Voice and MSDN Forum:

* [Windows Server Uservoice - create a base container image with MSMQ](https://windowsserver.uservoice.com/forums/304624-containers/suggestions/15719031-create-base-container-image-with-msmq-server)
* [Windows Server Forum - is MSMQ in a container supported?](https://social.msdn.microsoft.com/Forums/en-US/bce99a7d-aa60-44fa-a348-450855650810/msmqserver-is-it-supported?forum=windowscontainers)

Back in January, we fixed an issue that prevented MSMQ from installing in Windows Server Core containers ([read more in this blog](https://blogs.technet.microsoft.com/virtualization/2018/01/22/a-smaller-windows-server-core-container-with-better-application-compatibility/)).  With Windows Server version 1803 release, MSMQ now installs.

As the old saying, devils are in the details. In our effort to make the end-to-end scenarios work with MSMQ in containers, we learned that there is a long list of components, features, technologies and teams involved to make it fully working end-to-end for typical Enterprise customer scenarios. To name a few: [Container Networking](https://docs.microsoft.com/en-us/virtualization/windowscontainers/container-networking/architecture), [Active Directory](https://social.technet.microsoft.com/wiki/contents/articles/1026.active-directory-services-overview.aspx), [Group Managed Service Accounts](https://technet.microsoft.com/en-us/library/jj128431\(v=ws.11\).aspx). And it also brings another [top customer ask supporting MSDTC in Windows containers](/windowsserver.uservoice.com/forums/304624-containers/suggestions/30982237-support-for-msdtc) to the spot light. So, I decided to take this challenge to our internal Hackathon! In the first a few hours when we started the Hackathon, we identified a prioritized scenario list we’ll target to hack on. I will share the details of the scenarios in future blogs. But first I am happy to share that today we validated the first scenario working. It’s a very “Hello World” alike scenario that sends messages from a Window container using MSMQ. Here is the basics of the scenario: 

![](https://msdnshared.blob.core.windows.net/media/2018/07/MSMQ-Hackathon-Scenario-1-diagram.png)

* Set-up
  * Container Host: Windows Server v1803 or higher, OR, Windows 10 April 2018 Updates or higher
      * A quick note: In today’s Hackathon, my teammate who validated the scenario was actually on the most recent build of Windows 10 which is not even out for Insiders yet but we did test on Windows Server version 1803 and version 1809 pre-release builds before 😊
    * Container Image: Windows Server v1803 Server Core container
  * MSMQ Configurations
    * Queue Scope: Private 
    * Message Type: Transactional
    * 2 Simple apps using MSMQ to simulate the most basic send/receive operations:
      * MSMQSenderTest.exe
      * MSMQReceiveTest.exe
    * Queue Location: on the same container as the Sender/Receiver.
    * Where the sender and receive sit: to simplify things, both the sender and receiver testing apps run directly inside the above mentioned Container Image. This is far away from a real-world scenario but remember we are starting with baby steps.

And Voila… we can send and receive messages in a Windows container!

[![](https://msdnshared.blob.core.windows.net/media/2018/07/MSMQ-Hackathon-Scenario-1-screenshot-232x300.png)](https://msdnshared.blob.core.windows.net/media/2018/07/MSMQ-Hackathon-Scenario-1-screenshot.png)

Is it too basic? Yes it is. We know. As mentioned early on, we have worked on this on and off, and have tested a few other scenarios. Here is a quick glimpse of what we have tested or are still testing on. We will share more details in future blogs.

**Scope** | **Transactional** | **Container OS** | **Container Host OS** | **Queue Location** | **Send Works** | **Receive Works**  
---|---|---|---|---|---|---  
Private | Yes | Windows Server version 1803 | Windows Server version 1803 | On the container | Yes. | Yes.  
Public | Yes | Windows Server version 1803 | Windows Server version 1803 | On the Domain Controller (DC) | Yes. There are some security caveats we'd like to address. | Haven't tested  
Public | No | Windows Server version 1803 | Windows Server version 1803 | Not on the container, or the container host, or the DC, but another box | Yes. There are some security caveats we'd like to address. | Haven't tested  
Public | Yes | Windows Server version 1803 | Windows Server version 1803 | Not on the container, or the container host, or the DC, but another box | No. | Haven't tested  
  The top 2 rows are more basic scenarios for us to get started and troubleshoot. The last 2 rows in our view are most close to what Enterprise customers might be using. Is it true? We’d love to hear your validation. We didn’t test the scenario where the queue is a Private one and the messages are non-transactional. We believe as the scenario of a private queue with transactional messages works, a private queue with non-transactional one should work too as it’s less complex. As we peel the onions layers by layers, it’s becoming more and more obvious that we can use all the help inside and outside Microsoft to get this going, as MSMQ is a technology out for a long time, and there are lots of you who are experts on this. We’ll look into to ways we can sort of “crowdsource” or “group-think” to get the community involved. We will share more details on that in future blogs. OK, this is for now and I need to get back to the Hackathon! Wish me and my teammates (Andy, Jane, and Ross) good luck!    Weijuan  P.S. I am building up my Twitter presence which seems a popular place to keep people updated. I'll share updates more frequently there. Follow me @WeijuanLand
