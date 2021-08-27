---
title: Multiple subnet support for worker nodes in Windows containers with Calico for Windows
description: Learn about using multiple subnets with Windows containers using Calico.
keywords: multiple subnets, containers, Host Network Service
author: v-susbo
ms.author: v-susbo
ms.date: 08/10/2021
ms.topic: conceptual
---

# Multiple subnet support in Host Networking Service

Using multiple subnets per network is now supported in Host Networking Service (HNS) for Windows containers. Previously, HNS restricted Kubernetes container endpoint configurations to use only the prefix length of the underlying subnet. HNS is now enhanced so you can use more restrictive subnets (such as subnets with a longer prefix length) as well as multiple subnets per Windows worker node. The first Container Networking Interface (CNI) that can this functionality is Calico for Windows. Calico Network Policies is an open-source network and network security solution founded by [Tigera](https://www.tigera.io/).

You can utilize multiple subnets in HNS only for _l2bridge_, _l2tunnel_, and _overlay_ network drivers. These network drivers can expose multiple subnets, and then allow each endpoint to bind to one of these subnets.

HNS and the Host Compute Service (HCS) work together to create containers and attach endpoints to a network. You can interact with HNS using the [HNS Powershell Helper module](https://www.powershellgallery.com/packages/HNS/0.2.4).

## Calico requirements

Multiple subnet support for the Calico CNI requires subdividing the subnet into smaller IP blocks. All IP blocks must share the same gateway, but each IP block can have their own separate broadcast domain. To maximize IPV4 allocation to be as efficient as possible, Calico requires creating very small IP blocks (as small as one block = four IP addresses), in addition to setting very small prefixes on container endpoints (as small as /32).

A full implementation of Calico IP Address Management (IPAM) works as follows:

Calico's IPAM function is designed to allocate IP addresses to workloads on-demand. Calico supports multiple IP pools for administrative grouping. When configuring an allocation for a particular workload, the set of allowed pools may be limited by the configuration, which allows for various use cases. Different varied cases, follow these guidelines:

- Use multiple disjoint pools to increase capacity. 
- For _l2bridge_ networks within a rack, configure an IP pool per rack where the hosts within a rack can only allocate from a particular pool. 
- Use an IP pool per stack tier where front-end pods get IPs from a front-end pool (which could be public), but back-end pods (potentially on the same host) receive IPs from a different range. This allows Calico to fit in with aggressive network partitioning requirements (as may be needed to work with legacy firewalls).
- Use very small micro pools, one for each tier of a stack. Since these pools are so small, they require each host to support workloads from multiple pools.

 IPs are always allocated from blocks, and those blocks can be affine to a particular host. A host will always try to assign IPs from one of its own affine blocks if there is space (and only if the block is from an allowed pool for the given workload). If none of the host’s existing blocks have space, the host will try to claim a new block from an allowed pool. If no empty blocks are available, the host will borrow an IP from any block in an allowed pool that has free space available, even if that block is affine to another host.

Calico relies on longest prefix match routing to support aggregation. Each host advertises routes for all its affine blocks and advertises (/32) routes for any IPs that it has borrowed. Since a /32 route is more specific, remote hosts that need to forward to the /32 will use the /32 route instead of the broader /26 route to the host with the affine block.

Since Calico is a routed L3 network, it's worth noting that the /26 routes are not intended to be subnets. For example, there is no network or broadcast address; and the "0" and "255" addresses of a block are used as normal IPs.

### Calico HNS data plane requirements

There are several Calico connectivity and policy requirements to enable multiple subnets in HNS:

- All workloads on the same host must have connectivity to each other and to remote pods.
- All packet paths between pods should have the following whether or not the sender and receiver are co-located on the same host and whether they access each other either directly or by the service cluster IP:
  - Access control list (ACL) egress and ingress policies must apply. 
  - Both the egress policy of the sending pod and the ingress policy of the receiving pod must allow the traffic.
  - All Calico-programmed ACL rules should be able to view pod IPs.
 - Hosts and pods must be able to reach each other, and to reach pods on other hosts over routes learned over the Border Gateway Protocol (BGP).

### Multiple IP blocks per host requirements

To support multiple IP blocks per host, review the following requirements:

- For a given single IP pool, the data plane must allow pods to be added with IPs from different, disjoint IP blocks. For example, the IP pool may be 10.0.0.0/16, but a host may claim a pair of random blocks: 10.0.123.0/26 and 10.0.200.0/26. 
- The pool and the size of the blocks don't need to be known in advance of the first allocation. This is highly recommended.
- Other blocks from the same pool may be present on other hosts.
- The common prefix of the various blocks may overlap with the host's own IP address. 

### Requirements to support IP borrowing 

Calico IPAM allocates IPs to host in blocks for aggregation purposes. If the IP pool is full, nodes can also _borrow_ IPs from another node’s block. In BGP terms, the borrower then advertises a more specific /32 route for the borrowed IP and then traffic for that IP is routed to the borrowing host.

Windows nodes do not support this borrowing mechanism. They won't borrow IPs even if the IP pool is full, and they mark their blocks so that Linux nodes will also not borrow from them.

### Requirements to support micropools

To use micropools, the requirement to reserve 4 IPs per block is removed. In the micropool use case, very small pools and very small blocks are used, so four IPs per block wastes most of the IPs. You can require a small number of reserved IPs per host or per pool.
A best practice is to have all _layer 2_ support restrictions lifted (for example, there should be no support for broadcast and no reserved IPs).

## Create a subnet and an IP subnet using PowerShell

Before continuing, make sure you have the HNS.V2.psm1 module installed from the [HNS PowerShell gallery](https://www.powershellgallery.com/packages/HNS/0.2.4).

To create a subnet and an IP subnet, use the following steps.

1. To create am _l2bridge_ network with one 192.168.0.0/16 subnet that contains a 192.168.1.0/24 IP subnet and a 192.168.2.0/24 IP subnet, run the following command:

   ```powershell
   $net1 = New-HnsNetwork -Type L2Bridge -Name Test1 -AddressPrefix "192.168.0.0/16" -Gateway "192.168.0.1" -Verbose -IPSubnets @(@{"IpAddressPrefix"="192.168.1.0/24";"Flags"=0},@{"IpAddressPrefix"="192.168.2.0/24";"Flags"=[IPSubnetFlags]::EnableBroadcast})
   ```

2. To add a new 172.16.0.0/16 subnet that contains a 172.16.1.0/16 IP subnet to the _l2bridge_ network, run the following command:

   ```powershell
   New-HnsSubnet -NetworkID $net1.ID -Subnets @{
	   "IpAddressPrefix"="172.16.0.0/16";
	   "Routes"=@(@{"NextHop"="172.16.0.1";"DestinationPrefix"="0.0.0.0"});
	   "IpSubnets"=@(@{"IpAddressPrefix"="172.16.1.0/24"})
   ```

3. To add a new 172.16.2.0/24 IP subnet to the 172.16.0.0/16 subnet, run the following command:

   ```powershell
   New-HnsIPSubnet -NetworkID $net1.ID -SubnetID $net2.Subnets[1].ID -IPSubnets @{"IpAddressPrefix"="172.16.2.0/24";"Flags"=0}
   ```

To remove the IP subnets, use the following steps:

1. To dynamically remove the 172.16.2.0/24 IP subnet, run the following command:

   ```powershell
      $net2 = Get-HnsNetwork -ID $net1.ID
      Remove-HnsIpSubnet -NetworkID $net1.ID -SubnetID $net2.Subnets[1].ID -IPSubnets @{"ID"=$net2.Subnets[1].IPSubnets[1].ID}
   ```

2. To dynamically remove the 172.16.0.0/16 subnet, run the following command:

   ```powershell
   Remove-HnsSubnet -NetworkID $net1.ID -Subnets @{"ID"=$net2.Subnets[1].ID}
   ```
