# HcsSetupBaseOSLayer

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`layerPath`| Path to the root of the base OS layer|
|`type`| Type of the base OS Layer|
|`options`| Options for setting up the layer|
|    |    | 



## Return Values

The function returns `S_OK` on success. `HRESULT` error code for failures to setup the base OS layer.

## Remarks
This function sets up a base OS layer for the use on a host. The base OS layer is the first layer in teh set of layers used by a container or virtual machine.