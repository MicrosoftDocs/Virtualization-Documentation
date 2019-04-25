---
title:      "Hyper-V Replica BPA Rules"
date:       2013-10-01 05:26:00
categories: hvr
---
A frequent question from our customers is on whether there are standard “best practices” when deploying Hyper-V Replica (or any Windows Server role for that matter). These questions come in many avatars - Does the Product Group have any configuration gotchas based on internal testing, is my server properly configured, should I change any replication configuration etc.

**Best Practices Analyzer (BPA)** is a powerful inbox tool which scans the server for any potential ‘best practice’ violations. The report describes the problem and also provides recommendation to fix the issue. You can use the BPA both from UI as well as PowerShell.

From the Server Manager Dashboard, click on **Hyper-V,** scroll down to the **Best Practices Analyzer** option, click on **Tasks** , followed by **Start BPA Run**

[![BPA_3](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/2313.BPA_3_thumb_7E7DF293.png)](https://msdnshared.blob.core.windows.net/media/TNBlogsFS/prod.evol.blogs.technet.com/CommunityServer.Blogs.Components.WeblogFiles/00/00/00/50/45/metablogapi/1057.BPA_3_2D411A85.png)

Once the scan is complete, you can filter the issues based on Warning or Errors, Excluded Results, Compliant Results.

The same can be done through PowerShell by executing the following cmdlets
    
    
    Invoke-BpaModel -ModelId Microsoft/Windows/Hyper-V
    
    
     
    
    
    Get-BpaResult -ModelId Microsoft/Windows/Hyper-V

To filter non-compliant rules, issue the following cmdlet
    
    
    Get-BpaResult -ModelId Microsoft/Windows/Hyper-V -Filter Noncompliant

In a Windows Server 2012 server, the following rules constitute the Hyper-V BPA. The Hyper-V Replica specific rules are between rules 37-54. 

RuleId Title   
\------ -----   
3 The Hyper-V Virtual Machine Management Service should be configured to start automatically   
4 Hyper-V should be the only enabled role   
5 The Server Core installation option is recommended for servers running Hyper-V   
6 Domain membership is recommended for servers running Hyper-V   
7 Avoid pausing a virtual machine   
8 Offer all available integration services to virtual machines   
9 Storage controllers should be enabled in virtual machines to provide access to attached storage   
10 Display adapters should be enabled in virtual machines to provide video capabilities   
11 Run the current version of integration services in all guest operating systems   
12 Enable all integration services in virtual machines   
13 The number of logical processors in use must not exceed the supported maximum   
14 Use RAM that provides error correction   
15 The number of running or configured virtual machines must be within supported limits   
16 Second-level address translation is required when running virtual machines enabled for RemoteFX   
17 At least one GPU on the physical computer should support RemoteFX and meet the minimum requirements for DirectX when virtual machines are configured with a RemoteFX 3D video adapter   
18 Avoid installing RemoteFX on a computer that is configured as an Active Directory domain controller   
19 Use at least SMB protocol version 3.0 for file shares that store files for virtual machines.   
20 Use at least SMB protocol version 3.0 configured for continuous availability on file shares that store files for virtual machines.   
37 A Replica server must be configured to accept replication requests   
38 Replica servers should be configured to identify specific primary servers authorized to send replication traffic   
39 Compression is recommended for replication traffic   
40 Configure guest operating systems for VSS-based backups to enable application-consistent snapshots for Hyper-V Replica   
41 Integration services must be installed before primary or Replica virtual machines can use an alternate IP address after a failover   
42 Authorization entries should have distinct tags for primary servers with virtual machines that are not part of the same security group.   
43 To participate in replication, servers in failover clusters must have a Hyper-V Replica Broker configured   
44 Certificate-based authentication is recommended for replication.   
45 Virtual hard disks with paging files should be excluded from replication   
46 Configure a policy to throttle the replication traffic on the network   
47 Configure the Failover TCP/IP settings that you want the Replica virtual machine to use in the event of a failover   
48 Resynchronization of replication should be scheduled for off-peak hours   
49 Certificate-based authentication is configured, but the specified certificate is not installed on the Replica server or failover cluster nodes   
50 Replication is paused for one or more virtual machines on this server   
51 Test failover should be attempted after initial replication is complete   
52 Test failovers should be carried out at least monthly to verify that failover will succeed and that virtual machine workloads will operate as expected after failover   
53 VHDX-format virtual hard disks are recommended for virtual machines that have recovery history enabled in replication settings   
54 Recovery snapshots should be removed after failover   
55 At least one network for live migration traffic should have a link speed of at least 1 Gbps   
56 All networks for live migration traffic should have a link speed of at least 1 Gbps   
57 Virtual machines should be backed up at least once every week   
58 Ensure sufficient physical disk space is available when virtual machines use dynamically expanding virtual hard disks   
59 Ensure sufficient physical disk space is available when virtual machines use differencing virtual hard disks   
60 Avoid alignment inconsistencies between virtual blocks and physical disk sectors on dynamic virtual hard disks or differencing disks   
61 VHD-format dynamic virtual hard disks are not recommended for virtual machines that run server workloads in a production environment   
62 Avoid using VHD-format differencing virtual hard disks on virtual machines that run server workloads in a production environment.   
63 Use all virtual functions for networking when they are available   
64 The number of running virtual machines configured for SR-IOV should not exceed the number of virtual functions available to the virtual machines   
65 Configure virtual machines to use SR-IOV only when supported by the guest operating system   
66 Ensure that the virtual function driver operates correctly when a virtual machine is configured to use SR-IOV   
67 Configure the server with a sufficient amount of dynamic MAC addresses   
68 More than one network adapter should be available   
69 All virtual network adapters should be enabled   
70 Enable all virtual network adapters configured for a virtual machine   
72 Avoid using legacy network adapters when the guest operating system supports network adapters   
73 Ensure that all mandatory virtual switch extensions are available   
74 A team bound to a virtual switch should only have one exposed team interface   
75 The team interface bound to a virtual switch should be in default mode   
76 VMQ should be enabled on VMQ-capable physical network adapters bound to an external virtual switch   
77 One or more network adapters should be configured as the destination for Port Mirroring   
78 One or more network adapters should be configured as the source for Port Mirroring   
79 PVLAN configuration on a virtual switch must be consistent   
80 The WFP virtual switch extension should be enabled if it is required by third party extensions   
81 A virtual SAN should be associated with a physical host bus adapter   
82 Virtual machines configured with a virtual Fibre Channel adapter should be configured for high availability to the Fibre Channel-based storage   
83 Avoid enabling virtual machines configured with virtual Fibre Channel adapters to allow live migrations when there are fewer paths to Fibre Channel logical units (LUNs) on the destination than on the source   
106 Avoid using snapshots on a virtual machine that runs a server workload in a production environment   
107 Configure a virtual machine with a SCSI controller to be able to hot plug and hot unplug storage   
108 Configure SCSI controllers only when supported by the guest operating system   
109 Avoid configuring virtual machines to allow unfiltered SCSI commands   
110 Avoid using virtual hard disks with a sector size less than the sector size of the physical storage that stores the virtual hard disk file   
111 Avoid configuring a child storage resource pool when the directory path of the child is not a subdirectory of the parent   
112 Avoid mapping one storage path to multiple resource pools.   


Go ahead and run the BPA, you might learn something interesting from the non-compliant rules! Fix the errors which are reported as part of the non-compliant rules and re-run the rules. The BPA scan is non-intrusive and should not impact your production workload.
