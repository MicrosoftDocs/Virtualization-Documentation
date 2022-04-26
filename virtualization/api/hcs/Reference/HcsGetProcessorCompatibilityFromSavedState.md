---
title: HcsGetProcessorCompatibilityFromSavedState
description: HcsGetProcessorCompatibilityFromSavedState
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.prod: virtualization
ms.date: 12/21/2021
api_name:
- HcsGetProcessorCompatibilityFromSavedState
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsGetProcessorCompatibilityFromSavedState

## Description

Returns processor compatibility fields in JSON string format.

## Syntax

```cpp
HRESULT WINAPI
HcsGetProcessorCompatibilityFromSavedState(
    PCWSTR RuntimeFileName,
    _Outptr_opt_ PCWSTR* ProcessorFeaturesString
    );
```

## Parameters

`RuntimeFileName`

The path to the vmrs file.

`ProcessorFeaturesString`

JSON document of the processor compatibilities as [VmProcessorRequirements](./../SchemaReference.md#VmProcessorRequirements).

The caller is responsible for releasing the returned string using [`LocalFree`](/windows/win32/api/winbase/nf-winbase-localfree).

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 2104|
| **Minimum supported server** | Windows Server 2022 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
