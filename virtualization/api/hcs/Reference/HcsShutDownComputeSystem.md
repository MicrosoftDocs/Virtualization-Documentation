# HcsShutDownComputeSystem

>**Note: This API will be released in a future Windows build.**

## Syntax

### Parameters
`computeSystem`

Handle to the compute system to shut down

`operation`

Handle to the operation that tracks the shutdown operation

`options`

Optional JSON document specifying shutdown options

## Return Values
If shutting down the compute system is successfully initiated, the return value is `HCS_E_OPERTATION_PENDING`. 

The function returns `HCS_E_INVALID_STATE` if the compute system cannot be shut down in its current state (i.e. if the system has already started). 

`HRESULT` error code for failures to initiate the shutdown of the compute system.

## Remarks