---
title:      "How to install integration services when the virtual machine is not running"
description: How to install integration services when the virtual machine is not running
date:       04/18/2013
categories: hyper-v
author: scooley
ms.author: scooley

---

# How to install integration services when the virtual machine is not running

Update for people running Windows 10, Technical Preview, Server 16 or later: [Read this blog instead ](/virtualization/community/team-blog/2015/20150724-integration-components-available-for-virtual-machines-not-connected-to-windows-update)unless you're here for more detailed steps. \--------------------------- We've been talking to a lot of people about deploying integration services (integration components) lately. As it turns out, they're pretty easy to patch offline with existing Hyper-V tools. First, why would you update integration services on a not-running (offline) VM? Offline VM servicing is valuable for VM templates places that create new VMs frequently since it allows you to keep VM templates up-to-date. While this post targets exclusively integration service updates, the same update approach applies to many updates as well as any configurations specific to the environment. Keeping the VM images fully up to date and configured before they are deployed saves significant setup time and support every time a new VM is created. Here is a detailed write-up about deploying and updating integration services on an offline VM - both VHD/VHDX - using out of box PowerShell tools and a cab (cabinet) file that comes bundled with Server 2008 or later Hyper-V hosts. Before you start, open a PowerShell console **as administrator**. Make sure Hyper-V is installed and you're working from the management (host) OS. The management OS must be Server 2008R2 or newer and more recent than the VM OS you're patching. I tested this script with a Server 2012 host. For default Hyper-V installs, the CAB containing the up-to-date integration components will be located in [HostDrive]:\windows\vmguest\support. From there, choose your architecture; for my machine, I choose amd64. X86 people, you're files are there too. This file contains all of the components built into the VM Guest ISO. To update integration components offline, we're only interested in the two cab files highlighted below. There will be two files: 

  * Windows6.x-HyperVIntegrationServices-x64.cab corresponds with Windows 7 and earlier guests. Tested: Server 2008 R2, Windows 7 (enterprise and enterprise sp1).
  * Windows6.2-HyperVIntegrationServices-x64.cab corresponds with windows 8 and Server 2012 guests. Tested: Server 2012, Windows 8.

_Note: this process only works for Windows 2008R2 / Windows 7 and later operating systems. It works with both vhd and vhdx files._ You will need the path to this file. From here on out I'll refer to it as $integrationServicesCabPath. If you pick the wrong one it will fail a version check without harming the guest.  $integrationServicesCabPath="C:\Windows\vmguest\support\amd64\Windows6.2-HyperVIntegrationServices-x64.cab" [![ ](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0250.shot1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/0250.shot1.png) The next step is to apply the cab to the offline VM. First, you'll need the path to your VM image, I'm going to refer to this as $virtualHardDiskToUpdate. 

$virtualHardDiskToUpdate="D:\client_professional_en-us_vl.vhd"

Next, mount the image as a pass-through disk (unprotected data and direct I/O) and keep track of the disk number returned. $diskNo=(Mount-VHD -Path $ virtualHardDiskToUpdate -Passthru).DiskNumber Check to make sure the operational status is online and find the drive letter so we know which drive to patch. 

(Get-Disk $diskNo).OperationalStatus

$driveLetter=(Get-Disk $diskNo | Get-Partition | Get-Volume).DriveLetter

In my case this returned "online" and "E" (stored in $driveLetter). If you mounted a VM with Windows fully installed, the chances are good it'll mount more than one drive depending on the VMs particular setup. If this is the case, find the drive with all of the Windows OS files - apply the integration service update to that one. If the status returns not online prepare the image by running: 

Set-Disk $diskNo -IsOffline:$false -IsReadOnly:$false

Now the mounted VHD is ready to be patched. 

Add-WindowsPackage -PackagePath $integrationServicesCabPath -Path ($driveLetter+":\")

You should see a blue progress bar at the top of PowerShell. Enjoy watching the little yellow o's fill your screen. If the cab couldn't apply, make sure you're using the right version for your guest OS and the right drive. If the VM is running, it will not patch. Finally, dismount the VHD. Notice you dismount using the image path and not the mounted drive letter. 

Dismount-VHD -Path $virtualHardDiskToUpdate

[![This image is missing.](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/1121.shot2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/1121.shot2.png)

Here's a more reasonable, consolidated, PowerShell Script: 

$virtualHardDiskToUpdate="D:\client_professional_en-us_vl.vhd" $integrationServicesCabPath="C:\Windows\vmguest\support\amd64\Windows6.2-HyperVIntegrationServices-x64.cab"

#Mount the VHD $diskNo=(Mount-VHD -Path $virtualHardDiskToUpdate -Passthru).DiskNumber

#Get the driver letter associated with the mounted VHD, note this assumes it only has one partition if there are more use the one with OS bits $driveLetter=(Get-Disk $diskNo | Get-Partition).DriveLetter

#Check to see if the disk is online if it is not online it if ((Get-Disk $diskNo).OperationalStatus -ne 'Online') {Set-Disk $MountedVHD.Number -IsOffline:$false -IsReadOnly:$false}

#Install the patch Add-WindowsPackage-PackagePath $integrationServicesCabPath -Path ($driveLetter \+ ":\")

#Dismount the VHD Dismount-VHD -Path $virtualHardDiskToUpdate

Thank you to Taylor Brown (<https://blogs.msdn.com/b/taylorb>), for the script! Cheers, Sarah Cooley
