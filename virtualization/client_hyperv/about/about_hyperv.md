ms.ContentId: 5451dd5e-31b8-4aa7-88ee-78576fd2c6b8
title: About Hyper-V

# An Introduction to Hyper-V

 Whether you are a software developer, an IT administrator, or simply an enthusiast, many of you need to run multiple operating systems, usually on many different machines. Not all of us have access to a full suite of labs to house all these machines, and so virtualization can be a space and time saver.
 
 Hyper-V enables developers to easily maintain multiple test environments and provides a simple mechanism to quickly switch between these environments without incurring additional hardware costs. For example, we release pre-configured virtual machines containing old versions of Internet Explorer to support web developers. The IT administrator gets the additional benefit of virtual machine parity and a common management experience across Hyper-V in Windows Server and Windows Client. We also know that many of you use virtualization to try out new things without risking changes to the PC you are actively using.

## System Requirements

Hyper-V requires a 64-bit system that has Second Level Address Translation (SLAT). SLAT is a feature present in the current generation of 64-bit processors by Intel & AMD. You’ll also need a 64-bit version of Windows 8 or greater, and at least 4GB of RAM. Hyper-V does support creation of both 32-bit and 64-bit operating systems in the VMs.

Hyper-V’s dynamic memory allows memory needed by the VM to be allocated and de-allocated dynamically (you specify a minimum and maximum) and share unused memory between VMs. You can run 3 or 4 VMs on a machine that has 4GB of RAM but you will need more RAM for 5 or more VMs. On the other end of the spectrum, you can also create large VMs with 32 processors and 512GB RAM.

## Connecting to a Virtual Machine

As for user experience with VMs, Windows provides two mechanisms to peek into the Virtual Machine: the VM Console and the Remote Desktop Connection.

The VM Console (also known as VMConnect) is a console view of the VM. It provides a single monitor view of the VM with resolution up to 1600x1200 in 32-bit color. This console provides you with the ability to view the VM’s booting process.

For a richer experience, you can connect to the VM using the Remote Desktop Connection (RDC). With RDC, the VM takes advantage of capabilities present on your physical PC. For example, if you have multiple monitors, then the VM can show its graphics on all these monitors. Similarly, if you have a multipoint touch-enabled interface on your PC, then the VM can use this interface to give you a touch experience. The VM also has full multimedia capability by leveraging the physical system’s speakers and microphone. The Root OS (i.e. the main Windows OS that’s managing the VMs) can also share its clipboard and folders with the VMs. And finally, with RDC, you can also attach any USB device directly to the VM.

## Virtual Machine Data
For storage, you can add multiple hard disks to the IDE or SCSI controllers available in the VM. You can use Virtual Hard Disks (.VHD or .VHDX files) or actual disks that you pass directly through to the virtual machine. VHDs can also reside on a remote file server, making it easy to maintain and share a common set of predefined VHDs across a team.

Hyper-V’s “Live Storage Move” capability helps your VMs to be fairly independent of the underlying storage. With this, you could move the VM’s storage from one local drive to another, to a USB stick, or to a remote file share without needing to stop your VM. I’ve found this feature to be quite handy for fast deployments: when I need a VM quickly, I start one from a VM library maintained on a file share and then move the VM’s storage to my local drive.

## Save the current Virtual Machine state
Another great feature of Hyper-V is the ability to take snapshots of a virtual machine while it is running. A snapshot saves everything about the virtual machine allowing you to go back to a previous point in time in the life of a VM, and is a great tool when trying to debug tricky problems. At the same time, Hyper-V virtual machines have all of the manageability benefits of Windows. Windows Update can patch Hyper-V components, so you don’t need to set up additional maintenance processes. And Windows has all the same inherent capabilities with Hyper-V installed.

## Footnotes
Having said this, using virtualization has its limitations. Features or applications that depend on specific hardware will not work well in a VM. For example, Windows BitLocker and Measured Boot, which rely on TPM (Trusted Platform Module), might not function properly in a VM, and games or applications that require processing with GPUs (without providing software fallback) might not work well either. Also, applications relying on sub 10ms timers, i.e. latency-sensitive high-precision apps such as live music mixing apps, etc. could have issues running in a VM. The root OS is also running on top of the Hyper-V virtualization layer, but it is special in that it has direct access to all the hardware. This is why applications with special hardware requirements continue to work unhindered in the root OS but latency-sensitive, high-precision apps could still have issues running in the root OS.

As a reminder, you will still need to license any operating systems you use in the VMs.
