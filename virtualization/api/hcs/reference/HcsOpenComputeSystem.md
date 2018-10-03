# HcsOpenComputeSystem

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`id`| Unique Id identifying the compute system|
|`requestedAccess`| Specifies the required access to the compute system|
|`computeSystem`| Recieves a handle to the compute system. It is the responsibility of the caller to release the handle using `HcsCloseComputeSystem` once it is no longer in use.| 
|    |    | 



## Return Values
|Return | Description|
|---|---|
|`HCS_E_SYSTEM_NOT_FOUND`|Returns if a compute system with the specified Id does not exist|
|     |     |


## Remarks