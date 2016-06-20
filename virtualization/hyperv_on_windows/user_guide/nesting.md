---
title: Nested Virtualization
description: Nested Virtualization
keywords: windows 10, hyper-v
author: theodthompson
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-10-hyperv
ms.service: windows-10-hyperv
ms.assetid: 68c65445-ce13-40c9-b516-57ded76c1b15
---

# Nested Virtualization

Nested virtualization provides the ability to run Hyper-V hosts in a virtualized environment. In other words, with nested virtualization, a Hyper-V host itself can be virtualized. Some use cases for nested virtualization would be to run a Hyper-V lab in a virtualized environment, to provide virtualization services to others without the need for individual hardware, and the Windows container technology relies on nested virtualization when running Hyper-V containers on a virtualized container host. This document will detail software and hardware prerequisites, configuration steps, and provide troubleshooting details.

> Nested virtualization is in a preview release and should not be used in production.

## Prerequisites

- Windows Insiders build (Windows Server 2016, Nano Server or Windows 10) running Build 10565 or later.
- Both hypervisors (parent and child) must be running identical Windows builds (10565 or later).
- 4 GB RAM available minimum.
- An Intel processor with the Intel VT-x technology.

## Configure Nested Virtualization

First Create a virtual machine running the same build as your host, **do not turn on the virtual machine**. For more information see, [Create a Virtual Machine](../quick_start/walkthrough_create_vm.md).

Once the virtual machine has been created, run the following command on the parent hypervisor, this enables nested virtualization on the virtual machine.

```none
Set-VMProcessor -VMName <virtual machine> -ExposeVirtualizationExtensions $true -Count 2
```

When running a nested Hyper-V host, dynamic memory must be disabled on the virtual machine. This can be configured on the properties of the virtual machine or by using the following PowerShell command.

```none
Set-VMMemory <virtual machine> -DynamicMemoryEnabled $false
```

In order for nested virtual machines to recieve IP addresses, MAC address spoofing must be enabled. This is completed with the following PowerShell command.

```none
Get-VMNetworkAdapter -VMName <virtual machine> | Set-VMNetworkAdapter -MacAddressSpoofing On
```

When these steps have been completed, the virtual machine can be started and Hyper-V installed. For more information on installing Hyper-V see, [Install Hyper-V]( https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/quick_start/walkthrough_install).

## Configuration Script

Optionally, the following script can be used to enable and configured nested virtualization. The following commands will download and run the script.
  
```none
# download script
Invoke-WebRequest https://raw.githubusercontent.com/Microsoft/Virtualization-Documentation/master/hyperv-tools/Nested/Enable-NestedVm.ps1 -OutFile .\Enable-NestedVm.ps1 

# run script
.\Enable-NestedVm.ps1 -VmName "DemoVM"
```

## Known Issues

- Hosts with Device Guard enabled cannot expose virtualization extensions to guests.
- Hosts with Virtualization Based Security (VBS) enabled cannot expose virtualization extensions to guests. You must first disable VBS in order to use nested virtualization.
- Virtual machine connection may be lost if using a blank password. Change the password and the issue should be resolved.
- Once nested virtualization is enabled in a virtual machine, the following features are no longer compatible with that VM.  
  * Runtime memory resize.
  * Applying a checkpoint to a running virtual machine.
  * A virtual machine that is hosting other virtual machines cannot be live migrated.
  * Save and restore do not function.

## FAQ and Troubleshooting

My virtual machine won’t start, what should I do?

1. Make sure dynamic memory is OFF.
2. Run [this PowerShell script](https://raw.githubusercontent.com/Microsoft/Virtualization-Documentation/master/hyperv-tools/Nested/Get-NestedVirtStatus.ps1) on your host machine from an elevated prompt.
  
## Feedback

Report additional issue through the Windows feedback app, the [virtualization forums](https://social.technet.microsoft.com/Forums/windowsserver/En-us/home?forum=winserverhyperv), or through [GitHub](https://github.com/Microsoft/Virtualization-Documentation).

