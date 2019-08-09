---
title:      "System Center Virtual Machine Manager 2008 R2 - Quick Storage Migration"
date:       2009-06-25 09:30:00
categories: hyper-v
---
Hi, I'm Edwin Yuen, a Senior Technical Product Manager at Microsoft's Integrated Virtualization team. In today's blog, I'd like to discuss another type of migration being added to System Center Virtual Machine Manager 2008 R2, Quick Storage Migration. 

**Quick Storage Migration (QSM) In Brief**

As you may have seen, we recently released the Release Candidate for System Center Virtual Machine Manager 2008 R2. One of the most anticipated features of SCVMM 2008 R2 is Quick Storage Migration (QSM) which enables the migration of the storage of VM from one location to another. For example, suppose you have virtual machines on a leased SAN (SAN 1). The lease runs out and you decide to upgrade to a new SAN (SAN 2) with more capacity, better performance and additional capabilities. Quick Storage Migration allows you to move the virtual machine which resides on SAN 1 to SAN 2. I have had a number of request for more details on how this works so we've written this brief guide to QSM. (In addition, we wanted to make this technology **broadly available** , not just the biggest enterprises. More on that below.) 

QSM relies on Windows Server 2008 R2 Hyper-V and Background Intelligent Transfer Service (BITS). QSM can move the virtual disks of a running virtual machine independent of storage protocols (iSCSI, FC) or storage type (local, DAS, SAN), with minimal downtime. 

**QSM Is One of Many Migration Technologies Supported in Virtual Machine Manager's Portfolio**

**VM Migration Type**

| 

**Platforms available on**

| 

**Technology used for transfer**

| 

**Expected downtime for VM**  
  
---|---|---|---  
  
**Live Migration**

| 

  * Hyper-V   
(2008 R2) 
  * ESX 3.0, 3.5

| 

  * Windows Server 2008 Failover Cluster 
  * Hyper-V 
  * vMotion for ESX

| 

**None**

  * No service interruption while virtual machine is moved

  
  
**Quick Migration**

| 

  * Hyper-V

| 

  * Windows Server 2008 Failover Cluster 
  * Hyper-V

| 

**Under 1 minute in most cases**

  * VM is put into save-state while it is moved from one cluster node to another using the cluster failover mechanism

  
  
**SAN Migration**

| 

  * Virtual Server 
  * Hyper-V

| 

  * Windows Server 2008 Hyper-V and Virtual Disk Service (VDS) Hardware Providers 
  * N-Port Identification Virtualization (NPIV) on Emulex and QLogic Fibre Channel HBAs 
  * iSCSI on EMC, HP, Hitachi, NetApp, EquiLogic arrays

| 

**Under 1 minute in most cases**

  * VM is put into save-state while it is moved from one virtual machine host to another using unmasking and masking operations at the SAN level

  
  
**Network based migration**

**(aka LAN migration)  
**

| 

  * Virtual Server 
  * Hyper-V 
  * ESX

| 

  * BITS for Virtual Server and Hyper-V 
  * sFTP for ESX

| 

**Minutes to hours (W2K8, W2K3 hosts)**

  * VM needs to be stopped or in saved state for the entire duration of transfer 



**Under 1 minute in most cases (W2K8 R2)**

  * VM can remain running for the almost entire duration of the transfer of its virtual disks from once storage location to another 
  * VM is put into save-state for a brief interval to migrate its memory state and associated differencing disks.

  
  
**Storage Migration Type**

| 

**Platforms available on**

| 

**Technology used for transfer**

| 

**Expected downtime**  
  
---|---|---|---  
  
**Storage vMotion**

| 

  * ESX 3.5

| 

  * Storage vMotion

| 

**None**

  * No perceived service interruption while the virtual disks associated with a virtual machine are moved from storage location to another

  
  
**Quick Storage Migration**

| 

  * Hyper-V  
(2008 R2) 

| 

  * BITS and Hyper-V

| 

**Under 1 minute in most cases (W2K8 R2)** ****

  * VM can remain running for the almost the entire duration of the transfer of its virtual disks from once storage location to another 
  * VM is put into save-state for a brief interval to migrate its memory state and associated differencing disks. 

  
  
### 

Note on Processor Compatibility Mode: 

