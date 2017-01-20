---
title: Windows Container Networking
description: Configure networking for Windows containers.
keywords: docker, containers
author: jmesser81
ms.date: 08/22/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 538871ba-d02e-47d3-a3bf-25cda4a40965
---

# Container Networking

Windows containers function similarly to virtual machines in regards to networking. Each container has a virtual network adapter (vNIC) which is connected to a virtual switch (vSwitch), over which inbound and outbound traffic is forwarded. In order to enforce isolation between containers on the same host, a network compartment is created for each Windows Server and Hyper-V Container into which the network adapter for the container is installed. Windows Server containers use a Host vNIC to attach to the virtual switch. Hyper-V Containers use a Synthetic VM NIC (not exposed to the Utility VM) to attach to the virtual switch.

Windows containers support four different networking drivers or modes: *nat*, *transparent*, *l2bridge*, and *l2tunnel*. Depending on your physical network infrastructure and single- vs multi-host networking requirements, you should chose the network mode which best suits your needs.

The docker engine creates a NAT network by default when the dockerd service first runs. The default internal IP prefix created is 172.16.0.0/12. Container endpoints will be automatically attached to this default network and assigned an IP address from its internal prefix.

> Note: If your container host IP is in this same prefix, you will need to change the NAT internal IP prefix as documented below.

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

