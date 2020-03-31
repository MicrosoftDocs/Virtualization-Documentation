# HcsRevokeVmAccess

## Description
This function removes the entry in the ACL of a file that granted access to the file for the user account used to run the VM.

## Syntax
```C
HRESULT WINAPI
HcsRevokeVmAccess(
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
The function returns `S_OK` on success. `HRESULT` error code for failures to create the file.
