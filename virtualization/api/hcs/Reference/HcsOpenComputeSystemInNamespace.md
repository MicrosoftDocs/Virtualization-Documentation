---
title: HcsOpenComputeSystemInNamespace
description: HcsOpenComputeSystemInNamespace
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HcsOpenComputeSystemInNamespace
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsOpenComputeSystemInNamespace

## Description

Opens a handle to an existing compute system in a given namespace.

## Syntax

```cpp
HRESULT WINAPI
HcsOpenComputeSystemInNamespace(
    _In_ PCWSTR idNamespace,
    _In_ PCWSTR id,
    _In_ DWORD requestedAccess,
    _Out_ HCS_SYSTEM* computeSystem
    );
```

## Parameters

`idNamespace`

The string contains the namespace of the compute system to open.

`id`

Unique Id identifying the compute system.

`requestedAccess`

Reserved for future use, must be `GENERIC_ALL`.

`computeSystem`

Receives a handle to the compute system. It is the responsibility of the caller to release the handle using [HcsCloseComputeSystem](./HcsCloseComputeSystem.md) once it is no longer in use.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 2004 |
| **Minimum supported server** | Windows Server, version 2004 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
