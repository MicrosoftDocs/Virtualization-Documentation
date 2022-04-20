---
title: HcnUnregisterGuestNetworkServiceCallback
description: HcnUnregisterGuestNetworkServiceCallback
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.date: 10/31/2021
api_name:
- HcnUnregisterGuestNetworkServiceCallback
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnUnregisterGuestNetworkServiceCallback

## Description

Unregisters a guest network service callback.

## Syntax

```cpp
HRESULT
WINAPI
HcnUnregisterGuestNetworkServiceCallback(
    _In_ HCN_CALLBACK CallbackHandle
    );
```

## Parameters

`CallbackHandle`

The [HCN_CALLBACK](./HCN_CALLBACK.md) for the callback.

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



