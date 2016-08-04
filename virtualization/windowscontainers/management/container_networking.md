---
title: Windows Container Networking
description: Configure networking for Windows containers.
keywords: docker, containers
author: jmesser81
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 538871ba-d02e-47d3-a3bf-25cda4a40965
---

# Container Networking

**This is preliminary content and subject to change.** 

Windows containers function similarly to virtual machines in regards to networking. Each container has a virtual network adapter which is connected to a virtual switch, over which inbound and outbound traffic is forwarded. In order to enforce isolation between containers on the same host, a network compartment is created for each Windows Server and Hyper-V Container into which the network adapter for the container is installed. Windows Server containers use a Host vNIC to attach to the virtual switch. Hyper-V Containers use a Synthetic VM NIC (not exposed to the Utility VM) to attach to the virtual switch.

Windows containers support four different networking modes.

- **Network Address Translation Mode** – each container is connected to an internal virtual switch and will use WinNAT to connect to a private IP subnet. WinNAT will perform both network address translation (NAT) and port address translation (PAT) between the container host and the containers themselves.

- **Transparent Mode** – each container is connected to an external virtual switch and will be directly attached to the physical network. IPs can be assigned statically or dynamically using an external DHCP server. The raw container network traffic frames are placed directly on the physical network without any address translation.

- **L2 Bridge Mode** - each container is connected to an external virtual switch. Network traffic between two containers in the same IP subnet and attached to the same container host will be directly bridged. Network traffic between two containers on different IP subnets or attached to different container hosts will be sent out through the external virtual switch. On egress, network traffic originating from the container will have the source MAC address re-written to that of the container host. On ingress, network traffic destined for a container will have the destination MAC address re-written to that of the container itself.

- **L2 Tunnel Mode** - *(this mode should only be used in a Microsoft Cloud Stack)*. Similar to L2 Bridge mode, each container is connected to an external virtual switch with the MAC addresses re-written on egress and ingress. However, ALL container network traffic is forwarded to the physical host's virtual switch regardless of Layer-2 connectivity. This allows network policy to be enforced in the physical host's virtual switch, as programmed by higher-levels of the networking stack (e.g. Network Controller or Network Resource Provider).

This document will detail the benefit and configuration of each of these.

## Create a Network

### Overview

Either PowerShell or Docker can be used to create container networks, connect containers to a network, and setup port forwarding rules. Moving forward, emphasis will focus on Docker networking commands based on Docker's cloud network model (CNM).

The list of acceptable drivers for Docker network creation are 'transparent', 'nat', and 'l2bridge'. As was stated previously, the L2 tunnel driver, should only be used in Microsoft Azure public cloud deployment scenarios. 

> Docker network drivers are all lower-case.

The Docker daemon refers to different networking modes by the name of the driver used to create the network. For instance, the NAT networking mode has a corresponding Docker network driver named nat. By default, the Docker engine on Windows will look for a network with a nat driver. If a NAT network does not exist, the Docker engine will create one. All containers created will be attached to the nat network by default.

This behavior (using a NAT network driver by default) can be overridden by specifying a specific "bridge" named "none" using the -b none option when starting the Docker daemon engine.

To stop the service run the following PowerShell command.

```none
Stop-Service docker
```

The configuration file can be found at `c:\programdata\docker\runDockerDaemon.cmd`. Edit the following line, and add `-b "none"`

```none
dockerd <options> -b “none”
```

Restart the service.

```none
Start-Service docker
```

When running the Docker daemon with '-b "none"' a specific network will need to be be created and referenced during container creation / start.

In order to list the container networks available on the host, use the following Docker or PowerShell commands.

```none
docker network ls
```
Which will output something similar to:

```none
NETWORK ID          NAME                DRIVER
bd8b691a8286        nat                 nat
7b055c7ed373        none                null
```
Or the equivalent with PowerShell:


```none
Get-ContainerNetwork |fl
```

Which will output something similar to:

