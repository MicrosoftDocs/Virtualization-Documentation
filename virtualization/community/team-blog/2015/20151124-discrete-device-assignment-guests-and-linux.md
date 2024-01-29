---
title: Discrete Device Assignment -- Guests and Linux
description: Learn about supporting Linux guest virtual machines using Discrete Device Assignment.
author: sethmanheim
ms.author: sethm
date:       2015-11-24 14:46:02
ms.date: 11/24/2015
categories: dda
---
# Discrete Device Assignment -- Guests and Linux

In my previous three posts, I outlined a new feature in Windows Server 2016 TP4 called Discrete Device Assignment. This post talks about support for Linux guest VMs, and it's more of a description of my personal journey rather than a straight feature description. If it were just a description, I could do that in one line: We're contributing code to Linux to make this work, and it will eventually hit a distro near you.

Microsoft has cared a lot about supporting Linux in a Hyper-V VM for a while now. We have an entire team of people dedicated to making that work better. Microsoft Azure, which uses Hyper-V, hosts many different kinds of Linux, and they're constantly tuning to make that even better. What's new for me is that I built the Linux front-end code for PCI Express pass-through, rather than asking a separate team to do it. I also built PCI Express pass-through for Windows (along with a couple of other people) for Windows Server 2012, which showed up as SR-IOV for networking, and Discrete Device Assignment for Windows Server 2016 TP4, which is built on the same underpinnings.

When I first started out to work on PCIe pass-through, I realized that the changes to Hyper-V would be really extensive. Fundamentally, we're talking about distributing ownership of the devices inside your computer among multiple operating systems, some of which are more trusted than others. I was also trying to make sure that giving a device to an untrusted guest OS wouldn't result in that OS taking the device hostage, making it impossible to do anything related to plug-and-play in the rest of the machine. Imagine if I told you that you couldn't hot-plug another NVMe drive into your system because your storage utility VM wasn't playing along, or even worse yet, your SQL server with SR-IOV networking was on-line and not in a state to be interrupted.

I actually spent a few months thinking about the problem (back in 2008 and '09) and how to solve it. The possible interactions between various OSes running on the same machine were combinatorically scary. So I went forth with some guiding principles, two of which were: Allow as few interactions as possible while still making it all work and keep the attack surface from untrusted VMs to an absolute minimum. The solution involved replacing the PCI driver in the guest OS with one that batched up lots of things into a few messages, passed through Hyper-V and on to the PnP Manager in the management OS, which manages the hardware as a whole.

When I went to try to enable Linux, however, I discovered that my two principles had caused me to come up with a protocol that was perfectly tailored to what Windows needs as a guest OS. Anything that would have made it easier to accommodate Linux got left out as "extra attack surface" or "another potential failure path that needs to be handled," even though Linux does all the same things as Windows, but just a little differently. So the first step in enabling PCIe pass-through for Linux guests was actually to add some new infrastructure to Hyper-V. I still tried to minimize attack surface, and I think that I've added only that which was strictly necessary.

One of the challenges is that Linux device drivers are structured very differently from Windows device drivers. In Windows, a driver never interacts directly with the underlying driver for the bus itself. Windows drivers send I/O Request Packets (or IRPs) down to the bus driver. If they need to call a function in the bus driver in a very light-weight fashion, they send an IRP to the bus driver asking for a pointer to that function. This makes it possible, and even relatively easy, to replace the bus driver entirely, which is what we did for Windows. We replaced PCI.sys with vPCI.sys. vPCI.sys knows that it's running in a virtual machine and that it doesn't control the actual underlying hardware.  
Linux has a lot of flexibility around PCI, of course. It runs on a vastly wider gamut of computers than Windows does. But instead of allowing the underlying bus driver to be replaced, Linux accommodates these things by allowing a device driver to supply low-level functions to the PCI code which do things like scan the bus and set up IRQs. These low-level functions required very different underlying support from Hyper-V.

As part of this, I've learned how to participate in open source software development, sending iteration upon iteration of patches to a huge body of people who then tell me that I don't know anything about software development, with helpful pointers to their blogs explaining the one true way. This process is actually ongoing. Below is a link to the latest series of changes that I've sent in. Given that there hasn't be any comment on it in a couple of weeks, it seems fairly likely that this, or something quite like this, will eventually make it into "upstream" kernels.

<https://lkml.org/lkml/2015/11/2/672>

Once it's in the upstream kernels, the various distributions (Ubuntu, SUSE, RHEL, etc.) will eventually pick up the code as they move on to newer kernels. They can each individually choose to include the code or not, at their discretion, though most of the distros offer Hyper-V support by default. We may actually be able to work with them to back-port this to their long-term support products, though that's far from certain at this point.

So if you're comfortable patching, compiling and installing Linux kernels, and you want to play around with this, pull down the linux-next tree and apply the patch series. We'd love to know what you come up with.

\-- Jake Oshins
