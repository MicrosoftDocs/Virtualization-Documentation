---
title: Windows Container Networking
description: Configure networking for Windows containers.
keywords: docker, containers
author: jmesser81
manager: timlt
ms.date: 08/22/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 538871ba-d02e-47d3-a3bf-25cda4a40965
---

# Container Networking

Windows containers function similarly to virtual machines in regards to networking. Each container has a virtual network adapter which is connected to a virtual switch, over which inbound and outbound traffic is forwarded. In order to enforce isolation between containers on the same host, a network compartment is created for each Windows Server and Hyper-V Container into which the network adapter for the container is installed. Windows Server containers use a Host vNIC to attach to the virtual switch. Hyper-V Containers use a Synthetic VM NIC (not exposed to the Utility VM) to attach to the virtual switch.

Windows containers support four different networking drivers or modes: *nat*, *transparent*, *l2bridge*, and *l2tunnel*. Depending on your physical network infrastructure and single- vs multi-host networking requirements, you should chose the network mode which best suits your needs. 

The docker engine creates a nat network by default when the dockerd service first runs. The default internal IP prefix created is 172.16.0.0/12. 

> Note: If your container host IP is in this same prefix, you will need to change the NAT internal IP prefix as documented below

Container endpoints will be attached to this default network and be assigned an IP address from the internal prefix. Only one NAT network is currently supported in Windows (although a pending [Pull Request](https://github.com/docker/docker/pull/25097) might help work-around this restriction). 

Additional networks using a different driver (e.g. transparent, l2bridge) can be created on the same container host. The table below shows how network connectivity is provided for internal (container-to-container) and external connections for each mode.

- **Network Address Translation** – each container will receive an IP address from an internal, private IP prefix (e.g. 172.16.0.0/12). Port forwarding / mapping from the container host to container endpoints is supported

- **Transparent** – each container endpoint is directly connected to the physical network. IPs from the physical network can be assigned statically or dynamically using an external DHCP server

- **L2 Bridge** - each container endpoint will be in the same IP subnet as the container host. The IP addresses must be assigned statically from the same prefix as the container host. All container endpoints on the host will have the same MAC address due to Layer-2 address translation.

- **L2 Tunnel** - _this mode should only be used in a Microsoft Cloud Stack_

> To learn how to connect container endpoints to an overlay virtual network with the Microsoft SDN stack, reference the [Attaching Containers to a Virtual Network](https://technet.microsoft.com/en-us/windows-server-docs/networking/sdn/manage/connect-container-endpoints-to-a-tenant-virtual-network) topic.

## Single-Node

|  | Container-Container | Container-External |
| :---: | :---------------     |  :---                |
| nat | Bridged connection through Hyper-V Virtual Switch | routed through WinNAT with address translations applied | 
| transparent | Bridged connection through Hyper-V Virtual Switch | direct access to physical network | 
| l2bridge | Bridged connection through Hyper-V Virtual Switch|  access to physical network with MAC address translation|  



## Multi-Node

|  | Container-Container | Container-External |
| :---: | :----       | :---------- |
| nat | must reference external container host IP and port; routed through WinNAT with address translations applied | must reference external host; routed through WinNAT with address translations applied | 
| transparent | must reference container IP endpoint directly | direct access to physical network | 
| l2bridge | must reference container IP endpoint directly| access to physical network with MAC address translation| 


## Network Creation 

### (Default) NAT Network

The Windows docker engine creates a default 'nat' network with IP prefix 172.16.0.0/12. Only one nat network is currently allowed on a Windows container host. If a user wants to create a nat network with a specific IP prefix, they can do one of two things by changing the options in the docker config daemon.json file (located at C:\ProgramData\Docker\config\daemon.json - create it it doesn't already exist).
 1. Use the _"fixed-cidr": "< IP Prefix > / Mask"_ option which will create the default nat network with the IP prefix and match specified
 2. Use the _"bridge": "none"_ option which will not create a default network; a user can create a user-defined network with any driver using the *docker network create -d <driver>* command

Before performing either of these configuration options, the Docker service must first be stopped and any pre-existing nat networks need to be deleted.

```none
PS C:\> Stop-Service docker
PS C:\> Get-ContainerNetwork | Remove-ContainerNetwork

...Edit the daemon.json file...

PS C:\> Start-Service docker
```

If the user added the "fixed-cidr" option to the daemon.json file, the docker engine will now create a user-defined nat network with the custom IP prefix and mask specified. If instead the user added the "bridge:none" option, they will need to create a network manually.

```none
# Create a user-defined nat network
C:\> docker network create -d nat --subnet=192.168.1.0/24 --gateway=192.168.1.1 MyNatNetwork
```

By default, container endpoints will be connected to the default nat network. If the default nat network was not created (because "bridge:none" was specified in daemon.json) or access to a different, user-defined network is required, users can specify the *--network* parameter with the docker run command.

```none
# Connect new container to the MyNatNetwork
C:\> docker run -it --network=MyNatNetwork <image> <cmd>
```

#### Port Mapping

In order to access applications running inside of a container connected to a NAT network, port mappings need to be created between the container host and container endpoint. These mappings must be specified at container CREATION time or while the container is in a STOPPED state.

```none
# Creates a static mapping between port TCP:80 of the container host and TCP:80 of the container
C:\> docker run -it -p 80:80 <image> <cmd>

# Create a static mapping between port 8082 of the container host and port 80 of the container.
C:\> docker run -it -p 8082:80 windowsservercore cmd
```

Dynamic port mappings are also supported either using the -p parameter or the EXPOSE command in a Dockerfile with the -P parameter. A randomly chosen ephemeral port will be chosen on the container host and can be inspected when running Docker ps.

```none
C:\> docker run -itd -p 80 windowsservercore cmd

# Network services running on port TCP:80 in this container can be accessed externally on port TCP:14824
C:\> docker ps
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS              PORTS                   NAMES
bbf72109b1fc        windowsservercore   "cmd"               6 seconds ago       Up 2 seconds        *0.0.0.0:14824->80/tcp*   drunk_stonebraker

# Container image specified EXPOSE 80 in Dockerfile - publish this port mapping
C:\> docker network 
```
> Beginning in WS2016 TP5 and Windows Insider Builds greater than 14300, a firewall rule will be automatically created for all NAT port mappings. This firewall rule will be global to the container host and not localized to a specific container endpoint or network adapter.

The Windows NAT (WinNAT) implementation has a few capability gaps which are discussed in this blog post [WinNAT capabilities and limitations](https://blogs.technet.microsoft.com/virtualization/2016/05/25/windows-nat-winnat-capabilities-and-limitations/) 
 1. Only one NAT network (one internal IP prefix) is supported per container host
 2. Container endpoints are only reachable from the container host using the internal IP and port

Additional networks can be created using different drivers. 

> Docker network drivers are all lower-case.

### Transparent Network

To use the Transparent networking mode, create a container network with driver name 'transparent'. 

```none
C:\> docker network create -d transparent MyTransparentNetwork
```

If the container host is virtualized, and you wish to use DHCP for IP assignment, you must enable MACAddressSpoofing on the virtual machines network adapter. Otherwise, the Hyper-V host will block network traffic from the containers in the VM with multiple MAC addresses.

```none
PS C:\> Get-VMNetworkAdapter -VMName ContainerHostVM | Set-VMNetworkAdapter -MacAddressSpoofing On
```

> If you wish to create more than one transparent network you must specify to which (virtual) network adapter the external Hyper-V Virtual Switch (created automatically) should bind.

To bind a network (attached through the Hyper-V virtual switch) to a specific network interface, use the option *-o com.docker.network.windowsshim.interface=<Interface>*

```none
# Create a transparent network which is attached to the "Ethernet 2" network interface
C:\> docker network create -d transparent -o com.docker.network.windowsshim.interface="Ethernet 2" TransparentNet2
```

Value for *com.docker.network.windowsshim.interface* is the adapter's *Name* from: 
```none
Get-NetAdapter
```

IP addresses for container endpoints connected to a transparent network can either be assigned statically or dynamically from an external DHCP server.

When using static IP assignment, you must first ensure that the *--subnet* and *--gateway* parameters are specified when the network is created. The subnet and gateway IP address should be the same as the network settings for the container host - i.e. the physical network.

```none
# Create a transparent network corresponding to the physical network with IP prefix 10.123.174.0/23
C:\> docker network create -d transparent --subnet=10.123.174.0/23 --gateway=10.123.174.1 TransparentNet3
```
Specify an IP address using the *--ip* option to docker run command

```none
C:\> docker run -it --network=TransparentNet3 --ip 10.123.174.105 <image> <cmd>
```

> Make sure that this IP address is not assigned to any other network device on the physical network

Since the container endpoints have direct access to the physical network, there is no need to specify port mappings

### L2 Bridge 

To use the L2 Bridge Networking mode, create a Container Network with driver name 'l2bridge'. A subnet and gateway - again, corresponding to the physical network - must be specified.

```none
C:\> docker network create -d l2bridge --subnet=192.168.1.0/24 --gateway=192.168.1.1 MyBridgeNetwork
```

Only static IP assignment is supported with l2bridge networks. 

> When using an l2bridge network on an SDN fabric, only dynamic IP assignment is supported. Reference the [Attaching Containers to a Virtual Network](https://technet.microsoft.com/en-us/windows-server-docs/networking/sdn/manage/connect-container-endpoints-to-a-tenant-virtual-network) topic for more information.

## Other Operations and Configurations

### List Available Networks

```none
# list container networks
C:\> docker network ls

NETWORK ID          NAME                DRIVER              SCOPE
0a297065f06a        nat                 nat                 local
d42516aa0250        none                null                local
```

### Remove a Network

Use `docker network rm` to delete a container network.

```none
C:\> docker network rm "<network name>"
```

This will clean up any Hyper-V Virtual switches which the container network used, and also any network address translation (WinNAT - NetNat instances) created.

### Network Inspection 

In order to see which containers are connected to a specific network and the IPs associated with these container endpoints you can run the following.

```none
C:\> docker network inspect <network name>
```

### Multiple Container Networks

Multiple container networks can be created on a single container host with the following caveats:
* Only one NAT network can be created per container host.
* Multiple networks which use an external vSwitch for connectivity (e.g. Transparent, L2 Bridge, L2 Transparent) must each use its own network adapter.

### Network Selection

When creating a Windows Container, a network can be specified to which the container network adapter will be connected. If no network is specified, the default NAT network will be used.

In order to attach a container to the non-default NAT network use the --network option with the Docker run command.

```none
C:\> docker run -it --network=MyTransparentNet windowsservercore cmd
```

### Static IP Address

```none
C:\> docker run -it --network=MyTransparentNet --ip=10.80.123.32 windowsservercore cmd
```

Static IP assignment is performed directly on the container's network adapter and must only be performed when the container is in a STOPPED state. "Hot-add" of container network adapters or changes to the network stack is not supported while the container is running.


## Caveats and Gotchas

### Firewall

The container host requires specific Firewall rules to be created to enable ICMP (Ping) and DHCP. ICMP and DHCP are required by Windows Server Containers to ping between two containers on the same host, and to receive dynamically assigned IP addresses through DHCP. In TP5, these rules will be created through the Install-ContainerHost.ps1 script. Post-TP5, these rules will be created automatically. All Firewall rules corresponding to NAT port forwarding rules will be created automatically and cleaned up when the container stops.

### Unsupported features

The following networking features are not supported today through Docker CLI
 * container linking (e.g. --link)
 * name/service-based IP resolution for containers. _This will be supported soon with a servicing update_
 * default overlay network driver

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
