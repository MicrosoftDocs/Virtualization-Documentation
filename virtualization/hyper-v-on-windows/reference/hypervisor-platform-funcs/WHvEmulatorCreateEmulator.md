# WHvEmulatorCreateEmulator
**Note: These APIs are not yet publically available and will be included in a future Windows release.  Subject to change.**

## Syntax

```c
HRESULT
WINAPI
WHvEmulatorCreateEmulator(
    _In_ WHV_EMULATOR_CALLBACKS Callbacks,
    _Out_ WHV_EMULATOR_HANDLE* Emulator
    );
```
## Remarks
Create an instance of the instruction emulator with the specified callback methods