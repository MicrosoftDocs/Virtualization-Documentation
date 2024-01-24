---
title: HcsSetupBaseOSLayer
description: HcsSetupBaseOSLayer
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsSetupBaseOSLayer
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsSetupBaseOSLayer

## Description

This function sets up a base OS layer for the use on a host. The base OS layer is the first layer in the set of layers used by a container or virtual machine.

## Syntax

```cpp
HRESULT WINAPI
HcsSetupBaseOSLayer(
    _In_ PCWSTR layerPath,
    _In_ HANDLE vhdHandle,
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
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeStorage.h |
| **Library** | ComputeStorage.lib |
| **Dll** | ComputeStorage.dll |
