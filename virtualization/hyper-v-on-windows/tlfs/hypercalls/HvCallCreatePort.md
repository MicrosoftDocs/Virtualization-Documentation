---
title: HvCallCreatePort
description: HvCallCreatePort hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/01/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallCreatePort

HvCallCreatePort creates a new communication port within a partition.

## Interface

 ```c
HV_STATUS
HvCallCreatePort(
    _In_ HV_PARTITION_ID             PortPartition,
    _In_ HV_PORT_ID                  PortId,
    _In_ HV_VTL                      PortVtl,
    _In_ HV_VTL                      MinConnectionVtl,
    _In_ UINT16                      ReservedZ0,
    _In_ HV_PARTITION_ID             ConnectionPartition,
    _In_ HV_PORT_INFO                PortInfo,
    _In_ HV_PROXIMITY_DOMAIN_INFO    ProximityDomainInfo
    );
 ```

## Call Code

`0x0095` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `PortPartition`         | 0          | 8        | ID of the partition where the port will be created. |
| `PortId`                | 8          | 4        | Unique identifier for the new port. |
| `PortVtl`               | 12         | 1        | VTL at which the port exists. |
| `MinConnectionVtl`      | 13         | 1        | Minimum VTL required for connections. |
| `ReservedZ0`            | 14         | 2        | Reserved. Must be zero. |
| `ConnectionPartition`   | 16         | 8        | Partition automatically connected on creation (if any). Set to zero if unused. |
| `PortInfo`              | 24         | 24       | Type-specific port configuration (see `HV_PORT_INFO`). Reserved subfields must be zero. |
| `ProximityDomainInfo`   | 48         | 8        | NUMA proximity domain preferences. |

## See also

* [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
* [HV_PORT_ID](../datatypes/hv_port_id.md)
* [HV_PORT_INFO](../datatypes/hv_port_info.md)
* [HV_PROXIMITY_DOMAIN_INFO](../datatypes/hv_proximity_domain_info.md)
* [HvCallDeletePort](HvCallDeletePort.md)
* [HvCallConnectPort](HvCallConnectPort.md)
