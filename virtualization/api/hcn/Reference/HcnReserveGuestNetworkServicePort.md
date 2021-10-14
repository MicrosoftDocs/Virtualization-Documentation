---
title: HcnReserveGuestNetworkServicePort
description: HcnReserveGuestNetworkServicePort
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HcnReserveGuestNetworkServicePort
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnReserveGuestNetworkServicePort

## Description

Reserves a single port.

## Syntax

```cpp
HRESULT
WINAPI
HcnReserveGuestNetworkServicePort(
    _In_ HCN_GUESTNETWORKSERVICE GuestNetworkService,
    _In_ HCN_PORT_PROTOCOL Protocol,
    _In_ HCN_PORT_ACCESS Access,
    _In_ USHORT Port,
    _Out_ HANDLE* PortReservationHandle
    );
```

## Parameters

`GuestNetworkService`

The [HCN_GUESTNETWORKSERVICE](./HCN_GUESTNETWORKSERVICE.md) for the reservation.

`Protocol`

The [HCN_PORT_PROTOCOL](./HCN_PORT_PROTOCOL.md) for the reservation.

`Access`

The [HCN_PORT_ACCESS](./HCN_PORT_ACCESS.md) for the reservation.

`Port`

The port for the reservation.

`PortReservationHandle`

Receives a handle. It is the responsibility of the caller to release the handle using [HcnReleaseGuestNetworkServicePortReservationHandle](./HcnReleaseGuestNetworkServicePortReservationHandle.md) once it is no longer in use.

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

