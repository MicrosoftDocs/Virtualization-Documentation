# HcsGetComputeSystemProperties

## Description
Returns properties of a compute system

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`computeSystem`| Handle to the compute system to query|
|`operation`| Handle to the operation that tracks the query operation|
|`propertyQuery`| Optional JSON document specifying the properties to query| 
|    |    | 

### Return Values
|Return | Description|
|---|---|
|`HCS_E_OPERTATION_PENDING`|Returns if querying the compute system was successfully initiated|
|`HRESULT`|Error code for failures to query the compute system|
|     |     |