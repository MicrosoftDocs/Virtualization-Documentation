Author     : Cheng (Charles) Ding
Date: 6/12/2017

Bootstrap Powershell Script for Setting up NestedVMs. Checks Pre-Reqs, then installs/configures NestedVM. Will restart computer as necessary. This script was designed to be used by the new Windows Server 2016 VMTypes on Azure which suport Nested Virtualization. This script may work in other environments but is not guaranteed. This is forked from an older script: Forked Version from https://github.com/Microsoft/Virtualization-Documentation/tree/master/hyperv-tools/Nested

1) Make sure you change the name of your VM in this file to what you desire before executing script. (Tip: Copy the NVMBootstrap_WinServer16.ps1 script onto your VM then drag drop that file into a Administrative PowerShell window, then press Enter to start)
2) Wait for script to complete. (Note: Restarts may take place and RDP connection may be dropped, if this occurs, just RDP back in the VM after restart is complete - Please also note that if restart is "In Progress", you will be unable to RDP into your VM) If script fails, please fall back to use the older scripts located here: https://github.com/Microsoft/Virtualization-Documentation/tree/master/hyperv-tools/Nested
3) After Script completes, go to Hyper-V-Manager install OS onto the existing VHD or point to your custom VHD 
4) (Optional if you need internet) Setup NAT Network and DCHP Server. If the recommended DCHP Server is unavailable to you for some reason, you can also manually configure the network using Static IP. More details regarding this available below:

===================================

A) First step to get internet up and running is to go on the VirtualHost and create a NAT virtual network switch as follows:
Let's walk through setting up a new NAT network.

   1. Open a PowerShell console as Administrator. 
   
   2. Create an internal switch  
   ```New-VMSwitch -SwitchName "SwitchName" -SwitchType Internal```

   3. Configure the NAT gateway using New-NetIPAddress.
   ```New-NetIPAddress -IPAddress <NAT Gateway IP> -PrefixLength <NAT Subnet Prefix Length> -InterfaceIndex <ifIndex>```
   
   In order to configure the gateway, you'll need a bit of information about your network:
   * IPAddress -- NAT Gateway IP specifies the IPv4 or IPv6 address to use as the NAT gateway IP. The generic form will be a.b.c.1 (e.g. 172.16.0.1). While the final position doesn’t have to be .1, it usually is (based on prefix length)
A common gateway IP is 192.168.0.1
   * PrefixLength -- NAT Subnet Prefix Length defines the NAT local subnet size (subnet mask). The subnet prefix length will be an integer value between 0 and 32. 0 would map the entire internet, 32 would only allow one mapped IP. Common values range from 24 to 12 depending on how many IPs need to be attached to the NAT. A common PrefixLength is 24 -- this is a subnet mask of 255.255.255.0
   * InterfaceIndex -- ifIndex is the interface index of the virtual switch created above. You can find the interface index by running Get-NetAdapter. Your output should look something like this:

```PS C:\> Get-NetAdapter

Name                  InterfaceDescription               ifIndex Status       MacAddress           LinkSpeed
----                  --------------------               ------- ------       ----------           ---------
vEthernet (intSwitch) Hyper-V Virtual Ethernet Adapter        24 Up           00-15-5D-00-6A-01      10 Gbps
Wi-Fi                 Marvell AVASTAR Wireless-AC Net...      18 Up           98-5F-D3-34-0C-D3     300 Mbps
Bluetooth Network ... Bluetooth Device (Personal Area...      21 Disconnected 98-5F-D3-34-0C-D4       3 Mbps
```
The internal switch will have a name like vEthernet (SwitchName) and an Interface Description of Hyper-V Virtual Ethernet Adapter.
Run the following to create the NAT Gateway:

```New-NetIPAddress -IPAddress 192.168.0.1 -PrefixLength 24 -InterfaceIndex 24```

  4. Configure the NAT network using New-NetNat.  
  ```New-NetNat -Name <NATOutsideName> -InternalIPInterfaceAddressPrefix <NAT subnet prefix>```

In order to configure the gateway, you'll need to provide information about the network and NAT Gateway:
  * Name: NATOutsideName describes the name of the NAT network. You'll use this to remove the NAT network.
  * InternalIPInterfaceAddressPrefix: NAT subnet prefix describes both the NAT Gateway IP prefix from above as well as the NAT Subnet Prefix Length from above.
  
The generic form will be a.b.c.0/NAT Subnet Prefix Length
From the above, for this example, we'll use 192.168.0.0/24
For our example, run the following to setup the NAT network:

```New-NetNat -Name MyNATnetwork -InternalIPInterfaceAddressPrefix 192.168.0.0/24```
	
B) Next you want to now setup your DCHP Server on VirtualHost
  1. Install DCHP on your server if it does not exist (Install via Add Roles/Features)
  2. Go to IPv4 and right click it to create a "New Scope"
  3. Define an IP Range for your DCHP Server (Eg: 192.168.0.10 to 192.168.0.253)
  4. Leave everything else default and click Next until you get to Default Gateway page. Use the same IP Address you used earlier 192.168.0.1 as the Default Gateway.
  5. Now go to your VM in Hyper-V Manager and hook up the Virtual Network.
C) On VirtualGuest, IP and DNS should be automatic which should be fine.
Congrats - you should see similar screens to below. (Bottom screen is manual IP config (Don't worry about this unless you know what you are doing), and other is DCHP auto IP config)

**First Option: DCHP - Dynamically Assigned IP (Preferred Method)**
![DCHP - Dynamically Assigned IP](https://github.com/charlieding/Virtualization-Documentation/blob/live/hyperv-tools/Nested/Screenshot%20Examples/DCHPAssignedIPNAT.PNG)

**Second Option: Manual - Static IP Assignment**
![Manual - Static IP Assignment](https://github.com/charlieding/Virtualization-Documentation/blob/live/hyperv-tools/Nested/Screenshot%20Examples/StaticIPAssignments.PNG)
