# HcsOpenProcess

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`computeSystem`| Handle to the compute system in which to start the process|
|`processId`| Specifies the Id of the process to open|
|`requestedAccess`| Specifies the required access to the compute system|
|    |    | 



## Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`process`| Receives the hangle to the newly created process|
|    |    | 

The function returns `S_OK` on success. `HRESULT` error code for failures to open the process.

## Remarks
This function opens an existing process in a compute system.