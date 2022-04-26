---
title: HcnCreateNetwork
description: HcnCreateNetwork
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.date: 10/31/2021
api_name:
- HcnCreateNetwork
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnCreateNetwork

## Description

Creates a network.

## Syntax

```cpp
HRESULT
WINAPI
HcnCreateNetwork(
    _In_ REFGUID Id,
    _In_ PCWSTR Settings,
    _Out_ PHCN_NETWORK Network,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`Network`

Network for the new network.

`Id`

Id for the new network.

`Settings`

JSON document specifying the settings of the [HostComputeNetwork](./../HNS_Schema.md#HostComputeNetwork).

`Network`

Receives a handle to the newly created network. It is the responsibility of the caller to release the handle using [HcnCloseNetwork](./HcnCloseNetwork.md) once it is no longer in use.

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

