# HcsResumeComputeSystem

## Description

Resumes the execution of a compute system

## Syntax

```cpp
HRESULT WINAPI
HcsResumeComputeSystem(
    _In_ HCS_SYSTEM computeSystem,
    _In_ HCS_OPERATION operation,
    _In_opt_ PCWSTR options
    );
```

## Parameters

|Parameter     |Description|
|---|---|---|---|---|---|---|---|
|`computeSystem`| Handle to the compute system to resume|
|`operation`| Handle to the operation that tracks the resume operation|
|`options`| Optional JSON document specifying resume options|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`HCS_E_OPERATION_PENDING`|Returned if resuming the compute system was successfully initiated|
|`HCS_E_INVALID_STATE`|Returned if the compute system cannot be resumed in it's current state|
|`HRESULT`|Error code for failures to pause the compute system.|
|     |     |
