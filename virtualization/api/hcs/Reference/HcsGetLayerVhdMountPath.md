---
title: HcsGetLayerVhdMountPath
description: HcsGetLayerVhdMountPath
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsGetLayerVhdMountPath
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsGetLayerVhdMountPath

## Description

Returns the volume path for a virtual disk of a writable container layer.

## Syntax

```cpp
HRESULT WINAPI
HcsGetLayerVhdMountPath(
    _In_     HANDLE vhdHandle,
    _Outptr_ PWSTR* mountPath
    );
```

## Parameters

`vhdHandle`

The handle to a mounted virtual hard disk on the host.

`mountPath`

Receives the volume path for the layer. It is the caller's responsibility to release the returned string buffer using [`LocalFree`](/windows/win32/api/winbase/nf-winbase-localfree).

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeStorage.h |
| **Library** | ComputeStorage.lib |
| **Dll** | ComputeStorage.dll |
