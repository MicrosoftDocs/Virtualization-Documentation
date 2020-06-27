# HcsGetLayerVhdMountPath

## Description

Returns the volume path for a virtual disk of a writable container layer

## Syntax

```cpp
HRESULT WINAPI
HcsGetLayerVhdMountPath(
    _In_     HANDLE vhdHandle,
    _Outptr_ PWSTR* mountPath
    );
```

## Parameters

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`vhdHandle`| Handle to a VHD mounted on the host|
|`mountPath`| Receives the volume path for the layer. It is the caller's responsibility to release the returned string buffer using `LocalFree`.|
|    |    |

## Return Values

|Return Value     |Description|
|---|---|
|`S_OK` | The function returns on success.|
|`HRESULT`| Error code for failures to lookup the volume path.|
|    |    |
