# WHvEmulatorCreateEmulator
**Note: These APIs are not yet publicly available and will be included in a future Windows release.**

## Syntax

```c
HRESULT
WINAPI
WHvEmulatorCreateEmulator(
    _In_ WHV_EMULATOR_CALLBACKS Callbacks,
    _Out_ WHV_EMULATOR_HANDLE* Emulator
    );
```
### Parameters

`Callback`

The specified callback method

`Emulator`

Receives the handle to the newly created emulator instance

## Remarks
Create an instance of the instruction emulator with the specified callback methods

