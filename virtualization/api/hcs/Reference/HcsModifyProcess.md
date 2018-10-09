# HcsOpenProcess

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`process`| Handle to the process to modify|
|`settings`| Receives the new settings of the process|
|    |    | 



## Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`result`| Optional, receives an error document on failures to modify the process. It is the callers responsibility to release the returned buffer using `LocalFree`.|
|    |    | 

The function returns `S_OK` on success. `HRESULT` error code for failures to modify the process.

## Remarks
This function modifies the parameters of a process in a compute system.