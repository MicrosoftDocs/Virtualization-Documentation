---
layout:     post
title:      "Discrete Device Assignment -- GPUs"
date:       2015-11-23 11:41:54
categories: dda
---
This is the third post in a four part series.  My previous two blog posts talked about Discrete Device Assignment ([link](/b/virtualization/archive/2015/11/19/discrete-device-assignment.aspx "Discrete Device Assignment -- Description and background")) and the machines and devices necessary ([link](/b/virtualization/archive/2015/11/20/discrete-device-assignment-machines-and-devices.aspx "Discrete Device Assignment -- Machines and devices")) to make it work in Windows Server 2016 TP4. This post goes into more detail, focusing on GPUs.

There are those of you out there who want to get the most out of Photoshop, or CATIA, or some other thing that just needs a graphics processor, or GPU. If that’s you, and if you have GPUs in your machine that aren’t needed by the Windows management OS, then you can dismount them and pass them through to a guest VM.

GPUs, though, are complicated beasts. People want them to run as fast as they possibly can, and to pump a lot more data through the computer’s memory than almost any other part of the computer. To manage this, GPUs run at the hairy edge of what PCI Express buses can deliver, and the device drivers for the GPUs often tune the GPU and sometimes even the underlying machine, attempting to ensure that you get a reasonable experience.

The catch is that, when you pass a GPU through to VM, the environment for the GPU changes a little bit. For one thing, the driver can’t see the rest of the machine, to respond to its configuration or to tune things up. Second, access to memory works a little differently when you turn on an I/O MMU, changing timings and such. So the GPU will tend to work if the machine’s BIOS has already set up the GPU optimally, and this limits the machines that are likely to work well with GPUs. Basically, these are servers which were built for hosting GPUs. They’ll be the sorts of things that the salesman wants to push on you when you use words like “desktop virtualization” and “rendering.” When I look at a server, I can tell whether it was designed for GPU work instantly, because it has lots of long (x16) PCI Express slots, really big power supplies and fans that make a spooky howling sound.

We’re working with the GPU vendors to see if they want to support specific GPUs, and they may decide to do that. It’s really their call, and they’re unlikely to make a support statement on more than the few GPUs that are sold into the server market. If they do, they’ll supply driver packages which convert them from being considered “use at your own risk” within Hyper-V to the supported category. When those driver packages are installed, the error and warning messages that appear when you try to dismount the GPU will disappear.

So, if you’re still reading and you want to play around with GPUs in your VMs, you need to know a few other things. First, GPUs can have a lot of memory. And by default, we don’t reserve enough space in our virtual machines for that memory. (We reserve it for RAM that you might add through Dynamic Memory instead, which is the right choice for most users.) You can find out how much memory space your GPU uses by looking at it in Device Manager, or through scripts by looking at the WMI Win32_PnPAllocatedResource class.

[![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5873.ATIFireProV.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/5873.ATIFireProV.png)

The screen shot above is from the machine I’m using to type this. You can see two memory ranges listed, with beginning and end values expressed in hexadecimal. Doing the conversion to more straightforward numbers, the first range (the video memory, mostly) is 256MB and the second one (video setup and control registers) is 128KB. So any VM you wanted to use this GPU with would need at least 257MB of free space within it.

In Hyper-V within Server 2016 TP4, there are two types of VMs, Generation 1 and Generation 2. Generation 1 is intended to run older 32-bit operating systems and 64-bit operating systems which depend on the VM having a structure very like a PC. Generation 2 is intended for 64-bit operating systems which don’t depend on a PC architecture.

A Generation 1 VM, because it is intended to run 32-bit code, attempts to reserve as much as possible in the VM for RAM in the 32-bit address space. This leaves very little 32-bit space available for GPUs. There is, however, by default, 512MB of space available that 64-bit OS code can use.

A Generation 2 VM, because it is not constrained by 32-bit code, has about 2GB of space that could have any GPU placed in it. (Some GPUs require 32-bit space and some don’t, and it’s difficult to tell the difference without just trying it.)

Either type of VM, however, can be reconfigured so that there’s more space in it for GPUs. If you want to reserve more space for a GPU that needs 32-bit space, you can use PowerShell:

Set-VM pickyourvmname -LowMemoryMappedIoSpace upto3000MBofmemoryhere

Similarly, if you want to reserve memory for GPUs above 32-bit space:

Set-VM pickyourvmname -HighMemoryMappedIoSpace upto33000MBofmemoryhere

Note that, if your GPU supports it, you can have a lot more space above 32-bits.

Lastly, GPUs tend to work a lot faster if the processor can run in a mode where bits in video memory can be held in the processor’s cache for a while before they are written to memory, waiting for other writes to the same memory. This is called “write-combining.” In general, this isn’t enabled in Hyper-V VMs. If you want your GPU to work, you’ll probably need to enable it:

Set-VM pickyourvmname -GuestControlledCacheTypes $true

None of these settings above can be applied while the VM is running.

Happy experimenting!

\-- Jake Oshins
