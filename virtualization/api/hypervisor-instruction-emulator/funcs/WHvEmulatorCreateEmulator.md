# WHvEmulatorCreateEmulator


## Syntax

```c
HRESULT
WINAPI
WHvEmulatorCreateEmulator(
    _In_ const WHV_EMULATOR_CALLBACKS* Callbacks,
    _Out_ WHV_EMULATOR_HANDLE* Emulator
    );
```
### Parameters

`Callbacks`

The specified callback method

`Emulator`

Receives the handle to the newly created emulator instance

## Remarks
Create an instance of the instruction emulator with the specified callback methods

