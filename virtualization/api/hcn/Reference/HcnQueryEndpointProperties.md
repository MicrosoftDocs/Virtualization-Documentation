---
title: HcnQueryEndpointProperties
description: HcnQueryEndpointProperties
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HcnQueryEndpointProperties
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnQueryEndpointProperties

## Description

Queries the properties of an endpoint.

## Syntax

```cpp
HRESULT
WINAPI
HcnQueryEndpointProperties(
    _In_ HCN_ENDPOINT Endpoint,
    _In_ PCWSTR Query,
    _Outptr_ PWSTR* Properties,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`Endpoint`

Handle to an endpoint [`HCN_ENDPOINT`](./HCN_ENDPOINT.md)

`Query`

Optional JSON document of [HostComputeQuery](./../HNS_Schema.md#HostComputeQuery).

`Properties`

The properties in the form of a JSON document of [HostComputeEndpoint](./../HNS_Schema.md#HostComputeEndpoint).

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


