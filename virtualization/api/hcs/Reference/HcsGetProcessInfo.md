---
title: HcsGetProcessInfo
description: HcsGetProcessInfo
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsGetProcessInfo
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsGetProcessInfo

## Description

Returns the initial startup information of a process in a compute system.

## Syntax

```cpp
HRESULT WINAPI
HcsGetProcessInfo(
    _In_ HCS_PROCESS process,
    _In_ HCS_OPERATION operation
    );
```

## Parameters

`process`

The handle to the process to query.

`operation`

The handle to the operation that tracks the process.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation started successfully. Callers are expected to get the operation's result using [`HcsWaitForOperationResultAndProcessInfo`](./HcsWaitForOperationResultAndProcessInfo.md) or [`HcsGetOperationResultAndProcessInfo`](./HcsGetOperationResultAndProcessInfo.md).


## Operation Results

The return value of [`HcsWaitForOperationResultAndProcessInfo`](./HcsWaitForOperationResultAndProcessInfo.md) or [`HcsGetOperationResultAndProcessInfo`](./HcsGetOperationResultAndProcessInfo.md) based on current operation listed as below.

| Operation Result Value | Description |
| -- | -- |
| `S_OK` | The process information queried successfully, the process information is stored as [HCS_PROCESS_INFORMATION](./HCS_PROCESS_INFORMATION.md) in `processInformation`|


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
