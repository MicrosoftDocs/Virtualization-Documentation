---
title: WHV_EMULATOR_CALLBACKS method
description: Learn about the WHV_EMULATOR_CALLBACKS method. 
author: sethmanheim
ms.author: sethm
ms.date: 04/19/2022
---

# WHV_EMULATOR_CALLBACKS


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
Used in [`WHvTranslateGva`](/virtualization/api/hypervisor-platform/funcs/WHvTranslateGva) to specify callback methods needed by the emulator.
