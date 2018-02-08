# GetArchitecture
**Note: These APIs are not yet publicly available and will be available in the latest release of the Windows SDK.**

## Syntax
```C
HRESULT 
WINAPI 
GetArchitecture( 
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle, 
    _In_    UINT32                          VpId, 
    _Out_   VIRTUAL_PROCESSOR_ARCH*         Architecture 
    ); 
```
### Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`VpId`

Supplies the VP to query.

`Architecture`

Returns the architecture of the supplied vp.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Queries for the current Architecture/ISA the virtual processor was running at the time the saved state file was generated. 