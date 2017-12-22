# Windows Hypervisor Platform Instruction Emulator API Definitions and Support DLLs

**Note: These APIs are not yet publicly available and will be included in a future Windows release.**

Instruction emulation expects several higher-level abstractions at the interface between the accelerators and the device emulation that are not provided directly by the platform APIs. This functionality is provided by a separate DLL that builds these abstractions on top of the platform APIs.
 
## Instruction Emulation
Device emulation expects the platform to provide the details of an I/O access by a virtual processor. For an MMIO and string I/O port access this requires decoding and completing the instruction that issued the I/O access. 

|Structure   |Description|
|---|---|---|---|---|---|---|---|
|[MMIO Access](hypervisor-platform-funcs/MMIOAccessIE.md)|Instruction emulation expects this data for MMIO access|
|[I/O Port Access](hypervisor-platform-funcs/IOPortAccessIE.md)|Instruction emulation expects this data for port access|
|   |   |
 
## Virtual Processor Register State
Instruction emulation uses a fixed set of registers that are queried and set together if necessary. For X64, this set of registers include:
 
* RAX...R15, RIP, RFLAGS 
* CS, SS, DS, ES, FS, GS, LDT, TR, GDT, IDT 
* CR0, CR2, CR3, CR4 
* FPU: 
    * XMM0...15, FPMMX0...7 
    * FCW, FSW, FTW, FOP, FIP, FDP, MXCSR 
* MSRs: 
    * SYSENTER_CS, SYSENTER_ESP, SYSENTER_EIP, TSC 
    * EFER, STAR, LSTAR, CSTAR, FMASK, KERNELGSBASE 

This set of registers is provided using the [`WHvGetVirtualProcessorRegisters`](hypervisor-platform-funcs/WHvGetVirtualProcessorRegisters.md) and [`WHvSetVirtualProcessorRegisters`](hypervisor-platform-funcs/WHvSetVirtualProcessorRegisters.md) platform functions, keeping it in sync with the register state used by the instruction emulation.  

## Windows Hypervisor Platform Instruction Emulator API Reference

### Emulator Structures
|Structure   |Description|
|---|---|---|---|---|---|---|---|
|[`WHV_EMULATOR_CALLBACKS`](hypervisor-platform-funcs/WhvEmulatorCallbacks.md)|Used in [`WHvEmulatorCreateEmulator`](hypervisor-platform-funcs/WHvEmulatorCreateEmulator.md) to specify callback methods needed by the emulator.|
|[`WHV_EMULATOR_STATUS`](hypervisor-platform-funcs/WhvEmulatorStatus.md)|Describes extended return status information from a given emulation call.|
|[`WHV_EMULATOR_MEMORY_ACCESS_INFO`](hypervisor-platform-funcs/WhvEmulatorMemoryAccessInfo.md)|Information about the requested memory access by the emulator |
|[`WHV_EMULATOR_IO_ACCESS_INFO`](hypervisor-platform-funcs/WhvEmulatorIOAccessInfo.md)|Information about the requested Io Port access by the emulator|
|   |   |


## API Methods
|Methods   |Description|
|---|---|---|---|---|---|---|---|
|[WHvEmulatorCreateEmulator](hypervisor-platform-funcs/WHvEmulatorCreateEmulator.md)|Create an instance of the instruction emulator with the specified callback methods|
|[WHvEmulatorDestoryEmulator](hypervisor-platform-funcs/WHvEmulatorDestoryEmulator.md)|Destroy an instance of the instruction emulator created by [`WHvEmulatorCreateEmulator`](hypervisor-platform-funcs/WHvEmulatorCreateEmulator.md)|
|[WHvEmulatorTryIoEmulation and WHvEmulatorTryMmioEmulation](hypervisor-platform-funcs/WHvEmulatorTryEmulation.md)|Attempt to emulate a given type of instruction with the given instruction context returned by the WinHv APIs from a `RunVirtualProcessor` call. |
|   |   |




## Callback Functions
|Functions   |Description|
|---|---|---|---|---|---|---|---|
|[`WHV_EMULATOR_IO_PORT_CALLBACK`](hypervisor-platform-funcs/WHvEmulatorIOPortCallback.md)|Callback notifying the virtualization stack that the current instruction has modified the IO Port specified in the IoAccess structure|
|[`WHV_EMULATOR_MEMORY_CALLBACK`](hypervisor-platform-funcs/WHvEmulatorMemoryCallback.md)|Callback notifying the virtualization stack that the current instruction is attempting to accessing memory as specified in the MemoryAccess structure.|
|[`WHV_EMULATOR_GET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK`](hypervisor-platform-funcs/WHvEmulatorGetVirtualProcessorRegistersCallback.md)|Callback requesting VP register state, similar to the WinHv API|
|[`WHV_EMULATOR_SET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK`](hypervisor-platform-funcs/WHvEmulatorSetVirtualProcessorRegistersCallback.md)|Callback setting VP register state, similar to the WinHv API|
|[`WHV_EMULATOR_TRANSLATE_GVA_PAGE_CALLBACK`](hypervisor-platform-funcs/WHvEmulatorTranslateGVAPageCallback.md)|Callback requesting the virtualization stack to translate the Guest Virtual Address GvaPage that points to the start of a 4K page, with the specified TranslateFlags|
|   |   |


