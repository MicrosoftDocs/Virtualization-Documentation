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
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`layerPath`| Path to the root of the base OS layer|
|`vhdHandle`| Handle to a VHD|
|`options`| Optional JSON document describing options for setting up the layer|
|    |    | 



## Return Values
|Return Value    |Description|
|---|---|
|`S_OK` |The function returns on success.|
|`HRESULT`| Error code for failures to setup the base OS layer.|

