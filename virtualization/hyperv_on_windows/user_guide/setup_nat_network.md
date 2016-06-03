---
title: Set up a NAT network
description: Set up a NAT network
keywords: windows 10, hyper-v
author: jmesser81
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-10-hyperv
ms.service: windows-10-hyperv
ms.assetid: 1f8a691c-ca75-42da-8ad8-a35611ad70ec
---

# Set up a NAT network

Windows 10 Hyper-V allows native network address translation (NAT) for a virtual network.

This guide will walk you through:
* creating a NAT network
* connecting an existing virtual machine to your new network
* confirming that the virtual machine is connected correctly

Requirements:
* Windows build 14295 or later
* The Hyper-V role is enabled (instructions [here](../quick_start/walkthrough_create_vm.md))

> **Note:**  Currently, Hyper-V only allows you to create one NAT network.

## NAT Overview
NAT gives a virtual machine access to network resources using the host computer's IP address and a port.

Network Address Translation (NAT) is a networking mode designed to conserve IP addresses by mapping an external IP address and port to a much larger set of internal IP addresses.  Basically, a NAT switch uses a NAT mapping table to route traffic from an IP address and port number to the correct internal IP address associated with a device on the network (virtual machine, computer, container, etc.)

Additionally, NAT allows multiple virtual machines to host applications that require identical (internal) communication ports by mapping these to unique external ports.

For all of these reasons, NAT networking is very common for container technology (see [Container Networking](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/container_networking)).


## Create a NAT virtual network
Let's walk through setting up a new NAT network.

1.  Open a PowerShell console as Administrator.  

2. Create an internal switch  

  ``` PowerShell
  New-VMSwitch -SwitchName "SwitchName" -SwitchType Internal
  ```

