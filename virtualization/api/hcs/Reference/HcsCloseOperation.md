---
title: HcsCloseOperation
description: HcsCloseOperation
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# HcsCloseOperation

## Description

Close the operation, freeing any tracking resources associated with the operation. An operation can be closed from within a callback.

## Syntax

```cpp
void WINAPI
HcsCloseOperation(
    _In_ HCS_OPERATION operation
    );
```

## Parameters

`operation`

Handle to an operation.

## Return Values

None.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
