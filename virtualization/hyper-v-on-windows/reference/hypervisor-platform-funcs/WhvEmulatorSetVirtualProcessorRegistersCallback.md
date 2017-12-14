# WHV_EMULATOR_SET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK
**Note: These APIs are not yet publically available and will be included in a future Windows release.  Subject to change.**

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