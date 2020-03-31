# HcsSignalProcess

## Description
Sends a signal to a process in a compute system

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`process`| Handle to the process to send the signal to|
|`operation`| Handle to the operation that tracks the signal|
|`options`| Optional JSON document specifying the detailed signal|
|    |    | 



### Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`S_OK`|Returned on success|
|`HRESULT`|Error code for failures to send the signal to the process|
|    |    | 
