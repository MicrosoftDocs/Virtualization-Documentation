---
title: HCS_OPERATION_TYPE
description: HCS_OPERATION_TYPE
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HCS_OPERATION_TYPE
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HCS_OPERATION_TYPE

## Description

Function type for the completion callback of an operation.

## Syntax

```cpp
typedef void (CALLBACK *HCS_OPERATION_COMPLETION)(
    _In_ HCS_OPERATION operation,
    _In_opt_ void* context
    );
```

## Parameters

`operation`

Handle to an operation on a compute system.

`context`

Handle to the pointer of callback context.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
