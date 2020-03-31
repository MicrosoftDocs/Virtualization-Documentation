# HcsModifyServiceSettings

## Description
This function modifies the settings of the Host Compute System

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`settings`| JSON document specifying the new settings|
|    |    | 


### Return Values
|Return Values     |Description|
|---|---|---|---|---|---|---|---| 
|`result`| Optional, receives an error document on failures to apply the settings. It is the callers responsibility to release the returned buffer using `LocalFree`. |
|    |    | 

The function returns `S_OK` on success. `HRESULT` error code for failures to modify the settings.