To increase the mobility of a running virtual machine across hosts with different processor versions (with in the same processor family), Windows Server 2008 R2 Hyper-V offers Processor Compatibility Mode. This feature masks processor feature differences between the source and destination hosts. With this enabled, you can migrate a virtual machine from a host with Pentium 4 VT processors to a host with Nehalem processors. Processor Compatibility Mode does **not** require advanced processor features like Intel VT Flex Migration or AMD-V Extended Migration. For more on Processor Compatibility Mode, check out Jeff's Blog a few weeks ago where he goes into detail [here](http://blogs.technet.com/virtualization/archive/2009/05/12/tech-ed-windows-server-2008-r2-hyper-v-news.aspx).

**How QSM Works**

QSM uses native Windows platform technologies: Hyper-V and BITS. There are 2 scenarios of interest: 

_**Scenario 1: VM Storage Migration: VM Compute Stays on the Same Server and the VM Storage Migrates from One Storage to Another**_

1\. In the SCVMM console, a new action labeled Storage Migration is now available.

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/SystemCenterVirtualMachineManager2008R2Q_B002/image_thumb.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/SystemCenterVirtualMachineManager2008R2Q_B002/image_2.png)

 

2\. When the user right-clicks on a running virtual machine and selects the **_Migrate Storage_** action, a wizard is presented. The user provides the path to the new location to be used by the VM. If all the VMs files (configuration and VHD files) are to be placed in a single location the user has only to provide the " ** _Virtual Machine Path_** ". If one or more VHD files for the VM need to be placed at a separate location, the user can explicitly change the location of each VHD by selecting it from the list under " ** _Disks_** " and clicking the "Browse" button next to it to specify the path for the VHD.

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/SystemCenterVirtualMachineManager2008R2Q_B002/image_thumb_1.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/SystemCenterVirtualMachineManager2008R2Q_B002/image_4.png)

 

 

3\. SCVMM takes a Hyper-V snapshot of the running virtual machine. This will create a differencing disk for each VHD connected to the VM. All disk write operations from that point forward go into the differencing disk. The original base VHD is no longer changing since it is in a read-only state. 

4\. With the base VHD in a read-only state, SCVMM starts to transfer the file from the source location to the target location using BITS. This represents the bulk of the data that needs to be transferred and the VM remains running during this transfer. In addition, QSM does not depend on storage types, and the user is free to select any storage destination that is accessible to the Hyper-V host. 

5\. Once the base VHD is transferred, the virtual machine is put into " ** _Saved State_** ". 

6\. In " ** _Saved State_** ", SCVMM can transfer the differencing disk created by the snapshot and memory associated with the " ** _Saved State_** " to the destination location for the VM. 

7\. Once all the files are transferred, SCVMM exports and then re-imports the virtual machine on the same Hyper-V host with any necessary modifications to the configuration. 

8\. The snapshot created on step 3 is merged back into the base VHDs 

9\. Virtual machine is re-started from saved state 

10\. Job completes 

11\. The diagram below illustrates the steps performed by QSM on a Hyper-V R2 host.

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/SystemCenterVirtualMachineManager2008R2Q_B002/image_thumb_2.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/SystemCenterVirtualMachineManager2008R2Q_B002/image_6.png)

**_Scenario 2: VM Migration (Relocation): VM Compute Moves to a News Server AND VM Storage Moves from One Storage to Another_**

1\. In the SCVMM console, the user right-clicks on a running virtual machine and selects the Migrate action, a wizard is presented to help with the migration. The Migrate action initiates the migration of a VM from one host to another host. As part of the VM migration, all of the VMs files are moved to storage that is attached to the destination host. Storage Migration technology enhances the experience by allowing the move for a running virtual machine and limiting the down time of the VM to just the window required to move the save state files (as explained below).

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/SystemCenterVirtualMachineManager2008R2Q_B002/image_thumb_3.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/SystemCenterVirtualMachineManager2008R2Q_B002/image_8.png)

2\. The user first selects the destination host based on the desired star rating presented by Intelligent Placement. The user then provides a destination folder for the configuration file and the associated virtual disks. By default, the wizard will put all disks in the same location as the configuration file. After completing the wizard, the migration job is submitted.

