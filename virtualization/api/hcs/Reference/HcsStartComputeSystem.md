# HcsStartComputeSystem

>**Note: This API will be released in a future Windows build.**

## Syntax

### Parameters
`computeSystem`

Handle to the compute system to start

`operation`

Handle to the operation that tracks the start operation

`options`

Optional JSON document specifying start options

## Return Values
If starting the compute system was successfully initiated, the return value is `HCS_E_OPERTATION_PENDING`. 

The function returns `HCS_E_INVALID_STATE` if the compute system cannot be started in its current state (i.e. if the system has already started). 

`HRESULT` error code for failures to initiate the start of the compute system.

## Remarks