---
title: HcnCreateEndpoint
description: HcnCreateEndpoint
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HcnCreateEndpoint
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnCreateEndpoint

## Description

Creates an endpoint.

## Syntax

```cpp
HRESULT
WINAPI
HcnCreateEndpoint(
    _In_ HCN_NETWORK Network,
    _In_ REFGUID Id,
    _In_ PCWSTR Settings,
    _Out_ PHCN_ENDPOINT Endpoint,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`Network`

Network for the new endpoint.

`Id`

Id for the new endpoint.

`Settings`

JSON document specifying the settings of the [endpoint](./../HNS_Schema.md#HostComputeEndpoint).

`Endpoint`

Receives a handle to the newly created endpoint. It is the responsibility of the caller to release the handle using [HcnCloseEndpoint](./HcnCloseEndpoint.md) once it is no longer in use.

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




