# GetRegisterValue
**Note: These APIs are publicly available as of Windows 1803 (10.0.17134.48). You can build your project against these APIs, but the DLL for linking is missing from the SDK. You should use the latest SDK and associated DLL released with Windows Insider to run your application**

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