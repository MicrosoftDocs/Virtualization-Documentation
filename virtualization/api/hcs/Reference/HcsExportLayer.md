# HcsExportLayer

## Description

This function exports a container layer. This function is used by an application to create a representation of a layer in a transport format that can be copied to another host or uploaded to a container registry.

## Syntax

```cpp
HRESULT WINAPI
HcsExportLayer(
    _In_ PCWSTR layerPath,
    _In_ PCWSTR exportFolderPath,
    _In_ PCWSTR layerData,
    _In_ PCWSTR options
    );
```

## Parameters

|Parameter     |Description|
|---|---|
|`layerPath`| Path of the layer to export|
|`exportFolderPath`| Destination folder for the exported layer|
|`layerData`| JSON document providing the locations of the antecedent layers that are used by the exported layer|
|`options`| JSON document describing the layer to export|
|    |    |

## Return Values

|Return Value    |Description|
|---|---|
|`S_OK` |The function returns on success.|
|`HRESULT`| Error code for failures to export the layer.|
|    |    |
