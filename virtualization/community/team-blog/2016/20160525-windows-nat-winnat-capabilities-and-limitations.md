---
layout:     post
title:      "Windows NAT (WinNAT) -- Capabilities and limitations"
date:       2016-05-25 21:15:59
categories: hyper-v
---
**Author: Jason Messer**   How many devices (e.g. laptops, smart phones, tablets, DVRs, etc.) do you have at home which connect to the internet? Each of these devices probably has an IP address assigned to it, but did you know that that the public internet actually only sees **one IP address** for all of these devices? How does this work? Network Address Translation (NAT) allows users to create a private, internal network which shares a public IP address(es). When a new connection is established (e.g. web browser session to [www.bing.com](http://www.bing.com)) the NAT _translates_ the private (source) IP address assigned to your device to the shared public IP address which is routable on the internet and creates a new entry in the NAT flow state table. When a connection comes back into your network, the public (destination) IP address is translated to the private IP address based on the matching flow state entry. This same NAT technology and concept can also work with host networking using virtual machine and container endpoints running on a single host. IP addresses from the NAT internal subnet (prefix) can be assigned to VMs, containers, or other services running on this host. Similar to how the NAT translates the source IP address of a device, NAT can also translate the source IP address of a VM or container to the IP address of a virtual network adapter (Host vNIC) on the host. [caption id="attachment_8585" align="alignnone" width="721"][![Figure 1: Physical vs Virtual NAT](https://msdnshared.blob.core.windows.net/media/2016/05/Basic-NAT.jpg)](https://msdnshared.blob.core.windows.net/media/2016/05/Basic-NAT.jpg) Figure 1: Physical vs Virtual NAT[/caption]   Similarly, the TCP/UDP ports can also be translated (Port Address Translation – PAT) so that traffic received on an external port can be forwarded to a different, internal port. These are known as static mappings. [caption id="attachment_8595" align="alignnone" width="904"][![Figure 2: Static Port Mappings](https://msdnshared.blob.core.windows.net/media/2016/05/NAT-Port-Mapping.jpg)](https://msdnshared.blob.core.windows.net/media/2016/05/NAT-Port-Mapping.jpg) Figure 2: Static Port Mappings[/caption] 

# Host Networking with WinNAT to attach VMs and Containers

The first step in creating a host network for VMs and containers is to create an internal Hyper-V virtual switch in the host. This provides Layer-2 (Ethernet) internal connectivity between the endpoints. In order to obtain external connectivity through a NAT (using WinNAT), we add a Host vNIC to the internal vSwitch and assign the default gateway IP address of the NAT to this vNIC. This essentially creates a router so that any network traffic from one of the endpoints that is destined for an IP address outside of the internal network (e.g. bing.com) will go through the NAT translation process. _Note: when the Windows container feature is installed, the docker daemon creates a default NAT network automatically when it starts. To stop this network from being created, make sure the docker daemon (dockerd) is started with the ‘-b “none”’ argument specified._ In addition to address translation, WinNAT also allows users to create static port mappings or forwarding rules so that internal endpoints can be accessed from external clients. Take for example an IIS web server running in a container attached to the default NAT network. The IIS web server will be listening on port 80 and so it requires that any connections coming in on a particular port to the host from an external client will be forwarded or mapped to port 80 on the container. Reference Figure 2 above to see port 8080 on the host being mapped to port 80 on the container. In order to create a NAT network to connect VMs, please follow these instructions: <https://msdn.microsoft.com/en-us/virtualization/hyperv_on_windows/user_guide/setup_nat_network> In order to create a NAT network for containers (or use the default nat network) please follow these instructions: <https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/container_networking>

# Key Limitations in WinNAT (Windows NAT implementation)

  * Multiple internal subnet prefixes not supported
  * External / Internal prefixes must not overlap
  * No automatic networking configuration
  * Cannot access externally mapped NAT endpoint IP/ ports directly from host – must use internal IP / ports assigned to endpoints



### Multiple Internal Subnet Prefixes

Consider the case where multiple applications / VMs / containers each require access to a private NAT network. WinNAT only allows for one internal subnet prefix to be created on a host which means that if multiple applications or services need NAT connectivity, they will need to coordinate between each other to share this internal NAT network; each application cannot create its own individual NAT network. This may require creating a larger private NAT subnet (e.g. /18) for these endpoints. Moreover, the private IP addresses assigned to the endpoints cannot be re-used so that IP allocation also needs to be coordinated. [caption id="attachment_8605" align="alignnone" width="494"][![Figure 3: Multiple Internal NAT Subnets are not allowed – combined into a larger, shared subnet](https://msdnshared.blob.core.windows.net/media/2016/05/Overlapping-Internal-Prefixes.jpg)](https://msdnshared.blob.core.windows.net/media/2016/05/Overlapping-Internal-Prefixes.jpg) Figure 3: Multiple Internal NAT Subnets are not allowed – combined into a larger, shared subnet[/caption] Lastly, individual external host ports can only be mapped to one internal endpoint. A user cannot create two static port mappings with external port 80 and have traffic directed to two different internal endpoints. These static port mappings must be coordinated between applications and services requiring NAT. WinNAT does not support dynamic port mappings (i.e. allowing WinNAT to automatically choose an external – or ephemeral – host port to be used by the mapping). _Note: Dynamic port mappings are supported through docker run with the -p | -P options since IP address management (IPAM) is handled by the Host Network Service (HNS) for containers._

### Overlapping External and Intern IP Prefixes

A NAT network may be created on either a client or server host. When the NAT is first created, it must be ensured that the internal IP prefix defined does not overlap with the external IP addresses assigned to the host. Example – **This is not allowed** : _Internal, Private IP Subnet: 172.16.0.0/12 IP Address assigned to the Host: 172.17.0.4_ If a user is roaming on a laptop and connects to a different physical network such that the container host’s IP address is now within the private NAT network, the internal IP prefix of the NAT will need to be modified so that it does not overlap. 

### Automatic Network Configuration

WinNAT itself does not dynamically assign IP addresses, routes, DNS servers, or other network information to an endpoint. For container endpoints, since HNS manages IPAM, HNS will assign IP networking information from the NAT network to container endpoints. However, if a user is creating a VM and connecting a VM Network Adapter to a NAT network, the admin must assign the IP configuration manually inside the VM. 

### Accessing internal endpoints directly from the Host

Internal endpoints assigned to VMs or containers cannot be accessed using the external IPs / ports referenced in NAT static port mappings directly from the NAT host. From the NAT host, these internal endpoints must be addressed directly by their internal IP and ports. For instance, assume a container endpoint has IP 172.16.1.100 and is running a web server which is listening on port 80. Moreover, assume a port mapping has been created through docker to forward traffic from the host’s IP address (10.10.50.20) received on TCP port 8080 to the container endpoint. In this case, a user on the container host cannot directly access the web server using the externally mapped ports. e.g. A user operating on the container host cannot access the container web server indirectly on <http://10.10.50.20:8080>. Instead, the user must directly access the container web server on <http://172.16.1.100:80>. The one caveat to this limitation is that the internal endpoint can be accessed using the external IP/port from a separate, VM/container endpoint running on the same NAT host: this is called hair-pinning. E.g. A user operating on container A can access a web server running in Container B using the internal IP and port of <http://10.10.50.20:8080>. 

# Configuration Example: Attaching VMs and Containers to a NAT network

If you need to attach multiple VMs and containers to a single NAT, you will need to ensure that the NAT internal subnet prefix is large enough to encompass the IP ranges being assigned by different applications or services (e.g. Docker for Windows and Windows Container – HNS). This will require either application-level assignment of IPs and network configuration or manual configuration which must be done by an admin and guaranteed not to re-use existing IP assignments on the same host. The solution below will allow both Docker for Windows (Linux VM running Linux containers) and Windows Containers to share the same WinNAT instance using separate internal vSwitches. Connectivity between both Linux and Windows containers will work. 

### Example

  * User has connected VMs to a NAT network through an internal vSwitch named “VMNAT” and now wants to install Windows Container feature with docker engine 
    1.         PS C:\> Get-NetNat “VMNAT”| Remove-NetNat _(this will remove the NAT but keep the internal vSwitch)._

    2. Install Windows Container Feature
    3. DO NOT START Docker Service (daemon)
    4. Edit the arguments passed to the docker daemon (dockerd) by adding --fixed-cidr=<container prefix> parameter. This tells docker to create a default nat network with the IP subnet <container prefix> (e.g. 192.168.1.0/24) so that HNS can allocate IPs from this prefix.
    5.         PS C:\> Start-Service Docker; Stop-Service Docker

    6.         PS C:\> Get-NetNat | Remove-NetNAT _(again, this will remove the NAT but keep the internal vSwitch)_

    7.         PS C:\> New-NetNat -Name SharedNAT -InternalIPInterfaceAddressPrefix <shared prefix>

    8.         PS C:\> Start-Service docker


_Docker/HNS will assign IPs to Windows containers from the <container prefix> _ _Admin will assign IPs to VMs from the difference set of the <shared prefix> and <container prefix>_  

  * User has installed Windows Container feature with docker engine running and now wants to connect VMs to the NAT network 
    1.         PS C:\> Stop-Service docker

    2.         PS C:\> Get-ContainerNetwork | Remove-ContainerNetwork -force

    3.         PS C:\> Get-NetNat | Remove-NetNat _(this will remove the NAT but keep the internal vSwitch)_

    4. Edit the arguments passed to the docker daemon (dockerd) by adding -b “none” option to the end of docker daemon (dockerd) command to tell docker not to create a default NAT network.
    5.         PS C:\> New-ContainerNetwork –name nat –Mode NAT –subnetprefix <container prefix> _(create a new NAT and internal vSwitch – HNS will allocate IPs to container endpoints attached to this network from the <container prefix>)_

    6.         PS C:\> Get-Netnat | Remove-NetNAT _(again, this will remove the NAT but keep the internal vSwitch)_

    7.         PS C:\> New-NetNat -Name SharedNAT -InternalIPInterfaceAddressPrefix <shared prefix>

    8.         PS C:\> New-VirtualSwitch -Type internal _(attach VMs to this new vSwitch)_

    9.         PS C:\> Start-Service docker


_Docker/HNS will assign IPs to Windows containers from the <container prefix> _ _Admin will assign IPs to VMs from the difference set of the <shared prefix> and <container prefix>_ In the end, you should have two internal VM switches and one NetNat shared between them. 

# Troubleshooting

  1. Make sure you only have one NAT


    
    
    Get-NetNat

  2. If a NAT already exists, please delete it


    
    
    Get-NetNat | Remove-NetNat

  3. Make sure you only have one "internal" vmSwitch for the application or feature (e.g. Windows containers). Record the name of the vSwitch for Step 4


    
    
    Get-VMSwitch

  4. Check to see if there are private IP addresses (e.g. NAT default Gateway IP Address - usually *.1) from the old NAT still assigned to an adapter


    
    
    Get-NetIPAddress -InterfaceAlias "vEthernet(<name of vSwitch>)"

  5. If an old private IP address is in use, please delete it


    
    
    Remove-NetIPAddress -InterfaceAlias "vEthernet(<name of vSwitch>)" -IPAddress <IPAddress>

### Removing Multiple NATs

We have seen reports of multiple NAT networks created inadvertently. This is due to a bug in recent builds (including Windows Server 2016 Technical Preview 5 and Windows 10 Insider Preview builds). If you see multiple NAT networks, after running _docker network ls_ or _Get-ContainerNetwork_ , please perform the following from an elevated PowerShell: 
    
    
    $KeyPath = "HKLM:\SYSTEM\CurrentControlSet\Services\vmsmp\parameters\SwitchList"
     $keys = get-childitem $KeyPath
     foreach($key in $keys)
     {
     if ($key.GetValue("FriendlyName") -eq 'nat')
     {
     $newKeyPath = $KeyPath+"\"+$key.PSChildName
     Remove-Item -Path $newKeyPath -Recurse
     }
     }
    
    
    remove-netnat -Confirm:$false
    
    
    Get-ContainerNetwork | Remove-ContainerNetwork

**Restart the Computer**   ~ Jason Messer
