---
title: HcsCloseProcess
description: HcsCloseProcess
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name: HcsCloseProcess
api_location: computecore.dll
api_type: DllExport
topic_type: apiref
---
# HcsCloseProcess

## Description

Closes the handle to a process in a compute system.

## Syntax

```cpp
void WINAPI
HcsCloseProcess(
    _In_ HCS_PROCESS process
    );
```

## Parameters

`process`

Process handle to close.

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