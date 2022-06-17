---
title: HcsDestroyLayer
description: HcsDestroyLayer
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HcsDestroyLayer
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsDestroyLayer

## Description

Deletes a layer from the host.

## Syntax

```cpp
HRESULT WINAPI
HcsDestroyLayer(
    _In_ PCWSTR layerPath
    );
```

## Parameters

`layerPath`

Path of the layer to delete.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Remarks

**Be careful when using this API, it deletes directories using high privilege rights.**
This function deletes a layer from the host.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeStorage.h |
| **Library** | ComputeStorage.lib |
| **Dll** | ComputeStorage.dll |

