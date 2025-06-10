---
title: WHvEmulatorTryIoEmulation and WHvEmulatorTryMmioEmulation methods
description: Learn about the WHvEmulatorTryIoEmulation and WHvEmulatorTryMmioEmulation methods. 
author: sethmanheim
ms.author: roharwoo
ms.date: 04/19/2022
---

# WHvEmulatorTryIoEmulation and WHvEmulatorTryMmioEmulation


## Syntax

```C++
HRESULT
WINAPI
WHvEmulatorTryIoEmulation(
    _In_ WHV_EMULATOR_HANDLE Emulator,
    _In_ VOID* Context,
    _In_ const WHV_VP_EXIT_CONTEXT* VpContext,
    _In_ const WHV_X64_IO_PORT_ACCESS_CONTEXT* IoInstructionContext,
    _Out_ WHV_EMULATOR_STATUS* EmulatorReturnStatus
    );

HRESULT
WINAPI
WHvEmulatorTryMmioEmulation(
    _In_ WHV_EMULATOR_HANDLE Emulator,
    _In_ VOID* Context,
    _In_ const WHV_VP_EXIT_CONTEXT* VpContext,
    _In_ const WHV_MEMORY_ACCESS_CONTEXT* MmioInstructionContext,
    _Out_ WHV_EMULATOR_STATUS* EmulatorReturnStatus
    );
```

## Return Value
Attempt to emulate a given type of instruction with the given instruction context
returned by the WinHv APIs from a [`WHvRunVirtualProcessor`](/virtualization/api/hypervisor-platform/funcs/whvrunvirtualprocessor) call. This function returns
`S_OK` in most methods of operation, and `EmulatorReturnStatus` will be returned with
additional information. If `Emulator`, or the instruction context are malformed, this
function may return `E_INVALIDARG`. Any other return value indicates catastrophic failure, and the extended status should not be checked.

`Emulator` is a valid emulator handle returned from [`WHvEmulatorCreateEmulator`](WHvEmulatorCreateEmulator.md).

`Context` is a `void*` which is passed into each callback method, used as a way
for the virtualization stack to identify this emulation call.

`EmulatorReturnStatus` is extended status information about the emulation call. This return value
is only valid if the function's return value was `S_OK`:
* `EmulationSuccessful`: This emulation call was successful, the [`SetVirtualProcessorRegisters`](/virtualization/api/hypervisor-platform/funcs/whvsetvirtualprocessorregisters) callback was called and the virtualization stack should continue running the processor.
* `InternalEmulationFailure`: Some internal emulation failure occurred.
* `IoPortCallbackFailed`: The registered Io Port callback did not return `S_OK`.
* `MemoryCallbackFailed`: The registered Memory callback did not return `S_OK`.
* `TranslateGvaPageCallbackFailed`: The registered `TranslateGvaPage` callback did not return `S_OK`.
* `TranslateGvaPageCallbackGpaPageIsNotAligned`: The `GpaPage` address returned in the `TranslateGvaPage`
callback was not 4K aligned.
* `GetVirtualProcessorRegistersCallbackFailed`: The registered [`GetVirtualProcessorRegisters`](/virtualization/api/hypervisor-platform/funcs/whvgetvirtualprocessorregisters) callback did not return `S_OK`.
* `SetVirtualProcessorRegistersCallbackFailed`: The registered [`SetVirtualProcessorRegisters`](/virtualization/api/hypervisor-platform/funcs/whvsetvirtualprocessorregisters) callback did not return `S_OK`.
* `InterruptCausedIntercept`: A pending interrupt or fault caused this intercept, which the emulator cannot handle.
* `GuestCannotBeFaulted`: The guest is currently in a state where injecting a fault would do nothing, and instead must be terminated in other ways.

**NOTE:** The hypervisor is not guaranteed to always return `InstructionBytes` in the exit context. If required, the emulator will fetch additional instruction bytes via the registered memory callback. 

**NOTE:** Instructions that contain the x86 REP prefix will be internally resolved within the emulator by emulating that instruction multiple times, until the REP prefix condition is satisfied.
This may result in multiple callbacks of the registered callback functions.

This function is not thread safe when reusing the same emulator handle in another thread. Other calling threads should either use a different instance of the emulator (ie one emulator per VP) or wait until the current emulation call has returned.
