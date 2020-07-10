# HcsAttachLayerStorageFilter

## Description

This function sets up the container storage filter on a layer directory. The storage filter provides the unified view to the layer and its antecedent layers.

## Syntax

```cpp
HRESULT WINAPI
HcsAttachLayerStorageFilter(
    _In_ PCWSTR layerPath,
    _In_ PCWSTR layerData
    );
```

## Parameters

`layerPath` 

Full path to the root directory of the layer

`layerData`

JSON document of [layerData](./../SchemaReference.md#LayerData) providing the locations of the antecedent layers that are used by the layer

## Return Values

The function returns [HRESULT](./HCSHResult.md)

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeStorage.h |
| **Library** | ComputeStorage.lib |
| **Dll** | ComputeStorage.dll |
