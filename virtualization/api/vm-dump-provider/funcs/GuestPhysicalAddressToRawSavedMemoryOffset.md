# GuestPhysicalAddressToRawSavedMemoryOffset
**Note: These APIs are publicly available as of Windows 1803 (10.0.17134.48). You can build your project against these APIs, but the DLL for linking is missing from the SDK. You should use the latest SDK and associated DLL released with Windows Insider to run your application**

## Syntax
```C
HRESULT 
WINAPI 
GuestPhysicalAddressToRawSavedMemoryOffset( 
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle, 
    _In_    GUEST_PHYSICAL_ADDRESS          PhysicalAddress, 
    _Out_   UINT64*                         RawSavedMemoryOffset 
    ); 
```
### Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`PhysicalAddress`

Supplies the guest physical address to translate.

`RawSavedMemoryOffset`

Returns the raw saved memory offset for a given physical address.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Translates the given guest physical address to a raw saved memory offset. This is specially useful if callers need to read a memory range directly from all of the guest's saved memory starting in the saved memory address equivalent to the supplied guest physical address. Translation from raw saved memory offset to physical address is not supported. 