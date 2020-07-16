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

`layerPath`

Destination path for the container layer.

`sourceFolderPath`

Source path that contains the downloaded layer files.

`layerData`

JSON document of [layerData](./../SchemaReference.md#LayerData) providing the locations of the antecedent layers that are used by the imported layer.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeStorage.h |
| **Library** | ComputeStorage.lib |
| **Dll** | ComputeStorage.dll |
