# HcsSignalProcess

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`process`| Handle to the process to send the signal to|
|`options`| JSON document specifying the detailed signal|
|    |    | 



## Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`result`| Optional, receives an error document on failures to send the signal. It is the caller's responsibility to release the returned buffer using `LocalFree`.|
|    |    | 

The function returns `S_OK` on success. `HRESULT` error code for failures to send the signal to the process.

## Remarks
This function sends a signal to a process in a compute system.