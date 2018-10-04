# HcsCreateProcess

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`computeSystem`| Handle to the compute system in which to start the process|
|`processParameters`| JSON document specifiying the command line and environment for the process|
|`securityDescriptor`| Optional security descriptor specifying the permissions on the compute system process. If not specified, only the caller of the function is granted permissions to perform operations on the compute system process|
|    |    | 



## Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`processInformation`| Receives the information about the newly created process. It is the caller's responsibility to release the StdInput, StdOutput, and StdError handles returned in the structure using `CloseHandle`.|
|`process`| Receives the hangle to the newly created process|
|`result`| Optional, receives an error document on failures sto start the process. It is the caller's responsibility to release the return buffer using `LocalFree`|
|    |    | 

The function returns `S_OK` on success. `HRESULT` error code for failures to create the file.

## Remarks
This function starts a process in a compute system.