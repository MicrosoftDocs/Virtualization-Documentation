# GetVpCount
**Note: These APIs are publicly available as of Windows 1803 (10.0.17134.48). You can build your project against these APIs, but the DLL for linking is missing from the SDK. You should use the latest SDK and associated DLL released with Windows Insider to run your application**

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