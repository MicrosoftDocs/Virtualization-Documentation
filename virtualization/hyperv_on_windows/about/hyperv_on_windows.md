ms.ContentId: 93EDAAF5-E4FC-4F3F-AB55-669D2BF47D78 
title: Hyper-V on Windows 10

# Client Hyper-V # 
 
Client Hyper-V is an optional feature that can be installed on Windows 10 Enterprise and Windows 10 Professional. For details on installing Client Hyper-V, see [Install Client Hyper-V](..\quick_start\step3.md) 

A typical physical computer consists of hardware, an operating system and applications installed on this operating system. The operating system is installed on the hardware, applications are installed on the operating system and together these components make up a single computing environment.

By contrast, the virtual machine technology built into Hyper-V enables one physical computer to run multiple computing environments. This is achieved by using a specialized piece of software called a hypervisor. The hypervisor emulates computer hardware and allows us to install an operating system and applications onto this virtualized hardware. The end result is a single piece of physical hardware called the host running many virtualized computer systems called the guests. 


----------
**Important** 
You must license the software running on each of the guest virtual machines according to their operating system requirements.

-----------

## Uses ##
Client Hyper-V can be used in many ways, for example:

- A test environment consisting of multiple virtual machines can be created on a single desktop or laptop computer. Once testing has completed, these virtual machines can be exported and then imported into a production Hyper-V system.

- Developers can use Client Hyper-V to test their software on multiple operating systems. For example, if you have an application that must be tested on Windows 8, Windows 7 and a Linux operating system, multiple virtual machines can be created on your development system, one containing each of these operating systems.

- You can use Client Hyper-V to troubleshoot. You can export a virtual machine from your production environment, open it on your desktop with Client Hyper-V, perform your required troubleshooting, and then export it back into the production environment. 

- Using virtual networking, you can create a multi-machine environment for test/development/demonstration that is secure from affecting the production network.

- Enthusiasts can use it to experiment with other operating systems. Hyper-V makes it very easy to bring up and tear down different operating systems.

- You can use Hyper-V on a laptop for demonstrating older versions of Windows or non-Windows operating systems. 


## What isn’t supported? ##
There are some features included in Hyper-V on server that are not included in Client Hyper-V. These include the following:

- The Remote FX capability to virtualize GPUs 

- Live migration of virtual machines from one host to another

- Hyper-V Replica

- Virtual Fibre Channel

- SR-IOV networking

- Shared .VHDX

-----
**Warning**  
Virtual machines running on Client Hyper-V do not automatically handle moving from a wired to a wireless connection. You must change the virtual machines network adapter settings manually.
 
------

## What works differently? ##
There are some features that work differently on Client Hyper-V than they do Hyper-V running on Windows Server. These include the following:

- The memory management model is different for Client Hyper-V. On a server, Hyper-V memory is managed with the assumption that only the virtual machines are running on the server. In Client Hyper-V, memory is managed with the understanding most client machines are running software in addition to running virtual machines. For example, a developer might be running Visual Studio as well as several virtual machines on the same computer.

- SR-IOV on a 64-bit guest works normally, but 32-bit does not and is not supported.


## Requirements ## 
Hyper-V requires a computer with a supported 64-bit processor that has Second Level Address Translation (SLAT). For information about checking and changing the virtualization support settings of your system BIOS, consult your system manufacturer.

4 GB of RAM is required. 

Hyper-V is only available in the following versions of Windows:

- Windows 10 Pro 64-bit Edition

- Windows 10 Enterprise 64-bit Edition


## Supported Guest Operating Systems ##
For a list of supported guest operating systems, see [Supported Windows Guest Operating Systems](supported_guest_os.md). 

For supported Linux distributions as a guest operating systems on Hyper-V, see [Linux and FreeBSD Virtual Machines on Hyper-V](https://technet.microsoft.com/library/dn531030.aspx).


Next step: [Walkthrough Client Hyper-V on Windows 10](..\quick_start\walkthrough.md) 

