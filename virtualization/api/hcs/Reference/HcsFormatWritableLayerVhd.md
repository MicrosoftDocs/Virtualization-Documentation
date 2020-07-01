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

`vhdHandle`

The handle to a VHD

## Return Values

The function returns [HRESULT](https://docs.microsoft.com/en-us/windows/win32/seccrypto/common-hresult-values)

If the operation completes successfully, the return value is `S_OK`.

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeStorage.h |
| **Library** | ComputeStorage.lib |
| **Dll** | ComputeStorage.dll |

