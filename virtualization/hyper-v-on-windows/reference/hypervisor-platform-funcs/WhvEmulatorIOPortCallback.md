# WHV_EMULATOR_IO_PORT_CALLBACK
**Note: These APIs are not yet publically available and will be included in a future Windows release..**

## Syntax

```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_IO_PORT_CALLBACK)(
    _In_ VOID* Context,
    _Inout_ WHV_EMULATOR_IO_ACCESS_INFO* IoAccess
    );
```

## Return Value
The callback should return `S_OK` on success, and some error value on failure. Any error value returned here will terminate emulation and return from the corresponding emulation call.

## Remarks
Callback notifying the virtualization stack that the current instruction has
modified the IO Port specified in the IoAccess structure. Context is the value
specified in the emulation call which identifies this current instance of the emulation.

