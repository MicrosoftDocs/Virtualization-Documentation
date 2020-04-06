# HcsCreateEmptyGuestStateFile
## Description
This function creates an empty guest-state file (.vmgs) for a VM. This file is required in cases where the VM  is expected to be persisted and restarted multiple times. It is configured in the 'GuestState' property of the settings document for a VM.

## Syntax

```cpp
HRESULT
WINAPI
HcsCreateEmptyRuntimeStateFile(
    _In_ PCWSTR runtimeStateFilePath
    );
```

### Parameters
|Parameter     |Description|
|---|---|---|---|---|---|---|---| 
|`guestStateFilePath`| Full path to the guest-state file to create|
|    |    | 



### Return Values
|Return Value     |Description|
|---|---|---|---|---|---|---|---|
|``S_OK``|The function returns on success.|
|`HRESULT`|Returns error code for failures to create the file.|
|     |     | 

