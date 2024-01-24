---
title: HcnCreateNamespace
description: HcnCreateNamespace
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HcnCreateNamespace
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnCreateNamespace

## Description

Creates a namespace.

## Syntax

```cpp
HRESULT
WINAPI
HcnCreateNamespace(
    _In_ REFGUID Id,
    _In_ PCWSTR Settings,
    _Out_ PHCN_NAMESPACE Namespace,
    _Outptr_opt_ PWSTR* ErrorRecord
    );

```

## Parameters

`Id`

Id for the new namespace.

`Settings`

JSON document specifying the settings of the [namespace](./../HNS_Schema.md#HostComputeNamespace).

`Namespace`

Receives a handle to the newly created namespace. It is the responsibility of the caller to release the handle using [HcnCloseNamespace](./HcnCloseNamespace.md) once it is no longer in use.

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

