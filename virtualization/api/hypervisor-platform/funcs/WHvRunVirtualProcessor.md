# WHvRunVirtualProcessor


## Syntax

```C
// Exit reason for the return of the VID_WHV_IOCTL_RUN_VP IOCTL 
typedef enum WHV_RUN_VP_EXIT_REASON
{
    WHvRunVpExitReasonNone                   = 0x00000000,

    // Standard exits caused by operations of the virtual processor
    WHvRunVpExitReasonMemoryAccess           = 0x00000001,
    WHvRunVpExitReasonX64IoPortAccess        = 0x00000002,
    WHvRunVpExitReasonUnrecoverableException = 0x00000004,
    WHvRunVpExitReasonInvalidVpRegisterValue = 0x00000005,
    WHvRunVpExitReasonUnsupportedFeature     = 0x00000006,
    WHvRunVpExitReasonX64InterruptWindow     = 0x00000007,
    WHvRunVpExitReasonX64Halt                = 0x00000008,

    // Additional exits that can be configured through partition properties
    WHvRunVpExitReasonX64MsrAccess           = 0x00001000,
    WHvRunVpExitReasonX64Cpuid               = 0x00001001,
    WHvRunVpExitReasonException              = 0x00001002,

    // Exits caused by the host
    WHvRunVpExitReasonCanceled               = 0x00002001
} WHV_RUN_VP_EXIT_REASON;
 
// WHvRunVirtualProcessor output buffer
typedef struct WHV_RUN_VP_EXIT_CONTEXT
{
    WHV_RUN_VP_EXIT_REASON ExitReason;
    UINT32 Reserved;
    WHV_VP_EXIT_CONTEXT VpContext;

    union
    {
        WHV_MEMORY_ACCESS_CONTEXT MemoryAccess;
        WHV_X64_IO_PORT_ACCESS_CONTEXT IoPortAccess;
        WHV_X64_MSR_ACCESS_CONTEXT MsrAccess;
        WHV_X64_CPUID_ACCESS_CONTEXT CpuidAccess;
        WHV_VP_EXCEPTION_CONTEXT VpException;
        WHV_X64_INTERRUPTION_DELIVERABLE_CONTEXT InterruptWindow;
        WHV_X64_UNSUPPORTED_FEATURE_CONTEXT UnsupportedFeature;
        WHV_RUN_VP_CANCELED_CONTEXT CancelReason;
    };
} WHV_RUN_VP_EXIT_CONTEXT;
 
HRESULT
WINAPI
WHvRunVirtualProcessor(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _Out_writes_bytes_(ExitContextSizeInBytes) VOID* ExitContext,
    _In_ UINT32 ExitContextSizeInBytes
    );
```

### Parameters

`Partition`

Handle to the partition object

`VpIndex`

Specifies the index of the virtual processor that is executed

`ExitContext`

Specifies the output buffer that receives the context structure providing the information about the reason that caused the `WHvRunVirtualProcessor` function to return. 

`ExitContextSizeInBytes`

Specifies the size of the buffer that receives the exit context, in bytes. 
  

## Remarks

A virtual processor is executed (i.e., is enabled to run guest code) by making a call to the `WHvRunVirtualProcessor` function. A call to this function blocks synchronously until either the virtual processor executed an operation that needs to be handled by the virtualization stack (e.g., accessed memory in the GPA space that is not mapped or not accessible) or the virtualization stack explicitly request an exit of the function (e.g., to inject an interrupt for the virtual processor or to change the state of the VM). 
