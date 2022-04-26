---
title: HcnModifyEndpoint
description: HcnModifyEndpoint
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.date: 10/31/2021
api_name:
- HcnModifyEndpoint
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnModifyEndpoint

## Description

Modifies an endpoint.

## Syntax

```cpp
HRESULT
WINAPI
HcnModifyEndpoint(
    _In_ HCN_ENDPOINT Endpoint,
    _In_ PCWSTR Settings,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`Endpoint`

The [HCN\_ENDPOINT](./HCN_ENDPOINT.md) to modify.

`Settings`

JSON document specifying the settings of the [endpoint](./../HNS_Schema.md#HostComputeEndpoint).

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





