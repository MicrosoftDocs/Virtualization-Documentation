---
author: jmesser81
---

# Container Networking

**This is preliminary content and subject to change.** 

Windows containers function similarly to virtual machines in regards to networking. Each container has a virtual network adapter which is connected to a virtual switch over which inbound and outbound traffic is forwarded. In order to enforce isolation between containers on the same host, a network compartment is created for each Windows Server and Hyper-V Container into which the network adapter for the container is installed. Windows Server containers use a Host vNIC to attach to the virtual switch while Hyper-V Containers use a Synthetic VM NIC (not exposed to the Utility VM) to attach to the virtual switch.

Windows containers support four different networking modes. They are:

- **Network Address Translation Mode** – each container is connected to an internal virtual switch and will use WinNAT to connect containers to a private IP subnet. WinNAT will perform both network address translation (NAT) and port address translation (PAT) between the container host and the containers themselves.

- **Transparent Mode** – each container is connected to an external virtual switch and will be directly attached to the physical network. IPs can be assigned statically or dynamically using an external DHCP server. The raw container network traffic frames are placed directly on the physical network without any address translation.

- **L2 Bridge Mode** - each container is connected to an external virtual switch. Network traffic between two containers in the same IP subnet and attached to the same container host will be directly bridged. Network traffic between two containers on different IP subnets or attached to different container hosts will be sent out through the external virtual switch. On egress, network traffic originating from the container will have the source MAC address re-written to that of the container host. On ingress, network traffic destined for a container will have the destination MAC address re-written to that of the container itself.

- **L2 Tunnel Mode** - *(this mode should only be used in a Microsoft Cloud Stack)*. Similar to L2 Bridge mode, each container is connected to an external virtual switch with the MAC addresses re-written on egress and ingress. However, ALL container network traffic is forwarded to the physical host's virtual switch regardless of Layer-2 connectivity such that network policy can be enforced in the physical host's virtual switch as programmed by higher-levels of the networking stack (e.g. Network Controller or Network Resource Provider) in a Microosft cloud stack.

This document will detail the benefit and configuration of each of these.

## Docker Configuration

Either PowerShell or Docker can be used to create container networks, connect containers to a network, and setup port forwarding rules since the same Host Network Service (HNS) is used to create the required connectivity (e.g. vSwitch, NetNat, etc.) in the container host. Moving forward, emphasis will focus on the Docker networking commands based on Docker's cloud network model (CNM).

The list of acceptable drivers for docker network creation are 'transparent', 'nat', and 'l2bridge'. As was stated previously, the L2 tunnel driver, should only be used in Microsoft Azure public cloud deployment scenarios. 
***Note: Docker network drivers are all lower-case***

The Docker daemon refers to different networking modes by the name of the driver used to create the network. For instance, the NAT networking mode has a corresponding Docker network driver named nat. By default, the Docker engine on Windows will look for a network with a nat driver. If a NAT network does not exist, the Docker engine will create one. All containers created will be attached to the nat network by default.

This behavior (using a NAT network driver by default) can be overriden by specifying a specific "bridge" named "none" using the -b none option when starting the Docker daemon engine.

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

When running the docker daemon with '-b "none"' a specific network will need to be be created and referenced during container creation / start.

In order to list the container networks available on the host, a user can use the following Docker or PowerShell commands.

```powershell
docker network ls

C:\>docker network ls
NETWORK ID          NAME                DRIVER
bd8b691a8286        nat                 nat
7b055c7ed373        none                null
```

```powershell
PS C:\> Get-ContainerNetwork |fl

Name               : nat
SubnetPrefix       : {172.16.0.0/12}
Gateways           : {172.16.0.1}
Id                 : 67ea1851-326d-408b-a5ef-7dcdb15c4438
Mode               : NAT
NetworkAdapterName :
SourceMac          :
DNSServers         : {10.222.118.22, 10.221.228.12, 10.222.114.67}
DNSSuffix          : corp.microsoft.com
IsDeleted          : False
```

We will now look at the different network modes (drivers) individually.

***Note: In PowerShell, networking mode names are not case-sensitive.***


## NAT Networking Mode

