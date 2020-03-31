# HcsTerminateProcess

## Description
Terminates a process in a compute system

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`process`| Handle to the process to terminate|
|`operation`| Handle to the operation tracking the terminate operation|
|`options`|Optional JSON document specifying terminate options|
|    |    | 



### Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`S_OK`| Returned on success|
|`HRESULT`|Error code for failures to terminate the process|
|    |    | 