The Windows docker engine creates a default NAT network (which Docker names, 'nat') with IP prefix 172.16.0.0/12. If a user wants to create a NAT network with a specific IP prefix, they can do one of two things by changing the options in the Docker config daemon.json file (located at C:\ProgramData\Docker\config\daemon.json - create it it doesn't already exist).
 1. Use the _"fixed-cidr": "< IP Prefix > / Mask"_ option which will create the default NAT network with the IP prefix and match specified
 2. Use the _"bridge": "none"_ option which will not create a default network; a user can create a user-defined network with any driver using the *docker network create -d <driver>* command

Before performing either of these configuration options, the Docker service must first be stopped and any pre-existing NAT networks need to be deleted.

```none
PS C:\> Stop-Service docker
PS C:\> Get-ContainerNetwork | Remove-ContainerNetwork

...Edit the daemon.json file...

PS C:\> Start-Service docker
```

If the "fixed-cidr" option is added to the daemon.json file, the Docker engine will create a user-defined NAT network with the custom IP prefix and mask specified. If instead the "bridge:none" option is added, the network needs to be created manually.

```none
# Create a user-defined NAT network
C:\> docker network create -d nat --subnet=192.168.1.0/24 --gateway=192.168.1.1 MyNatNetwork
```

By default, container endpoints will be connected to the default 'nat' network. If the 'nat' network was not created (because "bridge:none" was specified in daemon.json) or access to a different, user-defined network is required, users can specify the *--network* parameter with the docker run command.

```none
# Connect new container to the MyNatNetwork
C:\> docker run -it --network=MyNatNetwork <image> <cmd>
```

#### Port Mapping

In order to access applications running inside of a container connected to a NAT network, port mappings need to be created between the container host and container endpoint. These mappings must be specified at container creation time or while the container is in a STOPPED state.

```none
# Creates a static mapping between port TCP:80 of the container host and TCP:80 of the container
C:\> docker run -it -p 80:80 <image> <cmd>

# Creates a static mapping between port 8082 of the container host and port 80 of the container.
C:\> docker run -it -p 8082:80 windowsservercore cmd
```

Dynamic port mappings are also supported either using the -p parameter or the EXPOSE command in a Dockerfile with the -P parameter. If not specified, a randomly chosen ephemeral port will be chosen on the container host and can be inspected by running 'docker ps'.

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
 1. Only one NAT internal IP prefix is supported per container host, so 'multiple' NAT networks must be defined by partitioning the prefix (see the "Multiple NAT Networks" section of this document).
 2. Container endpoints are only reachable from the container host using container internal IPs and ports (find this info using 'docker network inspect <CONTAINER ID>').

Additional networks can be created using different drivers.

> Docker network drivers are all lower-case.

### Transparent Network

To use the Transparent networking mode, create a container network with driver name 'transparent'.

```none
C:\> docker network create -d transparent MyTransparentNetwork
```
> Note: If you encounter an error in creating the transparent network, it is possible that there is an external vSwitch on your system which was not automatically discovered by Docker and is therefore preventing the transparent network from being bound to your container host's external network adapter. Reference the below section, 'Existing vSwitch Blocking Transparent Network Creation,' under 'Caveats and Gotchas' for more information.

If the container host is virtualized, and you wish to use DHCP for IP assignment, you must enable MACAddressSpoofing on the virtual machines network adapter. Otherwise, the Hyper-V host will block network traffic from the containers in the VM with multiple MAC addresses.

```none
PS C:\> Get-VMNetworkAdapter -VMName ContainerHostVM | Set-VMNetworkAdapter -MacAddressSpoofing On
```

> If you wish to create more than one transparent network you must specify to which (virtual) network adapter the external Hyper-V Virtual Switch (created automatically) should bind.

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

> We are constantly working on improving Docker on Windows. To make sure you have access to all of the latest functionality, confirm that you are using the latest version of the Docker Engine. You can check your docker version using `docker -v`. Reference the [Docker Engine on Windows](https://docs.microsoft.com/en-us/virtualization/windowscontainers/manage-docker/configure-docker-daemon) topic for guidance on configuring Docker.

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

### Specify the Name of a Network

If you are creating a network, you can specify the name that it is given by the HNS service using the option, `-o com.docker.network.windowsshim.networkname=<network name>` to the `docker network create` command. For instance, you might use the following command to create a transparent network with a name that is specified to the HNS service:

```none
C:\> docker network create -d transparent -o com.docker.network.windowsshim.networkname=MyTransparentNetwork MyTransparentNetwork
```
Ordinarily, when you create a container network using `docker network create`, the network name that you provide is used by the Docker service but not by the HNS service. As a result, you will see the name of your network when you view your network using the `docker network ls` command (as documented above), but you will not see your chosen name if you view your network or network switch using the `Get-VMSwitch` or `Get-ContainerNetwork` Windows PowerShell commands (instead you will see a name that was automatically generated by the HNS service).

### Bind a Network to a Specific Network Interface

To bind a network (attached through the Hyper-V virtual switch) to a specific network interface, use the option, `-o com.docker.network.windowsshim.interface=<Interface>` to the `docker network create` command. For instance, you might use the following command to create a transparent network which is attached to the "Ethernet 2" network interface:

```none
C:\> docker network create -d transparent -o com.docker.network.windowsshim.interface="Ethernet 2" TransparentNet2
```

> Note: The value for *com.docker.network.windowsshim.interface* is the network adapter's *Name*, which can be found with:
```none
PS C:\> Get-NetAdapter
```

### Multiple Container Networks
Multiple container networks can be created on a single container host with the following caveats:

* Multiple networks which use an external vSwitch for connectivity (e.g. Transparent, L2 Bridge, L2 Transparent) must each use its own network adapter.
* Currently, our solution for creating multiple NAT networks on a single container host is to partition the existing NAT network's internal prefix. Reference the below section, 'Multiple NAT Networks' for further guidance on this.

### Multiple NAT Networks
It is possible to define multiple NAT networks on a single container host by partitioning the host's NAT network internal prefix.

The partitions for any new NAT networks must be created under the larger internal NAT networking prefix. The prefix can be found by running the following command from PowerShell and referencing the "InternalIPInterfaceAddressPrefix" field.

```none
PS C:\> Get-NetNAT
```

For example, the host's NAT network internal prefix might be, 172.16.0.0/12. In this case, Docker can be used to create additional NAT networks *as long as they fall under the 172.16.0.0/12 prefix.* For example, two NAT networks could be created with the IP prefixes 172.16.0.0/16 (gateway, 172.16.0.1) and 172.17.0.0/16 (gateway, 172.17.0.1).

```none
C:\> docker network create -d nat --subnet=172.16.0.0/16 --gateway=172.16.0.1 CustomNat1
C:\> docker network create -d nat --subnet=172.17.0.0/16 --gateway=172.17.0.1 CustomNat2
```

The newly created networks can be listed using:
```none
C:\> docker network ls
```


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

## Docker Compose and Service Discovery

> For a practical example of how Docker Compose and Service Discovery can be used to define multi-service, scaled-out applications, visit [this post](https://blogs.technet.microsoft.com/virtualization/2016/10/18/use-docker-compose-and-service-discovery-on-windows-to-scale-out-your-multi-service-container-application/) on our [Virtualization Blog](https://blogs.technet.microsoft.com/virtualization/).

### Docker Compose

[Docker Compose](https://docs.docker.com/compose/overview/) can be used to define and configure container networks alongside the containers/services that will be using those networks. The Compose 'networks' key is used as the top-level key in defining the networks to which containers will be connected. For example, the syntax below defines the preexisting NAT network created by Docker to be the 'default' network for all containers/services defined in a given Compose file.

```none
networks:
 default:
  external:
   name: "nat"
```

Similarly, the following syntax can be used to define a custom NAT network.

> Note: The 'custom NAT network' defined in the below example is defined as a partition of the container host's pre-existing NAT internal prefix. See the above section, 'Multiple NAT Networks,' for more context.

```none
networks:
  default:
    driver: nat
    ipam:
      driver: default
      config:
      - subnet: 172.17.0.0/16
```

For further information on defining/configuring container networks using Docker Compose, refer to the [Compose File reference](https://docs.docker.com/compose/compose-file/).

### Service Discovery
Built in to Docker is Service Discovery, which handles service registration and name to IP (DNS) mapping for containers and services; with service discovery, it is possible for all container endpoints to discover each other by name (either container name, or service name). This is particularly valuable in scaled-out scenarios, where multiple container endpoints are being used to define a single service. In such cases, service discovery makes it possible for a service to be considered a single entity regardless of how many containers it has running behind the scenes. For multi-container services, incoming network traffic is managed using a round-robin approach, by which DNS load balancing is used to uniformly distribute traffic across all container instances implementing a given service.

## Caveats and Gotchas

### Existing vSwitch Blocking Transparent Network Creation

When creating a transparent network, Docker creates an external vSwitch for the network then tries to bind the switch to an (external) network adapter - the adapter could be a VM Network Adapter or the physical network adapter. If a vSwitch has already been created on the container host, *and it is visible to Docker,* the Windows Docker engine will use that switch instead of creating a new one. However, if the vSwitch which was created out-of-band (i.e. created on the container host using HYper-V Manager or PowerShell) and is not yet visible to Docker, the Windows Docker engine will try create a new vSwitch and then be unable to connect the new switch to the container host external network adapter (because the network adapter will already be connected to the switch that was created out-of-band).

For example, this issue would arise if you were to first create a new vSwitch on your host while the Docker service was running, then try to create a transparent network. In this case, Docker would not recognize the switch that you created and it would create a new vSwitch for the transparent network.

There are three approaches for solving this issue:

* You can of course delete the vSwitch that was created out-of-band, which will allow docker to create a new vSwitch and connect it to the host network adapter without issue. Before choosing this approach, ensure that your out-of-band vSwitch is not being used by other services (e.g. Hyper-V).
* Alternatively, if you decide to use an external vSwitch that was created out-of-band, restart the Docker and HNS services to *make the switch visible to Docker.*
```none
PS C:\> restart-service hns
PS C:\> restart-service docker
```
* Another option is to use the '-o com.docker.network.windowsshim.interface' option to bind the transparent network's external vSwitch to a specific network adapter which is not already in use on the container host (i.e. a network adapter other than the one being used by the vSwitch that was created out-of-band). The '-o' option is described further above, in the [Transparent Network](https://msdn.microsoft.com/virtualization/windowscontainers/management/container_networking#transparent-network) section of this document.

### Unsupported features

The following networking features are not supported today through Docker CLI
 * default overlay network driver
 * container linking (e.g. --link)

The following network options are not supported on Windows Docker at this time:
 * --add-host
 * --dns-opt
 * --dns-search
 * --aux-address
 * --internal
 * --ip-range
