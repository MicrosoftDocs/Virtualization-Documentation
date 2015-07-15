ms.ContentId: 295275F2-45D0-4177-8635-15C94B54DA8F
title: Hyper-V on Windows 10

# An Introduction to Hyper-V
93EDAAF5-E4FC-4F3F-AB55-669D2BF47D78
Whether you are a software developer, an IT administrator, or simply an enthusiast, many of you need to run multiple operating systems, occasionally on many different machines. Not all of us have access to a full suite of labs to house all these machines, and so virtualization can be a space and time saver.

## Uses 
Virtualization enables anyone to easily maintain multiple test environments consisting of many operating systems, software configurations, and hardware configurations.  Hyper-V provides virtualization on Windows as well as a simple mechanism to quickly switch between these environments without incurring additional hardware costs.    

Hyper-V can be used in many ways, for example:
- A test environment consisting of multiple virtual machines can be created on a single desktop or laptop computer. Once testing has completed, these virtual machines can be exported and then imported into any other Hyper-V system.

- Developers can use Hyper-V on their computer to test software on multiple operating systems. For example, if you have an application that must be tested on Windows 8, Windows 7 and a Linux operating system, multiple virtual machines can be created on your development system, one containing each of these operating systems.

- You can use Hyper-V to troubleshoot virtual machines from any Hyper-V deployment. You can export a virtual machine from your production environment, open it on your desktop running Hyper-V, perform your required troubleshooting, and then export it back into the production environment. 

- Using virtual networking, you can create a multi-machine environment for test/development/demonstration that is secure from affecting the production network.

- Enthusiasts can use it to experiment with other operating systems. Hyper-V makes it very easy to bring up and tear down different operating systems.

- You can use Hyper-V on a laptop for demonstrating older versions of Windows or non-Windows operating systems. 


## System requirements

Hyper-V requires a 64-bit system that has Second Level Address Translation (SLAT). SLAT is a feature present in the current generation of 64-bit processors by Intel & AMD. You’ll also need a 64-bit version of Windows 8 or greater, and at least 4GB of RAM. Hyper-V does support creation of both 32-bit and 64-bit operating systems in the VMs.

Hyper-V’s dynamic memory allows memory needed by the VM to be allocated and de-allocated dynamically (you specify a minimum and maximum) and share unused memory between VMs. You can run 3 or 4 VMs on a machine that has 4GB of RAM but you will need more RAM for 5 or more VMs. On the other end of the spectrum, you can also create large VMs with 32 processors and 512GB RAM, depending on your physical hardware.

## Connecting to a virtual machine

As for user experience with VMs, Windows provides two mechanisms to peek into the Virtual Machine: the VM Console and the Remote Desktop Connection.

The VM Console (also known as VMConnect) is a console view of the VM. It provides a single monitor view of the VM with resolution up to 1600x1200 in 32-bit color. This console provides you with the ability to view the VM’s booting process.

For a richer experience, you can connect to the VM using the Remote Desktop Connection (RDC). With RDC, the VM takes advantage of capabilities present on your physical PC. For example, if you have multiple monitors, then the VM can show its graphics on all these monitors. Similarly, if you have a multipoint touch-enabled interface on your PC, then the VM can use this interface to give you a touch experience. The VM also has full multimedia capability by leveraging the physical system’s speakers and microphone. The Root OS (i.e. the main Windows OS that’s managing the VMs) can also share its clipboard and folders with the VMs. And finally, with RDC, you can also attach any USB device directly to the VM.

## Virtual machine data
For storage, you can add multiple hard disks to the IDE or SCSI controllers available in the VM. You can use Virtual Hard Disks (.VHD or .VHDX files) or actual disks that you pass directly through to the virtual machine. VHDs can also reside on a remote file server, making it easy to maintain and share a common set of predefined VHDs across a team.

Hyper-V’s “Live Storage Move” capability helps your VMs to be fairly independent of the underlying storage. With this, you could move the VM’s storage from one local drive to another, to a USB stick, or to a remote file share without needing to stop your VM. I’ve found this feature to be quite handy for fast deployments: when I need a VM quickly, I start one from a VM library maintained on a file share and then move the VM’s storage to my local drive.

## Save the current virtual machine state
Another great feature of Hyper-V is the ability to take snapshots of a virtual machine while it is running. A snapshot saves everything about the virtual machine allowing you to go back to a previous point in time in the life of a VM, and is a great tool when trying to debug tricky problems. At the same time, Hyper-V virtual machines have all of the manageability benefits of Windows. Windows Update can patch Hyper-V components, so you don’t need to set up additional maintenance processes. And Windows has all the same inherent capabilities with Hyper-V installed.

## Footnotes
Having said this, using virtualization has its limitations. Features or applications that depend on specific hardware will not work well in a VM. For example, Windows BitLocker and Measured Boot, which rely on TPM (Trusted Platform Module), might not function properly in a VM, and games or applications that require processing with GPUs (without providing software fallback) might not work well either. Also, applications relying on sub 10ms timers, i.e. latency-sensitive high-precision apps such as live music mixing apps, etc. could have issues running in a VM. The root OS is also running on top of the Hyper-V virtualization layer, but it is special in that it has direct access to all the hardware. This is why applications with special hardware requirements continue to work unhindered in the root OS but latency-sensitive, high-precision apps could still have issues running in the root OS.

As a reminder, you will still need to license any operating systems you use in the VMs.


## What isn’t supported?
There are some features included in Hyper-V on server that are not included in Hyper-V on Windows. These include the following:

- The Remote FX capability to virtualize GPUs 

- Live migration of virtual machines from one host to another

- Hyper-V Replica

- Virtual Fibre Channel

- SR-IOV networking

- Shared .VHDX

-----
**Warning**  
Virtual machines running on Hyper-V do not automatically handle moving from a wired to a wireless connection. You must change the virtual machines network adapter settings manually.
 
------

## Differences between Hyper-V on Windows and Hyper-V on Windows Sertver
There are some features that work differently in Hyper-V on Windows than they do Hyper-V running on Windows Server. These include the following:

- The memory management model is different for Hyper-V on Windows. On a server, Hyper-V memory is managed with the assumption that only the virtual machines are running on the server. In Hyper-V on Windows, memory is managed with the understanding most client machines are running software in addition to running virtual machines. For example, a developer might be running Visual Studio as well as several virtual machines on the same computer.

- SR-IOV on a 64-bit guest works normally, but 32-bit does not and is not supported.

For more information, see this [article on SKU differences](./SKUDifferences.md).

## Supported Guest Operating Systems ##
For a list of supported guest operating systems, see [Supported Windows Guest Operating Systems](supported_guest_os.md). 

For supported Linux distributions as a guest operating systems on Hyper-V, see [Linux and FreeBSD Virtual Machines on Hyper-V](https://technet.microsoft.com/library/dn531030.aspx).


Next step: [Walkthrough Hyper-V on Windows 10](..\quick_start\walkthrough.md) 