**Network Address Translation** – This networking mode is useful when you need a quick and easy way to assign private IP addresses to containers which do not require direct connectivity to a physical or virtual network (described below).  In this configuration, all network services running in a container which need to be externally accessible will require a port mapping between the 'external' IP address and port on the container host and the 'internal' IP address and port on the container on which the network service is listening. These mappings are stored in the WinNAT port mapping tables. All network traffic received on an external IP address and port which has an entry in the mapping table will be forwarded to the specific container endpoint to the destination port specified in the port mapping table. Additionally, NAT allows multiple containers to host applications that may require identical (internal) communication ports by mapping these to unique external ports.

***Note: In TP5, a single firewall rule will be automatically created for a NAT static port mapping. This firewall rule will be global to the container host and not localized to a specific container endpoint or network adapter.***

***Note: In TP5, when you create a NAT container network in which the container host is connected to a specific physical network (e.g. Corporate Network) this network's settings (e.g. DNS Server) will be persisted. If the container host is mobile (e.g. laptop) and connects to a different physical network (e.g. Home Network) any containers which are created and attached to the NAT container network will still use the DNS server settings from that first physical network (i.e. the one on which the container host was connected when the container network was created). This is a bug which will be fixed in the next release.***

### Host Configuration <!--1-->

To use the NAT Networking mode, create a Container Network with driver name 'nat'.

***Note: By default, a NAT network is created when the Docker daemon starts if one does not already exist.***

```powershell
docker network create -d nat MyNatNetwork
```

Additional parameters such as Gateway IP address (--gateway=<string[]>) and subnet prefix (--subnet=<string[]>) can be added on to the docker network create command. See below for additional details.

In order to create a NAT network using PowerShell, one would use the following syntax. Notice that additional parameters including DNSServers and DNSSuffix can be specified by using PowerShell. If not specified, these settings are inherited from the container host and used in the container itself.

```powershell
New-ContainerNetwork -Name MyNatNetwork -Mode NAT -SubnetPrefix "172.16.0.0/12" [-GatewayAddress <string[]>] [-DNSServers <string[]>] [-DNSSuffix <string>]
```

***Note: You can only have one NAT network***

## Transparent Networking Mode

**Transparent Networking** – This networking mode should only be used in very small deployments when you do not require address translation but rather want direct connectivity between your containers and the physical network. In this configuration, all network services running in a container will be directly accessible from the physical network. IP addresses can be assigned statically assuming they are within the physical network's IP subnet prefix and do not conflict with other IPs on the physical network. IP addresses can also be assigned dynamically from an external DHCP server on the physical network. 

### Host Configuration <!--2-->

To use the Transparent Networking mode, create a Container Network with driver name 'transparent'. 

```powershell
docker network create -d transparent MyTransparentNetwork
```
The PowerShell syntax is similar.

```powershell
New-ContainerNetwork -Name MyTransparentNet -Mode Transparent -NetworkAdapterName "Ethernet"
```

If the container host is itself a virtual machine and you wish to use DHCP for IP assignment, you must enable MACAddressSpoofing in the physical host on the VM Network Adapter to which the container host VM is attached. The following example completes this on a VM named `ContaiherHostVm`.

```powershell
Get-VMNetworkAdapter -VMName ContainerHostVM | Set-VMNetworkAdapter -MacAddressSpoofing On
```
Containers can now connect directly to the 'Transparent' network named "MyTransparentNet" which is capable of receiving a IP address from a DHCP server. In this configuration, applications hosted inside of the container will be directly accessible by external clients using the IP Address assigned to the container.

Since the Transparent network is connected directly to the underlying physical network, a user must be careful to ensure that statically assigned IP addresses do not conflict with an existing IP address on the physical network. Similar to the 'nat' networking mode (driver), if a user is not using DHCP for IP assignment, a gateway IP address can (and should) be specified. It does not make sense to specify a "--subnet" parameter in the context of creating a Transparent network

## L2 Bridge Networking Mode

**L2 Bridge Networking** - This networking mode can be used in any deployment including when containers are hosted on a bare-metal server, in a container host VM, or in a Microsoft private cloud (e.g. Microsoft Azure Stack) deployment. In this configuration, the Virtual Filtering Platform (VFP) vSwitch extension in the container host will act as a Bridge and perform Layer-2 address translation (MAC address re-write) as required. The Layer-3 IP addresses and Layer-4 ports will remain unchanged. IP Addresses can be statically assigned to correspond with the physical network's IP subnet prefix or, if using a Microsoft private cloud deployment, with an IP from the virtual network's subnet prefix.

