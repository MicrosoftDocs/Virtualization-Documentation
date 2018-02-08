# GetGuestRawSavedMemorySize
**Note: These APIs are not yet publicly available and will be available in the latest release of the Windows SDK.**

## Syntax
```C
HRESULT 
WINAPI 
GetGuestRawSavedMemorySize( 
    _In_        VM_SAVED_STATE_DUMP_HANDLE  VmSavedStateDumpHandle, 
    _In_        UINT64                      RawSavedMemoryOffset, 
    _Out_writes_bytes_(BufferSize) LPVOID   Buffer, 
    _In_        UINT32                      BufferSize, 
    _Out_opt_   UINT32*                     BytesRead 
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