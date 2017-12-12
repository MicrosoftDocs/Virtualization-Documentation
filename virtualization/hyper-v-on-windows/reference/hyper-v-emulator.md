# Hyper-V Instruction Emulation API Reference and Support DLL for QEMU
QEMU expects several higher-level abstractions at the interface between the accelerators and the device emulation that are not provided directly by the platform APIs. This functionality is provided by a separate DLL that builds these abstractions on top of the platform APIs.
 
## Instruction Emulation
For its device emulation, QEMU expects the platform to provide the details of an I/O access by a virtual processor. For an MMIO and string I/O port access this requires decoding and completing the instruction that issued the I/O access. 
## Structures

# Hyper-V Instruction Emulator API Reference

## Struct Definitions

### `WHV_EMULATOR_CALLBACKS`
```c
typedef struct _WHV_EMULATOR_CALLBACKS {
    WHV_EMULATOR_IO_PORT_CALLBACK WHvEmulatorIoPortCallback;
    WHV_EMULATOR_MEMORY_CALLBACK WHvEmulatorMemoryCallback;
    WHV_EMULATOR_GET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK WHvEmulatorGetVirtualProcessorRegisters;
    WHV_EMULATOR_SET_VIRTUAL_PROCESSOR_REGISTERS_CALLBACK WHvEmulatorSetVirtualProcessorRegisters;
    WHV_EMULATOR_TRANSLATE_GVA_PAGE_CALLBACK WHvEmulatorTranslateGvaPage;
} WHV_EMULATOR_CALLBACKS;
```
Used in `WHvEmulatorCreateEmulator` to specify callback methods needed by the emulator.

### `WHV_EMULATOR_STATUS`
```c
typedef union _WHV_EMULATOR_STATUS
{
    struct
    {
        UINT32 EmulationSuccessful : 1;
        UINT32 InternalEmulationFailure : 1;
        UINT32 IoPortCallbackFailed : 1;
        UINT32 MemoryCallbackFailed : 1;
        UINT32 TranslateGvaPageCallbackFailed : 1;
        UINT32 TranslateGvaPageCallbackGpaPageIsNotAligned : 1;
        UINT32 GetVirtualProcessorRegistersCallbackFailed : 1;
        UINT32 SetVirtualProcessorRegistersCallbackFailed : 1;
        UINT32 InterruptCausedIntercept : 1;
        UINT32 GuestCannotBeFaulted : 1;
        UINT32 Reserved : 21;
    };

    UINT32 AsUINT32;
} WHV_EMULATOR_STATUS;
```
Describes extended return status information from a given emulation call.

### `WHV_EMULATOR_MEMORY_ACCESS_INFO`
```c
typedef struct _WHV_EMULATOR_MEMORY_ACCESS_INFO {
    UINT64 GpaAddress;
    UINT8 Direction; //0 for read, 1 for write
    UINT8 AccessSize; // 1 thru 8, TODO: odd numbers allowed?
    UINT8 Data[8]; // Little Endian (LE) byte encoding value for access size.
} WHV_EMULATOR_MEMORY_ACCESS_INFO;
```
Information about the requested memory access by the emulator. GpaAddress is the
guest physical address attempting to be accessed. Direction is 0 for a memory read access, 1 for a write access.
AccessSize is how big this memory access is in bytes, with a valid size of 1 to 8. Data is a byte
array with little endian encoding, to either be filled out by the virtualization stack for a read, or containing the data to write to memory for a write.

### `WHV_EMULATOR_IO_ACCESS_INFO`
```c
typedef struct _WHV_EMULATOR_IO_ACCESS_INFO {
    UINT8 Direction; //0 for in, 1 for out
    UINT16 Port;
    UINT16 AccessSize; // only 1, 2, 4
    UINT32 Data[4]; // LE byte encoding value for access size
} WHV_EMULATOR_IO_ACCESS_INFO;
```
Information about the requested Io Port access by the emulator. Direction is the same as for memory,
a 0 for a read and 1 for a write. Port is the Io Port the emulator is attempting to access. AccessSize is the same as described above for memory, but limited to values of 1, 2 or 4. Data is also the same as for memory, a byte array with little endian encoding to store the data for a read, or the data for the device in the case of a write.

