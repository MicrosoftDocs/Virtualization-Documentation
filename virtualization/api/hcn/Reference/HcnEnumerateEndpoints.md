---
title: HcnEnumerateEndpoints
description: HcnEnumerateEndpoints
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HcnEnumerateEndpoints
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnEnumerateEndpoints

## Description

Enumerates the endpoints.

## Syntax

```cpp
HRESULT
WINAPI
HcnEnumerateEndpoints(
    _In_ PCWSTR Query,
    _Outptr_ PWSTR* Endpoints,
    _Outptr_opt_ PWSTR* ErrorRecord
    );```

## Parameters

`Query`

Optional JSON document of [HostComputeQuery](./../HNS_Schema.md#HostComputeQuery).

`Endpoints`

A list of IDs for each Endpoint.

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

