ms.ContentId: df65d9b4-5f3a-4ade-8a43-9821a49758c9
title: Manage Windows Container Networking

When deploying the container infrastructure, you will need to decide on a networking strategy for Windows Containers. Two options are available, assign IP addresses using network address translation technology or assign IP address using a DHCP server.

Network Address Translation – in this configuration the container host will be assigned an IP address that is reachable on the LAN. All containers will be auto assigned an address that cannot be accessed on the LAN. To make the containers accessible an external port of the host is mapped to an internal port of port of the container. These mappings are stored in a NAT port mapping table. The container is accessible through the address and mapped external port of the host. The benefit of NAT in a container configuration is that the container host can scale to hundreds of containers while only using one externally available IP Address.

<insert image>

DHCP – this configuration is similar to traditional system / virtual machine networking. In this configuration each container receives an IP Address from a DHCP server and is accessible on this IP address. The advantage here is that a port mapping table is not maintained.

## Configuring NAT

To configure the container system with NAT, create a virtual machine switch using the **New-VMSwitch** command.

```powershell
PS C:\> New-VMSwitch -Name "Virtual Switch" -SwitchType NAT -NATSubnetAddress "172.16.0.0/12"
Name           SwitchType NetAdapterInterfaceDescription
----           ---------- ------------------------------
Virtual Switch NAT
```
For more information on the New-VMSwitch Command see the [New-VMSwitch Reference](https://technet.microsoft.com/en-us/library/hh848455.aspx)
Configure Containers with NAT
When creating a Windows Container, a virtual switch can be specified. When the container is connected to a virtual switch configured to use network address translation, the container will receive a translated address.

This example creates a container and connects is to a NET enabled virtual switch.

```powershell

PS C:\> New-Container -Name DemoNAT -ContainerImageName WindowsServerCore -SwitchName "Virtual Switch"
Name    State Uptime   ParentImageName
----    ----- ------   ---------------
DemoNAT Off   00:00:00 WindowsServerCore
```
When the container has been started you can connect to the container and view the translated IP Address.
```powershell
[DemoNAT]: PS C:\> ipconfig
Windows IP Configuration
Ethernet adapter vEthernet (Virtual Switch-527ED2FB-D56D-4852-AD7B-E83732A032F5-0):
   Connection-specific DNS Suffix  . : corp.microsoft.com
   Link-local IPv6 Address . . . . . : fe80::384e:a23d:3c4b:a227%16
   IPv4 Address. . . . . . . . . . . : 172.16.0.2
   Subnet Mask . . . . . . . . . . . : 255.240.0.0
   Default Gateway . . . . . . . . . : 172.16.0.1
[DemoNAT]: PS C:\>  
```
For more information on starting and connecting to a Windows Container see [Managing Contianers](./manage_containers.md).

## Manage Port Mapping

In order to access applications inside of a container connected to a NAT enabled virtual switch, port mappings need to be created between the container and container host. This process is currently managed manually using the **New-NetNatStaticMapping** command. To create the mapping, you need the NAT assigned IP address of the container, the container port and the host port.
Create NAT

```powershell
PS C:\> New-NetNat -Name ContianerNAT -InternalIPInterfaceAddressPrefix "172.16.0.0/12"

Name                             : ContianerNAT
ExternalIPInterfaceAddressPrefix :
InternalIPInterfaceAddressPrefix : 172.16.0.0/12
IcmpQueryTimeout                 : 30
TcpEstablishedConnectionTimeout  : 1800
TcpTransientConnectionTimeout    : 120
TcpFilteringBehavior             : AddressDependentFiltering
UdpFilteringBehavior             : AddressDependentFiltering
UdpIdleSessionTimeout            : 120
UdpInboundRefresh                : False
Store                            : Local
Active                           : True
```

This example created a mapping name **ContianerNat** that maps port **82** of the host to port **80** of the continaer.

```powershell
PS C:\> Add-NetNatStaticMapping -NatName "ContianerNat" -Protocol TCP -ExternalIPAddress 0.0.0.0 -InternalIPAddress 172.16.0.2 -InternalPort 80 -ExternalPort 82

StaticMappingID               : 0
NatName                       : ContianerNat
Protocol                      : TCP
RemoteExternalIPAddressPrefix : 0.0.0.0/0
ExternalIPAddress             : 0.0.0.0
ExternalPort                  : 82
InternalIPAddress             : 172.16.0.2
InternalPort                  : 80
InternalRoutingDomainId       : {00000000-0000-0000-0000-000000000000}
Active                        : True
```

After the mapping has been created the container application can be accessed through the IP address of the host and external port, for example **10.0.0.5:82**.

![](./media/portmapping.png)

## Configure DHCP
To configure the container system so that containers receive an IP address from a DHCP server, create a virtual machine switch that is connected to a physical or virtual network adapter.
The following sample created a virtual machine switch with the name DHCP using a network adapter named Ethernet.

```powershell
S C:\> New-VMSwitch -Name DHCP -NetAdapterName Ethernet
Name SwitchType NetAdapterInterfaceDescription
---- ---------- ------------------------------
DHCP External   Microsoft Hyper-V Network Adapter
```

If the container host is itself a virtual machine you will need to enable MacAddressSpoofing for the network adapter used as the container switch. This is completed with the **Set-VMNetworkAdapter** command and is run on the VM Host.

```powershell
PS C:\> Get-VMNetworkAdapter -VMName TP4FullLatest | Set-VMNetworkAdapter -MacAddressSpoofing On
```
The DHCP enabled switch can now be connected to a container, which is then capable of receiving a IP address from a DHCP server.


## Other Commands to Include

`Get-ContainerNetworkAdapter'