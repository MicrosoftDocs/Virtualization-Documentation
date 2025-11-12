---
title: HvCallDeletePort
description: HvCallDeletePort hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/01/2025
ms.topic: reference

---

# HvCallDeletePort

HvCallDeletePort removes a communication port from a partition.

## Interface

 ```c
HV_STATUS
HvCallDeletePort(
    _In_ HV_PARTITION_ID         PortPartition,
    _In_ HV_PORT_ID              PortId,
    _In_ UINT32                  Reserved
    );
 ```

## Call Code

`0x0058` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `PortPartition`         | 0          | 8        | ID of the partition that owns the port. |
| `PortId`                | 8          | 4        | Unique identifier of the port to be deleted. |
| `Reserved`              | 12         | 4        | Reserved. Must be zero. |

## See also

* [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
* [HV_PORT_ID](../datatypes/hv_port_id.md)
* [HvCallCreatePort](HvCallCreatePort.md)
* [HvCallDisconnectPort](HvCallDisconnectPort.md)
