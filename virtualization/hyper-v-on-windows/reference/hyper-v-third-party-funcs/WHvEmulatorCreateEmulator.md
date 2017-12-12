# WHvEmulatorCreateEmulator

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