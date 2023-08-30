---
title: Run Hyper-V in a Virtual Machine with Nested Virtualization
description: Learn about how to use nested virtualization to run Hyper-V in a virtual machine to emulate configurations that normally require multiple hosts.
keywords: windows 10, windows 11, hyper-v
author: johncslack
ms.author: wscontent
ms.date: 07/14/2023
ms.topic: article
ms.prod: windows-10-hyperv
ms.assetid: 68c65445-ce13-40c9-b516-57ded76c1b15
---

# Run Hyper-V in a Virtual Machine with Nested Virtualization

Nested Virtualization is a feature that allows you to run Hyper-V inside of a Hyper-V virtual machine (VM). Nested Virtualization is helpful for running a Visual Studio phone emulator in a virtual machine, or testing configurations that ordinarily require several hosts.

To learn more about Nested Virtualization and supported scenarios, see [What is Nested Virtualization for Hyper-V?](nested-virtualization.md).

## Prerequisites

### Intel processor with VT-x and EPT technology

- The Hyper-V host must be either Windows Server 2016 or later, or Windows 10 or later.
- VM configuration version 8.0 or higher.

### AMD EPYC / Ryzen processor or later

- The Hyper-V host must be either Windows Server 2022 or later, or Windows 11 or later.
- VM configuration version 10.0 or higher.

>[!NOTE]
> The guest can be any Windows supported guest operating system. Newer Windows operating systems may support enlightenments that improve performance.

## Configure Nested Virtualization

1. Create a virtual machine. See the prerequisites for the required OS and VM versions.

1. While the virtual machine is in the OFF state, run the following command on the physical Hyper-V host to enable nested virtualization for the virtual machine.

   ```powershell
   Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $true
   ```

1. Start the virtual machine.

1. Install Hyper-V within the virtual machine, just like you would for a physical server. For more information on installing Hyper-V, see, [Install Hyper-V](../quick-start/enable-hyper-v.md).

>[!NOTE]
> When using Windows Server 2019 as the first level VM, the number of vCPUs should be 225 or less.

## Disable Nested Virtualization

You can disable nested virtualization for a stopped virtual machine using the following PowerShell command:

```powershell
Set-VMProcessor -VMName <VMName> -ExposeVirtualizationExtensions $false
```

## Networking options

There are two options for networking with nested virtual machines:

1. MAC address spoofing
2. NAT networking

### MAC address spoofing

In order for network packets to be routed through two virtual switches, MAC address spoofing must be enabled on the first (L1) level of virtual switch. To enable MAC address spoofing, run the following PowerShell command.

```powershell
Get-VMNetworkAdapter -VMName <VMName> | Set-VMNetworkAdapter -MacAddressSpoofing On
```

### Network Address Translation (NAT)

The second option relies on network address translation (NAT). This approach is best suited for cases where MAC address spoofing isn't possible, like in a public cloud environment.

First, a virtual NAT switch must be created in the host virtual machine (the "middle" VM). The following example creates a new internal switch named `VmNAT` and creates a NAT object for all IP addresses in the `192.168.100.0/24` subnet.

```powershell
New-VMSwitch -Name VmNAT -SwitchType Internal
New-NetNat –Name LocalNAT –InternalIPInterfaceAddressPrefix “192.168.100.0/24”
```

Next, assign an IP address to the net adapter:

```powershell
Get-NetAdapter "vEthernet (VmNat)" | New-NetIPAddress -IPAddress 192.168.100.1 -AddressFamily IPv4 -PrefixLength 24
```

Each nested virtual machine must have an IP address and gateway assigned to it. The gateway IP must point to the NAT adapter from the previous step. You may also want to assign a DNS server:

```powershell
Get-NetAdapter "vEthernet (VmNat)" | New-NetIPAddress -IPAddress 192.168.100.2 -DefaultGateway 192.168.100.1 -AddressFamily IPv4 -PrefixLength 24
Netsh interface ip add dnsserver “vEthernet (VmNat)” address=<my DNS server>
```

## Next steps

- [Remotely manage Hyper-V hosts with Hyper-V Manager](/windows-server/virtualization/hyper-v/manage/remotely-manage-hyper-v-hosts)
