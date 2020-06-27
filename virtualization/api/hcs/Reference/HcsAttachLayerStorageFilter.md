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

|Parameter     |Description|
|---|---|
|`layerPath`| Full path to the root directory of the layer|
|`layerData`| JSON document providing the locations of the antecedent layers that are used by the layer|
|    |    |

## Return Values

|Return Value     |Description|
|---|---|
|`S_OK` | The function returns on success.|
|`HRESULT`| Error code for failures to attach a filter.
|    |    |
