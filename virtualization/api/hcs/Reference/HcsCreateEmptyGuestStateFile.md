# HcsCreateEmptyGuestStateFile
## Description
This function creates an empty guest-state file (.vmgs) for a VM. This file is required in cases where the VM  is expected to be persisted and restarted multiple times. It is configured in the ‘GuestState’ property of the settings document for a VM.

## Syntax

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`guestStateFilePath`| Full path to the guest-state file to create|
|    |    | 



### Return Values
The function returns `S_OK` on success. `HRESULT` error code for failures to create the file.


