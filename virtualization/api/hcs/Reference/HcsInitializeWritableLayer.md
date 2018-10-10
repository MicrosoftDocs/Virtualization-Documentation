# HcsInitializeWritableLayer

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`writableLayerPath`| Full path to the root directory of the writable layer|
|`layerData`| JSON document providing the locations of the antecedent layers that are used by teh writable layer|
|`options`| Optional JSON document specifying the options for how to initialize the sandbox (e.g. which filesystem paths should be pre-expanded in the sandbox)|
|    |    | 



## Return Values

The function returns `S_OK` on success. `HRESULT` error code for failures to initialize the sandbox.

## Remarks
This function initializes the writable layer for a container (e.g. the layer that caputres the filesystem and registry changes caused by executing the container).