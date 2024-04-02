---
title: HCN_PORT_RANGE_ENTRY
description: HCN_PORT_RANGE_ENTRY
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HCN_PORT_RANGE_ENTRY
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HCN\_PORT\_RANGE\_ENTRY

## Description

A range of ports for a reservation.

## Syntax

```cpp
typedef struct tagHCN_PORT_RANGE_ENTRY {
    GUID OwningPartitionId;
    GUID TargetPartitionId;
    HCN_PORT_PROTOCOL Protocol;
    UINT64 Priority;
    UINT32 ReservationType;
    UINT32 SharingFlags;
    UINT32 DeliveryMode;
    UINT16 StartingPort;
    UINT16 EndingPort;
} HCN_PORT_RANGE_ENTRY, *PHCN_PORT_RANGE_ENTRY;
```

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeNetwork.h |

