# HcsExportLayer

## Description

This function exports a legacy container writable layer.

## Syntax

```cpp
HRESULT WINAPI
HcsExportLegacyWritableLayer(
    _In_ PCWSTR writableLayerMountPath,
    _In_ PCWSTR writableLayerFolderPath,
    _In_ PCWSTR exportFolderPath,
    _In_ PCWSTR layerData
    );
```

## Parameters

|Parameter     |Description|
|---|---|
|`writableLayerMountPath`| Path of the writable layer to export|
|`writableLayerFolderPath`| Folder of the writable layer to export|
|`exportFolderPath`| Destination folder for the exported layer|
|`layerData`| JSON document providing the locations of the antecedent layers that are used by the exported layer|
|    |    |

## Return Values

|Return Value    |Description|
|---|---|
|`S_OK` |The function returns on success.|
|`HRESULT`| Error code for failures to export the layer.|
|    |    |
