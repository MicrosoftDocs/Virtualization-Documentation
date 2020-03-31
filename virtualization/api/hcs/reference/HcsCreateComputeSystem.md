# HcsCreateComputeSystem

## Description
Creates a new compute system

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`id`| Unique Id identifying the compute system|
|`configuration`| JSON document specifying the settings of the compute system|
|`operation`| Handle to the operation that tracks the create operation|
|`securityDescriptor`| Optional security descriptor specifying the permissions on the compute system. If not specified, only the caller of the function is granted permissions to perform operations on the compute system.|
|`computeSystem`| Receives a handle to the newly created compute system. It is the responsibility of the caller to release the handle using HcsCloseComputeSystem once it is no longer in use.| 
|    |    | 



### Return Values
|Return | Description|
|---|---|
|`HCS_E_OPERTATION_PENDING`|Returned if creating the compute system was successfully initiated|
|`HCS_E_SYSTEM_ALREADY_EXISTS`|Returned if a compute system with the specified unique Id already exists|
|`HCS_E_INVALID_JSON`|Returned if the specified settings document is invalid|
|`HRESULT`|Error code for failures to create the compute system|
|     |     |