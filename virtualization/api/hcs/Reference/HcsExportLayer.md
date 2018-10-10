# HcsExportLayer

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`layerPath`| Path of the layer to export|
|`exportFolderPath`| Destination folder for the exported layer|
|`layerData`| JSON document providing the locations of the antecedent layers that are used by the exported layer|
|`flags`| Flags describing the type of the exported layer|
|    |    | 



## Return Values

The function returns `S_OK` on success. `HRESULT` error code for failures to export the layer.

## Remarks
This function exports a container layer. This function is used by an application to create a representation of a layer in a transport format that can be copied to another host or uploaded to a container registry.