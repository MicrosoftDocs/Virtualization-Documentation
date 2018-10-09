# HcsGetProcessInfo

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`process`| Handle to the process to query|
|    |    | 



## Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`processInformation`| Receives the startup information about the process. It is the caller's responsibility to release the `StdInput`, `StdOutput`, and `StdError` handles returned in the structure using `CloseHandle`.|
|`result`| Optional, receives an error document on failures to get the process info. It is the callers responsibility to release the returned buffer using `LocalFree`. |
|    |    | 

The function returns `S_OK` on success. `HRESULT` error code for failures to get the process information.

## Remarks
This function returns the initial startup information of a process in a compute system.