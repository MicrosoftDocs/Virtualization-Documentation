# HcsImportLayer

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`layerPath`| Destination path for the container layer|
|`sourceFolderPath`| Source path that contains the downloaded layer files|
|`layerData`| JSON document providing the locations of the antecedent layers that are used by the imported layer|
|    |    | 



## Return Values

The function returns `S_OK` on success. `HRESULT` error code for failures to import the layer.

## Remarks
This function imports a container layer and sets it up for use on boot. This function is used by an application to setup a container layer that was copied in a transport format to the host (e.g was downloaded from a container registry such as DockerHub).