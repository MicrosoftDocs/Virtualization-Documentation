# HcsImportLayer

## Description
This function imports a container layer and sets it up for use on boot. This function is used by an application to setup a container layer that was copied in a transport format to the host (e.g was downloaded from a container registry such as DockerHub).

## Syntax

```cpp
HRESULT WINAPI
HcsImportLayer(
    _In_ PCWSTR layerPath,
    _In_ PCWSTR sourceFolderPath,
    _In_ PCWSTR layerData
    );
```

## Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`layerPath`| Destination path for the container layer|
|`sourceFolderPath`| Source path that contains the downloaded layer files|
|`layerData`| JSON document providing the locations of the antecedent layers that are used by the imported layer|
|    |    | 



## Return Values
|Return Value     |Description|
|---|---|
|`S_OK` | The function returns on success.|
|`HRESULT`| Error code for failures to import the layer.|
