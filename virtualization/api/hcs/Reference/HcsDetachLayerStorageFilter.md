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
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`layerPath`| Path to the root directory of the layer|
|    |    | 



## Return Values
|Return Value     |Description|
|---|---|
|`S_OK` | The function returns on success.|
|`HRESULT`| Error code for failures to detach a filter.|
