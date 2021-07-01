---
title: HcsCreateProcess
description: HcsCreateProcess
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name: HcsCreateProcess
api_location: computecore.dll
api_type: DllExport
topic_type: apiref
---
# HcsCreateProcess

## Description

Starts a process in a compute system.

## Syntax

```cpp
HRESULT WINAPI
HcsCreateProcess(
    _In_ HCS_SYSTEM computeSystem,
    _In_ PCWSTR processParameters,
    _In_ HCS_OPERATION operation,
    _In_opt_ const SECURITY_DESCRIPTOR* securityDescriptor,
    _Out_ HCS_PROCESS* process
    );
```

## Parameters

`computeSystem`

The handle to the compute system in which to start the process.

`processParameters`

JSON document of [ProcessParameters](./../SchemaReference.md#ProcessParameters) specifying the command line and environment for the process.

`operation`

Handle to the operation that tracks the process creation operation.

`securityDescriptor`

Reserved for future use, must be `NULL`.

`process`

Receives the `HCS_PROCESS` handle to the newly created process.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

If the return value is `S_OK`, it means the operation started successfully. Callers are expected to get the operation's result using [`HcsWaitForOperationResultAndProcessInfo`](./HcsWaitForOperationResultAndProcessInfo.md) or [`HcsGetOperationResultAndProcessInfo`](./HcsGetOperationResultAndProcessInfo.md).


## Operation Results

The return value of [`HcsWaitForOperationResultAndProcessInfo`](./HcsWaitForOperationResultAndProcessInfo.md) or [`HcsGetOperationResultAndProcessInfo`](./HcsGetOperationResultAndProcessInfo.md) based on current operation listed as below.

| Operation Result Value | Description |
| -- | -- |
| `S_OK` | The process was created successfully |


## Remarks

It is recommended for callers to use [`HcsWaitForOperationResultAndProcessInfo`](./HcsWaitForOperationResultAndProcessInfo.md) or [`HcsGetOperationResultAndProcessInfo`](./HcsGetOperationResultAndProcessInfo.md) function calls to ensure you can get a reference to the process information. This is important when the process has created standard Input/Output/Error handles. You can still get this through a call to [`HcsGetProcessInfo`](./HcsGetProcessInfo.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |