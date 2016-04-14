# Set up a NAT network

Windows 10 Hyper-V now supports native network address translation(NAT).  This guide will walk you through:
* creating a NAT network
* connecting an existing virtual machine to your new network
* confirming that the virtual machine is connected correctly

Requirements:
* Windows build **BUILD NUMBER**
* Hyper-V role is enabled (instructions here)

## Create a NAT network
Let's walk through setting up a new NAT network.

1.  Open a PowerShell console as Administrator -- you must also be part of the Hyper-V Administrators group.  
  You can run `Get-VM` to confirm that those are both true.

2. Create an internal switch  
  
  ``` PowerShell
  New-VMSwitch –SwitchName “SwitchName” –SwitchType Internal
  ```

3. Set up the IP address to use as the NAT gateway.  
   
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