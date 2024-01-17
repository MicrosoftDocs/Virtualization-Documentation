---
title: Port Hyper-V WMIv1 to WMIv2
description: Learn how to port Hyper-V WMIv1 to WMIv2
keywords: windows 10, hyper-v, WMIv1, WMIv2, WMI, Msvm_VirtualSystemGlobalSettingData, root\virtualization 
author: scooley
ms.author: scooley
ms.date: 04/13/2017
ms.topic: article
ms.assetid: b13a3594-d168-448b-b0a1-7d77153759a8
---

# Move from Hyper-V WMI v1 to WMI v2

Windows Management Instrumentation (WMI) is the management interface underlying Hyper-V Manager and Hyper-V's PowerShell cmdlets.  While most people use our PowerShell cmdlets or Hyper-V manager,  sometimes developers needed WMI directly.  

There have been two Hyper-V WMI namespaces (or versions of the Hyper-V WMI API).
* The WMI v1 namespace (root\virtualization) which was introduced in Windows Server 2008 and last available in Windows Server 2012
* The WMI v2 namespace (root\virtualization\v2) which was introduced in Windows Server 2012

This document contains references to resources for converting code that talks to our old WMI namespace to the new one.  Initially, this article will serve as a repository for API information and sample code / scripts that can be used to help port any programs or scripts that use Hyper-V WMI APIs from the v1 namespace to the v2 namespace.

## MSDN Samples

[Hyper-V virtual machine migration sample](https://code.msdn.microsoft.com/windowsdesktop/Hyper-V-virtual-machine-aef356ee)  
[Hyper-V virtual Fiber Channel sample](https://code.msdn.microsoft.com/windowsdesktop/Hyper-V-virtual-Fiber-35d27dcd)  
[Hyper-V planned virtual machines sample](https://code.msdn.microsoft.com/windowsdesktop/Hyper-V-planned-virtual-8c7b7499)  
[Hyper-V application health monitoring sample](https://code.msdn.microsoft.com/windowsdesktop/Hyper-V-application-health-dc0294f2)  
[Virtual hard disk management sample](https://code.msdn.microsoft.com/windowsdesktop/Virtual-hard-disk-03108ed3)  
[Hyper-V replication sample](https://code.msdn.microsoft.com/windowsdesktop/Hyper-V-replication-sample-d2558867)  
[Hyper-V metrics sample](https://code.msdn.microsoft.com/windowsdesktop/Hyper-V-metrics-sample-2dab2cb1)  
[Hyper-V dynamic memory sample](https://code.msdn.microsoft.com/windowsdesktop/Hyper-V-dynamic-memory-9b0b1d05)  
[Hyper-V Extensible Switch extension filter driver](https://code.msdn.microsoft.com/windowsdesktop/Hyper-V-Extensible-Virtual-e4b31fbb)  
[Hyper-V networking sample](https://code.msdn.microsoft.com/windowsdesktop/Hyper-V-networking-sample-7c47e6f5)  
[Hyper-V resource pool management sample](https://code.msdn.microsoft.com/windowsdesktop/Hyper-V-resource-pool-df906d95)  
[Hyper-V recovery snapshot sample](https://code.msdn.microsoft.com/windowsdesktop/Hyper-V-recovery-snapshot-ea72320c)  

## Samples From Blogs

[Adding a Network Adapter To A VM Using The Hyper-V WMI V2 Namespace](https://blogs.msdn.com/b/taylorb/archive/2013/07/15/adding-a-network-adapter-to-a-vm-using-the-hyper-v-wmi-v2-namespace.aspx)  
[Connecting a VM Network Adapter To A Switch Using The Hyper-V WMI V2 Namespace](https://blogs.msdn.com/b/taylorb/archive/2013/07/15/connecting-a-vm-network-adapter-to-a-switch-using-the-hyper-v-wmi-v2-namespace.aspx)  
[Changing The MAC Address Of NIC Using The Hyper-V WMI V2 Namespace](https://blogs.msdn.com/b/taylorb/archive/2013/08/12/changing-the-mac-address-of-nic-using-the-hyper-v-wmi-v2-namespace.aspx)  
[Removing a Network Adapter To A VM Using The Hyper-V WMI V2 Namespace](https://blogs.msdn.com/b/taylorb/archive/2013/08/12/removing-a-network-adapter-to-a-vm-using-the-hyper-v-wmi-v2-namespace.aspx)  
[Attaching a VHD To A VM Using The Hyper-V WMI V2 Namespace](https://blogs.msdn.com/b/taylorb/archive/2013/08/12/attaching-a-vhd-to-a-vm-using-the-hyper-v-wmi-v2-namespace.aspx)  
[Removing a VHD From A VM Using The Hyper-V WMI V2 Namespace](https://blogs.msdn.com/b/taylorb/archive/2013/08/12/removing-a-vhd-from-a-vm-using-the-hyper-v-wmi-v2-namespace.aspx)  
[Creating a VM using the Hyper-V WMI V2 Namespace](https://blogs.msdn.com/b/virtual_pc_guy/archive/2013/06/20/creating-a-virtual-machine-with-wmi-v2.aspx)

