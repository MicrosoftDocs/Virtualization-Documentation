# HcsOpenProcess

## Description
Opens an existing process in a compute system

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`computeSystem`| Handle to the compute system in which to start the process|
|`processId`| Specifies the Id of the process to open|
|`requestedAccess`| Specifies the required access to the compute system|
|`process`| Receives the handle to the process|
|    |    | 


### Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`S_OK`| Returned on success|
|`HRESULT`|Error code for failures to open the process|
|    |    | 
