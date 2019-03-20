---
title:      "Looking at the Hyper-V Event Log (January 2018 edition)"
date:       2018-01-23 22:57:01
categories: debugging
---
Hyper-V has changed over the last few years and so has our event log structure. With that in mind, here is an update of [Ben's original post in 2009](https://blogs.msdn.microsoft.com/virtual_pc_guy/2009/02/03/looking-at-the-hyper-v-event-log/) ("Looking at the Hyper-V Event Log"). This post gives a short overview on the different Windows event log channels that Hyper-V uses. It can be used as a reference to better understand which event channels might be relevant for different purposes. As a general guidance you should **start with the Hyper-V-VMMS and Hyper-V-Worker** event channels when analyzing a failure. For migration-related events it makes sense to look at the event logs both on the source and destination node.  [![Windows Event Viewer showing the Hyper-V-VMMS Admin log](https://msdnshared.blob.core.windows.net/media/2018/01/2018-01-02-6-454x350.png)](https://msdnshared.blob.core.windows.net/media/2018/01/2018-01-02-6.png) Below are the current event log channels for Hyper-V. Using "Event Viewer" you can find them under "Applications and Services Logs", "Microsoft", "Windows". If you would like to collect events from these channels and consolidate them into a single file, we've published a [HyperVLogs PowerShell module](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/live/hyperv-tools/HyperVLogs) to help.  Event Channel Category | Description  
---|---  
Hyper-V-Compute | Events from the [Host Compute Service (HCS)](https://blogs.technet.microsoft.com/virtualization/2017/01/27/introducing-the-host-compute-service-hcs/) are collected here. The HCS is a low-level management API.  
Hyper-V-Config | This section is for anything that relates to virtual machine configuration files. If you have a missing or corrupt virtual machine configuration file – there will be entries here that tell you all about it.  
Hyper-V-Guest-Drivers | Look at this section if you are experiencing issues with VM integration components.  
Hyper-V-High-Availability | Hyper-V clustering-related events are collected in this section.  
Hyper-V-Hypervisor | This section is used for hypervisor specific events. You will usually only need to look here if the hypervisor fails to start – then you can get detailed information here.  
Hyper-V-StorageVSP | Events from the Storage Virtualization Service Provider. Typically you would look at these when you want to debug low-level storage operations for a virtual machine.  
Hyper-V-VID | These are events form the Virtualization Infrastructure Driver. Look here if you experience issues with memory assignment, e.g. dynamic memory, or changing static memory while the VM is running.  
**Hyper-V-VMMS** |  Events from the virtual machine management service can be found here. When VMs are not starting properly, or VM migrations fail, this would be a good source to start investigating.  
Hyper-V-VmSwitch | These channels contain events from the virtual network switches.  
**Hyper-V-Worker** |  This section contains events from the worker process that is used for the actual running of the virtual machine. You will see events related to startup and shutdown of the VM here.  
Hyper-V-Shared-VHDX | Events specific to virtual hard disks that can be shared between several virtual machines. If you are using shared VHDs this event channel can provide more detail in case of a failure.  
Hyper-V-VMSP | The VM security process (VMSP) is used to provide secured virtual devices like the virtual TPM module to the VM.  
Hyper-V-VfpExt | Events form the Virtual Filtering Platform (VFP) which is part of the Software Defined Networking Stack.  
VHDMP | Events from operations on virtual hard disk files (e.g. creation, merging) go here.  
Please note: some of these only contain analytic/debug logs that need to be enabled separately and not all channels exist on Windows client. To enable the analytic/debug logs, you can use the [HyperVLogs PowerShell module](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/live/hyperv-tools/HyperVLogs). Alles Gute, Lars