## API Methods

### `WHvEmulatorCreateEmulator`
```c
HRESULT
WINAPI
WHvEmulatorCreateEmulator(
    _In_ WHV_EMULATOR_CALLBACKS Callbacks,
    _Out_ WHV_EMULATOR_HANDLE* Emulator
    );
```
Create an instance of the instruction emulator with the specified callback
methods.

### `WHvEmulatorDestoryEmulator`
```c
HRESULT
WINAPI
WHvEmulatorDestoryEmulator(
    _In_ WHV_EMULATOR_HANDLE Emulator
    );
```
Destroy an instance of the instruction emulator created by WHvEmulatorCreateEmulator.

### `WHvEmulatorTryIoEmulation`, `WHvEmulatorTryMmioEmulation`
```C++
HRESULT
WINAPI
WHvEmulatorTryIoEmulation(
    _In_ WHV_EMULATOR_HANDLE Emulator,
    _In_ VOID* Context,
    _In_ WHV_X64_IO_PORT_ACCESS_CONTEXT* IoInstructionContext,
    _Out_ WHV_EMULATOR_STATUS* const EmulatorReturnStatus
    );

HRESULT
WINAPI
WHvEmulatorTryMmioEmulation(
    _In_ WHV_EMULATOR_HANDLE Emulator,
    _In_ VOID* Context,
    _In_ WHV_MEMORY_ACCESS_CONTEXT* MmioInstructionContext,
    _Out_ WHV_EMULATOR_STATUS* const EmulatorReturnStatus
    );
```
Attempt to emulate a given type of instruction with the given instruction context
returned by the WinHv APIs from a RunVirtualProcessor call. This function returns
S_OK in most methods of operation, and EmulatorReturnStatus will be returned with
additional information. If Emulator, or the instruction context are malformed, this
function may return E_INVALIDARG. Any other return value indicates catastrophic failure, and
the extended status should not be checked.

Emulator is a valid emulator handle returned from WHvEmulatorCreateEmulator.

Context is a `void*` which is passed into each callback method, used as a way
for the virtualization stack to identify this emulation call.

EmulatorReturnStatus is extended status information about the emulation call. This return value
is only valid if the function's return value was S_OK:
* EmulationSuccessful: This emulation call was successful, the SetVirtualProcessorRegisters callback was called and the virtualization stack should continue running the processor.
* InternalEmulationFailure: Some internal emulation failure occured.
* IoPortCallbackFailed: The registered Io Port callback did not return S_OK.
* MemoryCallbackFailed: The registered Memory callback did not return S_OK.
* TranslateGvaPageCallbackFailed: The registered TranslateGvaPage callback did not return S_OK.
* TranslateGvaPageCallbackGpaPageIsNotAligned: The GpaPage address returned in the TranslateGvaPage
callback was not 4K aligned.
* GetVirtualProcessorRegistersCallbackFailed: The registered GetVirtualProcessorRegisters callback did not return S_OK.
* SetVirtualProcessorRegistersCallbackFailed: The registered SetVirtualProcessorRegisters callback
did not return S_OK.
* InterruptCausedIntercept: A pending interrupt or fault caused this intercept, which the emulator cannot handle.
* GuestCannotBeFaulted: The guest is currently in a state where injecting a fault would do nothing, and instead must be terminated in other ways.

**NOTE:** The hypervisor is not guaranteed to always return InstructionBytes in the exit context.
For simple IO instructions, this is fine. However, for IO string and MMIO instructions, the virtualization stack must fetch the InstructionBytes to pass into the emulator. In this case, it is okay for the virtualization stack to fetch more than the next instruction, because the emulator will only emulate a single instruction regardless of the number of bytes present in InstructionBytes.

**NOTE:** Instructions that contain the x86 REP prefix will be internally resolved within the emulator by emulating that instruction multiple times, until the REP prefix condition is satisfied.
This may result in multiple callbacks of the registered callback functions.

This function is not thread safe when reusing the same emulator handle in another thread. Other calling threads should either use a different instance of the emulator (ie one emulator per VP) or wait until the current emulation call has returned.

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
