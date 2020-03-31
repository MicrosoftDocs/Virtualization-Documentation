# HcsSaveComputeSystem

## Description
Saves the state of a compute system

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`computeSystem`| Handle to the compute system to save|
|`operation`| Handle to the operation that tracks the save operation|
|`options`| Optional JSON document specifying save options| 
|    |    | 

### Return Values
|Return | Description|
|---|---|
|`HCS_E_OPERTATION_PENDING`|Returned if saving the compute system was successfully initiated|
|`HCS_E_INVALID_STATE`|Returned if the compute system cannot be saved in it's current state|
|`HRESULT`|Error code for failures to save the compute system|
|     |     |