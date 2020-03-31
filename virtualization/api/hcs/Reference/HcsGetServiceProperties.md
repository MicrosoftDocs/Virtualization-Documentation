# HcsGetServiceProperties

## Description
This function returns properties of the Host Compute System

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`propertyQuery`| Optional JSON document specifying the properties to query|
|    |    | 



### Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`result`| Optional, receives an error document on failures to query the properties. It is the callers responsibility to release the returned buffer using `LocalFree`. |
|    |    | 

The function returns `S_OK` on success. `HRESULT` error code for failures to query the properties.
