# HcsGetProcessProperties

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`process`| Handle to the process to query|
|    |    | 



## Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`properties`| Receives the properties of the process|
|`result`| Optional, receives an error document on failures to query the process. It is the callers responsibility to release the returned buffer using `LocalFree`. |
|    |    | 

The function returns `S_OK` on success. `HRESULT` error code for failures to query the process.

## Remarks
This function returns properties of a process in a compute system.