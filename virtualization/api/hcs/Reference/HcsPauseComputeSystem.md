# HcsPauseComputeSystem

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`computeSystem`| Handle to the compute system to pause|
|`operation`| Handle to the operation that tracks the pause operation|
|`options`| Optional JSON document specifying pause options| 
|    |    | 

## Return Values
|Return | Description|
|---|---|
|`HCS_E_OPERTATION_PENDING`|Returns if pausing the compute system was successfully initiated|
|`HCS_E_INVALID_STATE`|Returns if the compute system cannot be paused in it's current state|
|     |     |

`HRESULT` error code for failures to pause the compute system.

## Remarks