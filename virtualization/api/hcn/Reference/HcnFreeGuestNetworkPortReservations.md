---
title: HcnFreeGuestNetworkPortReservations
description: HcnFreeGuestNetworkPortReservations
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HcnFreeGuestNetworkPortReservations
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnFreeGuestNetworkPortReservations

## Description

Free port reservations.

## Syntax

```cpp
VOID
WINAPI
HcnFreeGuestNetworkPortReservations(
    _Inout_opt_ HCN_PORT_RANGE_ENTRY* PortEntries
    );
```

## Parameters

`PortEntries`

The list of [`HCN_PORT_RANGE_ENTRY`](./HCN_PORT_RANGE_ENTRY.md) instances to free.

## Return Values

The function returns [HRESULT](./HCNHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeNetwork.h |
| **Library** | ComputeNetwork.lib |
| **Dll** | ComputeNetwork.dll |