### Host Configuration <!--3-->

To use the L2 Bridge Networking mode, create a Container Network with driver name 'l2bridge'.

```powershell
C:\> docker network create -d l2bridge MyBridgeNetwork
```

```powershell
New-ContainerNetwork -Name MyBridgeNetwork -Mode L2Bridge -NetworkAdapterName "Ethernet"
```

## L2 Tunnel Networking Mode

**L2 Tunnel Networking** - This networking mode should not be used in any environment except Microsoft Azure public cloud. 

## Docker Network Creation Options

Different docker networking commands and options can be specified at either container network creation time or container creation time. In addition to the -d (--driver=<network mode>) option to specify networking mode, the --gateway, --subnet, and -o options are also supported when creating a container network.

A user can specify a specific gateway IP address when using static IP allocation / network configuration (e.g. for Transparent networks). If using NAT or Transparent mode with DHCP you should not change the gateway IP address.
```powershell
docker network create -d transparent --gateway=10.50.34.1 "MyTransparentNet"
```

A user can also specify a specific IP subnet prefix to represent a specific network segment and from which IP addresses will be allocated.
```powershell
docker network create -d nat --subnet=192.168.0.0/24 "MyCustomNatNetwork"
```
Additional customizations to a container network can be made through docker by using the -o (--opt=map[]) parameter. 

In order to specify which network adapter in the container host to use for a Transparent, L2Bridge, or L2 Tunnel network, a user can specify the *com.docker.network.windowsshim.interface* option
```powershell
PS C:\> Get-NetAdapter

docker network create -d transparent -o com.docker.network.windowsshim.interface="Ethernet 2" "TransparentNetTwo"
```

In order for container networks created through Docker to be accessible by the same name using PowerShell cmdlets the *com.docker.network.windowsshim.networkname* option must be given:
```powershell
docker network create -d transparent -o com.docker.network.windowsshim.networkname="MyTransparentNet" "MyTransparentNet"
```
***Note: Container networks which are created through PowerShell will not be available in Docker until the Docker daemon is restarted. Any other changes made to a container network via PowerShell also requires a restart of the docker daemon.***

### Support for Multiple Container Networks on a Single Container Host

Multiple container networks can be created on a single container host with the following caveats:
* Only one NAT network can be created per container host
* Multiple networks which use an external vSwitch for connectivity (e.g. Transparent, L2 Bridge, L2 Transparent) must each use its own network adapter
* Different networks must use different vSwitches

### Container Configuration 

When creating a Windows Container, a network can be specified to which the container network adapter will be connected. If no network is specified, the default NAT network will be used to provide connectivity. 

In order to attach a container to the non-default NAT network (or when -b "none" is in use), use the --net option with the docker run command. This example creates a container explicitly connected to the default "nat" container network

```powershell
C:\> docker run -it --net=nat windowsservercore cmd
```

This example creates a container connected to the "MyTransparentNet" container network using PowerShell.

```powershell
New-Container -Name DemoTransparent -ContainerImageName WindowsServerCore -NetworkName "MyTransparentNet"
```

