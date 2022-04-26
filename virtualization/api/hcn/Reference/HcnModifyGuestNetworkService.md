---
title: HcnModifyGuestNetworkService
description: HcnModifyGuestNetworkService
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.date: 10/31/2021
api_name:
- HcnModifyGuestNetworkService
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnModifyGuestNetworkService

## Description

Modifies a guest network service.

## Syntax

```cpp
HRESULT
WINAPI
HcnModifyGuestNetworkService(
    _In_ HCN_GUESTNETWORKSERVICE GuestNetworkService,
    _In_ PCWSTR Settings,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`GuestNetworkService`

The [HCN\_GUESTNETWORKSERVICE](./HCN_GUESTNETWORKSERVICE.md) to modify.

`Settings`

JSON document specifying the settings of the [guest network service](./../HNS_Schema.md#GuestNetworkService).

`GuestNetworkService`

Receives a handle to the newly created guest network service. It is the responsibility of the caller to release the handle using [HcnCloseGuestNetworkService](./HcnCloseGuestNetworkService.md) once it is no longer in use.

`ErrorRecord`

Receives a JSON document with extended errorCode information. The caller must release the buffer using CoTaskMemFree.

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






