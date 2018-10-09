# HcsRegisterProcessCallback

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`process`| Handle to the process for that the callback is registered|
|`callback`| Callback function that is invoked for events on the process|
|`context`| Opaque pointer that is passed to the callback function|
|    |    | 



## Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`callbackHandle`| Handle to the registered callback|
|    |    | 

The function returns `S_OK` on success. `HRESULT` error code for failures to register the callback.

## Remarks
This function registers a callback function to receive events for a process in a compute system.