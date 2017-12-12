# Hyper-V Instruction Emulator API Definitions and Support DLL for QEMU
QEMU expects several higher-level abstractions at the interface between the accelerators and the device emulation that are not provided directly by the platform APIs. This functionality is provided by a separate DLL that builds these abstractions on top of the platform APIs.
 
## Instruction Emulation
For its device emulation, QEMU expects the platform to provide the details of an I/O access by a virtual processor. For an MMIO and string I/O port access this requires decoding and completing the instruction that issued the I/O access. 

|Structure   |Description|
|---|---|---|---|---|---|---|---|
|[MMIO Access](hyper-v-third-party-funcs/MMIOAccessQEMU.md)|QEMU expects this data for MMIO access|
|[I/O Port Access](hyper-v-third-party-funcs/IOPortAccessQEMU.md)|QEMU expects this data for port access|
|   |   |
 
## Virtual Processor Register State
QEMU uses a fixed set of registers that are queried and set together if necessary. For X64, this set of registers include:
 
* RAX...R15, RIP, RFLAGS 
* CS, SS, DS, ES, FS, GS, LDT, TR, GDT, IDT 
* CR0, CR2, CR3, CR4 
* FPU: 
    * XMM0...15, FPMMX0...7 
    * FCW, FSW, FTW, FOP, FIP, FDP, MXCSR 
* MSRs: 
    * SYSENTER_CS, SYSENTER_ESP, SYSENTER_EIP, TSC 
    * EFER, STAR, LSTAR, CSTAR, FMASK, KERNELGSBASE 

This set of registers is provided using the [`WHvGetVirtualProcessorRegisters`](hyper-v-third-party-funcs/WHvGetVirtualProcessorRegisters.md) and [`WHvSetVirtualProcessorRegisters`](hyper-v-third-party-funcs/WHvSetVirtualProcessorRegisters.md) platform functions, keeping it in sync with the register state used by the instruction emulation.  

## Hyper-V Instruction Emulator API Reference

### Emulator Structures
|Structure   |Description|
|---|---|---|---|---|---|---|---|
|[`WHV_EMULATOR_CALLBACKS`](hyper-v-third-party-funcs/WhvEmulatorCallbacks.md)|Used in `WHvEmulatorCreateEmulator` to specify callback methods needed by the emulator.|
|[`WHV_EMULATOR_STATUS`](hyper-v-third-party-funcs/WhvEmulatorStatus.md)|Describes extended return status information from a given emulation call.|
|[`WHV_EMULATOR_MEMORY_ACCESS_INFO`](hyper-v-third-party-funcs/WhvEmulatorMemoryAccessInfo.md)|Information about the requested memory access by the emulator |
|[`WHV_EMULATOR_IO_ACCESS_INFO`](hyper-v-third-party-funcs/WhvEmulatorIOAccessInfo.md)|Information about the requested Io Port access by the emulator|
|   |   |


## API Methods
|Methods   |Description|
|---|---|---|---|---|---|---|---|
|[WHvEmulatorCreateEmulator](hyper-v-third-party-funcs/WHvEmulatorCreateEmulator.md)|Create an instance of the instruction emulator with the specified callback methods|
|[WHvEmulatorDestoryEmulator](hyper-v-third-party-funcs/WHvEmulatorDestoryEmulator.md)|Destroy an instance of the instruction emulator created by [`WHvEmulatorCreateEmulator`](hyper-v-third-party-funcs/WHvEmulatorCreateEmulator.md)|
|[`WHvEmulatorTryIoEmulation` and `WHvEmulatorTryMmioEmulation`](hyper-v-third-party-funcs/WHvEmulatorTryEmulation.md)|Attempt to emulate a given type of instruction with the given instruction context returned by the WinHv APIs from a `RunVirtualProcessor` call. |
|   |   |




## Callback Functions

### Io Port Callback
```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_IO_PORT_CALLBACK)(
    _In_ VOID* Context,
    _Inout_ WHV_EMULATOR_IO_ACCESS_INFO* IoAccess
    );
```
Callback notifying the virtualization stack that the current instruction has
modified the IO Port specified in the IoAccess structure. Context is the value
specified in the emulation call which identifies this current instance of the emulation.
The callback should return S_OK on success, and some error value on failure. Any error value returned here will terminate emulation and return from the corresponding emulation call.

### Memory Callback
```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_MEMORY_CALLBACK)(
    _In_ VOID* Context,
    _Inout_ WHV_EMULATOR_MEMORY_ACCESS_INFO* MemoryAccess
    );
```
Callback notifying the virtualization stack that the current instruction is attempting
to accessing memory as specified in the MemoryAccess structure.

**NOTE:** As mentioned above, since in x86/AMD64 it is legal to do unaligned memory accesses, a memory access spanning a page boundary ie:

`movq [0xffe], rax `

This would cause two different memory callbacks to be invoked, one for two bytes, and one for 6 bytes.

### Get Virtual Processor Registers Callback
```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_GET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK)(
    _In_ VOID* Context,
    _In_reads_(RegisterCount) const WHV_REGISTER_NAME* RegisterNames,
    _In_ UINT32 RegisterCount,
    _Out_writes_(RegisterCount) WHV_REGISTER_VALUE* RegisterValues
    );
```
Callback requesting VP register state, similar to the WinHv API.

### Set Virtual Processor Registers Callback
```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_SET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK)(
    _In_ VOID* Context,
    _In_reads_(RegisterCount) const WHV_REGISTER_NAME* RegisterNames,
    _In_ UINT32 RegisterCount,
    _In_reads_(RegisterCount) const WHV_REGISTER_VALUE* RegisterValues
    );
```
Callback setting VP register state, similar to the WinHv API. This will only
be called right before a successful emulation call is about to return.

### Translate Guest Virtual Address Page Callback
```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_TRANSLATE_GVA_PAGE_CALLBACK)(
    _In_ VOID* Context,
    _In_ WHV_GUEST_VIRTUAL_ADDRESS GvaPage,
    _In_ WHV_TRANSLATE_GVA_FLAGS TranslateFlags,
    _Out_ WHV_TRANSLATE_GVA_RESULT_CODE* TranslationResult,
    _Out_ WHV_GUEST_PHYSICAL_ADDRESS* GpaPage // NOTE: This pointer _must_ be 4K page aligned
    );
```
Callback requesting the virtualization stack to translate the Guest Virtual Address GvaPage that points to the start of a 4K page, with the specified TranslateFlags. The virtstack should
return in TranslationResult exactly what `WHvTranslateGva` returned, along with the resulting
address in GpaPage.

**NOTE:** GpaPage must be 4K aligned or the current emulation call will fail, with extended status
TranslateGvaPageCallbackGpaPageIsNotAligned bit set.
