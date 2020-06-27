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

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`layerPath`| Path of the layer to delete|
|    |    |

## Return Values

|Return Value     |Description|
|---|---|
|`S_OK` |The function returns on success.|
|`HRESULT`| Error code for failures to delete the layer.|
|    |    |

## Remarks

This function deletes a layer from the host.
