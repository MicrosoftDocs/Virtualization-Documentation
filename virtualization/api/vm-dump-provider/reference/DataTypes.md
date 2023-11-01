---
title: VM Dump Provider Data Types
description: Learn about VM Dump Provider Data Types.
ms.date: 04/18/2022
author: sethmanheim
ms.author: mabrigg
---
# VM Dump Provider Data Types
**Note: These APIs are publicly available as of Windows 1803 (10.0.17134.48). You can build your project against these APIs, but the DLL for linking is missing from the SDK. You should use the latest SDK and associated DLL released with Windows Insider to run your application**

## Syntax
```C
typedef VOID* VM_SAVED_STATE_DUMP_HANDLE; 
 
typedef UINT64 GUEST_VIRTUAL_ADDRESS; 
typedef UINT64 GUEST_PHYSICAL_ADDRESS; 
 
// 
// Define paging modes 
// 
typedef enum PAGING_MODE 
{ 
    Paging_Invalid = 0, 
    Paging_NonPaged, 
    Paging_32Bit, 
    Paging_Pae, 
    Paging_Long, 
} PAGING_MODE; 
 
 
// 
// Define guest physical memory chunks 
// 
typedef struct GPA_MEMORY_CHUNK 
{ 
    UINT64  GuestPhysicalStartPageIndex; 
    UINT64  PageCount; 
} GPA_MEMORY_CHUNK; 
 
 
// 
// Define Virtual Processors dump information 
// 
typedef enum VIRTUAL_PROCESSOR_ARCH 
{ 
    Arch_Unkown = 0, 
    Arch_x86, 
    Arch_x64, 
} VIRTUAL_PROCESSOR_ARCH; 
 
 
typedef enum REGISTER_ID_X86 
{ 
    // 
    // General Purpose Registers 
    // 
    X86_RegisterEax = 0, 
    X86_RegisterEcx, 
    X86_RegisterEdx, 
    X86_RegisterEbx, 
    X86_RegisterEsp, 
    X86_RegisterEbp, 
    X86_RegisterEsi, 
    X86_RegisterEdi, 
    X86_RegisterEip, 
    X86_RegisterEFlags, 
 
    // 
    // Floating Point Registers 
    // 
    X86_RegisterLowXmm0, 
    X86_RegisterHighXmm0, 
    X86_RegisterLowXmm1, 
    X86_RegisterHighXmm1, 
    X86_RegisterLowXmm2, 
    X86_RegisterHighXmm2, 
    X86_RegisterLowXmm3, 
    X86_RegisterHighXmm3, 
    X86_RegisterLowXmm4, 
    X86_RegisterHighXmm4, 
    X86_RegisterLowXmm5, 
    X86_RegisterHighXmm5, 
    X86_RegisterLowXmm6, 
    X86_RegisterHighXmm6, 
    X86_RegisterLowXmm7, 
    X86_RegisterHighXmm7, 
    X86_RegisterLowXmm8, 
    X86_RegisterHighXmm8, 
    X86_RegisterLowXmm9, 
    X86_RegisterHighXmm9, 
    X86_RegisterLowXmm10, 
    X86_RegisterHighXmm10, 
    X86_RegisterLowXmm11, 
    X86_RegisterHighXmm11, 
    X86_RegisterLowXmm12, 
    X86_RegisterHighXmm12, 
    X86_RegisterLowXmm13, 
    X86_RegisterHighXmm13, 
    X86_RegisterLowXmm14, 
    X86_RegisterHighXmm14, 
    X86_RegisterLowXmm15, 
    X86_RegisterHighXmm15, 
    X86_RegisterLowXmmControlStatus, 
    X86_RegisterHighXmmControlStatus, 
    X86_RegisterLowFpControlStatus, 
    X86_RegisterHighFpControlStatus, 
 
    // 
    // Control Registers 
    // 
    X86_RegisterCr0, 
    X86_RegisterCr2, 
    X86_RegisterCr3, 
    X86_RegisterCr4, 
    X86_RegisterCr8, 
    X86_RegisterEfer, 
 
    // 
    // Debug Registers 
    // 
    X86_RegisterDr0, 
    X86_RegisterDr1, 
    X86_RegisterDr2, 
    X86_RegisterDr3, 
    X86_RegisterDr6, 
    X86_RegisterDr7, 
 
    // 
    // Segment Registers 
    // 
    X86_RegisterBaseGs, 
    X86_RegisterBaseFs, 
    X86_RegisterSegCs, 
    X86_RegisterSegDs, 
    X86_RegisterSegEs, 
    X86_RegisterSegFs, 
    X86_RegisterSegGs, 
    X86_RegisterSegSs, 
    X86_RegisterTr, 
    X86_RegisterLdtr, 
 
    // 
    // Table Registers 
    // 
    X86_RegisterBaseIdtr, 
    X86_RegisterLimitIdtr, 
    X86_RegisterBaseGdtr, 
    X86_RegisterLimitGdtr, 
 
    // 
    // Register Count 
    // 
    X86_RegisterCount, 
} REGISTER_ID_X86; 
 
 
typedef enum REGISTER_ID_X64 
{ 
    // 
    // General Purpose Registers 
    // 
    X64_RegisterRax = 0, 
    X64_RegisterRcx, 
    X64_RegisterRdx, 
    X64_RegisterRbx, 
    X64_RegisterRsp, 
    X64_RegisterRbp, 
    X64_RegisterRsi, 
    X64_RegisterRdi, 
    X64_RegisterR8, 
    X64_RegisterR9, 
    X64_RegisterR10, 
    X64_RegisterR11, 
    X64_RegisterR12, 
    X64_RegisterR13, 
    X64_RegisterR14, 
    X64_RegisterR15, 
    X64_RegisterRip, 
    X64_RegisterRFlags, 
 
    // 
    // Floating Point Registers 
    // 
    X64_RegisterLowXmm0, 
    X64_RegisterHighXmm0, 
    X64_RegisterLowXmm1, 
    X64_RegisterHighXmm1, 
    X64_RegisterLowXmm2, 
    X64_RegisterHighXmm2, 
    X64_RegisterLowXmm3, 
    X64_RegisterHighXmm3, 
    X64_RegisterLowXmm4, 
    X64_RegisterHighXmm4, 
    X64_RegisterLowXmm5, 
    X64_RegisterHighXmm5, 
    X64_RegisterLowXmm6, 
    X64_RegisterHighXmm6, 
    X64_RegisterLowXmm7, 
    X64_RegisterHighXmm7, 
    X64_RegisterLowXmm8, 
    X64_RegisterHighXmm8, 
    X64_RegisterLowXmm9, 
    X64_RegisterHighXmm9, 
    X64_RegisterLowXmm10, 
    X64_RegisterHighXmm10, 
    X64_RegisterLowXmm11, 
    X64_RegisterHighXmm11, 
    X64_RegisterLowXmm12, 
    X64_RegisterHighXmm12, 
    X64_RegisterLowXmm13, 
    X64_RegisterHighXmm13, 
    X64_RegisterLowXmm14, 
    X64_RegisterHighXmm14, 
    X64_RegisterLowXmm15, 
    X64_RegisterHighXmm15, 
    X64_RegisterLowXmmControlStatus, 
    X64_RegisterHighXmmControlStatus, 
    X64_RegisterLowFpControlStatus, 
    X64_RegisterHighFpControlStatus, 
 
    // 
    // Control Registers 
    // 
    X64_RegisterCr0, 
    X64_RegisterCr2, 
    X64_RegisterCr3, 
    X64_RegisterCr4, 
    X64_RegisterCr8, 
    X64_RegisterEfer, 
 
    // 
    // Debug Registers 
    // 
    X64_RegisterDr0, 
    X64_RegisterDr1, 
    X64_RegisterDr2, 
    X64_RegisterDr3, 
    X64_RegisterDr6, 
    X64_RegisterDr7, 
 
    // 
    // Segment Registers 
    // 
    X64_RegisterBaseGs, 
    X64_RegisterBaseFs, 
    X64_RegisterSegCs, 
    X64_RegisterSegDs, 
    X64_RegisterSegEs, 
    X64_RegisterSegFs, 
    X64_RegisterSegGs, 
    X64_RegisterSegSs, 
    X64_RegisterTr, 
    X64_RegisterLdtr, 
 
    // 
    // Table Registers 
    // 
    X64_RegisterBaseIdtr, 
    X64_RegisterLimitIdtr, 
    X64_RegisterBaseGdtr, 
    X64_RegisterLimitGdtr, 
 
    // 
    // Register Count 
    // 
    X64_RegisterCount, 
} REGISTER_ID_X64; 
 
 
typedef struct VIRTUAL_PROCESSOR_REGISTER 
{ 
    VIRTUAL_PROCESSOR_ARCH  Architecture; 
    UINT64                  RegisterValue; 
    union{ 
        REGISTER_ID_X86     RegisterId_x86; 
        REGISTER_ID_X64     RegisterId_x64; 
        DWORD               RegisterId; 
    }; 
} VIRTUAL_PROCESSOR_REGISTER; 
```
## Remarks

The VmSavedSate Dump Provider definitions used by the APIs. 