In order to assign a specific IP address to the container, you must set a static IP address (from within the range of the container network's subnet prefix defined above) on the container's network adapter. Static IP assignment is only supported for NAT, Transparent, and L2Bridge networking modes. Furthermore, Static IP assignment is not supported for the default "nat" network through Docker.

```powershell
docker run -it --net=MyTransparentNet --ip=10.80.123.32 windowsservercore cmd
```

Static IP assignment is performed directly on the container's network adapter and must only be performed when the container is in a STOPPED state. "Hot-add" of container network adapters or changes to the network stack is not supported while the container is running.

```powershell
PS C:\> Get-ContainerNetworkAdapter -ContainerName "DemoNAT"

ContainerName Name            Network Id                           Static MacAddress Static IPAddress Maximum Bandwidth
------------- ----            ----------                           ----------------- ---------------- -----------------
DemoNAT       Network Adapter C475D31C-FB42-408E-8493-6DB6C9586915                   			0

PS C:\> Set-ContainerNetworkAdapter -ContainerName "DemoNAT" -StaticIPAddress 172.16.0.100
```

If you would rather the IP address be chosen automatically from the range specified in the container network's subnet prefix, you can simply start the container as-is without applying any settings to the container network adapter.

```powershell
docker run -it --net=nat windowsservercore cmd
```

```powershell
PS C:\> Start-Container "DemoNAT"
```

***Note: Static IP Address assignment through PowerShell will not work on container endpoints attached to a Transparent network***

In order to see which containers are connected to a specific network and the IPs associated with these container endpoints you can run the following.

```powershell
C:\>docker network inspect nat
```

Through PowerShell, when the container has been started, the IP address of the container can be viewed from the container host.

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

### Container Creation

In addition to the -p (--publish=[], -P and --net commands documented separately, a user can also specify a MAC by using the --mac-address option after docker run
```powershell
docker run -it --mac="92:d0:c6:0a:29:33" --name="MyContainer" windowsservercore cmd
```


### Port Mapping

In order to access applications inside of a container connected to a NAT network, port mappings need to be created between the container host and container network adapter. These mappings must be created while the container is in a STOPPED state.

This example creates a static mapping between port **80** of the container host to port **80** of the container to which the specified container network adapter is attached.

```powershell
docker run -it --name=DemoNat -p 80:80 windowsservercore cmd
```

```powershell
Add-ContainerNetworkAdapterStaticMapping -ContainerName "DemoNAT" -AdapterName "Network Adapter" -ExternalPort 80 -InternalPort 80 -Protocol TCP
```

This example creates a static mapping between port **8082** of the container host to port **80** of the container to which the specified container network adapter is attached. You can 

```powershell
docker run -it --name=DemoNat -p 8082:80 windowsservercore cmd
```

Similarly, for PowerShell:

```powershell
Add-ContainerNetworkAdapterStaticMapping -ContainerName "DemoNAT" -AdapterName "Network Adapter" -ExternalPort 8082 -InternalPort 80 -Protocol TCP
```

Dynamic port mappings are also supported through docker such that a user does not need to specify a specific port to map from the container host. A randomly chosen ephemeral port will be chosen on the container host and can be inspected when running docker ps.

```powershell
docker run -itd --name=DemoNat -p 80 windowsservercore cmd

docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                   NAMES
bbf72109b1fc        windowsservercore   "cmd"               6 seconds ago       Up 2 seconds        *0.0.0.0:14824->80/tcp*   DemoNat
```

In this example, the DemoNat container's TCP port 80 is being exposed externally from the container host on port 14824.


Beginning in Technical Preview 5, it is no longer necessary to create an explicit firewall rule. 

After the port mapping has been created, a container's application can be accessed through the IP address of the container host (physical or virtual), and exposed external port. For example, the below diagram depicts a NAT configuration with a request targeting external port **82** of the container host. Based on the port mapping, this request would return the application being hosted in container 2.

![](./media/nat1.png)

A view of the request from an internet browser.

![](./media/portmapping.png)


## Removing Networks

In order to delete a specific container network, you can use the following commands

```powershell
docker network rm "<network name>"
```

Through PowerShell
```
Remove-ContainerNetwork -Name <network name>
```

This will clean up any Hyper-V Virtual switches which the container network used and also any Nats created for nat container networks.

## Caveats and Gotchas

 * The container host requires specific Firewall rules to be created to enable ICMP (Ping), DHCP, and RDP (Remote Desktop). ICMP and DHCP are required by Windows Server Containers to ping between two containers on the same host and to receive dynamically assigned IP addresses through DHCP (RDP to a container is not supported). In TP5, these rules will be created through the Install-ContainerHost.ps1 script. Post-TP5, these rules will be created automatically. All Firewall rules corresponding to NAT port forwarding rules will be created automatically and cleaned up when the container stops.
 *

The following networking features are not supported today through docker CLI
 * container linking (e.g. --link)
 * name-based IP resolution for containers

The following network options are not supported on Windows docker at this time:
 * --add-host
 * --dns
 * --dns-opt
 * --dns-search
 * -h, --hostname
 * --net-alias
 * --aux-address
 * --internal
 * --ip-range

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

For details on each of these command see the [Container PowerShell reference]( https://technet.microsoft.com/en-us/library/mt433069.aspx).