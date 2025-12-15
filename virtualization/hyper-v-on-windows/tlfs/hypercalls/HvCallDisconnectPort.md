---
title: HvCallDisconnectPort
description: HvCallDisconnectPort hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/01/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallDisconnectPort

HvCallDisconnectPort terminates an active connection between two communication ports.

## Interface

 ```c
HV_STATUS
HvCallDisconnectPort(
    _In_ HV_PARTITION_ID ConnectionPartition,
    _In_ HV_CONNECTION_ID ConnectionId
    );
 ```

## Call Code

`0x005b` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `ConnectionPartition`   | 0          | 8        | Specifies the ID of the partition that owns the port. |
| `ConnectionId`          | 8          | 4        | Specifies the unique identifier of the port to disconnect. |

## See also

* [HV_PARTITION_ID](../datatypes/hv_partition_id.md)
* [HV_CONNECTION_ID](../datatypes/hv_connection_id.md)
* [HvCallConnectPort](HvCallConnectPort.md)
* [HvCallDeletePort](HvCallDeletePort.md)
