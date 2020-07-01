# HcsInitializeWritableLayer

## Description

This function initializes the writable layer for a container (e.g. the layer that captures the filesystem and registry changes caused by executing the container).

## Syntax

```cpp
HRESULT WINAPI
HcsInitializeWritableLayer(
    _In_ PCWSTR writableLayerPath,
    _In_ PCWSTR layerData,
    _In_opt_ PCWSTR options
    );
```

## Parameters

`writableLayerPath`

Full path to the root directory of the writable layer

`layerData`

JSON document providing the locations of the antecedent layers that are used by teh writable layer

`options`

Optional JSON document specifying the options for how to initialize the sandbox (e.g. which filesystem paths should be pre-expanded in the sandbox)

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
