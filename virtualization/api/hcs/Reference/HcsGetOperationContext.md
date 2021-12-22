---
title: HcsGetOperationContext
description: HcsGetOperationContext
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HcsGetOperationContext
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsGetOperationContext

## Description

Gets the context pointer of an operation.

## Syntax

```cpp
void* WINAPI
HcsGetOperationContext(
    _In_ HCS_OPERATION operation
    );

```

## Parameters

`operation`

The handle to an operation.

## Return Values

Returns the context pointer stored in the operation as a `void*` type.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
