# ReleaseSavedStateFiles
**Note: These APIs are not yet publicly available and will be available in the latest release of the Windows SDK.**

## Syntax
```C
HRESULT 
WINAPI 
ReleaseSavedStateFiles( 
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle 
    );  
```
### Parameters

`VmSavedStateDumpHandle`

Supplies the ID of the dump provider instance to release.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Releases the given VmSavedStateDump provider that matches the supplied ID. Releasing the provider releases the locks to the saved state files. This means that it won't be available for use on other methods. 