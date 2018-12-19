---
layout:     post
title:      "Trying to achieve granularity of backups with the Hyper-V VSS Writer"
date:       2009-03-09 01:36:00
categories: hyper-v
---
Another area of feedback on the Hyper-V VSS Writer is that it does not give much by way of granularity beyond the level of the virtual machine. As a result of that, backup applications are stuck to backing up the entire VHD file, which could easily end up being a rather onerous process, expesially if the administrator is backing up to a separate DR site.

 

To work around this, backup vendors have been looking into solutions for browsing/indexing the files in the in the VHD file. In general, the user can mount the VHD as another drive on the host and browse its file system. The way to do this is not available via the UI in **Windows Server 2008 Hyper-V** , but is available via the WMI API. Ben Armstrong has a blog post on doing that via vbscript/powershell over [here](http://blogs.msdn.com/virtual_pc_guy/archive/2008/02/01/mounting-a-virtual-hard-disk-with-hyper-v.aspx). Given this avenue, the first approach is to follow the following steps:

1\. Create VSS snapshot of that involves the VM

2\. Mount the VSS snapshot as a volume on the host

3. Get the VHD residing in the VSS snapshot

4\. Mount the VHD as drive on the physical machine

5\. Go to town on the files residing in the VHD.

 

Problem with the steps above is that #4 fails due to the fact that the snapshot volume is a read-only volume and the WMI API for mounting VHDs tries to mount it in RW mode. So, we add a step 3a to the sequence and modify step 4 slightly. Here is the updated sequence:

 

1\. Create VSS snapshot of that involves the VM

2\. Mount the snapshot as a volume on the host

3. Get the VHD residing in the VSS snapshot

 **3a. Create a differencing disk on a physical volume with the VHD in the VSS snapshot as the parent disk**

 **4\. Mount the VHD created above as drive on the physical machine**

5\. Go to town on the files residing in the VHD.

 

since the differencing disk sits on a RW volume, the Mount API will succeed, while keeping the VHD in the snapshot unaffected. The backup application can now browse/index the files inside volume residing in the VHD at will and allow for a more granular and thus optimized backup experience for the user. 

 

 _There are some important caveats to keep in mind about this approach_ :

1.       While this approach allows for granular backup of specific files inside a virtual machine, the onus for ensuring the right files are available upon restore rests on the backup application as well. So, the backup application will need to do a similar process of mounting the VHD and copying down the right files during the restore process.

2.       If the virtual machine in question has snapshots, this approach is not possible in v1 it is not possible for a user or a third-party application to create a differencing disk off a snapshot VHD file (ie: a .avhd file). If the virtual machine has snapshots, the backup application will need to copy the VHD and avhd files to RW media before mounting the avhd files in the physical machine. Additionally, the backup application will need to know the latest snapshot in the snapshot tree. 

3.       In **Windows Server 2008 R2** , VHD files can be mounted in RO mode using the native disk management APIs. Thus, there is no need to create differencing disks anymore and the VHDs (as well as AVHDs) can be mounted directly from the snapshot volume.
