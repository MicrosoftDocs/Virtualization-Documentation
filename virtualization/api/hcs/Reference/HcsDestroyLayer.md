# HcsDestroyLayer

## Description

Deletes a layer from the host.

## Syntax

```cpp
HRESULT WINAPI
HcsDestroyLayer(
    _In_ PCWSTR layerPath
    );
```

## Parameters

`layerPath`

Path of the layer to delete

## Return Values

The function returns [HRESULT](./HCSHResult.md)

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeStorage.h |
| **Library** | ComputeStorage.lib |
| **Dll** | ComputeStorage.dll |

## Remarks

This function deletes a layer from the host.
