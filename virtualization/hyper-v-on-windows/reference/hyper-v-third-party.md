# Windows Hypervisor Platform API Definitions

The following section contains the definitions of the core platform APIs that are exposed through the platform API DLL. The DLL exports a set of C-style Windows API functions, the functions return HRESULT error codes indicating the result of the function call.

## Platform Capabilities

|Function   |Description|
|---|---|
|[WHvGetCapability](hyper-v-third-party-funcs/WHvGetCapability.md)|Platform capabilities are a generic way for callers to query properties and capabilities of the hypervisor, of the API implementation, and of the hardware platform that the application is running on.The platform API uses these capabilities to publish the availability of extended functionality of the API as well as the set of features that the processor on the current system supports.|
|   |   |

## Partition Creation, Setup, and Deletion

|Function   |Description|
|---|---|---|---|---|---|---|---|
|[WHvCreatePartition](hyper-v-third-party-funcs/WHvCreatePartition.md)|Creating a partition creates a new partition object. Additional properties of the partition are stored in the partition object in the VID and are applied when creating the partition in the hypervisor.|
|[WHvSetupPartition](hyper-v-third-party-funcs/WHvSetupPartition.md)|Setting up the partition causes the actual partition to be created in the hypervisor. A partition needs to be set up prior to performing any other operation on the partition after it was created, with exception of configuring the initial properties of the partition.|
|[WHvDeletePartition](hyper-v-third-party-funcs/WHvDeletePartition.md)|Deleting a partition tears down the partition object and releases all resource that the partition was using.|
|   |   |

## Partition Properties

|Function   |Description|
|---|---|
|[WHvGetPartitionProperty](hyper-v-third-party-funcs/WHvGetPartitionProperty.md)|   |
|[WHvSetPartitionProperty](hyper-v-third-party-funcs/WHvSetPartitionProperty.md)|   |
|   |   |

## VM Memory Managment
The physical address space of the VM partition (the GPA space) is populated using memory allocated in the user-mode process of the virtualization stack. I.e., the virtualization stack allocates the required memory using standard memory management functions in Windows (such as VirtualAlloc) or maps a file into its process, and uses the addresses to these areas to map this memory into the partition’s GPA space.


|Function   |Description|
|---|---|
|[WHvMapGpaRange](hyper-v-third-party-funcs/WHvMapGpaRange.md)|Creating a mapping for a range in the GPA space of a partition sets a region in the caller’s process as the backing memory for that range. The operation replaces any previous mappings for the specified GPA pages.    |
|[WHvUnmapGpaRange](hyper-v-third-party-funcs/WHvUnmapGpaRange.md)|Unmapping a previously mapped GPA range (or parts of it) makes the memory range unavailable to the partition. Any further access by a virtual processor to the range will result in a memory access exit.|
|[WHvTranslateVirtualAddress](hyper-v-third-party-funcs/WHvTranslateVirtualAddress.md)|Translating a virtual address used by a virtual processor in a partition allows the virtualization stack to emulate a processor instruction for an I/O operation, using the results of the translation to read and write the memory operands of the instruction in the GPA space of the partition.|
|   |   |

## Virtual Processor Execution

The virtual processors of a VM are executed using the new integrated scheduler of the hypervisor. To run a virtual processor, a thread in the process of the virtualization stack issues a blocking call to execute the virtual processor in the hypervisor, the call returns because of an operation of the virtual processor that requires handling in the virtualization stack or because of a request by the virtualization stack.  

A thread that handles a virtual processor executes the following basic operations: 
1. Create the virtual processor in the partition. 
2. Setup the state of the virtual processor, which includes injecting pending interrupts and events into the processor. 
3. Run the virtual processor. 
4. Upon return from running the virtual processor, query the state of the processor and handle the operation that caused the processor to stop running. 
5. If the virtual processor is still active, go back to Step 2 to continue to run the processor. 
6. Delete the virtual processor in the partition.  

The state of the virtual processor includes the hardware registers and any interrupts the virtualization stack wants to inject into the virtual processor.

