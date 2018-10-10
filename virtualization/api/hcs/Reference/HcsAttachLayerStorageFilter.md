# HcsAttachLayerStorageFilter

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`layerPath`| Full path to the root directory of the layer|
|`layerData`| JSON document providing the locations of the antecedent layers that are used by the layer|
|    |    | 



## Return Values

The function returns `S_OK` on success. `HRESULT` error code for failures to attach a filter.

## Remarks
This function sets up the container storage filter on a layer directory. The storage filter provides the unified view to the layer and its antecedent layers.