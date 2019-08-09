# WHvEmulatorDestoryEmulator


## Syntax

```c
HRESULT
WINAPI
WHvEmulatorDestoryEmulator(
    _In_ WHV_EMULATOR_HANDLE Emulator
    );
```
### Parameters

`Partition`

Handle to the emulator instance that is destroyed.

## Remarks
Destroy an instance of the instruction emulator created by [`WHvEmulatorCreateEmulator`](WHvEmulatorCreateEmulator.md)