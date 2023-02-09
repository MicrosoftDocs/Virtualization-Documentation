---
title:      "Tech Ed&#58; Windows Server 2008 R2 Hyper-V News!"
description: Greetings from Tech Ed in Los Angeles! It's been a busy couple of days.
author: scooley
ms.author: scooley
date:       2009-05-13 01:34:00
ms.date: 05/13/2009
categories: uncategorized
---
# Tech Ed: Windows Server 2008 R2 Hyper-V News

Virtualization Nation,

Greetings from Tech Ed in Los Angeles! It's been a busy couple of days and you've probably heard the big news by now, Windows 7 and Windows Server 2008 R2 will be shipping for the holidays!

On the Hyper-V R2 front, we're pleased to announce a few surprises of our own. :-) Let's start with scalability.

**64 logical processor support**. This is a **4x improvement over Hyper-V R1** and means that Hyper-V can take advantage of larger scale-up systems with greater amount of compute resources. As our friends at AMD and Intel drive up core counts, we want you to know that Hyper-V is ready to take advantage of the compute resources in your server today and those you're buying tomorrow.

**Support for up to 384 Concurrently Running Virtual Machines & 512 Virtual Processors _PER SERVER_**. (No, that's not a typo.) Going hand in hand with our support for 64 logical processors, we're upping the maximum number of concurrently running virtual machines to 384 per server and the maximum number of virtual processors to 512 for the highest virtual machine density on the market. Here are a few examples. You could run:

  1. 384 single virtual processor vms OR
  2. 256 dual virtual processor vms (512 Virtual Processors) OR
  3. 128 quad virtual processor vms (512 Virtual Processors) OR
  4. any combination so long as you're running up to 384 VMs and up to 512 Virtual Processors



**Live Migration & Processors.**

With the addition of Live Migration in Hyper-V R2, one of the immediate questions we're asked is: "Do the physical processors have to be _exactly the same_?"

Scenario 1: Suppose you bought three servers for live migration and created a three node cluster. Everything's working well and a 6-12 months down the road you want to add another couple of nodes to increase the compute resources in your cluster. In the meantime, your OEM has upgraded their server hardware line with new processors, now what do you do?

Scenario 2: You work in a small/medium business or K-12 education and you need to squeeze every nickel you can out of your budget. You want to use virtualization and would love to use Live Migration, but you have a mix of different servers ranging from Pentium 4, Core 2 and maybe next year you'll get budget to purchase a new Core i7 server.

_Wouldn't it be great if you could Live Migrate virtual machines across different processor generations?_

We think so too.

**Introducing: Processor Compatibility**

With Hyper-V R2, we include a new Processor Compatibility feature. Processor compatibility allows you to move a virtual machine up and down multiple processor generations from the same vendor. Here's how it works.

When a Virtual Machine (VM) is started on a host, the hypervisor exposes the set of supported processor features available on the underlying hardware to the VM. This set of processor features are called guest visible processor features and are available to the VM until the VM is restarted. 

When a VM is started with processor compatibility mode enabled, Hyper-V normalizes the processor feature set and only exposes guest visible processor features that are available on all Hyper-V enabled processors of the same processor architecture, i.e. AMD or Intel.  This allows the VM to be migrated to any hardware platform of the same processor architecture. Processor features are "hidden" by the hypervisor by intercepting a VM's CPUID instruction and clearing the returned bits corresponding to the hidden features.

__Just so we're clear: this still means AMD <->AMD and Intel<->Intel. It does **not** mean you can Live Migrate between different processor vendors AMD <->Intel or vice versa.__

In addition, you may be aware that both AMD and Intel have provided similar capabilities in hardware, Extended Migration and Flex Migration respectively. Extended and Flex Migration are cool technologies available on relatively recent processors, but this is a case where providing the solution in software allows us to be more flexible and provide this capability to older systems too. Processor Compatibility also makes it easier to upgrade to the newest server hardware. In addition, Hyper-V Processor Compatibility can be done on a per VM basis (it's a checkbox) and doesn't require any BIOS changes.



**Processor Compatibility In Action**

Here's an example of a cluster we've been testing. This is a 4 node cluster **using 4 generations of Intel Processors with VT** all attached to a small iSCSI SAN over 1 Gb/E. We have a script that _continuously_ Live Migrates VMs from one node to the next every 15 seconds. We've been running this test for about a week and have successfully completed over 110,000 Live Migrations. Looks kinda like this.

 

 

**Time To Get Uber-Geeky**

Now that I've explained what processor compatibility mode does and the flexibility provides, I'm guessing there are a few propeller heads who want to go further and know exactly what a "normalized processor" means from a processor feature standpoint. Happy to oblige. When a VM in processor compatibility mode is started, the following processor features are hidden from the VM:

**Host running AMD based processor**

| 

**Host running Intel based processor**  
  
---|---  
  
SSSE3, SSE4.1, SSE4.A, SSE5, POPCNT, LZCNT, Misaligned SSE, AMD 3DNow!, Extended AMD 3DNow!

| 

SSSE3, SSE4.1, SSE4.2, POPCNT, Misaligned SSE, XSAVE, AVX  
  
**FAQ**

_Q: What happens if a vendor has written an application that uses one of these features that isn't visible with processor compatibility enabled?_

A: Since the feature isn't exposed to the virtual machine, the application won't "see it" and it's up to the application to determine how to proceed; however, there are two likely paths.

**Path 1: The application will check to see if a specific processor feature is available and use it if it's available**. If the processor features isn't available, it will use a different code path. Remember that applications that make use of these advanced processor features are generally written in a flexible fashion to accommodate the servers in market today and there are still thousands of older Xeons and Opterons on the market that don't have some of the latest processor features.

**Path 2: The application requires a specific processor feature and refuses to launch**. At this point in time, we haven't found _any application that fall into this category_. It's possible they exist, but we haven't hit one yet. Since we can't test every application out there, processor compatibility is defaulted off. (We're conservative by nature.).

BTW, if there were issues with Hyper-V Processor Compatibility, you'd also see it with other virtualization products which rely on underlying hardware capabilities to mitigate this problem as well.

_Q: Does processor compatibility have a hardware requirement? Does it require Intel Flex Migration or AMD Extended Migration?_

A: Hyper-V processor compatibility mode has no dependencies on these technologies.

_Q: Does Hyper-V processor compatibility allow you to migrate a VM from an AMD host to an Intel host and vice versa?_

A: No. Processor compatibility allows you to move a virtual machine up and down multiple processor generations from the same vendor. It does _not_ allow migrating a VM (with or without processor compatibility mode) from AMD based hosts to Intel based hosts, and vice versa. 

Cheers,

_Jeff Woolsey_

_Principal Group Program Manager_

_Windows Server, Hyper-V_
