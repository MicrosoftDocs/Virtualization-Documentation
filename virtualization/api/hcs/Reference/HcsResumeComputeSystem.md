# HcsResumeComputeSystem

## Description
Resumes the execution of a compute system

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`computeSystem`| Handle to the compute system to resume|
|`operation`| Handle to the operation that tracks the resume operation|
|`options`| Optional JSON document specifying resume options| 
|    |    | 

### Return Values
|Return | Description|
|---|---|
|`HCS_E_OPERTATION_PENDING`|Returned if resuming the compute system was successfully initiated|
|`HCS_E_INVALID_STATE`|Returned if the compute system cannot be resumed in it's current state|
|`HRESULT`|Error code for failures to pause the compute system.|
|     |     |