# LoadSavedStateFiles
**Note: These APIs are not yet publicly available and will be available in the latest release of the Windows SDK.**

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
### Parameters

`BinFile`

Supplies the path to the BIN file to load.

`VsvFile`

Supplies the path to the VSV file to load.

`VmSavedStateDumpHandle`

Returns the ID for the dump provider instance created.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Loads the given saved state files and creates an instance of VmSavedStateDump. This instance can be referenced on the other methods with the returned UINT64 Id. 