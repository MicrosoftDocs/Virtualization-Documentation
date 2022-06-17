---
title: HcnCloseNetwork
description: HcnCloseNetwork
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.date: 10/31/2021
api_name:
- HcnCloseNetwork
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnCloseNetwork

## Description

Close a handle to a Network.

## Syntax

```cpp
HRESULT
WINAPI
HcnCloseNetwork(
    _In_ HCN_NETWORK Network
    );
```

## Parameters

`operation`

Handle to a network [`HCN_NETWORK`](./HCN_NETWORK.md)

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