3. Configure the NAT gateway using [New-NetIPAddress](https://technet.microsoft.com/en-us/library/hh826150.aspx).  

  Here is the generic command:
  ``` PowerShell
  New-NetIPAddress -IPAddress <NAT Gateway IP> -PrefixLength <NAT Subnet Prefix Length> -InterfaceIndex <ifIndex>
  ```

  In order to configure the gateway, you'll need a bit of information about your network:  
  * **IPAddress** -- NAT Gateway IP specifies the IPv4 or IPv6 address to use as the NAT gateway IP.  
    The generic form will be a.b.c.1 (e.g. 172.16.0.1).  While the final position doesn’t have to be .1, it usually is (based on prefix length)

    A common gateway IP is 192.168.0.1  

  * **PrefixLength** --  NAT Subnet Prefix Length defines the NAT local subnet size (subnet mask).
    The subnet prefix length will be an integer value between 0 and 32.

    0 would map the entire internet, 32 would only allow one mapped IP.  Common values range from 24 to 12 depending on how many IPs need to be attached to the NAT.

    A common PrefixLength is 24 -- this is a subnet mask of 255.255.255.0

  * **InterfaceIndex** -- ifIndex is the interface index of the virtual switch created above.

    You can find the interface index by running `Get-NetAdapter`

    Your output should look something like this:

    ```
    PS C:\> Get-NetAdapter

    Name                  InterfaceDescription               ifIndex Status       MacAddress           LinkSpeed
    ----                  --------------------               ------- ------       ----------           ---------
    vEthernet (intSwitch) Hyper-V Virtual Ethernet Adapter        24 Up           00-15-5D-00-6A-01      10 Gbps
    Wi-Fi                 Marvell AVASTAR Wireless-AC Net...      18 Up           98-5F-D3-34-0C-D3     300 Mbps
    Bluetooth Network ... Bluetooth Device (Personal Area...      21 Disconnected 98-5F-D3-34-0C-D4       3 Mbps

    ```

    The internal switch will have a name like `vEthernet (SwitchName)` and an Interface Description of `Hyper-V Virtual Ethernet Adapter`.

  Run the following to create the NAT Gateway:

  ``` PowerShell
  New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex 24
  ```

4. Configure the NAT network using [New-NetNat](https://technet.microsoft.com/en-us/library/dn283361(v=wps.630).aspx).  

  Here is the generic command:

  ``` PowerShell
  New-NetNat -Name <NATOutsideName> -InternalIPInterfaceAddressPrefix <NAT subnet prefix>
  ```

  In order to configure the gateway, you'll need to provide information about the network and NAT Gateway:  
  * **Name** -- NATOutsideName describes the name of the NAT network.  You'll use this to remove the NAT network.

  * **InternalIPInterfaceAddressPrefix** -- NAT subnet prefix describes both the NAT Gateway IP prefix from above as well as the NAT Subnet Prefix Length from above.

    The generic form will be a.b.c.0/NAT Subnet Prefix Length

    From the above, for this example, we'll use 192.168.0.0/24

  For our example, run the following to setup the NAT network:

  ``` PowerShell
  New-NetNat -Name MyNATnetwork -InternalIPInterfaceAddressPrefix 192.168.0.0/24
  ```

Congratulations!  You now have a virtual NAT network!  To add a virtual machine, to the NAT network follow [these instructions](setup_nat_network.md#connect-a-virtual-machine).

## Connect a virtual machine

To connect a virtual machine to your new NAT network, connect the internal switch you created in the first step of the [NAT Network Setup](setup_nat_network.md#create-a-nat-virtual-network) section to your virtual machine using the VM Settings menu.


## Troubleshooting

This workflow assumes that there are no other NATs on the host. However, sometimes multiple applications or services will require the use of a NAT. Since Windows (WinNAT) only supports one internal NAT subnet prefix, trying to create multiple NATs will place the system into an unknown state.

### Troubleshooting Steps
1. Make sure you only have one NAT

  ``` PowerShell
  Get-NetNat
  ```
2. If a NAT already exists, please delete it

  ``` PowerShell
  Get-NetNat | Remove-NetNat
  ```

3. Make sure you only have one "internal" vmSwitch for the NAT. Record the name of the vSwitch for Step 4

  ``` PowerShell
  Get-VMSwitch
  ```

4. Check to see if there are private IP addresses (e.g. NAT default Gateway IP Address - usually *.1) from the old NAT still assigned to an adapter

  ``` PowerShell
  Get-NetIPAddress -InterfaceAlias "vEthernet(<name of vSwitch>)"
  ```

5. If an old private IP address is in use, please delete it  
   ``` PowerShell
  Remove-NetIPAddress -InterfaceAlias "vEthernet(<name of vSwitch>)" -IPAddress <IPAddress>
  ```

## Multiple Applications using the same NAT

Some scenarios require multiple applications or services to use the same NAT. In this case, the following workflow must be followed so that multiple applications / services can use a larger NAT internal subnet prefix

**_We will detail the Docker 4 Windows - Docker Beta - Linux VM co-existing with the Windows Container feature on the same host as an example. This workflow is subject to change_**

1. C:\> net stop docker
2. Stop Docker4Windows MobyLinux VM
3. PS C:\> Get-ContainerNetwork | Remove-ContainerNetwork -force
4. PS C:\> Get-NetNat | Remove-NetNat  
   *Removes any previously existing container networks (i.e. deletes vSwitch, deletes NetNat, cleans up)*  

5. New-ContainerNetwork -Name nat -Mode NAT –subnetprefix 10.0.76.0/24 (this subnet will be used for Windows containers feature)
   *Creates internal vSwitch named nat*  
   *Creates NAT network named “nat” with IP prefix 10.0.76.0/24*  

6. Remove-NetNAT  
   *Removes both DockerNAT and nat NAT networks (keeps internal vSwitches)*  

7. New-NetNat -Name DockerNAT -InternalIPInterfaceAddressPrefix 10.0.0.0/17 (this will create a larger NAT network for both D4W and containers to share)  
   *Creates NAT network named DockerNAT with larger prefix 10.0.0.0/17*  

8. Run Docker4Windows (MobyLinux.ps1)  
   *Creates internal vSwitch DockerNAT*  
   *Creates NAT network named “DockerNAT” with IP prefix 10.0.75.0/24*  

9. Net start docker  
   *Docker will use the user-defined NAT network as the default to connect Windows containers*  

In the end, you should have two internal vSwitches – one named DockerNAT and the other named nat. You will only have one NAT network (10.0.0.0/17) confirmed by running Get-NetNat. IP addresses for Windows containers will be assigned by the Windows Host Network Service (HNS) from the 10.0.76.0/24 subnet. Based on the existing MobyLinux.ps1 script, IP addresses for Docker 4 Windows will be assigned from the 10.0.75.0/24 subnet.


## References
Read more about [NAT networks](https://en.wikipedia.org/wiki/Network_address_translation)
