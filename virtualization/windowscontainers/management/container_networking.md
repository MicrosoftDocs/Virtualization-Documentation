---
author: neilpeterson
author: jmesser81
---

# Container Networking

**This is preliminary content and subject to change.** 

Windows containers function similarly to virtual machines in regards to networking. Each container has a virtual network adapter, which is connected to a virtual switch, over which inbound and outbound traffic is forwarded. In order to enforce isolation between containers on the same host, a network compartment is created for each Windows Server and Hyper-V Container into which the network adapter for the container is installed. Windows Server containers use a Host vNIC to attached to the virtual switch while Hyper-V Containers use a Synthetic VM NIC (not exposed to the Utility VM) to attach to the virtual switch.

Windows containers support four different networking modes. They are:

- **Network Address Translation Mode** – each container is connected to an internal virtual switch and will use WinNAT to connect containers to a private IP subnet. WinNAT will perform both network address translation (NAT) and port address translation (PAT) between the container host and the containers themselves.

- **Transparent Mode** – each container is connected to an external virtual switch and will be directly attached to the physical network. IPs can be assigned statically or dynamically using an external DHCP server. The raw container network traffic frames are placed directly on the physical network without any address translation.

- **L2 Bridge Mode** - each container is connected to an external virtual switch. Network traffic between two containers in the same IP subnet and attached to the same container host will be directly bridged. Network traffic between two containers on different IP subnets or attached to different container hosts will be sent out through the external virtual switch. On egress, network traffic originating from the container will have the source MAC address re-written to that of the container host. On ingress, network traffic destined for a container will have the destination MAC address re-written to that of the container itself.

- **L2 Tunnel Mode** - (this mode should only be used in a Microsoft Cloud Stack). Similar to L2 Bridge mode, each container is connected to an external virtual switch with the MAC addresses re-written on egress and ingress. However, ALL container network traffic is forwarded to the physical host's virtual switch regardless of Layer-2 connectivity such that network policy is enforced in the physical host's virtual switch as programmed by higher-levels (e.g. Network Controller or Network Resource Provider) in a Microosft cloud stack.

This document will detail the benefit and configuration of each of these.

## NAT Networking Mode

**Network Address Translation** – This networking mode is useful when you need a quick and easy way to assign private IP addresses to containers which do not require direct connectivity to a physical or virtual network (described below).  In this configuration, all network services running in a container which need to be externally accessible will require a port mapping between the 'external' IP address and port assigned to the container host and the 'internal' IP address and port assigned to the container. These mappings are stored in the WinNAT port mapping tables. All network traffic received on the external IP address and port is forwarded to the container. Additionally, NAT allows multiple containers to host applications that may require identical communication ports by mapping unique external ports.

### Host Configuration <!--1-->

To use the NAT Networking mode, create a Container Network with mode 'NAT' and specify an internal subnet prefix. 

```powershell
New-ContainerNetwork -Name nat -Mode NAT -SubnetPrefix "172.16.0.0/12" [-GatewayAddress <string[]>] [-DNSServers <string[]>] [-DNSSuffix <string>]
```

### Container Configuration 

When creating a Windows Container, a network can be specified to which the container network adapter will be connected.

This example creates a container connected to the "nat" container network

```powershell
New-Container -Name DemoNAT -ContainerImageName WindowsServerCore -NetworkName "nat"
```

