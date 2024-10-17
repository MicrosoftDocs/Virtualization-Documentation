---
title: HcsGetComputeSystemFromOperation
description: HcsGetComputeSystemFromOperation
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsGetComputeSystemFromOperation
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsGetComputeSystemFromOperation

## Description

Get the compute system associated with operation.

## Syntax

```cpp
HCS_SYSTEM WINAPI
HcsGetComputeSystemFromOperation(
    _In_ HCS_OPERATION operation
    );

```

## Parameters

`operation`

The handle to an active operation.

## Return Values

Returns the `HCS_SYSTEM` handle to the compute system used by active operation, returns `NULL` if the operation is not active.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
