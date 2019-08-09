# GetArchitecture
**Note: These APIs are publicly available as of Windows 1803 (10.0.17134.48). You can build your project against these APIs, but the DLL for linking is missing from the SDK. You should use the latest SDK and associated DLL released with Windows Insider to run your application**

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