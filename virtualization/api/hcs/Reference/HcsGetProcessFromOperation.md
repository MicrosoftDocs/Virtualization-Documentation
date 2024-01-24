---
title: HcsGetProcessFromOperation
description: HcsGetProcessFromOperation
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsGetProcessFromOperation
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsGetProcessFromOperation

## Description

Returns the handle to the process associated with an operation.

## Syntax

```cpp
HCS_PROCESS WINAPI
HcsGetProcessFromOperation(
    _In_ HCS_OPERATION operation
    );

```

## Parameters

`operation`
The handle to an active operation.

## Return Values

If the function succeeds, the return value is `HCS_PROCESS`.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
