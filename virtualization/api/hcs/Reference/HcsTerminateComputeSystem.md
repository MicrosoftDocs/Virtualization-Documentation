# HcsTerminateComputeSystem

## Description
Forcefully terminates a compute system

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`computeSystem`| Handle to the compute system to terminate|
|`operation`| Handle to the operation that tracks the terminate operation|
|`options`| Optional JSON document specifying terminate options| 
|    |    | 

### Return Values
|Return | Description|
|---|---|
|`HCS_E_OPERTATION_PENDING`|Returned if terminating the compute system was successfully initiated|
|`HRESULT`|Error code for failures to terminate of the compute system.|
|     |     |