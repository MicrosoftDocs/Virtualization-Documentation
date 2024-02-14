---
title: HcsInitializeLegacyWritableLayer
description: HcsInitializeLegacyWritableLayer
author: sethmanheim
ms.author: sethm
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsInitializeLegacyWritableLayer
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsInitializeLegacyWritableLayer

## Description

This function initializes the writable layer for a container (e.g. the layer that captures the filesystem and registry changes caused by executing the container).

## Syntax

```cpp
HRESULT WINAPI
HcsInitializeLegacyWritableLayer(
    _In_ PCWSTR writableLayerMountPath,
    _In_ PCWSTR writableLayerFolderPath,
    _In_ PCWSTR layerData,
    _In_opt_ PCWSTR options
    );

```

## Parameters

`writableLayerMountPath`

Full path to the root directory of the writable layer.

`writableLayerFolderPath`

The legacy hive folder with the writable layer.

`layerData`

JSON document of [layerData](./../SchemaReference.md#LayerData) providing the locations of the antecedent layers that are used by teh writable layer.

`options`

Optional JSON document specifying the options for how to initialize the sandbox (e.g. which filesystem paths should be pre-expanded in the sandbox).

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
