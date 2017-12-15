# I/O Port Access
**Note: These APIs are not yet publically available and will be included in a future Windows release.**

## Syntax
```C
//
// Context data for an exit caused by an I/O port access (WHvRunVpExitReasonX64IOPortAccess)
//
typedef union WHV_X64_IO_PORT_ACCESS_INFO
{
    struct
    {
        UINT32 IsWrite : 1;
        UINT32 AccessSize: 3;
        UINT32 StringOp : 1;
        UINT32 RepPrefix : 1;
        UINT32 Reserved : 26;
    };

    UINT32 AsUINT32;
} WHV_X64_IO_PORT_ACCESS_INFO;

typedef struct WHV_X64_IO_PORT_ACCESS_CONTEXT
{
    // Context of the virtual processor
    WHV_VP_EXIT_CONTEXT VpContext;
    UINT8 InstructionByteCount;
    UINT8 InstructionBytes[16];

    // I/O port access info
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

## Return Value

Information about exits caused by the virtual processor executing an I/O port instruction (IN, OUT, INS, and OUTS) is provided in the `WHV_X64_IO_PORT_ACCESS_CONTEXT` structure. The context information includes the I/O port address, which allows the virtualization stack to forward the exit to the device emulation logic of the device that uses the I/O port accessed by the virtual processor. 