---
title: HcnOpenNetwork
description: HcnOpenNetwork
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HcnOpenNetwork
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnOpenNetwork

## Description

Opens a network.

## Syntax

```cpp
HRESULT
WINAPI
HcnOpenNetwork(
    _In_ REFGUID Id,
    _Out_ PHCN_NETWORK Network,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`Id`

Id of the network.

`Network`

Receives a handle to the network. It is the responsibility of the caller to release the handle using [HcnCloseNetwork](./HcnCloseNetwork.md) once it is no longer in use.

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

