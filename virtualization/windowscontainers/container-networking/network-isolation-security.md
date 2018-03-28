---
title: Windows Container Networking
description: Network isolation and security within Windows containers.
keywords: docker, containers
author: jmesser81
ms.date: 03/27/2018
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 538871ba-d02e-47d3-a3bf-25cda4a40965
---


# Network Isolation and Security

## Isolation (Namespace) with Network Compartments
Each container endpoint is placed in its own __network compartment__ which is analogous to a network namespace in Linux. The management host vNIC and host network stack are located in the default network compartment. In order to enforce network isolation between containers on the same host, a network compartment is created for each Windows Server and Hyper-V Container into which the network adapter for the container is installed. Windows Server containers use a Host vNIC to attach to the virtual switch. Hyper-V Containers use a Synthetic VM NIC (not exposed to the Utility VM) to attach to the virtual switch. 


![text](media/network-compartment-visual.png)


```powershell 
Get-NetCompartment
```

## Windows Firewall Security

The Windows Firewall is used to enforce network security through port ACLs.

> NOTE: Make sure your environment satisfies these *required* [prerequisites](https://docs.docker.com/network/overlay/#operations-for-all-overlay-networks) for creating overlay networks.


### Windows Server containers
These use the Windows hosts' firewall (enlightened with network compartments.) 
  * Default Outbound: ALLOW ALL
  * Default Inbound: DENY ALL unsolicited
    * Except "common" (e.g. DHCP, DNS, ICMP, etc.) network traffic
    * Create inbound ALLOW rule in response to ``docker run -p`` (port forwarding)

### Hyper-V containers
Hyper-V containers have their own isolated kernel and hence run their own instance of Windows Firewall with the following configuration:
  * Default ALLOW ALL in Windows Firewall

Note that in general, all container endpoints attached to an overlay network have an:
  *  ALLOW ALL rule created.  


![text](media/windows-firewall-containers.png)
