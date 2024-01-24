---
title: HcnQueryNetworkProperties
description: HcnQueryNetworkProperties
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HcnQueryNetworkProperties
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnQueryNetworkProperties

## Description

Queries the properties of a network.

## Syntax

```cpp
HRESULT
WINAPI
HcnQueryNetworkProperties(
    _In_ HCN_NETWORK Network,
    _In_ PCWSTR Query,
    _Outptr_ PWSTR* Properties,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`Network`

Handle to an network [`HCN_NETWORK`](./HCN_NETWORK.md)

`Query`

Optional JSON document of [HostComputeQuery](./../HNS_Schema.md#HostComputeQuery).

`Properties`

The properties in the form of a JSON document of [HostComputeNetwork](./../HNS_Schema.md#HostComputeNetwork).

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



