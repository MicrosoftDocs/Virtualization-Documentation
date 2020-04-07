# HcsStartComputeSystem

## Description

Starts a compute system

## Syntax

```cpp
HRESULT WINAPI
HcsStartComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`computeSystem`| Handle to the compute system to start|
|`operation`| Handle to the operation that tracks the start operation|
|`options`| Optional JSON document specifying start options|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HCS_E_OPERATION_PENDING`|Returned if starting the compute system was successfully initiated|
|`HCS_E_INVALID_STATE`|Returned if the compute system cannot be started in it's current state (i.e. if the system has already started)|
|`HRESULT`|Error code for failures to initiate the start of the compute system|
|     |     |
