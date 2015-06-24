ms.ContentId: 295275F2-45D0-4177-8635-15C94B54DA8F 
title: Client Hyper-V in Windows 10

# Client Hyper-V # 
 
Client Hyper-V is an optional feature that can be installed on Windows 10 Enterprise and Windows 10 Professional. For details on installing Client Hyper-V, see [Install Client Hyper-V](..\quick_start\step3.md) 

Client Hyper-V is built upon the same virtualization technology that is available in Windows Server. 


--------
Hyper-V is an optional component that enables users to run a broad range of operating systems simultaneously on a single physical computer. 

A typical computer configuration matches hardware with one operating system and the applications designed for that one operating system. The hardware includes the mouse and keyboard, processor, memory, disk drives and drive controllers, video and network cards, and other devices. The operating system runs on and controls the hardware. Applications run on the operating system.

By contrast, the virtual machine technologies built into Hyper-V enables one physical computer to run multiple of operating systems and related applications inside of a virtualized computer also know as a virtual machine. A virtual machine uses specialized software called a hypervisor to create a separate operating environment on the physical hardware. 

Hyper-V virtualizes hardware to provide an virtual machine environment. Each virtual machine is an isolated, virtualized computer that can run its own operating system and software. You can run multiple virtual machines on one physical computer.The operating system that runs within a virtual machine is called a guest operating system. You can use Hyper-V Manager to create and manage virtual machines and their resources. 

Hyper-V is designed to enable you to run multiple virtual machines simultaneously on the same physical computer. The main factor that affects how many virtual machines you can run simultaneously is system resources of the physical computer.


----------
**Important** 

You must license the software running on each of the guest virtual machines according to their operating system requirements.

-----------
 


## Uses ##
Client Hyper-V can be used in many ways, for example:

- You can create your own testing environment with a single machine. ITPros and developers can you can create an entire infrastructure, hosted entirely on a laptop or desktop computer. Then, when everything is working correctly, you can export the virtual machines and run them on server running Hyper-V.

- Developers can also use Client Hyper-V to test their software on multiple operating systems. For example, if you have an application that you must test on the Windows 8, Windows 7, and Linux operating systems, you can create three separate virtual machines right on your development computer.

- You can use Client Hyper-V to troubleshoot. You can export a virtual machine from your production environment, open it on your desktop with Client Hyper-V, perform your required troubleshooting, and then export it back into the production environment. Using virtual networking, you can create a multi-machine environment for test/development/demonstration that is secure from affecting the production network.

- Enthusiasts can use it to experiment with other operating systems. Hyper-V makes it very easy to bring up and tear down different operating systems.

- You can use Hyper-V on a laptop for demonstrating older versions of Windows or non-Windows operating systems. 


## What isn’t supported? ##
There are some features included in Hyper-V on server that are not included in Client Hyper-V. These include the following:

- The Remote FX capability to virtualize GPUs 

- Live migration of virtual machines from one host to another

- Hyper-V Replica

- Virtual Fibre Channel

- 32-bit SR-IOV networking

- Shared .vhdx

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

