---
title: HcsInitializeWritableLayer
description: HcsInitializeWritableLayer
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# HcsInitializeWritableLayer

## Description

This function initializes the writable layer for a container (e.g. the layer that captures the filesystem and registry changes caused by executing the container).

## Syntax

```cpp
HRESULT WINAPI
HcsInitializeWritableLayer(
    _In_ PCWSTR writableLayerPath,
    _In_ PCWSTR layerData,
    _In_opt_ PCWSTR options
    );
```

## Parameters

`writableLayerPath`

Full path to the root directory of the writable layer.

`layerData`

JSON document providing the locations of the antecedent layers that are used by teh writable layer.

`options`

Reserved for future use. Must be `NULL`.

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
