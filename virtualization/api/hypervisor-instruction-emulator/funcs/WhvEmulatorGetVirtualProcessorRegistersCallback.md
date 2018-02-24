# WHV_EMULATOR_GET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK
**Note: A prerelease of this API is available starting in the Windows Insiders Preview Build 17083**

## Syntax

```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_GET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK)(
    _In_ VOID* Context,
    _In_reads_(RegisterCount) const WHV_REGISTER_NAME* RegisterNames,
    _In_ UINT32 RegisterCount,
    _Out_writes_(RegisterCount) WHV_REGISTER_VALUE* RegisterValues
);
```

## Remarks
Callback requesting VP register state, similar to the WinHv API