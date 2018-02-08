# GetRegisterValue
**Note: These APIs are not yet publicly available and will be available in the latest release of the Windows SDK.**

## Syntax
```C
HRESULT 
WINAPI 
GetRegisterValue( 
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle, 
    _In_    UINT32                          VpId, 
    _Inout_ VIRTUAL_PROCESSOR_REGISTER*     Register 
    ); 
```
### Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`VpId`

Supplies the Virtual Processor Id.

`Register`

Supplies an enumeration value with the register being queried. Returns the queried register value.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Remarks

Queries for a specific register value for a given VP in a VmSavedStateDump. Callers must specify architecture and register ID in paremeter Register, and this function returns the regsiter value through it. 