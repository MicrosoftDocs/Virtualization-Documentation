# HcsGrantVmAccess

## Description

This function adds a group of entries to a files ACL that grants access to the user account used to run the VM. 

## Syntax

```cpp
HRESULT WINAPI
HcsGrantVmAccess(
    _In_ PCWSTR filePath
    );
```

## Parameters

|Parameter     |Description|
|---|---|
|`filePath`| Path to the file for which to update the ACL|
|    |    |

## Return Values

|Return Value | Description|
|---|---|
|`S_OK`|The function returns on success.|
|`HRESULT` | error code for failures to grant VM access to user.|
|    |    |
