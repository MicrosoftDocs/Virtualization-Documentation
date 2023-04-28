---
title: Windows container network drivers
description: Network drivers and topologies for Windows containers.
author: daschott
ms.author: daschott
ms.date: 10/20/2021
ms.topic: conceptual
ms.assetid: 538871ba-d02e-47d3-a3bf-25cda4a40965
---
# Windows container network drivers

> Applies to: Windows Server 2022, Windows Server 2019, Windows Server 2016

In addition to leveraging the default 'nat' network created by Docker on Windows, users can define custom container networks. User-defined networks can be created using the Docker CLI [`docker network create -d <NETWORK DRIVER TYPE> <NAME>`](https://docs.docker.com/engine/reference/commandline/network_create/) command. On Windows, the following network driver types are available:

### NAT network driver

Containers attached to a network created with the 'nat' driver will be connected to an *internal* Hyper-V switch and receive an IP address from the user-specified (``--subnet``) IP prefix. Port forwarding / mapping from the container host to container endpoints is supported.

  >[!TIP]
  > It is possible to customize the subnet used by the default 'nat' network via the `fixed-cidr` setting in the [Docker daemon configuration file](https://docs.docker.com/engine/reference/commandline/dockerd/#/windows-configuration-file).

  >[!NOTE]
  > NAT networks created on Windows Server 2019 (or above) are no longer persisted after reboot.

##### Creating a NAT network

To create a new NAT network with subnet `10.244.0.0/24`:
```powershell
docker network create -d "nat" --subnet "10.244.0.0/24" my_nat
```

### Transparent network driver

Containers attached to a network created with the 'transparent' driver will be directly connected to the physical network through an *external* Hyper-V switch. IPs from the physical network can be assigned statically (requires user-specified ``--subnet`` option) or dynamically using an external DHCP server.

  >[!NOTE]
  >Due to the following requirement, connecting your container hosts over a transparent network is not supported on Azure VMs.

  > Requires: When this mode is used in a virtualization scenario (container host is a VM) _MAC address spoofing is required_.

##### Creating a transparent network

To create a new transparent network with subnet `10.244.0.0/24`, gateway `10.244.0.1`, DNS server `10.244.0.7` and VLAN ID `7`:
```powershell
docker network create -d "transparent" --subnet 10.244.0.0/24 --gateway 10.244.0.1 -o com.docker.network.windowsshim.vlanid=7 -o com.docker.network.windowsshim.dnsservers="10.244.0.7" my_transparent
```

### Overlay network driver

Popularly used by containers orchestrators such as Docker Swarm and Kubernetes, containers attached to an overlay network can communicate with other containers attached to the same network across multiple container hosts. Each overlay network is created with its own IP subnet, defined by a private IP prefix. The overlay network driver uses VXLAN encapsulation to achieve network traffic isolation between tenant container networks and enables re-using IP addresses across overlay networks.
  > Requires: Make sure your environment satisfies these required [prerequisites](https://docs.docker.com/network/overlay/#operations-for-all-overlay-networks) for creating overlay networks.

  > Requires: On Windows Server 2019, this requires [KB4489899](https://support.microsoft.com/help/4489899).

  > Requires: On Windows Server 2016, this requires [KB4015217](https://support.microsoft.com/help/4015217/windows-10-update-kb4015217).

  >[!NOTE]
  >On Windows Server 2019 and above, overlay networks created by Docker Swarm leverage VFP NAT rules for outbound connectivity. This means that a given container receives 1 IP address. It also means that ICMP-based tools such as `ping` or `Test-NetConnection` should be configured using their TCP/UDP options in debugging situations.

##### Creating a overlay network

To create a new overlay network with subnet `10.244.0.0/24`, DNS server `168.63.129.16`, and VSID `4096`:
```powershell
docker network create -d "overlay" --attachable --subnet "10.244.0.0/24" -o com.docker.network.windowsshim.dnsservers="168.63.129.16" -o com.docker.network.driver.overlay.vxlanid_list="4096" my_overlay
```

### L2bridge network driver

Containers attached to a network created with the 'l2bridge' driver will be connected to the physical network through an *external* Hyper-V switch. In l2bridge, container network traffic will have the same MAC address as the host due to Layer-2 address translation (MAC re-write) operation on ingress and egress. In datacenters, this helps alleviate the stress on switches having to learn MAC addresses of sometimes short-lived containers. L2bridge networks can be configured in 2 different ways:
  1. L2bridge network is configured with the same IP subnet as the container host
  2. L2bridge network is configured with a new custom IP subnet

  In configuration 2 users will need to add a endpoint on the host network compartment that acts as a gateway and configure routing capabilities for the designated prefix.

##### Creating a l2bridge network

To create a new l2bridge network with subnet `10.244.0.0/24`, gateway `10.244.0.1`, DNS server `10.244.0.7` and VLAN ID 7:
```powershell
docker network create -d "l2bridge" --subnet 10.244.0.0/24 --gateway 10.244.0.1 -o com.docker.network.windowsshim.vlanid=7 -o com.docker.network.windowsshim.dnsservers="10.244.0.7" my_l2bridge
```

  >[!TIP]
  >L2bridge networks are highly programmable; More details on how to configure l2bridge can be found [here](https://techcommunity.microsoft.com/t5/networking-blog/l2bridge-container-networking/ba-p/1180923).

### L2tunnel network driver

Creation is identical to l2bridge, however _this driver should only be used in a Microsoft Cloud Stack (Azure)_. The only difference over l2bridge is that all container traffic is sent to the virtualization host where SDN policy is applied, thereby enabling features such as [Azure Network Security Groups](/azure/virtual-network/security-overview) for containers.

## Network topologies and IPAM

The table below shows how network connectivity is provided for internal (container-to-container) and external connections for each network driver.

### Networking modes/Docker drivers

  | Docker Windows Network Driver | Typical uses | Container-to-container (Single node) | Container-to-external (single node + multi-node) | Container-to-container (multi-node) |
  |-------------------------------|:------------:|:------------------------------------:|:------------------------------------------------:|:-----------------------------------:|
  | **NAT (Default)** | Good for Developers | <ul><li>Same Subnet: Bridged connection through Hyper-V virtual switch</li><li> Cross subnet: Not supported (only one NAT internal prefix)</li></ul> | Routed through Management vNIC (bound to WinNAT) | Not directly supported: requires exposing ports through host |
  | **Transparent** | Good for Developers or small deployments | <ul><li>Same Subnet: Bridged connection through Hyper-V virtual switch</li><li>Cross Subnet: Routed through container host</li></ul> | Routed through container host with direct access to (physical) network adapter | Routed through container host with direct access to (physical) network adapter |
  | **Overlay** | Good for multi-node; required for Docker Swarm, available in Kubernetes | <ul><li>Same Subnet: Bridged connection through Hyper-V virtual switch</li><li>Cross Subnet: Network traffic is encapsulated and routed through Mgmt vNIC</li></ul> | Not directly supported - requires second container endpoint attached to NAT network on Windows Server 2016 or VFP NAT rule on Windows Server 2019.  | Same/Cross Subnet: Network traffic is encapsulated using VXLAN and routed through Mgmt vNIC |
  | **L2Bridge** | Used for Kubernetes and Microsoft SDN | <ul><li>Same Subnet: Bridged connection through Hyper-V virtual switch</li><li> Cross Subnet: Container MAC address re-written on ingress and egress and routed</li></ul> | Container MAC address re-written on ingress and egress | <ul><li>Same Subnet: Bridged connection</li><li>Cross Subnet: routed through Mgmt vNIC on WSv1809 and above</li></ul> |
  | **L2Tunnel**| Azure only | Same/Cross Subnet: Hair-pinned to physical host's Hyper-V virtual switch to where policy is applied | Traffic must go through Azure virtual network gateway | Same/Cross Subnet: Hair-pinned to physical host's Hyper-V virtual switch to where policy is applied |

### IPAM

IP Addresses are allocated and assigned differently for each networking driver. Windows uses the Host Networking Service (HNS) to provide IPAM for the nat driver and works with Docker Swarm Mode (internal KVS) to provide IPAM for overlay. All other network drivers use an external IPAM.

| Networking Mode / Driver | IPAM |
| -------------------------|:----:|
| NAT | Dynamic IP allocation and assignment by Host Networking Service (HNS) from internal NAT subnet prefix |
| Transparent | Static or dynamic (using external DHCP server) IP allocation and assignment from IP addresses within container host's network prefix |
| Overlay | Dynamic IP allocation from Docker Engine Swarm Mode managed prefixes and assignment through HNS |
| L2Bridge | Dynamic IP allocation and assignment by Host Networking Service (HNS) from provided subnet prefix |
| L2Tunnel | Azure only - Dynamic IP allocation and assignment from plugin |

### Service Discovery

Service Discovery is only supported for certain Windows network drivers.

| Driver name | Local Service Discovery  | Global Service Discovery |
| :--- | :---------------     |  :---                |
| nat | YES | YES with Docker EE |
| overlay | YES | YES with Docker EE or kube-dns |
| transparent | NO | NO |
| l2bridge | YES with kube-dns | YES with kube-dns |
