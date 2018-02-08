# LoadSavedStateFile
**Note: These APIs are not yet publicly available and will be available in the latest release of the Windows SDK.**

## Syntax
```C
HRESULT 
WINAPI 
LoadSavedStateFile( 
    _In_    LPCWSTR                         VmrsFile, 
    _Out_   VM_SAVED_STATE_DUMP_HANDLE*     VmSavedStateDumpHandle 
    ); 
```
### Parameters

`VmrsFile`

Supplies the path to the VMRS file whose any pending replay log will be applied.

`VmSavedStateDumpHandle`

Returns a Handle to the dump provider instance created. 

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Loads the given saved state file and creates an instance of VmSavedStateDump. This instance can be referenced on the other methods with the returned UINT64 Id. 