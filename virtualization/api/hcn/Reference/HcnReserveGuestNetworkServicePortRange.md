---
title: HcnReserveGuestNetworkServicePortRange
description: HcnReserveGuestNetworkServicePortRange
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HcnReserveGuestNetworkServicePortRange
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnReserveGuestNetworkServicePortRange

## Description

Reserves a range of ports.

## Syntax

```cpp
HRESULT
WINAPI
HcnReserveGuestNetworkServicePortRange(
    _In_ HCN_GUESTNETWORKSERVICE GuestNetworkService,
    _In_ USHORT PortCount,
    _Out_ HCN_PORT_RANGE_RESERVATION* PortRangeReservation,
    _Out_ HANDLE* PortReservationHandle
    );
```

## Parameters

`GuestNetworkService`

The [HCN\_GUESTNETWORKSERVICE](./HCN_GUESTNETWORKSERVICE.md) for the reservation.

`PortCount`

The number of ports to reserve.

`PortRangeReservation`

The list of [HCN_PORT_RANGE_RESERVATION](./HCN_PORT_RANGE_RESERVATION.md) for the reservation.

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



