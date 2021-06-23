---
title: HcsDetachLayerStorageFilter
description: HcsDetachLayerStorageFilter
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
---
# HcsDetachLayerStorageFilter

## Description

This function detaches the container storage filter from the root directory of a layer.

## Syntax

```cpp
HRESULT WINAPI
HcsDetachLayerStorageFilter(
    _In_ PCWSTR layerPath
    );
```

## Parameters

`layerPath`

Path to the root directory of the layer.

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