```none
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

> In PowerShell, networking mode names are not case-sensitive.


### NAT Networking

**Network Address Translation** – This networking mode is useful to quickly assign private IP addresses to a containers. External access to the container is provided through mapping a port between the external IP address and port (container host), and the internal IP address and port of the container. All network traffic received on the external IP address / port combo is compared to a WinNAT port mapping table, and forwarded to the correct container IP address and port. Additionally, NAT allows multiple containers to host applications that may require identical (internal) communication ports by mapping these to unique external ports. Windows only suppots the existence of one NAT network internal prefix per host. For more information read the blog post [WinNAT capabilities and limitations](https://blogs.technet.microsoft.com/virtualization/2016/05/25/windows-nat-winnat-capabilities-and-limitations/) 

> Beginning in TP5, a firewall rule will be automatically created for all NAT static port mappings. This firewall rule will be global to the container host and not localized to a specific container endpoint or network adapter.

#### Host Configuration <!--1-->

To use the NAT Networking mode, create a Container Network with driver name 'nat'. 

> Since only one _nat_ default network can be created per host, make sure you only create a new NAT network when all other NAT networks have been removed and docker daemon is run with the '-b "none"' option. Alternatively, if you simply want to control which internal IP network is used by NAT, you can add the _--fixed-cidr=<NAT internal prefix / mask>_ option to the dockerd command in C:\ProgramData\docker\runDockerDaemon.cmd.

```none
docker network create -d nat MyNatNetwork [--subnet=<string[]>] [--gateway=<string[]>]
```

In order to create a NAT network using PowerShell, one would use the following syntax. Notice that additional parameters including DNSServers and DNSSuffix can be specified by using PowerShell. If not specified, these settings are inherited from the container host.

```none
New-ContainerNetwork -Name MyNatNetwork -Mode NAT -SubnetPrefix "172.16.0.0/12" [-GatewayAddress <address>] [-DNSServers <address>] [-DNSSuffix <string>]
```

> There is a known bug in Windows Server 2016 Technical Preview 5 and recent Windows Insider Preview (WIP) "flighted" builds where, upon upgrade to a new build results in a duplicate (i.e. "leaked") container network and vSwitch. In order to work-around this issue, please run the following script.
```none
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
Get-VmSwitch -Name nat | Remove-VmSwitch # Note: failure is expected
Stop-Service docker
Set-Service docker -StartupType Disabled
```
> Reboot the host, then run the remaining steps:
```none
Get-NetNat | Remove-NetNat -Confirm $false
Set-Service docker -StartupType automatic
Start-Service docker 
```

### Transparent Networking

**Transparent Networking** – This networking mode should only be used in very small deployments where direct connectivity between containers and the physical network is required. In this configuration, all network services running in a container will be directly accessible from the physical network. IP addresses can be assigned statically, assuming they are within the physical network's IP subnet prefix, and do not conflict with other IPs on the physical network. IP addresses can also be assigned dynamically from an external DHCP server on the physical network. If DHCP is not being used for IP assignment, a gateway IP address can be specified. 

#### Host Configuration <!--2-->

To use the Transparent networking mode, create a container network with driver name 'transparent'. 

```none
docker network create -d transparent MyTransparentNetwork
```

In this example the transparent network is being created and assigned a gateway.

```none
docker network create -d transparent --gateway=10.50.34.1 "MyTransparentNet"
```

If the container host is virtualized, and you wish to use DHCP for IP assignment, you must enable MACAddressSpoofing on the virtual machines network adapter.

```none
Get-VMNetworkAdapter -VMName ContainerHostVM | Set-VMNetworkAdapter -MacAddressSpoofing On
```

> If you wish to create more than one transparent (or l2bridge) networks you must specify to which (virtual) network adapter the external Hyper-V Virtual Switch (created automatically) should bind.
 
### L2 Bridge Networking

**L2 Bridge Networking** - In this configuration, the Virtual Filtering Platform (VFP) vSwitch extension in the container host, will act as a Bridge and perform Layer-2 address translation (MAC address re-write) as required. The Layer-3 IP addresses and Layer-4 ports will remain unchanged. IP Addresses can be statically assigned to correspond with the physical network's IP subnet prefix or, if using a Microsoft private cloud deployment, with an IP from the virtual network's subnet prefix.

#### Host Configuration <!--3-->

To use the L2 Bridge Networking mode, create a Container Network with driver name 'l2bridge'. A subnet and gateway must also be specified when creating a L2Bridge network.

```none
docker network create -d l2bridge --subnet=192.168.1.0/24 --gateway=192.168.1.1 MyBridgeNetwork
```

## Remove a Network

Use `docker network rm` to delete a container network.

```none
docker network rm "<network name>"
```
Or `Remove-ContainerNetwork` with PowerShell:

This will clean up any Hyper-V Virtual switches which the container network used, and also any network address translation objects created for nat container networks.

## Network Options

Different Docker networking options can be specified when the container network is created or when a container itself is created. In addition to the -d (--driver=<network mode>) option to specify networking mode, the --gateway, --subnet, and -o options are also supported when creating a container network.

### Additional Options

Gateway IP address can be specified using `--gateway`. This should be completed only when using statically assigned IP allocation (transparent networks).

```none
docker network create -d transparent --gateway=10.50.34.1 "MyTransparentNet"
```

An IP subnet prefix can specified using `--subnet`, which will control the network segment from which IP addresses will be allocated.

```none
docker network create -d nat --subnet=192.168.0.0/24 "MyCustomNatNetwork"
```
Additional customizations to a container network can be made through Docker by using the -o (--opt=map[]) parameter. 

In order to specify which network adapter in the container host to use for a Transparent, L2Bridge, or L2 Tunnel network, specify the *com.docker.network.windowsshim.interface* option. 
```none
docker network create -d transparent -o com.docker.network.windowsshim.interface="Ethernet 2" "TransparentNetTwo"
```

Value for *com.docker.network.windowsshim.interface* is the adapter's *Name* from: 
```none
Get-NetAdapter
```

> Container networks which are created through PowerShell will not be available in Docker until the Docker daemon is restarted. Any other changes made to a container network via PowerShell also requires a restart of the Docker daemon.

### Multiple Container Networks

Multiple container networks can be created on a single container host with the following caveats:
* Only one NAT network can be created per container host.
* Multiple networks which use an external vSwitch for connectivity (e.g. Transparent, L2 Bridge, L2 Transparent) must each use its own network adapter.

### Network Selection

When creating a Windows Container, a network can be specified to which the container network adapter will be connected. If no network is specified, the default NAT network will be used.

In order to attach a container to the non-default NAT network (or when -b "none" is in use), use the --net option with the Docker run command.

```none
docker run -it --net=MyTransparentNet windowsservercore cmd
```

### Static IP Address

Static IP addresses are set on the containers network adapter, and are only supported for NAT, Transparent (pending [PR](https://github.com/docker/docker/pull/22208), and L2Bridge networking modes. Furthermore, Static IP assignment is not supported for the default "nat" network through Docker.

```none
docker run -it --net=MyTransparentNet --ip=10.80.123.32 windowsservercore cmd
```

Static IP assignment is performed directly on the container's network adapter and must only be performed when the container is in a STOPPED state. "Hot-add" of container network adapters or changes to the network stack is not supported while the container is running.

```none
Get-ContainerNetworkAdapter -ContainerName "DemoNAT"

