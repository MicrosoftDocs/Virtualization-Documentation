# HcsGetServiceProperties

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`propertyQuery`| JSON document specifying the properties to query|
|    |    | 



## Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`properties`| Receives a JSON document with the requested properties|
|`result`| Optional, receives an error document on failures to query the properties. It is the callers responsibility to release the returned buffer using `LocalFree`. |
|    |    | 

The function returns `S_OK` on success. `HRESULT` error code for failures to query the properties.

## Remarks
This function returns properties of the Host Compute System