[![image](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/SystemCenterVirtualMachineManager2008R2Q_B002/image_thumb_4.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/BlogFileStorage/blogs_technet/virtualization/WindowsLiveWriter/SystemCenterVirtualMachineManager2008R2Q_B002/image_10.png)

3\. SCVMM creates a placeholder virtual machine on the destination host. The virtual machine is not powered on so there is no need to reserve CPU or memory resources at this time. Intelligent placement has already accounted for the impact on the destination host of the VM being migrated.

4\. SCVMM takes a Hyper-V snapshot of the running virtual machine. This will create a differencing disk for each VHD connected to the VM. All disk write operations from that point forward go into the differencing disk. The original base VHD is no longer changing since it is in a read-only state. 

5\. With the base VHD in a read-only state, SCVMM starts to transfer the file from the storage location on the source host to a storage location on the target host using BITS. Since QSM does not depend on storage protocols or storage types, the user is free to select any storage destination as long as the Hyper-V can access it. 

6\. Once the base VHDs are transferred, the virtual machine is put into Saved State.  
In Saved State, SCVMM can transfer the differencing disks created by the snapshot and associated memory state. 

7\. Once all the files are transferred, SCVMM exports the virtual machine and transfers the exported virtual machine configuration to the target host and then imports the virtual machine to Hyper-V host with any necessary modifications to the configuration. 

8\. The snapshots are merged back into the base VHDs as part of the import process. 

9\. Virtual machine is started from saved state 

10\. Job completes

**How QSM Compares To VMware Storage VMotion**

  | 

**VMM 2008 R2 +** **Windows Server 2008 R2 Hyper-V**

| 

**VMware** **(vCenter 2.5 + ESX 3.5)**  
  
---|---|---  
  
Migration of virtual machines across two hosts with independent storage

| 

**Supported**

| 

Not Supported  
  
Migration of virtual machines with snapshots

| 

**Supported**

| 

Not Supported  
  
Migration of Virtual machine with Virtual Disks

| 

**Supported**

| 

Supported (persistent mode)  
  
Requires sufficient resources to support two instances of the virtual machines running concurrently

| 

**Not Required**

| 

Required  
  
Additional Licensed Required

| 

**None**

| 

VMotion License  
  
Number of concurrent storage Migrations allowed

| 

**10**

| 

4  
  
Storage Migrations supported in the Administrator Console

| 

**Yes (QSM and Storage vMotion)**

| 

No  
  
Storage Migrations supported in the CLI

| 

**Yes (QSM and Storage vMotion)**

| 

Yes  
  
Protocol agnostic

| 

**Yes**

| 

Yes  
  
Support for migrations of VMs and storage between hosts with different processors versions (same manufacturer) 

| 

**Yes (use Hyper-V R2 Processor Compatibility Mode to increase the number of compatible hosts )**

| 

Not Applicable  
  
**Microsoft: Driving Down Costs**

One thing our customers have been telling us loud and clear is that they are very, very happy [we are offering Live Migration for FREE with Hyper-V R2](http://blogs.technet.com/virtualization/archive/2009/05/06/microsoft-hyper-v-server-2008-r2-release-candidate-free-live-migration-ha-anyone.aspx) **.** With Quick Storage Migration, we knew we had another opportunity to drive down the costs for storage migration capability that has been largely priced out of the reach of most customers. Specifically, VMware Storage VMotion is only available in their Enterprise/Enterprise Plus SKUs ( **$2875 & $3495 per processor respectively**). Contrast this with the fact that Quick Storage Migration is **included** with System Center Virtual Machine Manager 2008 R2 both the Enterprise Edition **and** the Workgroup Edition which will be available for starting at about $500.

For a small five node cluster consisting of two and four processors servers, that would cost at a minimum:

  | 

**Virtual Machine R2 QSM**

| 

**VMware**  
  
---|---|---  
Three Nodes;  
Two Processor Servers | 

~$500

| 

$11,500  
  
Five Nodes;  
Two Processor Servers | 

~$500

| 

$28,750  
  
Five Nodes  
Four Processor Servers | 

~$500

| 

$57,500  
  
That's customer focus.

Cheers,

_Edwin Yuen_

_Sr. Technical Product Manager_
