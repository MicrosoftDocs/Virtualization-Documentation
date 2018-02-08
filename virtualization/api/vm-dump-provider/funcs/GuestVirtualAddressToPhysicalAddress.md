# GuestVirtualAddressToPhysicalAddress
**Note: These APIs are not yet publicly available and will be available in the latest release of the Windows SDK.**

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