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

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`writableLayerPath`| Full path to the root directory of the writable layer|
|`layerData`| JSON document providing the locations of the antecedent layers that are used by teh writable layer|
|`options`| Optional JSON document specifying the options for how to initialize the sandbox (e.g. which filesystem paths should be pre-expanded in the sandbox)|
|    |    |

## Return Values

|Return Value     |Description|
|---|---|
|`S_OK` | The function returns on success.|
|`HRESULT` | Error code for failures to initialize the sandbox.|
|    |    |
