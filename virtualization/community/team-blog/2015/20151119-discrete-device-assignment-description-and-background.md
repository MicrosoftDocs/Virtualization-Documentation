---
title:      "Discrete Device Assignment -- Description and background"
date:       2015-11-19 13:27:30
categories: dda
---
With Windows Server 2016, we're introducing a new feature, called Discrete Device Assignment, in Hyper-V.  Users can now take some of the PCI Express devices in their systems and pass them through directly to a guest VM.  This is actually much of the same technology that we've used for SR-IOV networking in the past.  And because of that, instead of giving you a lot of background on how this all works, I'll just point to an excellent series of posts that John Howard did a few years ago about SR-IOV when used for networking.

[Everything you wanted to know about SR-IOV in Hyper-V part 1](/b/jhoward/archive/2012/03/12/everything-you-wanted-to-know-about-sr-iov-in-hyper-v-part-1.aspx "Everything you wanted to know about SR-IOV in Hyper-V part 1")

[Everything you wanted to know about SR-IOV in Hyper-V part 2](/b/jhoward/archive/2012/03/13/everything-you-wanted-to-know-about-sr-iov-in-hyper-v-part-2.aspx "Everything you wanted to know about SR-IOV in Hyper-V part 2")

[Everything you wanted to know about SR-IOV in Hyper-V part 3](/b/jhoward/archive/2012/03/14/everything-you-wanted-to-know-about-sr-iov-in-hyper-v-part-3.aspx "Everything you wanted to know about SR-IOV in Hyper-V part 3")

[Everything you wanted to know about SR-IOV in Hyper-V part 4](/b/jhoward/archive/2012/03/15/everything-you-wanted-to-know-about-sr-iov-in-hyper-v-part-4.aspx "Everything you wanted to know about SR-IOV in Hyper-V part 4")

Now I've only linked the first four posts that John Howard did back in 2012 because those were the ones that discussed the internals of PCI Express and distributing actual devices among multiple operating systems.  The rest of his series is mostly about networking, and while I do recommend it, that's not what we're talking about here.

At this point, I have to say that full device pass-through is actually a lot like disk pass-through -- it's a half a solution to a lot of different problems.  We actually built full PCI Express device pass-through in 2009 and 2010 in order to test our hypervisor's handling of an I/O MMU and interrupt delivery before we asked the networking community to write new device drivers targeted at Hyper-V, enabling SR-IOV.

We decided at the time not to put PCIe device pass-through into any shipping product because we would have had to make a lot of compromises in the virtual machines that used them -- disabling Live Migration, VM backup, saving and restoring of VMs, checkpoints, etc.  Some of those compromises aren't necessary any more.  Production checkpoints now work entirely without needing to save the VM's RAM or virtual processor state, for instance. 

But even more than these issues, we decided to forgo PCIe device pass-through because it was difficult to prove that the system would be secure and stable once a guest VM had control of the device.  Security conferences are full of papers describing attacks on hypervisors, and allowing an attacker's code control of a PCI Express "endpoint" just makes that a lot easier, mostly in the area of Denial of Service attacks.  If you can trigger an error on the PCI Express bus, most physical machines will either crash or just go through a hard reset.

Things have changed some since 2012, though, and we're getting many requests to allow full-device pass-through.  First, it's far more common now for there to be VMs running on a system which constitute part of the hoster or IT admin's infrastructure.  These "utility VMs" run anything from network firewalls to storage appliances to connection brokers.  And since they're part of the hosting fabric, they are often more trusted than VMs running outward-facing workloads supplied by users or tenants.

On top of that, Non-Volatile Memory Express (NVMe) is taking off.  SSDs attached via NVMe can be many times faster than SSDs attached through SATA or SAS.  And until there's a full specification on how to do SR-IOV with NVMe, the only choice if you want full performance in a storage appliance VM is to pass the entire device through.

Windows Server 2016 will allow NVMe devices to be assigned to guest VMs.  We still recommend that these VMs only be those that are under control of the same administration team that manages the host and the hypervisor.