|Function   |Description|
|---|---|
|[WHvCreateVirtualProcessor](hyper-v-third-party-funcs/WHvCreateVirtualProcessor.md)|This function creates a new virtual processor in a partition. The index of the virtual processor is used to set the APIC ID of the processor.|
|[WHvDeleteVirtualProcessor](hyper-v-third-party-funcs/WHvDeleteVirtualProcessor.md)|This function deletes a virtual processor in a partition.|
|[WHvRunVirtualProcessor](hyper-v-third-party-funcs/WHvDeleteVirtualProcessor.md)|This function executes the virtual processor (i.e., enables to run guest code). A call to this function blocks synchronously until either the virtual processor executed an operation that needs to be handled by the virtualization stack (e.g., accessed memory in the GPA space that is not mapped or not accessible) or the virtualization stack explicitly request an exit of the function (e.g., to inject an interrupt for the virtual processor or to change the state of the VM). |
|[WHvGetRunContextBufferSize](hyper-v-third-party-funcs/WHvGetRunContextBufferSize.md)|This function returns the minimum size required for the buffer that receives the exit context. The value returned by the [`WHvRunVirtualProcessor`](hyper-v-third-party-funcs/WHvDeleteVirtualProcessor.md) function is constant for a respective version of the DLL implementation.|
|[WHvCancelRunVirtualProcessor](hyper-v-third-party-funcs/WHvCancelRunVirtualProcessor.md)|Canceling the execution of a virtual processor allows an application to abort the call to run the virtual processor ([`WHvRunVirtualProcessor`](hyper-v-third-party-funcs/WHvDeleteVirtualProcessor.md)) by another thread, and to return the control to that thread. The virtualization stack can use this function to return the control of a virtual processor back to the virtualization stack in case it needs to change the state of a VM or to inject an event into the processor. |
|   |   |


## Partition Properties

#### Data Types
The `WHvPartitionExtendedVmExits` property controls the set of additional operations by a virtual processor that should cause the execution of the processor to exit and to return to the caller of the `WHvRunVirtualProcessor` function.

The `WHvPartitionProcessorXXX` properties control the processor features that are made available to the virtual processor of the partition. These properties can only be configured during the initial creation of the partition, prior to calling `WHvInitializePartition`. 

```C
typedef enum { 
    WHvPartitionPropertyCodeExtendedVmExits        = 0x00000001, 
     
    WHvPartitionPropertyCodeProcessorVendor        = 0x00001000, 
    WHvPartitionPropertyCodeProcessorFeatures      = 0x00001001, 
    WHVPartitionPropertyCodeProcessorClFlushSize   = 0x00001002, 
     
    WHvPartitionPropertyCodeProcessorCount         = 0x00001fff 
} WHV_PARTITION_PROPERTY_CODE; 
 
typedef struct { 
    WHV_PARTITION_PROPERTY_CODE PropertyCode; 
     
    union { 
        WHV_EXTENDED_VM_EXITS ExtendedVmExits; // See VID_WHV_IOCTL_GET_CAPABILITY 
        WHV_PROCESSOR_VENDOR ProcessorVendor; // HV_PROCESSOR_VENDOR 
        WHV_PROCESSOR_FEATURES ProcessorFeatures; // HV_PARTITION_PROCESSOR_FEATURES 
        UINT8 ProcessorClFlushSize; 
    }; 
} WHV_GET_PARTITION_PROPERTY_OUTPUT; 
 
```

#### WHvGetPartitionProperty

```C
/*!
    \param Partition – Handle to the partition object. 
    \param Property – Specifies the property that is queried.
    \param PropertyBuffer – Specifies the output buffer that 
        receives the value of the requested property. 
    \param PropertyBufferSizeInBytes – Specifies the size of 
        the output buffer, in bytes. For the currently available set of properties, 
        the buffer should be large enough to hold a 64-bit value. 
*/

```

#### WHvSetPartitionProperty

```C
/*!
    \param Partition – Handle to the partition object. 
    \param PropertyBuffer – Specifies the input buffer that provides the property value. 
    \param PropertyBufferSizeInBytes – Specifies the size of the input buffer, in bytes. 
    \Return
        If the operation completed successfully, the return value is S_OK. 

        The function returns E_WHV_UNKNOWN_PROPERTY for attempts to configure a property 
        that is not available on the current system. 

        The function returns E_WHV_INVALID_PARTITION_STATE if the property cannot be 
        modified in the current state of the partition, particularly for attempts to set 
        a property that can only be modified prior to executing the partition but a virtual 
        processor in the partition already started executing. 
*/
```



