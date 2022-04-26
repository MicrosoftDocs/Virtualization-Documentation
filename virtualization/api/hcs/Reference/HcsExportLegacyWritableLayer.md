---
title: HcsExportLegacyWritableLayer
description: HcsExportLegacyWritableLayer
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HcsExportLegacyWritableLayer
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsExportLegacyWritableLayer

## Description

This function exports a legacy container writable layer.

## Syntax

```cpp
HRESULT WINAPI
HcsExportLegacyWritableLayer(
    _In_ PCWSTR writableLayerMountPath,
    _In_ PCWSTR writableLayerFolderPath,
    _In_ PCWSTR exportFolderPath,
    _In_ PCWSTR layerData
    );
```

## Parameters

`writableLayerMountPath`

Path of the writable layer to export.

`writableLayerFolderPath`

Folder of the writable layer to export.

`exportFolderPath`

Destination folder for the exported layer.

`layerData`

JSON document of [layerData](./../SchemaReference.md#LayerData) providing the locations of the antecedent layers that are used by the exported layer.

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
