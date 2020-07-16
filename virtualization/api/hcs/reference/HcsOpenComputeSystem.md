# HcsOpenComputeSystem

## Description

Opens a handle to an existing compute system, see [sample code](./ComputeSystemSample.md#OpenGetPropVM).

## Syntax

```cpp
HRESULT WINAPI
HcsOpenComputeSystem(
    _In_  PCWSTR id,
    _In_  DWORD requestedAccess,
    _Out_ HCS_SYSTEM* computeSystem
    );
```

## Parameters

`id`

Unique Id identifying the compute system.

`requestedAccess`

Reserved for future use, must be `GENERIC_ALL`.

`computeSystem`

Receives a handle to the compute system. It is the responsibility of the caller to release the handle using [HcsCloseComputeSystem](./HcsCloseComputeSystem.md) once it is no longer in use.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
