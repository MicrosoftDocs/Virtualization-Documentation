# MMIO Access for QEMU
**Note: These APIs are not yet publically available and will be included in a future Windows release.**

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