## Virtual Processor Execution


### Running a Virtual Processor

#### Exit Contexts
The detailed reason and additional information for the exit of the 'WHvRunVirtualProcessor' function is return in an output buffer of the function that receives a context structure for the exit. The data provided in this context buffer is specific to the individual exit reason, and for simple exit reasons the buffer might be unused (`RunVpExitLegacyFpError` and `RunVpExitInvalidVpRegisterValue`). 

The context structures for several exit reasons share common definitions for the data that provides information about the processor instruction that caused the exit and the state of the virtual processor at the time of the exit
```C
// Execution state of the virtual processor (HV_X64_VP_EXECUTION_STATE) 
typedef struct { 
    UINT16 Cpl : 2; 
    UINT16 Cr0Pe : 1; 
    UINT16 Cr0Am : 1; 
    UINT16 EferLma : 1; 
    UINT16 DebugActive : 1; 
    UINT16 InterruptionPending : 1; 
    UINT16 Reserved : 9; 
} WHV_VP_EXECUTION_STATE; 
 
// Instruction that caused an exit 
typedef struct { 
    UINT64 Rip; 
    UINT64 Rflags; 
    WHV_X64_SEGMENT_REGISTER Cs; // HV_X64_SEGMENT_REGISTER 
    UINT8 InstructionByteCount; 
    UINT8 InstructionBytes[16]; 
} WHV_VP_INSTRUCTION_CONTEXT; 
```

##### Memory Access
Information about exits caused by the virtual processor accessing a memory location that is not mapped or not accessible is provided by the     `WHV_MEMORY_ACCESS_CONTEXT` structure.   

A common use case for memory access exits is the emulation of MMIO device operations, where unmapped regions of the partition’s GPA space are used for the MMIO space of an emulated device and accesses to this region are forwarded to the device emulation logic in the virtualization stack. 
```C
// Context data for an exit caused by a memory access 
typedef struct { 
    UINT32 AccessType : 2; // HV_INTERCEPT_ACCESS_TYPE 
    UINT32 GpaUnmapped : 1; // Unmapped GPA or GPA access violation 
    UINT32 GvaValid : 1; 
    UINT32 Reserved : 28; 
} WHV_MEMORY_ACCESS_INFO; 
 
typedef struct { 
    WHV_VP_INSTRUCTION_CONTEXT Instruction; 
    WHV_VP_EXECUTION_STATE VpState; 
    WHV_MEMORY_ACCESS_INFO AccessInfo; 
    WHV_GUEST_ADDRESS Gpa; 
    WHV_GUEST_ADDRESS Gva; 
} WHV_MEMORY_ACCESS_CONTEXT; 
```

##### I/O Port Access
Information about exits caused by the virtual processor executing an I/O port instruction (IN, OUT, INS, and OUTS) is provided in the `WHV_X64_IO_PORT_ACCESS_CONTEXT` structure. The context information includes the I/O port address, which allows the virtualization stack to forward the exit to the device emulation logic of the device that uses the I/O port accessed by the virtual processor. 
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

##### MSR Access
Information about exits caused by the virtual processor accessing a model specific register (MSR) using the RDMSR or WRMSR instructions is provided in the `WHV_X64_MSR_ACCESS_CONTEXT` structure. 

Exits for MSR accesses are only generated if they are enabled by setting the `WHV_EXTENDED_VM_EXITS.MsrExit` property for the partition. 

```C
// Context data for an exit caused by an MSR access 
typedef struct { 
    UINT32 IsWrite : 1; 
    UINT32 Reserved : 31; 
} WHV_X64_MSR_ACCESS_INFO; 
 
typedef struct { 
    WHV_VP_INSTRUCTION_CONTEXT Instruction; 
    WHV_VP_EXECUTION_STATE VpState; 
    WHV_X64_MSR_ACCESS_INFO AccessInfo; 
    UINT32 MsrNumber; 
    UINT64 Rax; 
    UINT64 RdX; 
} WHV_X64_MSR_ACCESS_CONTEXT; 
```

##### CPUID Access
Information about exits caused by the virtual processor executing the CPUID instruction is provided in the `WHV_X64_CPUID_ACCESS_CONTEXT` structure. The `DefaultResultRax-Rbx` members of the structure provide the values of the requested CPUID values that the hypervisor would return based on the partition properties and the capabilities of the host.  