GPUs (graphics processors) are, similarly, becoming a must-have in virtual machines.  And while what most people really want is to slice up their GPU into lots of slivers and let VMs share them, you can use Discrete Device Assignment to pass them through to a VM.  GPUs are complicated enough, though, that a full support statement must come from the GPU vendor.  More on GPUs in a future blog post.

Other types of devices may work when passed through to a guest VM.  We've tried a few USB 3 controllers, RAID/SAS controllers, and sundry other things.  Many will work, but none will be candidates for official support from Microsoft, at least not at first, and you won't be able to put them into use without overriding warning messages.  Consider these devices to be in the "experimental" category.  More on which devices can work in a future blog post.

##   
Switching it all On

Managing the underlying hardware of your machine is complicated, and can quickly get you in trouble. Furthermore, we’re really trying to address the need to pass NVMe devices though to storage appliances, which are likely to be configured by people who are IT pros and want to use scripts. So all of this is only available through PowerShell, with nothing in the Hyper-V Manager. What follows is a PowerShell script that finds all the NVMe controllers in the system, unloads the default drivers from them, dismounts them from the management OS and makes them available in a pool for guest VMs.

# get all devices which are NVMe controllers

$pnpdevs = Get-PnpDevice -PresentOnly | Where-Object {$_.Class -eq "SCSIAdapter"} | Where-Object {$_.Service -eq "stornvme"}

 

# cycle through them disabling and dismounting them

foreach ($pnpdev in $pnpdevs) {

       disable-pnpdevice -InstanceId $pnpdev.InstanceId -Confirm:$false

       $locationpath = ($pnpdev | get-pnpdeviceproperty DEVPKEY_Device_LocationPaths).data[0]

       dismount-vmhostassignabledevice -locationpath $locationpath

       $locationpath

}

Depending on whether you’ve already put your NVMe controllers into use, you might actually have to reboot between disabling them and dismounting them. But after you have both disabled (removed the drivers) and dismounted (taken them away from the management OS) you should be able to find them all in a pool. You can, of course, reverse this process with the Mount-VMHostAssignableDevice and Enable-PnPDevice cmdlets.

Here’s the output of running the script above on my test machine where I have, alas, only one NVMe controller, followed by asking for the list of devices in the pool:

[jakeo-t620]: PS E:\test> .\dismount-nvme.ps1  
PCIROOT(40)#PCI(0200)#PCI(0000)  
[jakeo-t620]: PS E:\test> Get-VMHostAssignableDevice

  
InstanceID : PCIP\VEN_144D&DEV_A820&SUBSYS_1F951028&REV_03\4&368722DD&0&0010  
LocationPath : PCIROOT(40)#PCI(0200)#PCI(0000)  
CimSession : CimSession: .  
ComputerName : JAKEO-T620  
IsDeleted : False

Now that we have the NVMe controllers in the pool of dismounted PCI Express devices, we can add them to a VM. There are basically three options here, using the InstanceID above, using the LocationPath and just saying “give me any device from the pool.” You can add more than one to a VM. And you can add or remove them at any time, even when the VM is running. I want to add this NVMe controller to a VM called “StorageServer”:

[jakeo-t620]: PS E:\test> Add-VMAssignableDevice -LocationPath "PCIROOT(40)#PCI(0200)#PCI(0000)" -VMName StorageServer

There are similar Remove-VMAssignableDevice and Get-VMAssignableDevice cmdlets.

If you don’t like scripts, the InstanceID can be found as “Device Instance Path” under the Details tab in Device Manager. The Location Path is also under Details. You can disable the device there and then use PowerShell to dismount it.  
Finally, it wouldn’t be a blog post without a screen shot. Here’s Device Manager from that VM, rearranged with “View by Connection” simply because it proves that I’m talking about a VM.

[![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/StorageServer.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/StorageServer.png)

In a future post, I’ll talk about how to figure out whether your machine and your devices support all this.

Read the next post in this series:  [Discrete Device Assignment -- Machines and devices](/b/virtualization/archive/2015/11/20/discrete-device-assignment-machines-and-devices.aspx "Discrete Device Assignment -- Machines and devices")

\-- Jake Oshins
