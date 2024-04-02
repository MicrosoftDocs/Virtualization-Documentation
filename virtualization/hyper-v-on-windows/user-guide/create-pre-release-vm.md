---
title: Try pre-release features for Hyper-V
description: Try pre-release features for Hyper-V
keywords: windows 10, hyper-v
author: scooley
ms.author: scooley
ms.date: 05/02/2016
ms.topic: article
ms.assetid: 426c87cc-fa50-4b8d-934e-0b653d7dea7d
---

# Try pre-release features for Hyper-V

> This is preliminary content and subject to change.  
  Pre-release virtual machines are intended for development or test environments only as they are not supported by Microsoft.

Get early access to pre-release features for Hyper-V on Windows Server 2016 Technical Preview to try out in your development or test environments. You can be the first to see the latest Hyper-V features and help shape the product by providing early feedback.

The virtual machines you create as pre-release have no build-to-build compatibility or future support.  Don't use them in a production environment.

Here are some more reasons why these are for non-production environments only:

* There is no forward compatibility for pre-release virtual machines. You can't upgrade these virtual machines to a new configuration version.
* Pre-release virtual machines don't have a consistent definition between builds. If you update the host operating system, existing pre-release virtual machines may be incompatible with the host. These virtual machines may not start, or may initially appear to work but later run into significant compatibility issues.
* If you import a pre-release virtual machine to a host with a different build, the results are unpredictable. You can move a pre-release virtual machine to another host. But this scenario is only expected to work if both hosts are running the same build.

## Create a pre-release virtual machine

You can create a pre-release virtual machine on Hyper-V hosts that run Windows Server 2016 Technical Preview.

1. On the Windows desktop, click the Start button and type any part of the name **Windows PowerShell**.
2. Right-click **Windows PowerShell** and select **Run as Administrator**.
3. Use the [New-VM](/powershell/module/hyper-v/new-vm?view=win10-ps&preserve-view=true) cmdlet with the -Prerelease flag to create the pre-release virtual machine. For example, run the following command where VM Name is the name of the virtual machine that you want to create.

``` PowerShell
New-VM -Name <VM Name> -Prerelease
```
Other examples you can use the -Prerelease flag with:
 - To create a virtual machine that uses an existing virtual hard disk or a new hard disk, see the PowerShell examples in [Create a virtual machine in Hyper-V on Windows Server 2016 Technical Preview](/windows-server/virtualization/hyper-v/get-started/Create-a-virtual-machine-in-Hyper-V#BKMK_PowerShell).
 - To create a new virtual hard disk that boots to an operating system image, see the PowerShell example in [Deploy a Windows Virtual Machine in Hyper-V on Windows 10](/virtualization/hyper-v-on-windows/quick-start/create-virtual-machine).

 The examples covered in those articles work for Hyper-V hosts that run Windows 10 or Windows Server 2016 Technical Preview. But right now, you can only use the -Prerelease flag to create a pre-release virtual machine on Hyper-V hosts that run Windows Server 2016 Technical Preview.

## See also
-  [Virtualization Blog](https://techcommunity.microsoft.com/t5/Virtualization/bg-p/Virtualization) - Learn about the pre-release features that are available and how to try them out.
- [Supported virtual machine configuration versions](/windows-server/virtualization/hyper-v/deploy/Upgrade-virtual-machine-version-in-Hyper-V-on-Windows-or-Windows-Server#BKMK_SupportedConfigVersions) - Learn how to check the virtual machine configuration version and which versions are supported by Microsoft.
