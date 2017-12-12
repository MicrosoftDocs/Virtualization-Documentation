# WHvEmulatorTryIoEmulation and WHvEmulatorTryMmioEmulation
## Syntax

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

## Return Value
Attempt to emulate a given type of instruction with the given instruction context
returned by the WinHv APIs from a  `RunVirtualProcessor` call. This function returns
`S_OK` in most methods of operation, and `EmulatorReturnStatus` will be returned with
additional information. If Emulator, or the instruction context are malformed, this
function may return `E_INVALIDARG`. Any other return value indicates catastrophic failure, and the extended status should not be checked.

Emulator is a valid emulator handle returned from [WHvEmulatorCreateEmulator](hyper-v-third-party-funcs/WHvEmulatorCreateEmulator.md).

Context is a `void*` which is passed into each callback method, used as a way
for the virtualization stack to identify this emulation call.

EmulatorReturnStatus is extended status information about the emulation call. This return value
is only valid if the function's return value was `S_OK`:
* `EmulationSuccessful`: This emulation call was successful, the SetVirtualProcessorRegisters callback was called and the virtualization stack should continue running the processor.
* `InternalEmulationFailure`: Some internal emulation failure occured.
* `IoPortCallbackFailed`: The registered Io Port callback did not return `S_OK`.
* `MemoryCallbackFailed`: The registered Memory callback did not return `S_OK`.
* `TranslateGvaPageCallbackFailed`: The registered TranslateGvaPage callback did not return `S_OK`.
* `TranslateGvaPageCallbackGpaPageIsNotAligned`: The GpaPage address returned in the TranslateGvaPage
callback was not 4K aligned.
* `GetVirtualProcessorRegistersCallbackFailed`: The registered GetVirtualProcessorRegisters callback did not return `S_OK`.
* `SetVirtualProcessorRegistersCallbackFailed`: The registered SetVirtualProcessorRegisters callback did not return `S_OK`.
* `InterruptCausedIntercept`: A pending interrupt or fault caused this intercept, which the emulator cannot handle.
* `GuestCannotBeFaulted`: The guest is currently in a state where injecting a fault would do nothing, and instead must be terminated in other ways.

**NOTE:** The hypervisor is not guaranteed to always return InstructionBytes in the exit context.
For simple IO instructions, this is fine. However, for IO string and MMIO instructions, the virtualization stack must fetch the InstructionBytes to pass into the emulator. In this case, it is okay for the virtualization stack to fetch more than the next instruction, because the emulator will only emulate a single instruction regardless of the number of bytes present in InstructionBytes.

**NOTE:** Instructions that contain the x86 REP prefix will be internally resolved within the emulator by emulating that instruction multiple times, until the REP prefix condition is satisfied.
This may result in multiple callbacks of the registered callback functions.

This function is not thread safe when reusing the same emulator handle in another thread. Other calling threads should either use a different instance of the emulator (ie one emulator per VP) or wait until the current emulation call has returned.