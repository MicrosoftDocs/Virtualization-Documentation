---
title: HCS_PROCESS_INFORMATION
description: HCS_PROCESS_INFORMATION
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HCS_PROCESS_INFORMATION
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HCS_PROCESS_INFORMATION

## Description

The struct contains information about a process created by [HcsCreateProcess](./HcsCreateProcess.md). This structure can be obtained with [`HcsGetOperationResultAndProcessInfo`](./HcsGetOperationResultAndProcessInfo.md) and [`HcsWaitForOperationResultAndProcessInfo`](./HcsWaitForOperationResultAndProcessInfo.md).

## Syntax

```cpp
typedef struct
{
    DWORD ProcessId;
    DWORD Reserved;
    HANDLE StdInput;
    HANDLE StdOutput;
    HANDLE StdError;
} HCS_PROCESS_INFORMATION;
```

## Members

`ProcessId`

Identifier of the created process.

`Reserved`

`StdInput`

If created, standard input handle of the process.

`StdOutput`

If created, standard output handle of the process.

`StdError`

If created, standard error handle of the process.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
