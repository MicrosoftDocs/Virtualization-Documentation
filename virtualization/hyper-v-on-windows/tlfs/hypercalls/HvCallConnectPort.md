---
title: HvCallConnectPort
description: HvCallConnectPort hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/01/2025
ms.topic: reference

---

# HvCallConnectPort

HvCallConnectPort establishes a connection between a partition and a port for inter-partition communication. This hypercall creates a communication channel that can be used for messaging, events, monitoring, or doorbell operations between partitions.

## Interface

 ```c
HV_STATUS
HvCallConnectPort(
    _In_ HV_PARTITION_ID             ConnectionPartition,
    _In_ HV_CONNECTION_ID            ConnectionId,
    _In_ HV_VTL                      ConnectionVtl,
    _In_ UINT8                       ReservedZ0,
    _In_ UINT16                      ReservedZ1,
    _In_ HV_PARTITION_ID             PortPartition,
    _In_ HV_PORT_ID                  PortId,
    _In_ UINT32                      ReservedZ2,
    _In_ HV_CONNECTION_INFO          ConnectionInfo,
    _In_ HV_PROXIMITY_DOMAIN_INFO    ProximityDomainInfo
    );
 ```

## Call Code

`0x0096` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `ConnectionPartition`   | 0          | 8        | Specifies the ID of the partition that will own the connection. |
| `ConnectionId`          | 8          | 4        | Specifies the connection identifier for this communication channel. |
| `ConnectionVtl`         | 12         | 1        | Specifies the VTL for the connection. |
| ReservedZ0              | 13         | 1        |                                           |
| ReservedZ1              | 14         | 2        |                                           |
| `PortPartition`         | 16         | 8        | Specifies the ID of the partition that owns the port. |
| `PortId`                | 24         | 4        | Specifies the port identifier to connect to. |
| ReservedZ2              | 28         | 4        |                                           |
| `ConnectionInfo`        | 32         | 32       | Specifies connection type-specific information including port type and connection parameters. |
| `ProximityDomainInfo`   | 64         | 8        | Specifies NUMA proximity domain preferences for memory allocation. |

## See also

[HV_CONNECTION_ID](../datatypes/hv_connection_id.md)
[HV_PORT_ID](../datatypes/hv_port_id.md)
[HV_CONNECTION_INFO](../datatypes/hv_connection_info.md)
[HV_PROXIMITY_DOMAIN_INFO](../datatypes/hv_proximity_domain_info.md)
 [HvCallDisconnectPort](HvCallDisconnectPort.md)
 [HvCallCreatePort](HvCallCreatePort.md)
