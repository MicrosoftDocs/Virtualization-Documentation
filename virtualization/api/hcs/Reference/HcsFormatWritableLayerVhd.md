# HcsFormatWritableLayerVhd

## Description

This function creates and formats a partition that is intended to be used as a writable layer for a container

## Syntax

```cpp
HRESULT WINAPI
HcsFormatWritableLayerVhd(
    _In_ HANDLE vhdHandle
    );
```

## Parameters

|Parameter     |Description|
|---|---|
|`vhdHandle`| Handle to a VHD|
|    |    |

## Return Values

|Return Value     |Description|
|---|---|
|`S_OK` | The function returns on success.|
|`HRESULT`| Error code for failures to initialize the VHD.|
|    |    |
