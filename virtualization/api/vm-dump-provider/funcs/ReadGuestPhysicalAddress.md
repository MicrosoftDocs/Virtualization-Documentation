# ReadGuestPhysicalAddress
**Note: These APIs are publicly available as of Windows 1803 (10.0.17134.48). You can build your project against these APIs, but the DLL for linking is missing from the SDK. You should use the latest SDK and associated DLL released with Windows Insider to run your application**

## Syntax
```C
HRESULT 
WINAPI 
ReadGuestPhysicalAddress( 
    _In_        VM_SAVED_STATE_DUMP_HANDLE  VmSavedStateDumpHandle, 
    _In_        GUEST_PHYSICAL_ADDRESS      PhysicalAddress, 
    _Out_writes_bytes_(BufferSize) LPVOID   Buffer, 
    _In_        UINT32                      BufferSize, 
    _Out_opt_   UINT32*                     BytesRead 
    ); 
```
### Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`PhysicalAddress`

Supplies the physical address to read.

`Buffer`

Returns the read memory range on the given address.

`BufferSize`

Supplies the requested byte count to read.

`BytesRead`

Optionally returns the bytes actually read

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Reads from the saved state file the given guest physical address range and then it is written into the supplied buffer. If BytesRead returns something lower than BufferSize, then the end of memory has been reached. 