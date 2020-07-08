# HcsShutDownComputeSystem

## Description

Cleanly shuts down a compute system

## Syntax

```cpp
HRESULT WINAPI
HcsShutDownComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

`computeSystem`

The handle to the compute system to shut down

`operation`

The handle to the operation that tracks the shutdown operation

`options`

Reserved for future use. Must be `NULL`.

## Return Values

The function returns [HRESULT](https://docs.microsoft.com/en-us/windows/win32/seccrypto/common-hresult-values)

If the operation completes successfully, the return value is `S_OK`.

If  the compute system cannot be shut down in it's current state (i.e. if the system was not yet started or is currently paused), the return value is `HCS_E_INVALID_STATE`.

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
