---
title: Nested Virtualization
description: Nested Virtualization
keywords: windows 10, hyper-v
author: theodthompson
ms.date: 06/20/2016
ms.topic: article
ms.prod: windows-10-hyperv
ms.service: windows-10-hyperv
ms.assetid: 68c65445-ce13-40c9-b516-57ded76c1b15
---

# Run Hyper-V in a Virtual Machine with Nested Virtualization

Nested virtualization is a feature that allows you to run Hyper-V inside of a Hyper-V virtual machine. In other words, with nested virtualization, a Hyper-V host itself can be virtualized. Some use cases for nested virtualization would be to run a Hyper-V Container in a virtualized container host, set-up a Hyper-V lab in a virtualized environment, or to test multi-machine scenarios without the need for individual hardware. This document will detail software and hardware prerequisites, configuration steps, and limitations. 

## Prerequisites

- A Hyper-V host running Windows Server 2016 or Windows 10 Anniversary Update.
- A Hyper-V VM running Windows Server 2016 or Windows 10 Anniversary Update.
- A Hyper-V VM with configuration version 8.0 or greater.
- An Intel processor with VT-x and EPT technology.

## Configure Nested Virtualization

1. Create a virtual machine. See the prerequisites above for the required OS and VM versions.
2. While the virtual machine is in the OFF state, run the following command on the physical Hyper-V host. This enables nested virtualization for the virtual machine.

```none
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
```
3. Start the virtual machine.
4. Install Hyper-V within the virtual machine, just like you would for a physical server. For more information on installing Hyper-V see, [Install Hyper-V]( https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/quick_start/walkthrough_install).

## Disable Nested Virtualization
You can disable nested virtualization for a stopped virtual machine using the following PowerShell command:
```none
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $false
```

## Dynamic Memory and Runtime Memory Resize
When Hyper-V is running inside a virtual machine, the virtual machine must be turned off to adjust its memory. This means that even if dynamic memory is enabled, the amount of memory will not fluctuate. For virtual machines without dynamic memory enabled, any attempt to adjust the amount of memory while it's on will fail. 

Note that simply enabling nested virtualization will have no effect on dynamic memory or runtime memory resize. The incompatibility only occurs while Hyper-V is running in the VM.

## Networking Options
There are two options for networking with nested virtual machines: MAC address spoofing and NAT mode.

### MAC Address Spoofing
In order for network packets to be routed through two virtual switches, MAC address spoofing must be enabled on the first level of virtual switch. This is completed with the following PowerShell command.

```none
Get-VMNetworkAdapter -VMName <VMName> | Set-VMNetworkAdapter -MacAddressSpoofing On
```
### Network Address Translation
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

## 3rd Party Virtualization Apps
Virtualization applications other than Hyper-V are not supported in Hyper-V virtual machines, and are likely to fail. This includes any software that requires hardware virtualization extensions.
