# WHvRunVirtualProcessor
**Note: These APIs are not yet publically available and will be included in a future Windows release.**

## Syntax

```C
// Exit reason for the return of the VID_WHV_IOCTL_RUN_VP IOCTL 
typedef enum { 
 
    // Standard exits caused by operations of the virtual processor 
    RunVpExitReasonMemoryAccess           = 0x00000001, 
    RunVpExitReasonX64IOPortAccess        = 0x00000002, 
    RunVpExitReasonX64LegacyFpError       = 0x00000003, 
    RunVpExitReasonUnrecoverableException = 0x00000004, 
    RunVpExitReasonInvalidVpRegisterValue = 0x00000005, 
    RunVpExitReasonUnsupportedFeature     = 0x00000006, 
     
    // Additional exits that can be configured through partition properties 
    RunvpExitReasonX64MSRAccess           = 0x00001000, 
    RunVpExitReasonX64CPUID               = 0x00001001, 
    RunVpExitReasonException              = 0x00001002, 
     
    // Exits caused by the host 
    RunVpExitReasonCanceled               = 0x00002001 
 
} WHV_RUN_VP_EXIT_REASON; 
 
// VP run context buffer 
typedef struct { 
    WHV_RUN_VP_EXIT_REASON ExitReason; 
     
    union { 
        WHV_MEMORY_ACCESS_CONTEXT MemoryAccess; 
        WHV_X64_IO_PORT_ACCESS_CONTEXT IoPortAccess; 
        WHV_X64_MSR_ACCESS_CONTEXT MsrAccess; 
        WHV_X64_CPUID_ACCESS_CONTEXT CpuidAccess; 
        WHV_VP_EXCEPTION_CONTEXT VpException; 
        WHV_UNRECOVERABLE_EXCEPTION_CONTEXT UnrecoverableError; 
        WHV_X64_UNSUPPORTED_FEATURE_CONTEXT UnsupportedFeature; 
        WHV_RUN_VP_CANCELLED_CONTEXT CancelReason; 
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
 
Specifies the output buffer that receives the context structure providing the information about the reason that caused the WHvRunVirtualProcessor function to return. 

`ExitContextSizeInBytes` 

Specifies the size of the buffer that receives the exit context, in bytes. The minimum buffer size required to hold the exit context can be queried with the [`WHvGetRunContextBufferSize`](WHvGetRunContextBufferSize.md) function. 
  

## Remarks

A virtual processor is executed (i.e., is enabled to run guest code) by making a call to the `WHvRunVirtualProcessor` function. A call to this function blocks synchronously until either the virtual processor executed an operation that needs to be handled by the virtualization stack (e.g., accessed memory in the GPA space that is not mapped or not accessible) or the virtualization stack explicitly request an exit of the function (e.g., to inject an interrupt for the virtual processor or to change the state of the VM). 
