 ---
title: HcnEnumerateGuestNetworkPortReservations
description: HcnEnumerateGuestNetworkPortReservations
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HcnEnumerateGuestNetworkPortReservations
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnEnumerateGuestNetworkPortReservations

## Description

Enumerates the guest network port reservations.

## Syntax

```cpp
HRESULT
WINAPI
HcnEnumerateGuestNetworkPortReservations(
    _Out_ ULONG* ReturnCount,
    _Out_writes_bytes_all_(*ReturnCount) HCN_PORT_RANGE_ENTRY** PortEntries
    );```

## Parameters

`ReturnCount`

Recieves the count of reserved port entries.

`PortEntries`

Recieves the list of [port entries](./.HCN_PORT_RANGE_ENTRY.md).

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


