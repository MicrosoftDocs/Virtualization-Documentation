---
title: HcnQueryNamespaceProperties
description: HcnQueryNamespaceProperties
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.date: 10/31/2021
api_name:
- HcnQueryNamespaceProperties
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnQueryNamespaceProperties

## Description

Queries the properties of a namespace.

## Syntax

```cpp
HRESULT
WINAPI
HcnQueryNamespaceProperties(
    _In_ HCN_NAMESPACE Namespace,
    _In_ PCWSTR Query,
    _Outptr_ PWSTR* Properties,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`Namespace`

Handle to an namespace [`HCN_NAMESPACE`](./HCN_NAMESPACE.md)

`Query`

Optional JSON document of [HostComputeQuery](./../HNS_Schema.md#HostComputeQuery).

`Properties`

The properties in the form of a JSON document of [HostComputeNamespace](./../HNS_Schema.md#HostComputeNamespace).

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



