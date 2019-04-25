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
# Network isolation and security

## Isolation with network namespaces

Each container endpoint is placed in its own __network namespace__. The management host vNIC and host network stack are located in the default network namespace. In order to enforce network isolation between containers on the same host, a network namespace is created for each Windows Server container and containers run under Hyper-V isolation into which the network adapter for the container is installed. Windows Server containers use a Host vNIC to attach to the virtual switch. Hyper-V isolation uses a Synthetic VM NIC (not exposed to the Utility VM) to attach to the virtual switch.

![text](media/network-compartment-visual.png)

```powershell
Get-NetCompartment
```

## Network security

Depending on which container and network driver is used, port ACLs are enforced by a combination of the Windows Firewall and [VFP](https://www.microsoft.com/en-us/research/project/azure-virtual-filtering-platform/).

### Windows Server containers

These use the Windows hosts' firewall (enlightened with network namespaces) as well as VFP

* Default Outbound: ALLOW ALL
* Default Inbound: ALLOW ALL (TCP, UDP, ICMP, IGMP) unsolicited network traffic
  * DENY ALL other network traffic not from these protocols

  >[!NOTE]
  >Prior to Windows Server, version 1709 and Windows 10 Fall Creators Update, the default inbound rule was DENY all. Users running these older releases can create inbound ALLOW rules with ``docker run -p`` (port forwarding).

### Hyper-V isolation

Containers running in Hyper-V isolation have their own isolated kernel and therefore run their own instance of Windows Firewall with the following configuration:

* Default ALLOW ALL in both Windows Firewall (running in the utility VM) and VFP

![text](media/windows-firewall-containers.png)

### Kubernetes pods

In a [Kubernetes pod](https://kubernetes.io/docs/concepts/workloads/pods/pod/), an infrastructure container is first created to which an endpoint is attached. Containers that belong to the same pod, including infrastructure and worker containers, share a common network namespace (same IP and port space).

![text](media/pod-network-compartment.png)

### Customizing default port ACLs

If you want to modify the default port ACLs, please read our Host Networking Service documentation first (link to be added soon). You'll need to update policies inside the following components:

>[!NOTE]
>For Hyper-V isolation in Transparent and NAT mode, you currently can't reprogram the default port ACLs. This is reflected by an "X" in the table.

| Network driver | Windows Server containers | Hyper-V isolation  |
| -------------- |-------------------------- | ------------------- |
| Transparent | Windows Firewall | X |
| NAT | Windows Firewall | X |
| L2Bridge | Both | VFP |
| L2Tunnel | Both | VFP |
| Overlay  | Both | VFP |