# HcsGrantVmAccess

## Description
This function adds an entry to a files ACL that grants access to the user account used to run the VM. The user account is based on an internal GUID that is derived from the compute system ID of the VM’s HCS compute system object.


## Syntax
```C
HRESULT WINAPI
HcsGrantVmAccess(
    _In_ PCWSTR vmId,
    _In_ PCWSTR filePath
    );

```
### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`vmId`| Unique Id of the VM's compute system|
|`filePath`| Path to teh file for which to update the ACL|
|    |    | 

### Return Values
The function returns `S_OK` on success. `HRESULT` error code for failures to grant VM access to user.
