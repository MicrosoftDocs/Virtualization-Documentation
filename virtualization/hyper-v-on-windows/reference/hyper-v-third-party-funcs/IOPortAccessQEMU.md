# I/O Port Access for QEMU
## Syntax
```C
// Context data for an exit caused by an I/O port access 
typedef struct { 
    UINT32 IsWrite : 1; 
    UINT32 AccessSize: 3; 
    UINT32 StringOp : 1; 
    UINT32 RepPrefix : 1; 
    UINT32 Reserved : 26; 
} WHV_X64_IO_PORT_ACCESS_INFO; 
 
typedef struct { 
    WHV_VP_INSTRUCTION_CONTEXT Instruction; 
    WHV_VP_EXECUTION_STATE VpState; 
    WHV_X64_IO_PORT_ACCESS_INFO AccessInfo; 
    UINT16 PortNumber; 
    UINT64 Rax; 
    UINT64 Rcx; 
    UINT64 Rsi; 
    UINT64 Rdi; 
    WHV_X64_SEGMENT_REGISTER Ds; 
    WHV_X64_SEGMENT_REGISTER Es; 
} WHV_X64_IO_PORT_ACCESS_CONTEXT; 
```

## Remarks

Information about exits caused by the virtual processor executing an I/O port instruction (IN, OUT, INS, and OUTS) is provided in the `WHV_X64_IO_PORT_ACCESS_CONTEXT` structure. The context information includes the I/O port address, which allows the virtualization stack to forward the exit to the device emulation logic of the device that uses the I/O port accessed by the virtual processor. 