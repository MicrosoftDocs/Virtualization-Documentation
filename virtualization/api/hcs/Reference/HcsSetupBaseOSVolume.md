---
title: HcsSetupBaseOSVolume
description: HcsSetupBaseOSVolume
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.prod: virtualization
ms.date: 12/21/2021
api_name:
- HcsSetupBaseOSVolume
api_location:
- ComputeStorage.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsSetupBaseOSVolume

## Description

This function sets up the base OS layer for the use on a host based on the mounted volume (VHD).

## Syntax

```cpp
HRESULT WINAPI
HcsSetupBaseOSVolume(
    _In_ PCWSTR layerPath,
    _In_ PCWSTR volumePath,
    _In_ PCWSTR options
    );
```

## Parameters

`layerPath`

Path to the root of the base OS layer.

`vhdHandle`

The handle to a VHD.

`options`

Optional JSON document  of [OsLayerOptions](./../SchemaReference.md#OsLayerOptions) describing options for setting up the layer.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 2104|
| **Minimum supported server** | Windows Server 2022 |
| **Target Platform** | Windows |
| **Header** | ComputeStorage.h |
| **Library** | ComputeStorage.lib |
| **Dll** | ComputeStorage.dll |
