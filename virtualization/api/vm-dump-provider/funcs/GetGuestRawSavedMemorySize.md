# GetGuestRawSavedMemorySize
**Note: These APIs are publicly available as of Windows 1803 (10.0.17134.48). You can build your project against these APIs, but the DLL for linking is missing from the SDK. You should use the latest SDK and associated DLL released with Windows Insider to run your application**

## Syntax
```C
HRESULT 
WINAPI 
GetGuestRawSavedMemorySize( 
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle, 
    _Out_   UINT64*                         GuestRawSavedMemorySize 
    ); 
```
### Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`GuestRawSavedMemorySize`

Returns the size of the saved memory of a given guest in bytes.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Returns the size in bytes of the saved memory for a given VM saved state file.