In order to assign a specific IP address to the container, you must set a static IP address (from within the range of the container network's subnet prefix defined above) on the container's network adapter.

```powershell
PS C:\> Get-ContainerNetworkAdapter -ContainerName "DemoNAT"

ContainerName Name            Network Id                           Static MacAddress Static IPAddress Maximum Bandwidth
------------- ----            ----------                           ----------------- ---------------- -----------------
DemoNAT       Network Adapter C475D31C-FB42-408E-8493-6DB6C9586915                   			0

PS C:\> Set-ContainerNetworkAdapter -ContainerName "DemoNAT" -StaticIPAddress 172.16.0.100
```

If you would rather the IP address be chosen automatically from the range specified in the container network's subnet prefix, you can simply start the container as-is without applying any settings to the container network adapter.

```powershell
PS C:\> Start-Container "DemoNAT"
```

When the container has been started, the IP address of the container can be viewed from the container host.

```powershell
PS C:\> Invoke-Command -ContainerName DemoNAT {ipconfig}

Windows IP Configuration

Ethernet adapter vEthernet (Temp Nic Name):

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::2d76:2fc0:73e7:5cda%12
   IPv4 Address. . . . . . . . . . . : 172.16.0.100
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . : 172.16.0.1
```

For more information on starting and connecting to a Windows Container see [Managing Containers](./manage_containers.md).

### Port Mapping

In order to access applications inside of a container connected to a NAT network, port mappings need to be created between the container host and container network adapter. These mappings must be created while the container is in a STOPPED state.

This example creates a mapping between port **80** of the container host to port **80** of the container to which the specified container network adapter is attached.

```powershell
Add-ContainerNetworkAdapterStaticMapping -ContainerName "DemoNAT" -AdapterName "Network Adapter" -ExternalPort 80 -InternalPort 80 -Protocol TCP
```

This example creates a mapping between port **8082** of the container host to port **80** of the container to which the specified container network adapter is attached.

```powershell
Add-ContainerNetworkAdapterStaticMapping -ContainerName "DemoNAT" -AdapterName "Network Adapter" -ExternalPort 8082 -InternalPort 80 -Protocol TCP
```

Beginning in Technical Preview 5, it is no longer necessary to create an explicit firewall rule. 

After the port mapping has been created, a container's application can be accessed through the IP address of the container host (physical or virtual), and exposed external port. For example, the below diagram depicts a NAT configuration with a request targeting external port **82** of the container host. Based on the port mapping, this request would return the application being hosted in container 2.

![](./media/nat1.png)

A view of the request from an internet browser.

![](./media/portmapping.png)

## Transparent Networking Mode

**Transparent Networking** – This networking mode should only be used in very small deployments when you do not require address translation but rather want direct connectivity between your containers and the physical network. In this configuration, all network services running in a container will be directly accessible from the physical network. IP addresses can be assigned statically assuming they are within the physical network's IP subnet prefix and do not conflict with other IPs on the physical network. IP addresses can also be assigned dynamically from an external DHCP server on the physical network. 

### Host Configuration <!--2-->

To use the Transparent Networking mode, create a Container Network with mode 'Transparent' and specify a physical or virtual network adapter to which the external vSwitch will be connected. 

```powershell
New-ContainerNetwork -Name MyTransparentNet -Mode Transparent -NetworkAdapterName "Ethernet"
```

If the container host is itself a virtual machine and you wish to use DHCP for IP assignment, you must enable MACAddressSpoofing in the physical host on the VM Network Adapter to which the container host VM is attached. The following example completes this on a VM named `ContaiherHostVm`.

```powershell
Get-VMNetworkAdapter -VMName ContainerHostVM | Set-VMNetworkAdapter -MacAddressSpoofing On
```
Containers can now connect directly to the 'Transparent' network named "MyTransparentNet" which is capable of receiving a IP address from a DHCP server. In this configuration, applications hosted inside of the container will be directly accessible by external clients using the IP Address assigned to the container.

This example creates a container connected to the "MyTransparentNet" container network

```powershell
New-Container -Name DemoTransparent -ContainerImageName WindowsServerCore -NetworkName "MyTransparentNet"
```

If you want to specify a static IP address for containers connected to a Transparent network, you must do so while the container is STOPPED.

```powershell
PS C:\> Set-ContainerNetworkAdapter -ContainerName "DemoTransparent" -StaticIPAddress 10.123.174.22
PS C:\> Get-ContainerNetworkAdapter -ContainerName "DemoTransparent"

ContainerName   Name            Network Id                           Static MacAddress Static IPAddress Maximum
                                                                                                        Bandwidth
-------------   ----            ----------                           ----------------- ---------------- ---------------
DemoTransparent Network Adapter 1D139A5C-EFF4-4878-8EB0-0E2A39A48745                   10.123.174.22    0
```

## L2 Bridge Networking Mode

**L2 Bridge Networking** - This networking mode...

### Host Configuration <!--3-->

## L2 Tunnel Networking Mode

**L2 Tunnel Networking** - This networking mode...

### Host Configuration <!--4-->



## Docker Configuration

The Docker daemon refers to different networking modes by the name of the driver used to create the network. For instance, the NAT networking mode has a corresponding Docker network driver named nat. By default, the Docker engine on Windows will look for a network with a nat driver. If a nat network does not exist, the Docker engine will create one. All containers created will be attached to the nat network by default.

This behavior (using a NAT network driver by default) can be overriden by specifying a specific "bridge" named "none" using the -b none option when starting the Docker daemon engine. The configuration file can be found at `c:\programdata\docker\runDockerDaemon.cmd` and requires that the docker service be restarted.

To stop the service run the following PowerShell command.

```powershell
Stop-Service docker
```

The configuration file can be found at `c:\programdata\docker\runDockerDaemon.cmd`. Edit the following line, and add `-b "none"`

```powershell
Docker daemon -D -b “none” -H 0.0.0.0:2375
```

Restart the service.

```powershell
Start-Service docker
```

In this mode, a specific network will need to be be created and referenced during container start.

You can check and see which container networks are available through docker by executing the docker network ls command.

```powershell
C:\>docker network ls

NETWORK ID          NAME                DRIVER
e660288f15f3        nat                 nat
e55acdfbd0f8        none                null
```

You can also inspect networks to see what container endpoints are already connected to a given network.

```powershell
C:\>docker network inspect nat
```

Lastly, you can create new networks by specifying the network driver to use and any associated parameters.
***Note: You can only have one NAT network***

For instance, in order to create a new Transparent network through docker, you would issue the following command:
***Note: Docker network drivers are all lower-case***

```powershell
C:\> docker network create -d transparent MyTransparentNet
```

In order to attach a container to the non-default NAT network (or when -b "none" is in use), use the --net option to the docker run command.

```powershell
C:\> docker run -it --net=MyTransparentNet windowsservercore cmd
```


## Manage Network Adapters

Regardless of networking mode or driver, several PowerShell commands are available for managing container network adapter and virtual switch connections.

Manage a Containers Network Adapter

- Add-ContainerNetworkAdapter - Adds a network adapter to a container.
- Set-ContainerNetworkAdapter - Modifies a container's network adapter.
- Remove-ContainerNetworkAdapter - Removes a container's network adapter.
- Get-ContainerNetworkAdapter - Returns data about a container's network adapter.

Manage the connection between a containers network adapter and a virtual switch.

- Connect-ContainerNetworkAdapter - connects a container to a virtual switch.
- Disconnect-ContainerNetworkAdapter - disconnects a container from a virtual switch.

For details on each of these command see the [Container PowerShell Reference]( https://technet.microsoft.com/en-us/library/mt433069.aspx).
