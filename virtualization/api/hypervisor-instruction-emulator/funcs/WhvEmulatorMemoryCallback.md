# WHV_EMULATOR_MEMORY_CALLBACK
**Note: A prerelease of this API is available starting in the Windows Insiders Preview Build 17083**

## Syntax

```c
typedef HRESULT (CALLBACK *WHV_EMULATOR_MEMORY_CALLBACK)(
    _In_ VOID* Context,
    _Inout_ WHV_EMULATOR_MEMORY_ACCESS_INFO* MemoryAccess
    );
```

## Remarks
Callback notifying the virtualization stack that the current instruction is attempting to accessing memory as specified in the `MemoryAccess` structure.

**NOTE:** As mentioned above, since in x86/AMD64 it is legal to do unaligned memory accesses, a memory access spanning a page boundary ie:

`movq [0xffe], rax `

This would cause two different memory callbacks to be invoked, one for two bytes, and one for 6 bytes.