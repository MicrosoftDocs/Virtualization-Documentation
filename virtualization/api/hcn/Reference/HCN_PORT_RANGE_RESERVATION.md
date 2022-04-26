---
title: HCN_PORT_RANGE_RESERVATION
description: HCN_PORT_RANGE_RESERVATION
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.date: 10/31/2021
api_name:
- HCN_PORT_RANGE_RESERVATION
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HCN\_PORT\_RANGE\_RESERVATION

## Description

A range of ports for a reservation.

## Syntax

```cpp
typedef struct tagHCN_PORT_RANGE_RESERVATION
{
    // start and end are inclusive
    USHORT startingPort;
    USHORT endingPort;
} HCN_PORT_RANGE_RESERVATION;

```


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeNetwork.h |

