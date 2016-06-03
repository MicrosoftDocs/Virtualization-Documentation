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

Network Address Translation (NAT) is a networking mode designed to conserve IP addresses by mapping an external IP address and port to a much larger set of internal IP addresses.  Basically, a NAT switch uses a NAT mapping table to route traffic from an IP Address and port number to the correct internal IP address associated with a device on the network (virtual machine, computer, container, etc.)

Additionally, NAT allows multiple virtual machines to host applications that require identical (internal) communication ports by mapping these to unique external ports.

For all of these reasons, NAT networking is very common for container technology (see [Container Networking](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/container_networking)). 


## Create a NAT virtual network
Let's walk through setting up a new NAT network.

1.  Open a PowerShell console as Administrator.  

2. Create an internal switch  
  
  ``` PowerShell
  New-VMSwitch –SwitchName “SwitchName” –SwitchType Internal
  ```

3. Configure the NAT gateway using [New-NetIPAddress](https://technet.microsoft.com/en-us/library/hh826150.aspx).  
  
  Here is the generic command:
  ``` PowerShell
  New-NetIPAddress – IPAddress <NAT Gateway IP> -PrefixLength <Nat Subnet Prefix Length> -InterfaceIndex <ifIndex>
  ```
  
  In order to configure the gateway, you'll need a bit of information about your network:  
  * **IPAddress** -- NAT Gateway IP specifies the IPv4 or IPv6 address to use as the NAT gateway IP.  
    The generic form will be a.b.c.1 (e.g. 172.16.0.1).  While the final position doesn’t have to be .1, it usually is (based on prefix length)
    
    A common gateway IP is 192.168.0.1  
  
  * **PrefixLength** --  NAT Subnet Prefix Length defines the NAT local subnet size (subnet mask). 
    The subnet prefix length will be an int value between 0 and 32.
    
    0 would map the entire internet, 32 would only allow one mapped IP.  Common values range from 24 to 12 depending on how many IPs need to be attached to the NAT.
     
    A common PrefixLength is 24 -- this is a subnet mask of 255.255.255.0
  
  * **InterfaceIndex** -- ifIndex is the interface index of the virtual switch created above.
    
    You can find the interface index by running `Get-NetAdapter`
    
    Your output should look something like this:
    
    ```
    PS C:\Users\sarah> Get-NetAdapter
    
    Name                  InterfaceDescription               ifIndex Status       MacAddress           LinkSpeed
    ----                  --------------------               ------- ------       ----------           ---------
    vEthernet (intSwitch) Hyper-V Virtual Ethernet Adapter        24 Up           00-15-5D-00-6A-01      10 Gbps
    Wi-Fi                 Marvell AVASTAR Wireless-AC Net...      18 Up           98-5F-D3-34-0C-D3     300 Mbps
    Bluetooth Network ... Bluetooth Device (Personal Area...      21 Disconnected 98-5F-D3-34-0C-D4       3 Mbps

    ```
    
    The internal switch will have a name like `vEthernet (SwitchName)` and an Interface Description of `Hyper-V Virtual Ethernet Adapter`.
  
  Run the following to create the NAT Gateway:
    
  ``` PowerShell
  New-NetIPAddress – IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex 24
  ```

4. Configure the NAT network using [New-NetNat](https://technet.microsoft.com/en-us/library/dn283361(v=wps.630).aspx).  
  
  Here is the generic command:
    
  ``` PowerShell
  New-NetNat –Name <NATOutsideName> –InternalIPInterfaceAddressPrefix <NAT subnet prefix>
  ```
  
  In order to configure the gateway, you'll need to provide information about the network and NAT Gateway:  
  * **Name** -- NATOutsideName describes the name of the NAT network.  You'll use this to remove the NAT network.
  
  * **InternalIPInterfaceAddressPrefix** -- NAT subnet prefix describes both the NAT Gateway IP prefix from above as well as the NAT Subnet Prefix Length from above.
    
    The generic form will be a.b.c.0/Nat Subnet Prefix Length 
    
    From the above, for this example, we'll use 192.168.0.0/24
  
  For our example, run the following to setup the NAT network:
  
  ``` PowerShell
  New-NetNat –Name MyNATnetwork –InternalIPInterfaceAddressPrefix 192.168.0.0/24
  ```
  
Congratulations!  You now have a virtual NAT network!  To add a virtual machine, to the NAT network follow [these instructions](setup_nat_network.md#connect-a-virtual-machine).

## Connect a virtual machine

To connect a virtual machine to your new NAT network, connect the internal switch you created in the first step of the [NAT Network Setup](setup_nat_network.md#create-a-nat-virtual-network) section to your virtual machine using the VM Settings menu.


## References
Read more about [NAT networks](https://en.wikipedia.org/wiki/Network_address_translation)