Exits for `CPUID` accesses are only generated if they are enabled by setting the `WHV_EXTENDED_VM_EXITS`.CpuidExit property for the partition. 
```C
// Context data for an exit caused by a CPUID call 
typedef struct { 
    WHV_VP_INSTRUCTION_CONTEXT Instruction; 
    WHV_VP_EXECUTION_STATE VpState; 
    UINT64 Rax; 
    UINT64 Rcx; 
    UINT64 Rdx; 
    UINT64 Rbx; 
    UINT64 DefaultResultRax; 
    UINT64 DefaultResultRcx; 
    UINT64 DefaultResultRdx; 
    UINT64 DefaultResultRbx; 
} WHV_X64_CPUID_ACCESS_CONTEXT; 
```

##### Virtual Processor Exception

Information about an exception generated by the virtual processor is provided in the `WHV_VP_EXCEPTION_CONTEXT` structure. 

Exits for exceptions are only generated if they are enabled by setting the `WHV_EXTENDED_VM_EXITS.ExceptionExit` property for the partition. 
```C
// Context data for an exit cuased by an exception generated by the virtual processor 
typedef struct { 
    UINT32 ErrorCodeValid : 1; 
    UINT32 SoftwareException : 1; 
    UINT32 Reserved : 30; 
} WHV_VP_EXCEPTION_INFO; 
 
typedef struct { 
    WHV_VP_INSTRUCTION_CONTEXT Instruction; 
    WHV_VP_EXECUTION_STATE VpState; 
    WHV_VP_EXCEPTION_INFO ExceptionInfo; 
    UINT16 ExceptionVector; 
    UINT32 ErrorCode; 
    UINT64 ExceptionParameter; 
} WHV_VP_EXCEPTION_CONTEXT; 
```

##### Unrecoverable Exception
An exit for an unrecoverable error is caused by the virtual processor generating an exception that cannot be delivered (triple fault). 

```C
// Context data for an exit caused by an unrecoverable error (tripple fault)
 
typedef struct { 
    WHV_VP_INSTRUCTION_CONTEXT Instruction; 
    WHV_VP_EXECUTION_STATE VpState; 
} WHV_UNRECOVERABLE_EXCEPTION_CONTEXT; 
```
##### Unsupported Feature
An exit for an unsupported feature is caused by the virtual processor accesses a feature of the architecture that is not properly virtualized by the hypervisor. 

```C
// Context data for an exit caused by the use of an unsupported feature 
typedef struct { 
    WHV_X64_UNSUPPORTED_FEATURE_CODE FeatureCode; // HV_X64_UNSUPPORTED_FEATURE_CODE 
    UINT64 FeatureParameter;  
} WHV_X64_UNSUPPORTED_FEATURE_CONTEXT; 
```

##### Execution Cancelled
Information about an exit caused by host system is provided in the `WHV_RUN_VP_CANCELLED_CONTEXT` structure.  

```C
// Context data for an exit caused by a cancellation from the host 
typedef enum { 
    WhvRunVpCancelReasonUser = 0 // Execution canceled by HvCancelRunVirtualProcessor 
} WHV_RUN_VP_CANCEL_REASON; 
 
typedef struct { 
    WHV_RUN_VP_CANCEL_REASON CancelReason; 
} WHV_RUN_VP_CANCELED_CONTEXT; 
```

#### WHvRunVirtualProcessor

```C
 /*!
    \param Partition – Handle to the partition object. 
    \param VpIndex – Specifies the index of the virtual processor that is executed. 
    \param ExitContext – Specifies the output buffer that receives the context structure providing the
         information about the reason that caused the WHvRunVirtualProcessor function to return. 
    \param ExitContextSizeInBytes – Specifies the size of the buffer that receives the exit context, 
        in bytes. The minimum buffer size required to hold the exit context can be queried with the
        WHvGetRunContextBufferSize function. 
*/

```



### Virtual Processor Registers
The state of a virtual processor, which includes both the state defined by the underlying architecture (such as general-purpose registers) and additional state defined by the hypervisor, can be access through the `WHvGetVirtualProcessorRegisters` and `WHvSetVirtualProcessorRegisters` functions. The functions allow for querying and setting a set of individual registers by the virtualization stack. 

