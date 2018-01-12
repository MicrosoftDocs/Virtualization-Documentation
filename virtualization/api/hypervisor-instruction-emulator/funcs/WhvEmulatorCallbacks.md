# WHV_EMULATOR_CALLBACKS
**Note: These APIs are not yet publicly available and will be included in a future Windows release.**

## Syntax

```c
typedef struct _WHV_EMULATOR_CALLBACKS {
    WHV_EMULATOR_IO_PORT_CALLBACK WHvEmulatorIoPortCallback;
    WHV_EMULATOR_MEMORY_CALLBACK WHvEmulatorMemoryCallback;
    WHV_EMULATOR_GET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK       WHvEmulatorGetVirtualProcessorRegisters;
    WHV_EMULATOR_SET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK               WHvEmulatorSetVirtualProcessorRegisters;
    WHV_EMULATOR_TRANSLATE_GVA_PAGE_CALLBACK WHvEmulatorTranslateGvaPage;
} WHV_EMULATOR_CALLBACKS;
```
## Remarks
Used in [`WHvEmulatorCreateEmulator`](WHvEmulatorCreateEmulator.md) to specify callback methods needed by the emulator.
