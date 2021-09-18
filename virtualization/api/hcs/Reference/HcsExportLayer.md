---
title: HcsExportLayer
description: HcsExportLayer
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HcsExportLayer
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsExportLayer

## Description

This function exports a container layer. This function is used by an application to create a representation of a layer in a transport format that can be copied to another host or uploaded to a container registry.

## Syntax

```cpp
HRESULT WINAPI
HcsExportLayer(
    _In_ PCWSTR layerPath,
    _In_ PCWSTR exportFolderPath,
    _In_ PCWSTR layerData,
    _In_ PCWSTR options
    );
```

## Parameters

`layerPath`

Path of the layer to export.

`exportFolderPath`

Destination folder for the exported layer.

`layerData`

JSON document of [layerData](./../SchemaReference.md#LayerData) providing the locations of the antecedent layers that are used by the exported layer.

`options`

JSON document of [ExportLayerOptions](./../SchemaReference.md#ExportLayerOptions) describing the layer to export.


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
