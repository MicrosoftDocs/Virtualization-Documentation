# GuestVirtualAddressToPhysicalAddress
**Note: These APIs are publicly available as of Windows 1803 (10.0.17134.48). You can build your project against these APIs, but the DLL for linking is missing from the SDK. You should use the latest SDK and associated DLL released with Windows Insider to run your application**

## Syntax
```C
HRESULT 
WINAPI 
GuestVirtualAddressToPhysicalAddress( 
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle, 
    _In_    UINT32                          VpId, 
    _In_    const GUEST_VIRTUAL_ADDRESS     VirtualAddress, 
    _Out_   GUEST_PHYSICAL_ADDRESS*         PhysicalAddress 
    ); 
```
### Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance. 

`VpId`

Supplies the VP from where the virtual address is read.

`VirtualAddress`

Supplies the virtual address to translate.

`PhysicalAddress`

Returns the physical address assigned to the supplied virtual address. 

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Translates a virtual address to a pysical address using information found in the guest's memory and processor's state. 