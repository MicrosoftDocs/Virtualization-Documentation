# LoadSavedStateFiles function

Loads the given saved state files and creates an instance of VmSavedStateDump. This instance can be referenced on the other methods with the returned UINT64 Id.

## Syntax

```C
HRESULT
WINAPI
LoadSavedStateFiles(
    _In_    LPCWSTR                         BinFile,
    _In_    LPCWSTR                         VsvFile,
    _Out_   VM_SAVED_STATE_DUMP_HANDLE*     VmSavedStateDumpHandle
    );
```

## Parameters

`BinFile`

Supplies the path to the BIN file to load.

`VsvFile`

Supplies the path to the VSV file to load.

`VmSavedStateDumpHandle`

Returns the ID for the dump provider instance created.

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