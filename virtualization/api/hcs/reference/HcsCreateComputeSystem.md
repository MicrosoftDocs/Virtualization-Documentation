# HcsCreateComputeSystem

>**Note: This API will be released in a future Windows build.**

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`id`| Unique Id identifying the compute system|
|`configuration`| JSON document specifying the settings of the compute system|
|`securityDescriptor`| Optional security descriptor specifying the permissions on the compute system. If not specified, only the caller of the function is granted permissions to perform operations on the compute system.|
|`computeSystem`| Handle to the compute system to start| 
|    |    | 



## Return Values
|Return | Description|
|---|---|
|`HCS_E_OPERTATION_PENDING`|Returns if creating the compute system was successfully initiated|
|`HCS_E_SYSTEM_ALREADY_EXISTS`|Returns if a compute system with the specified unique Id already exists|
|`HCS_E_INVALID_JSON`|Returns if the specified settings document is invalid|
|     |     |



## Remarks