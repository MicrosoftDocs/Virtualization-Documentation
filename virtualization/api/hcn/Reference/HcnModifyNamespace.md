---
title: HcnModifyNamespace
description: HcnModifyNamespace
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HcnModifyNamespace
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnModifyNamespace

## Description

Modifies an namespace.

## Syntax

```cpp
HRESULT
WINAPI
HcnModifyNamespace(
    _In_ HCN_NAMESPACE Namespace,
    _In_ PCWSTR Settings,
    _Outptr_opt_ PWSTR* ErrorRecord
    );

```

## Parameters

`Id`

The [HCN\_NAMESPACE](./HCN_NAMESPACE.md) to modify.

`Settings`

JSON document specifying the settings of the [namespace](./../HNS_Schema.md#HostComputeNamespace).

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






