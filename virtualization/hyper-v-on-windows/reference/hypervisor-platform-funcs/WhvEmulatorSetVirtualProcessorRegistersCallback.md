# WHV_EMULATOR_SET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK
## Syntax

```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_SET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK)(
    _In_ VOID* Context,
    _In_reads_(RegisterCount) const WHV_REGISTER_NAME* RegisterNames,
    _In_ UINT32 RegisterCount,
    _In_reads_(RegisterCount) const WHV_REGISTER_VALUE* RegisterValues
    );
```

## Remarks
Callback setting VP register state, similar to the WinHv API. This will only
be called right before a successful emulation call is about to return.