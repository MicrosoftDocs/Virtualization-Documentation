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

# Run Hyper-V in a Virtual Machine with Nested Virtualization

Nested virtualization is a feature that allows you to run Hyper-V inside of a Hyper-V virtual machine. In other words, with nested virtualization, a Hyper-V host itself can be virtualized. Some use cases for nested virtualization would be to run a Hyper-V Container in a virtualized container host, set-up a Hyper-V lab in a virtualized environment, or to test multi-machine scenarios without the need for individual hardware. This document will detail software and hardware prerequisites, configuration steps, and provide troubleshooting details.

## Prerequisites

- A Hyper-V host running a Windows Insiders build (Windows Server 2016, or Windows 10) running Build 10565 or later.
- Both hypervisors (parent and child) must be running identical Windows builds (10565 or later).
- An Intel processor with the Intel VT-x and EPT technology.

## Configure Nested Virtualization

First Create a virtual machine  **do not turn on the virtual machine**. For more information see, [Create a Virtual Machine](../quick_start/walkthrough_create_vm.md).

Once the virtual machine has been created, run the following command on the physical Hyper-V host. This enables nested virtualization on the virtual machine.

```none
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
```
When running a nested Hyper-V host, dynamic memory must be disabled on the virtual machine. This can be configured on the properties of the virtual machine or by using the following PowerShell command.
```none
Set-VMMemory -VMName <VMName> -DynamicMemoryEnabled $false
```

When these steps have been completed, the virtual machine can be started and Hyper-V installed. For more information on installing Hyper-V see, [Install Hyper-V]( https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/quick_start/walkthrough_install).

## Nested Virtual Machine Networking
There are two options for networking with nested virtual machines: MAC address spoofing and NAT mode.

### Option 1: MAC Address Spoofing
In order for network packets to be routed through two virtual switches, MAC address spoofing must be enabled on the first level of virtual switch. This is completed with the following PowerShell command.

```none
Get-VMNetworkAdapter -VMName <VMName> | Set-VMNetworkAdapter -MacAddressSpoofing On
```
### Option 2: NAT Mode
The second option relies on network address translation (NAT). This approach is best suited for cases where MAC address spoofing is not possible, like in a public cloud environment.

First, a virtual NAT switch must be created in the host virtual machine (the "middle" VM). Note that the IP addresses are just an example, and will vary across environments:
```none
new-vmswitch -name VmNAT -SwitchType Internal
New-NetNat –Name LocalNAT –InternalIPInterfaceAddressPrefix “192.168.100.0/24”
```
Next, assign an IP address to the net adapter:
```none
get-netadapter "vEthernet (VmNat)" | New-NetIPAddress -IPAddress 192.168.100.1 -AddressFamily IPv4 -PrefixLength 24
```
Each nested virtual machine must have an IP address and gateway assigned to it. Note that the gateway IP must point to the NAT adapter from the previous step. You may also want to assign a DNS server:
```none
get-netadapter "Ethernet" | New-NetIPAddress -IPAddress 192.168.100.2 -DefaultGateway 192.168.100.1 -AddressFamily IPv4 -PrefixLength 24
Netsh interface ip add dnsserver “Ethernet” address=<my DNS server>
```


## Known Issues

- Hosts with Device Guard enabled cannot expose virtualization extensions to guests.
- Virtual machines with Virtualization Based Security (VBS) enabled cannot simultaneously have nested enabled. You must first disable VBS in order to use nested virtualization.
- Once nested virtualization is enabled in a virtual machine, the following features are no longer compatible with that VM.  
  * Runtime memory resize, and Dynamic Memory
  * Checkpoints
  * A virtual machine with Hyper-V enabled cannot be live migrated.

## FAQ and Troubleshooting

My virtual machine won’t start, what should I do?

1. Make sure dynamic memory is OFF.
2. Make sure you have a capable Intel processor.
3. Run [this PowerShell script](https://raw.githubusercontent.com/Microsoft/Virtualization-Documentation/master/hyperv-tools/Nested/Get-NestedVirtStatus.ps1) on your host machine from an elevated prompt.

## Feedback

Report additional issue through the Windows feedback app, the [virtualization forums](https://social.technet.microsoft.com/Forums/windowsserver/En-us/home?forum=winserverhyperv), or through [GitHub](https://github.com/Microsoft/Virtualization-Documentation).
