# WHV_EMULATOR_CALLBACKS
**Note: A prerelease of this API is available starting in the Insiders Preview Build 17083**

## Syntax

```c
typedef struct _WHV_EMULATOR_CALLBACKS {
    UINT32 Size;
    UINT32 Reserved;
    WHV_EMULATOR_IO_PORT_CALLBACK WHvEmulatorIoPortCallback;
    WHV_EMULATOR_MEMORY_CALLBACK WHvEmulatorMemoryCallback;
    WHV_EMULATOR_GET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK       WHvEmulatorGetVirtualProcessorRegisters;
    WHV_EMULATOR_SET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK               WHvEmulatorSetVirtualProcessorRegisters;
    WHV_EMULATOR_TRANSLATE_GVA_PAGE_CALLBACK WHvEmulatorTranslateGvaPage;
} WHV_EMULATOR_CALLBACKS;
```
## Remarks
Used in [`WHvTranslateGva`](/virtualization/api/hypervisor-platform/funcs/WHvTranslateGva.md) to specify callback methods needed by the emulator.
