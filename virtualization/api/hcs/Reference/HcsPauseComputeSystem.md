# HcsPauseComputeSystem

## Description
Pauses the execution of a compute system

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`computeSystem`| Handle to the compute system to pause|
|`operation`| Handle to the operation that tracks the pause operation|
|`options`| Optional JSON document specifying pause options| 
|    |    | 

### Return Values
|Return | Description|
|---|---|
|`HCS_E_OPERTATION_PENDING`|Returned if pausing the compute system was successfully initiated|
|`HCS_E_INVALID_STATE`|Returned if the compute system cannot be paused in it's current state|
|`HRESULT`|Error code for failures to pause the compute system.|
|     |     |