#### Data Types

```C
// Register names (subset of HV_REGISTER_NAME) 
typedef enum { 
    // General purpose registers 
    WHvX64RegisterRax...R15, 
    WHvX64RegisterRip, 
    WHvX64RegisterRflags, 
     
    // Segment registers 
    WhvX64RegisterCs..Gs, 
    WhvX64RegisterLdtr, 
    WhvX64RegisterTr, 
     
    // Table registers 
    WHvX64RegisterIdtr, 
    WHvX64RegisterGdtr, 
     
    // Floating-point registers 
    WhvX64RegisterXmm0...15, 
    WhvX64RegisterFpMmx0...7, 
    WhvX64RegisterFpControlStatus, 
    WhvX64RegisterXmmControlStatus, 
     
    // Control registers 
    WHvX64RegisterCr0...Cr8, 
     
    // Debug Registers 
    WHvX64RegisterDr0...Dr7, 
     
    // MSRs 
    WHvX64RegisterTsc, 
    WHvX64RegisterEfer, 
    WHvX64RegisterKernelGsBase, 
    WHvX64RegisterApicBase, 
    WHvX64RegisterPat, 
    WHvX64RegisterSysenterCs, 
    WHvX64RegisterSysenterRip, 
    WHvX64RegisterSysenterRsp, 
    WHvX64RegisterStar, 
    WHvX64RegisterLstar, 
    WHvX64RegisterCstar, 
    WHvX64RegisterSfmask, 
 
    // Interrupt Registers 
    WHvRegisterPendingInterruption, 
    WHvRegisterInterruptState, 
    WHvRegisterPendingEvent0, 
    WHvRegisterPendingEvent1, 
    WHvX64RegisterDeliverabilityNotifications 
} WHV_REGISTER_NAME; 
 
// Register value (HV_REGISTER_VALUE) 
typedef union { 
    WHV_UINT128 Reg128; 
    UINT64 Reg64; 
    UINT32 Reg32; 
    UINT16 Reg16; 
    UINT8  Reg8; 
    WHV_X64_FP_REGISTER Fp; 
    WHV_X64_FP_CONTROL_STATUS_REGISTER FpControlStatus; 
    WHV_X64_XMM_CONTROL_STATUS_REGISTER XmmControlStatus; 
    WHV_X64_SEGMENT_REGISTER Segment; 
    WHV_X64_TABLE_REGISTER Table; 
    WHV_X64_INTERRUPT_STATE_REGISTER InterruptState; 
    WHV_X64_PENDING_INTERRUPTION_REGISTER PendingInterruption; 
} WHV_REGISTER_VALUE; 
```

#### WHvGetVirtualProcessorRegisters

```C
/*!
    \param Partition – Handle to the partition object. 
    \param VpIndex – Specifies the index of the virtual processor whose registers are queried. 
    \param RegisterNames – Array specifying the names of the registers that are queried. 
    \param RegisterCount – Specifies the number of elements in the RegisterNames array. 
    \param RegisterValues – Specifies the output buffer that receives the values of the request registers
*/

HRESULT 
WHvGetVirtualProcessorRegisters( 
    _In_ WHV_PARTITION_HANDLE Partition, 
    _In_ UINT32 VpIndex, 
    _In_ WHV_REGISTER_NAME* RegisterNames, 
    _In_ UINT32 RegisterCount, 
    _Out_ WHV_REGISTER_VALUE* RegisterValues 
); 
```

#### WHvSetVirtualProcessorRegisters
```C
/*!
    \param Partition – Handle to the partition object. 
    \param VpIndex – Specifies the index of the virtual processor whose registers are set. 
    \param RegisterNames – Array specifying the names of the registers that are set. 
    \param RegisterCount – Specifies the number of elements in the RegisterNames array. 
    \param RegisterValues – Array specifying the values of the registers that are set.  
*/

HRESULT 
WHvSetVirtualProcessorRegisters( 
    _In_ WHV_PARTITION_HANDLE Partition, 
    _In_ UINT32 VpIndex, 
    _In_ WHV_REGISTER_NAME* RegisterNames, 
    _In_ UINT32 RegisterCount, 
    _In_ WHV_REGISTER_VALUE* RegisterValues 
); 
```
