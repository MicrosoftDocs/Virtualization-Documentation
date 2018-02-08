# GetVpCount
**Note: These APIs are not yet publicly available and will be available in the latest release of the Windows SDK.**

## Syntax
```C
HRESULT 
WINAPI 
GetVpCount( 
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle, 
    _Out_   UINT32*                         VpCount 
    ); 
```
### Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`VpCount`

Returns the Virtual Processor count.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Queries for the Virtual Processor count for a given VmSavedStateDump. 