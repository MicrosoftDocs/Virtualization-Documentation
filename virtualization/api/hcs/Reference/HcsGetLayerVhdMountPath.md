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

`vhdHandle`

The handle to a VHD mounted on the host

`mountPath`

Receives the volume path for the layer. It is the caller's responsibility to release the returned string buffer using `LocalFree`.

## Return Values

The function returns [HRESULT](./HCSHResult.md), refering details in [asnyc model](./../AsyncModel.md#HcsOperationResult)

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeStorage.h |
| **Library** | ComputeStorage.lib |
| **Dll** | ComputeStorage.dll |
