---
title:      "Windows Server 2008 R2 Core&#58; Introducing SCONFIG."
author: sethmanheim
ms.author: mabrigg
description: Windows Server 2008 R1 Core Deployment
ms.date: 07/07/2009
categories: hyper-v
---
# Windows Server 2008 R1: Core Deployment

Virtualization Nation, 

It's been very busy in the world of Windows Server. With the launch of Windows Server 2008 R2 Release Candidate, Tech Ed and the announcement of several new [Hyper-V R2 capabilities such as 64 logical processor support and processor compatibility](https://techcommunity.microsoft.com/t5/virtualization/tech-ed-windows-server-2008-r2-hyper-v-news/ba-p/381610), it's been pretty non-stop. In fact, it's been so busy, that we haven't even had a chance to introduce one more really cool new feature in Windows Server 2008 R2, but first, some background. 

**Windows Server 2008 R1: Core Deployment**

In Windows Server 2008, we introduced the ability to deploy Windows Server in a core deployment. Server Core is a minimal server installation option which provides a low-maintenance server environment with limited functionality. Just to be clear, Server Core isn't a SKU. You don't buy "Server Core" it's simply a deployment option presented during Windows Server Setup. For example, here's a screen shot during Windows Server Setup, notice that there are options for **Full Installations** and **Server Core Installations**. 



The benefits are smaller attack surface, a reduction in patches and reduction of server reboots. If you compare the number of reboots between running a server running Windows Server 2008 core deployment versus Windows Server 2008 a full installation, there's a substantial reduction in the number of reboots which, in turn, helps reduce management costs. 

While customers like the idea of core installations, the fact that a server core deployment is a command-line interface (CLI) only (no GUI, no Start Menu, etc) with a very differently deployment mechanism introduces a challenging learning curve for those considering core deployments. For those of you who've never seen a Windows Server 2008 server core deployment it looks like this: 

 

Pretty spartan. 

As you can see, there's no Start Menu. It's all command-line all the time. For enterprise customers, this isn't a big deal because very often they deploy Windows Server in an automated fashion. However, for small and mid-sized customers a command-line only interface can make some of the most rudimentary tasks a challenge. For example, here are the commands to rename your computer and then join a domain via a Windows Server 2008 core deployment. 

  1. **Rename your computer** : netdom renamecomputer %computername% /newname:<new_computername>
  2. **Domain join** : netdom join %computername% /domain: \<domain\> /userd: \<username\> /passwordd:*



Not the easiest thing to remember. We knew we could do better. 

**Improving Usability**

While Windows Server 2008 R1 was in development, a few of us were quietly working on the Hyper-V Server 2008 standalone SKU which also uses a CLI. We spent time working on improving the server configuration experience with an easy to use CLI called HVCONFIG. Within hours of our first private releases of Hyper-V Server 2008 to testers, we received email asking/begging/pleading/cajoling/offering bribes for a similar tool for Windows Server as well. 

Happy to oblige. 

**Introducing SCONFIG for Windows Server 2008 R2 Core Deployments**

We are pleased to announce that in Windows Server 2008 R2, there's an easy to use CLI, **_SCONFIG_**. **SCONFIG dramatically eases server configuration for Windows Server 2008 R2 core deployments**. With SCONFIG, you can easily set your system up, get it on the network so you can easily manage the server remotely. 

  * Rename your computer? Press **2** and you will be prompted to type in the computer name. 
  * Domain join? Press **1** and you'll be prompted for name & password.



Simple and fast. 

With SCONFIG you can easily have a Windows Server 2008 R2 Server Core deployment setup in **minutes**. I should also mention that SCONFIG is also localized in almost 20 languages. 

Tasks include: 

  1. Domain join 
  2. Rename Computer 
  3. Configure Remote (Enable management via Server Manager, & PowerShell including properly configuring the firewall.) 
  4. Configuring Windows Update 
  5. Enabling Remote Desktop (in case you want to login remotely.) 
  6. Configuring Networking (static vs. DHCP and for multiple NICs)



All you have to do is type **sconfig** at the command line. 

 



**Great! Now What?**

Remember, the goal with a server core deployment is to **_get the server on the network so you can manage it remotely_**. With SCONFIG this is a snap. Now from another system you can enable roles, run PowerShell scripts, manage it using System Center, manage it using Server Manager from another server running Windows Server 2008 R2, or manage it using the free Remote System Administration Tools (RSAT) for Windows 7.

In short, our goal is to provide customers multiple solutions based on their business needs.

Cheers,

_Jeff Woolsey_

_Principal Group Program Manager_

_Windows Server, Hyper-V_
