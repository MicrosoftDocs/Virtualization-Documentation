---
title: MMIO Access for QEMU
description: Learn about the MMIO Access for QEMU. 
author: sethmanheim
ms.author: mabrigg
ms.date: 04/19/2022
---
# MMIO Access for QEMU


## Syntax
```C
typedef struct { 
    UINT64 GpaAddress; // GPA address of the memory access 
    UINT8 Direction; // Read or write 
    UINT8 AccessSize; // 1, 2, 4, or 8 bytes 
    union { 
        UINT64 Value; // Input value (for write), output value (for read) 
        UINT64 GpaAddress2; // GPA address of the second instruction operand 
    }; 
} MMIO_ACCESS_INFO; 
```

## Remarks
This information is derived by decoding the instruction that caused an `RunVpExitMemoryAccess` exit for a virtual processor. 