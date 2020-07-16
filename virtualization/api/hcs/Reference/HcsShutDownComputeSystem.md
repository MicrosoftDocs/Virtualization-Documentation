# HcsShutDownComputeSystem

## Description

Cleanly shuts down a compute system.

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

The handle to the compute system to shut down.

`operation`

The handle to the operation that tracks the shutdown operation.

`options`

Reserved for future use. Must be `NULL`.

## Return Values

The function returns [HRESULT](./HCSHResult.md), refer to [hcs operation async model](./../AsyncModel.md#HcsOperationResult).

## Remarks

If there is duplicate shutdown or terminate for same compute system, the return value of `HcsWaitForOperationResult` will be `HCS_E_SYSTEM_ALREADY_STOPPED`.


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
