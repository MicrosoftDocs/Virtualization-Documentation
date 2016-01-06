# Container Networking

**This is preliminary content and subject to change.** 

Windows containers function similarly to virtual machines in regards to networking. Each container has a virtual network adapter, which is connected to a virtual switch, over which inbound and outbound traffic is forwarded. Two types of network configuration are available.

- **Network Address Translation Mode** – each container is connected to an internal virtual switch and will receive an internal IP address. A NAT configuration will translate this internal address to the external address of the container host.

- **Transparent Mode** – each container is connected to an external virtual switch and will receive an IP Address from a DHCP server.

This document will detail the benefit and configuration of each of these.

## NAT Networking Mode

**Network Address Translation** – This configuration is comprised of an internal network switch with a type of NAT, and WinNat. In this configuration, the container host has an 'external' IP address which is reachable on a network. All containers are assigned 'internal' address that cannot be accessed on a network. To make a container accessible in this configuration, an external port of the host is mapped to an internal port of port of the container. These mappings are stored in a NAT port mapping table. The container is accessible through the IP Address and external port of the host, which forwards traffic to the internal IP address and port of the container. The benefit of NAT is that the container host can scale to hundreds of containers, while only using one externally available IP Address. Additionally, NAT allows multiple containers to host applications that may require identical communication ports.

### Host Configuration <!--1-->

To configure the container host for Network Address Translation, follow these steps.

Create a Virtual Switch with a type of ‘NAT’ and configure it with an internal subnet. For more information on the **New-VMSwitch** Command, see the [New-VMSwitch Reference](https://technet.microsoft.com/en-us/library/hh848455.aspx).

```powershell
New-VMSwitch -Name "NAT" -SwitchType NAT -NATSubnetAddress "172.16.0.0/12"
```
Create the Network Address Translation Object. This object is responsible for the NAT address translation. For more information on the **New-NetNat** command, see the [New-NetNat Reference](https://technet.microsoft.com/en-us/library/dn283361.aspx)

```powershell
New-NetNat -Name NAT -InternalIPInterfaceAddressPrefix "172.16.0.0/12" 
```

### Container Configuration 

When creating a Windows Container, a virtual switch can be selected for the container. When the container is connected to a virtual switch configured to use NAT, the container will receive a translated address.

This example creates a container connected to a NAT enabled virtual switch.

```powershell
New-Container -Name DemoNAT -ContainerImageName WindowsServerCore -SwitchName "NAT"
```

When the container has been started, the IP address can be viewed from within the container.

```powershell
[DemoNAT]: PS C:\> ipconfig

Windows IP Configuration
Ethernet adapter vEthernet (Virtual Switch-527ED2FB-D56D-4852-AD7B-E83732A032F5-0):
   Connection-specific DNS Suffix  . : contoso.com
   Link-local IPv6 Address . . . . . : fe80::384e:a23d:3c4b:a227%16
   IPv4 Address. . . . . . . . . . . : 172.16.0.2
   Subnet Mask . . . . . . . . . . . : 255.240.0.0
   Default Gateway . . . . . . . . . : 172.16.0.1
```

For more information on starting and connecting to a Windows Container see [Managing Containers](./manage_containers.md).

### Port Mapping

In order to access applications inside of a 'NAT enabled' container, port mappings need to be created between the container and container host. To create the mapping, you need the IP address of the container, the ‘internal’ container port and an ‘external’ host port.

This example creates a mapping between port **80** of the host to port **80** of a container with an IP address of **172.16.0.2**.

```powershell
Add-NetNatStaticMapping -NatName "Nat" -Protocol TCP -ExternalIPAddress 0.0.0.0 -InternalIPAddress 172.16.0.2 -InternalPort 80 -ExternalPort 80
```

This example creates a mapping between port **82** of the container host to port **80** of a container with an IP address of **172.16.0.3**.

```powershell
Add-NetNatStaticMapping -NatName "Nat" -Protocol TCP -ExternalIPAddress 0.0.0.0 -InternalIPAddress 172.16.0.3 -InternalPort 80 -ExternalPort 82
```
> A corresponding firewall rule will be required for each external port. This can be created with the `New-NetFirewallRule`. For more information see the [New-NetFirewallRule Reference](https://technet.microsoft.com/en-us/library/jj554908.aspx).

After the port mapping has been created, a containers application can be accessed through the IP address of the container host (physical or virtual), and exposed external port. For example, the below diagram depicts a NAT configuration with a request targeting external port **82** of the container host. Based on the port mapping, this request would return the application being hosted in container 2.

![](./media/nat1.png)

A view of the request from an internet browser.

![](./media/portmapping.png)

## Transparent Networking Mode

**Transparent Networking** – This configuration is comprised of an external network switch. In this configuration each container receives an IP Address from a DHCP server, and is accessible on this IP address. The advantage here is that a port mapping table is not maintained.

### Host Configuration <!--2-->

To configure the container system so that containers can receive an IP address from a DHCP server, create a virtual switch that is connected to a physical or virtual network adapter.

The following sample creates a virtual switch with the name DHCP, using a network adapter named Ethernet.

```powershell
New-VMSwitch -Name DHCP -NetAdapterName Ethernet
```

If the container host is itself a virtual machine, you need to enable MacAddressSpoofing on the network adapter used with the container switch. The following example completes this on a VM named `DemoVm`.

```powershell
Get-VMNetworkAdapter -VMName DemoVM | Set-VMNetworkAdapter -MacAddressSpoofing On
```
The external virtual switch can now be connected to a container, which is then capable of receiving a IP address from a DHCP server. In this configuration, applications hosted inside of the container will be accessible on the IP Address assigned to the container.

## Docker Configuration

When starting the Docker daemon, a network bridge can be selected. When running Docker on Windows, this is the External or NAT virtual switch. The following example starts the Docker daemon, specifying a virtual switch named `Virtual Switch`.

```powershell
Docker daemon –D –b “Virtual Switch” -H 0.0.0.0:2375
```

If you have deployed the container host, and Docker using the scripts provide in the Windows Container Quick Starts, an internal virtual switch is created with a type of NAT, and a Docker service is created and preconfigured to use this switch. To change the virtual switch that the Docker service is using, the Docker service needs to be stopped, a configuration file modified, and the service started again.

To stop the service run the following PowerShell command.

```powershell
Stop-Service docker
```

The configuration file can be found at `c:\programdata\docker\runDockerDaemon.cmd’. Edit the following line, replacing `Virtual Switch` with the name of the virtual switch to be used by the Docker service.

```powershell
docker daemon -D -b “New Switch Name"
```
Finally start the service.

```powershell
Start-Service docker
```

## Manage Container Network Adapters

Regardless of network configuration (NAT or Transparent), several PowerShell commands are available for managing container network adapter and virtual switch connections.

Manage a Containers Network Adapter

- Add-ContainerNetworkAdapter - Adds a network adapter to a container.
- Set-ContainerNetworkAdapter - Modifies a containers network adapter.
- Remove-ContainerNetworkAdapter - Removes a containers network adapter.
- Get-ContainerNetworkAdapter - Returns data about a containers network adapter.

Manage the connection between a containers network adapter and a virtual switch.

- Connect-ContainerNetworkAdapter - connects a container to a virtual switch.
- Disconect-ContainerNetworkAdapter - disconnects a container from a virtual switch.

For details on each of these command see the [Container PowerShell Reference]( https://technet.microsoft.com/en-us/library/mt433069.aspx).
