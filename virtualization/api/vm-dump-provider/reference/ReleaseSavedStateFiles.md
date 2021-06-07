# ReleaseSavedStateFiles function

Releases the given VmSavedStateDump provider that matches the supplied ID. Releasing the provider releases the locks to the saved state files. This means that it won't be available for use on other methods.

## Syntax
```C

HRESULT
WINAPI
ReleaseSavedStateFiles(
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle
    );
```

## Parameters

`VmSavedStateDumpHandle`

Supplies the ID of the dump provider instance to release.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Requirements

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    |