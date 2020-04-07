# HcsTerminateComputeSystem

## Description

Forcefully terminates a compute system

## Syntax

```cpp
HRESULT WINAPI
HcsTerminateComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`computeSystem`| Handle to the compute system to terminate|
|`operation`| Handle to the operation that tracks the terminate operation|
|`options`| Optional JSON document specifying terminate options|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HCS_E_OPERATION_PENDING`|Returned if terminating the compute system was successfully initiated|
|`HRESULT`|Error code for failures to terminate of the compute system.|
|     |     |
