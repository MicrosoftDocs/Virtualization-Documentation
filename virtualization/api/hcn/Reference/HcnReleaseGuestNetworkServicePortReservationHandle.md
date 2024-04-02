---
title: HcnReleaseGuestNetworkServicePortReservationHandle
description: HcnReleaseGuestNetworkServicePortReservationHandle
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HcnReleaseGuestNetworkServicePortReservationHandle
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnReleaseGuestNetworkServicePortReservationHandle

## Description

Releases a port reservation handle.

## Syntax

```cpp
HRESULT
WINAPI
HcnReleaseGuestNetworkServicePortReservationHandle(
    _In_ HANDLE PortReservationHandle
    );
```

## Parameters

`PortReservationHandle`

The handle to the reservations to release.

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

