---
title: HcsOpenProcess
description: HcsOpenProcess
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HcsOpenProcess
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsOpenProcess

## Description

Opens an existing process in a compute system.

## Syntax

```cpp
HRESULT WINAPI
HcsOpenProcess(
    _In_ HCS_SYSTEM computeSystem,
    _In_ DWORD processId,
    _In_ DWORD requestedAccess,
    _Out_ HCS_PROCESS* process
    );

```

## Parameters

`computeSystem`

The handle to the compute system in which to start the process.

`processId`

Specifies the Id of the process to open.

`requestedAccess`

Specifies the required access to the compute system.

`process`

Receives the handle to the process.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
