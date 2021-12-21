---
title: HcnCloseEndpoint
description: HcnCloseEndpoint
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HcnCloseEndpoint
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnCloseEndpoint

## Description

Close a handle to an Endpoint.

## Syntax

```cpp
HRESULT
WINAPI
HcnCloseEndpoint(
    _In_ HCN_ENDPOINT Endpoint
    );```

## Parameters

`Endpoint`

Handle to an endpoint [`HCN_ENDPOINT`](./HCN_ENDPOINT.md)

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