ContainerName Name            Network Id                           Static MacAddress Static IPAddress Maximum Bandwidth
------------- ----            ----------                           ----------------- ---------------- -----------------
DemoNAT       Network Adapter C475D31C-FB42-408E-8493-6DB6C9586915                   			0

Set-ContainerNetworkAdapter -ContainerName "DemoNAT" -StaticIPAddress 172.16.0.100
```

If you would rather the IP address be chosen automatically from the range specified in the container network's subnet prefix, start the container without applying any settings to the container network adapter.

> Static IP Address assignment through PowerShell will not work on container endpoints attached to a Transparent network.

In order to see which containers are connected to a specific network and the IPs associated with these container endpoints you can run the following.

```none
docker network inspect nat
```

### Create MAC address

A MAC address can be specified by using the `--mac-address` option.

```none
docker run -it --mac="92:d0:c6:0a:29:33" --name="MyContainer" windowsservercore cmd
```

### Port Mapping

In order to access applications inside of a container connected to a NAT network, port mappings need to be created between the container host and container network adapter. These mappings must be created while the container is in a STOPPED state.

This example creates a static mapping between port **80** of the container host to port **80** of the container.

```none
docker run -it --name=DemoNat -p 80:80 windowsservercore cmd
```

This example creates a static mapping between port **8082** of the container host to port **80** of the container.

```none
docker run -it --name=DemoNat -p 8082:80 windowsservercore cmd
```

Dynamic port mappings are also supported through Docker such that a user does not need to specify a specific port to map from the container host. A randomly chosen ephemeral port will be chosen on the container host and can be inspected when running Docker ps.

```none
docker run -itd --name=DemoNat -p 80 windowsservercore cmd

docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                   NAMES
bbf72109b1fc        windowsservercore   "cmd"               6 seconds ago       Up 2 seconds        *0.0.0.0:14824->80/tcp*   DemoNat
```

In this example, the DemoNat container's TCP port 80 is being exposed externally from the container host on port 14824.

After the port mapping has been created, a container's application can be accessed through the IP address of the container host (physical or virtual), and exposed external port. For example, the below diagram depicts a NAT configuration with a request targeting external port **82** of the container host. Based on the port mapping, this request would return the application being hosted in container 2.

![](./media/nat1.png)

A view of the request from an internet browser.

![](./media/PortMapping.png)

## Caveats and Gotchas

### Firewall

The container host requires specific Firewall rules to be created to enable ICMP (Ping) and DHCP. ICMP and DHCP are required by Windows Server Containers to ping between two containers on the same host, and to receive dynamically assigned IP addresses through DHCP. In TP5, these rules will be created through the Install-ContainerHost.ps1 script. Post-TP5, these rules will be created automatically. All Firewall rules corresponding to NAT port forwarding rules will be created automatically and cleaned up when the container stops.

### Unsupported features

The following networking features are not supported today through Docker CLI
 * container linking (e.g. --link)
 * name-based IP resolution for containers

The following network options are not supported on Windows Docker at this time:
 * --add-host
 * --dns
 * --dns-opt
 * --dns-search
 * -h, --hostname
 * --net-alias
 * --aux-address
 * --internal
 * --ip-range
