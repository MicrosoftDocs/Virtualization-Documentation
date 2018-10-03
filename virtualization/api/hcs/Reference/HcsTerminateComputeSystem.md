# HcsTerminateComputeSystem

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`computeSystem`| Handle to the compute system to terminate|
|`operation`| Handle to the operation that tracks the terminate operation|
|`options`| Optional JSON document specifying terminate options| 
|    |    | 

## Return Values
|Return | Description|
|---|---|
|`HCS_E_OPERTATION_PENDING`|Returns if terminating the compute system was successfully initiated|
|     |     |

`HRESULT` error code for failures to terminate of the compute system.

## Remarks