# Set up a NAT network

Windows 10 Hyper-V now supports native network address translation (NAT).  This guide will walk you through:
* creating a NAT network
* connecting an existing virtual machine to your new network
* confirming that the virtual machine is connected correctly

Requirements:
* Windows build 14295 or later
* Hyper-V role is enabled (instructions [here](../quick_start/walkthrough_create_vm.md))

> **Note:**  Currently, Hyper-V only allows you to create one NAT network.

## NAT Overview
Network Address Translation (NAT) is a networking mode designed to conserve IP addresses by mapping an external IP address and port to a much larger set of internal IP addresses.  Basically, a NAT switch uses a NAT mapping table to route traffic from an IP Address and port number to the correct internal IP address and port associated with a device on the network (virtual machine, computer, container, etc.)

Additionally, NAT allows multiple virtual machines to host applications that require identical (internal) communication ports by mapping these to unique external ports.

For all of these reasons, NAT networking is very common for container technology (see [Container Networking](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/container_networking)). 


## Create a NAT network
Let's walk through setting up a new NAT network.

1.  Open a PowerShell console as Administrator.  

2. Create an internal switch  
  
  ``` PowerShell
  New-VMSwitch –SwitchName “SwitchName” –SwitchType Internal
  ```

3. Choose and configure the IP address you're using as the NAT gateway using [New-NetIPAddress](https://technet.microsoft.com/en-us/library/hh826150.aspx).  
  
  Numbers to choose and what they mean:
  * **IPAddress** -- Specifies the IPv4 or IPv6 address to use as the NAT gateway IP.
  * **PrefixLength** --  Defines the local subnet size (subnet mask).
  * **InterfaceIndex** -- 
    
  ``` PowerShell
  New-NetIPAddress – IPAddress <NAT Gateway IP> -PrefixLength <Nat Subnet Prefix Length> -InterfaceIndex <X>
  ```

4. 

  ``` PowerShell
  New-NetNat –Name NATOutside –InternalIPInterfaceAddressPrefix <NAT subnet prefix>

  <Switch Name> := string (e.g. “MyNat”)
  <NAT Gateway IP> := a.b.c.1 (e.g. 172.16.0.1) – doesn’t have to be .1 but usually is (based on prefix length) 
  <Nat Subnet Prefix Length> := int (e.g. 24, 16, or 12 depending on how many IPs need to be attached to the NAT)
  <X> := int (this is the interface index of the management vNIC – e.g. vEthernet (MyNat))
  <Nat Subnet Prefix> := a.b.c.0/<Nat Subnet Prefix Length (e.g. 172.16.0.0/24)
  ```

## Connect a virtual machine

## Test the NAT network

## References
Read more about [NAT networks](https://en.wikipedia.org/wiki/Network_address_translation)