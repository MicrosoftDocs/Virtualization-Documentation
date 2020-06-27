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

|Parameter     |Description|
|---|---|
|`computeSystem`| Handle to the compute system to shut down|
|`operation`| Handle to the operation that tracks the shutdown operation|
|`options`| Optional JSON document specifying shutdown options|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HCS_E_OPERATION_PENDING`|Returned if shutting down the compute system was successfully initiated|
|`HCS_E_INVALID_STATE`|Returned if the compute system cannot be shut down in it's current state (i.e. if the system was not yet started or is currently paused)|
|`HRESULT`|Error code for failures to initiate the shutdown of the compute system|
|     |     |
