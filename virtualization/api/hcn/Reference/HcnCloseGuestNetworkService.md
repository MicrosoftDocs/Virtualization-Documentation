---
title: HcnCloseGuestNetworkService
description: HcnCloseGuestNetworkService
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.date: 10/31/2021
api_name:
- HcnCloseGuestNetworkService
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnCloseGuestNetworkService

## Description

Close a handle to a guest network service handle.

## Syntax

```cpp
HRESULT
WINAPI
HcnCloseGuestNetworkService(
    _In_ HCN_GUESTNETWORKSERVICE GuestNetworkService
    );
```

## Parameters

`GuestNetworkService`

Handle to a guest network service [`HCN_GUESTNETWORKSERVICE`](./HCN_GUESTNETWORKSERVICE.md)

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


