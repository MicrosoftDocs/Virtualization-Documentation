# HcsTerminateProcess

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`process`| Handle to the process to terminate|
|    |    | 



## Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`result`| Optional, receives an error document on failures to terminate the process. It is the caller's responsiblity to release the returned buffer using `LocalFree`. |
|    |    | 

The function returns `S_OK` on success. `HRESULT` error code for failures to terminate the process.

## Remarks
This function terminates a process in a compute system.