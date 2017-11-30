# Third-Party Platform API Definitions

The following section contains the definitions of the core platform APIs that are exposed through the platform API DLL. The DLL exports a set of C-style Windows API functions, the functions return HRESULT error codes indicating the result of the function call.

## Platform Capabilities

Platform capabilities are a generic way for callers to query properties and capabilities of the hypervisor, of the API implementation, and of the hardware platform that the application is running on. The platform API uses these capabilities to publish the availability of extended functionality of the API as well as the set of features that the processor on the current system supports. Applications must query the availability of a feature prior to calling the corresponding APIs or allowing a VM to use a processor feature.

#### WHvGetCapability
```C
typedef enum {
    // Capabilities of the API implementation
    WHvCapabilityCodeHypervisorPresent      = 0x00000000,
    WHvCapabilityCodeFeatures               = 0x00000001,
    WHvCapabilityCodeExtendedVmExits        = 0x00000002,

    // Processor properties
    WHvCapabilityCodeProcessorVendor        = 0x00001000,
    WHvCapabilityCodeProcessorFeatures      = 0x00001001,
    WHVCapabilityCodeProcessorClFlushSize   = 0x00001002

    // Additional capabilities might be defined in future versions of the API
} WHV_CAPABILITY_CODE;

typedef struct {
    UINT64 Reserved : 64; // Zero
} WHV_CAPABILITY_FEATURES;

typedef struct {
    UINT64 X64CpuidExit : 1;
    UINT64 X64MsrExit : 1;
    UINT64 ExceptionExit : 1;
    UINT64 Reserved : 61; // Zero
} WHV_EXTENDED_VM_EXITS;

typedef struct
{
    WHV_CAPABILITY_CODE CapabilityCode;

    union {
        WHV_CAPABILITY_FEATURES Features;
        WHV_EXTENDED_VM_EXITS ExtendedVmExits;
        WHV_PROCESSOR_VENDOR ProcessorVendor; // HV_PROCESSOR_VENDOR
        WHV_PROCESSOR_FEATURES ProcessorFeatures; // HV_PARTITION_PROCESSOR_FEATURES
        UINT8 ProcessorClFlushSize;
    };
} WHV_CAPABILITY;

/*!
    \param Capability - Specifies the capability that is queried.
    \param CababilityBuffer - Specifies the output buffer that receives the
        value of the capability:

        The WHvCapabilityCodeHypervisorPresent capability can be used to
        determine whether the Hyper-V Hypervisor is running on a host and the
        functions of the platform APIs can be used to create VM partitions.

        The WHvFeatures capability is reserved for future use, it returns 0.

        For the WHvCapabilityCodeExtendedVmExits capability, the buffer
        contains a bit field that specifies which additional exit reasons are
        available that can be configured to cause the execution of a virtual
        processor to be halted (see Running a Virtual Processor).

        The values returned for the processor properties are based on the
        capabilities of the physical processor on the system (i.e., they are
        retrieved by querying the corresponding properties of the root
        partition).

    \return
        If the operation completed successfully, the return value is S_OK.

        The function returns E_WHV_UNKNOWN_CAPABILITY if an unknown
        capability is requested. The functionality that corresponds to the
        requested capability must be treated as being not available on the
        system.
*/
HRESULT
WHvGetCapability(
    _In_  WHV_CAPABILITY_CODE Capability,
    _Out_ VOID* CapabilityBuffer,
    _In_  SIZE_T CapabilityBufferSize
);
```

## Partition Creation

#### WHvCreatePartition

The `WHvCreatePartition` function creates a new partition object.

Creating the file object does not yet create the actual partition in the hypervisor. To create the hypervisor partition, the `WHvSetupPartition` function needs to be called. Additional properties of the partition can be configured prior to this call; these properties are stored in the partition object in the VID and are applied when creating the partition in the hypervisor.

```C
typedef VOID* WHV_PARTITION_HANDLE;

/*!
    \param Partition - Receives the handle to the newly created partition
        object. All operations on the partition are performed through this
        handle.

        Closing this handle will tear down and cleanup the partition.
*/
HRESULT
WHvCreatePartition(
    _Out_ WHV_PARTITION_HANDLE* Partition
    );
```

## Partition Setup

#### WHvSetupPartition

Setting up the partition causes the actual partition to be created in the hypervisor.

A partition needs to be set up prior to performing any other operation on the partition after it was created by `WHvCreatePartition`, with exception of calling `WHvSetPartitionProperty` to configure the initial properties of the partition.

```C
/*!
    \param Partition - Handle to the partition object that is set up.
*/
HRESULT
WHvSetupPartition(
    _In_ WHV_PARTITION_HANDLE Partition
    );
```

## Partition Deletion

#### WHvDeletePartition

Deleting a partition tears down the partition object and releases all resource that the partition was using.

```C
/*!
    \param Partition - Handle to the partition object that is deleted.
*/
HRESULT
WHvDeletePartition(
    _In_ WHV_PARTITION_HANDLE Partition
    );
```

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
HRESULT 
WHvGetPartitionProperty( 
    _In_  WHV_PARTITION_HANDLE Partition, 
    _In_  WHV_PARTITION_PROPERTY_CODE Property, 
    _Out_ VOID* PropertyBuffer, 
    _In_  UINT32 PropertyBufferSizeInBytes 
    ); 
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
HRESULT 
WHvSetPartitionProperty( 
    _In_ WHV_PARTITION_HANDLE Partition, 
    _In_ VOID* PropertyBuffer, 
    _In_ UINT32 PropertyBufferSizeInBytes 
); 
```

## VM Memory Management
The physical address space of the VM partition (the GPA space) is populated using memory allocated in the user-mode process of the virtualization stack. I.e., the virtualization stack allocates the required memory using standard memory management functions in Windows (such as VirtualAlloc) or maps a file into its process, and uses the addresses to these areas in the call to WHvMapGpaRange to map this memory into the partition’s GPA space
### Mapping GPA Ranges

#### WHvMapGpaRange
Creating a mapping for a range in the GPA space of a partition sets a region in the caller’s process as the backing memory for that range. The operation replaces any previous mappings for the specified GPA pages. 

```C
typedef UINT64 WHV_GUEST_PHYSICAL_ADDRESS; 
 
typedef enum { 
    WHvMapGpaRangeFlagNone    = 0x00000000, 
    WHvMapGpaRangeFlagRead    = 0x00000001, 
    WHvMapGpaRangeFlagWrite   = 0x00000002, 
    WHvMapGpaRangeFlagExecute = 0x00000004 
} WHV_MAP_GPA_RANGE_FLAGS; 
 
/*!
    \param Partition – Handle to the partition object. 
    \param VirtualAddress – Specifies the page-aligned address of the memory region in the caller’s 
        process that is the source of the mapping. 
    \param GpaPageAddress – Specifies the destination address in the VM’s physical address space. 
    \param PageCount – Specifies the number of pages that are mapped. 
    \param Flags – Specifies the access flags for the mapping. 
*/

HRESULT 
WHvMapGpaRange( 
    _In_ WHV_PARTITION_HANDLE Partition, 
    _In_ VOID* VirtualAddress, 
    _In_ WHV_GUEST_PHYSICAL_ADDRESS FirstGpa, 
    _In_ UINT64 PageCount, 
    _In_ HV_MAP_GPA_RAGE_FLAGS Flags 
); 
```

### Unmapping GPA Ranges

#### WHvUnmapGpaRange
Unmapping a previously mapped GPA range (or parts of it) makes the memory range unavailable to the partition. Any further access by a virtual processor to the range will result in a memory access exit. 

```C
/*! 
    \param Partition – Handle to the partition object. 
    \param GpaPageAddress – Specifies the start address of the region in the VM’s physical 
        address space that is unmapped. 
    \param PageCount – Specifies the number of pages that are unmapped. 
*/

HRESULT 
WHvUnmapGpaRange( 
    _In_ WHV_PARTITION_HANDLE Partition, 
    _In_ WHV_GUEST_PHYSICAL_ADDRESS FirstGpa, 
    _In_ UINT64 PageCount 
); 
```

### Translating Guest Virtual Addresses

Translating a virtual address used by a virtual processor in a partition allows the virtualization stack to emulate a processor instruction for an I/O operation, using the results of the translation to read and write the memory operands of the instruction in the GPA space of the partition. 

The hypervisor performs the translating by walking the page table that is currently active for the virtual processor. The translation can fail if the page table is not accessible, in which case an appropriate page fault needs to be injected into the virtual processor by the virtualization stack. 
#### WHvTranslateVirtualAddress

```C
typedef UINT64 WHV_GUEST_VIRTUAL_ADDRESS; 
 
typedef enum { 
    WHvTranslateGvaFlagNone             = 0x00000000, 
    WHvTranslateGvaFlagValidateRead     = 0x00000001, 
    WHvTranslateGvaFlagValidateWrite    = 0x00000002, 
    WHvTranslateGvaFlagValidateExecute  = 0x00000004, 
    WHvTranslateGvaFlagPrivilegeExempt  = 0x00000008, 
    WHvTranslateGvaFlagSetPageTableBits = 0x00000010 
} WHV_TRANSLATE_GVA_FLAGS; 
 
typedef enum { 
    WhvTranslateGvaSuccess                 = 0; 
 
    // Translation failures 
    WHvTranslateGvaPageNotPresent          = 1, 
    WHvTranslateGvaPrivilegeViolation      = 2, 
    WHvTranslateGvaInvalidPageTableFlags   = 3, 
 
    // GPA access failures 
    WHvTranslateGvaGpaUnmapped             = 4, 
    WHvTranslateGvaGpaNoReadAccess         = 5, 
    WHvTranslateGvaGpaNoWriteAccess        = 6, 
    WHvTranslateGvaGpaIllegalOverlayAccess = 7, 
    WHvTranslateGvaIntercept               = 8 
} WHV_TRANSLATE_GVA_RESULT_CODE; 
 
typedef struct { 
    WHV_TRANSLATE_GVA_RESULT_CODE ResultCode; 
    UINT32 Reserved: 32; 
} WHV_TRANSLATE_GVA_RESULT; 

/*!
    \param Partition – Handle to the partition object in the VID. 
    \param VpIndex – Specifies the index of the virtual processor for which the virtual address is translated. 
    \param TranslateFlags – Specifies flags for the translation. 
    \param GvaPageAddress – Specifies the virtual address that is translated. 
    \param TranslationResult – Receives the result of the translation. 
    \param GpaPageAddress – Receives the physical address if the translation was successful. 

    \Return 
        If the operation completed successfully, the return value is S_OK. Note that a successful completion of
             the call just indicates that the TranslationResult output parameter is valid, the result of the
             translation is return in the ResultCode member of this struct. 
*/
 
HRESULT 
WHvTranslateVirtualAddress( 
_In_  WHV_PARTITION_HANDLE Partition, 
_In_  UINT32 VpIndex, 
_In_  WHV_GUEST_VIRTUAL_ADDRESS Gva, 
_In_  WHV_TRANSLATE_GVA_FLAGS TranslateFlags, 
  _Out_ WHV_TRANSLATE_GVA_RESULT* TranslationResult, 
_Out_ WHV_GUEST_PHYSICAL_ADDRESS* Gpa 
); 
```

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
### Virtual Processor Creation

#### WHvCreateVirtualProcessor
The `WHvCreateVirtualProcessor` function creates a new virtual processor in a partition. The index of the virtual processor is used to set the APIC ID of the processor. 

```C
/*!
    \param Partition – Handle to the partition object. 
    \param VpIndex – Specifies the index of the new virtual processor. 
    \param Flags – Unused, must be zero. 
*/
HRESULT 
WHvCreateVirtualProcessor( 
    _In_ WHV_PARTITION_HANDLE Partition, 
    _In_ UINT32 VpIndex, 
    _In_ UINT32 Flags 
); 
```

### Virtual Processor Deletion

#### WHvDeleteVirtualProcessor
The `WHvDeleteVirtualProcessor` function deletes a virtual processor in a partition. 
```C
/*!
    \param Partition – Handle to the partition object. 
    \param VpIndex – Specifies the index of the virtual processor that is deleted. 
*/

HRESULT 
WHvDeleteVirtualProcessor( 
    _In_ WHV_PARTITION_HANDLE Partition, 
    _In_ UINT32 VpIndex 
); 
```

### Running a Virtual Processor
A virtual processor is executed (i.e., is enabled to run guest code) by making a call to the `WHvRunVirtualProcessor` function. A call to this function blocks synchronously until either the virtual processor executed an operation that needs to be handled by the virtualization stack (e.g., accessed memory in the GPA space that is not mapped or not accessible) or the virtualization stack explicitly request an exit of the function (e.g., to inject an interrupt for the virtual processor or to change the state of the VM).  
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
 
 /*!
    \param Partition – Handle to the partition object. 
    \param VpIndex – Specifies the index of the virtual processor that is executed. 
    \param ExitContext – Specifies the output buffer that receives the context structure providing the
         information about the reason that caused the WHvRunVirtualProcessor function to return. 
    \param ExitContextSizeInBytes – Specifies the size of the buffer that receives the exit context, 
        in bytes. The minimum buffer size required to hold the exit context can be queried with the
        WHvGetRunContextBufferSize function. 
*/
 
HRESULT 
WHvRunVirtualProcessor( 
    _In_  WHV_PARTITION_HANDLE Partition, 
    _In_  UINT32 VpIndex, 
    _Out_ VOID* ExitContext, 
    _In_  SIZE_T ExitContextSizeInBytes 
); 
```

#### WHvGetRunContextBufferSize

```C
/*! 
    \Return
        Returns the minimum size required for the buffer that receives the exit context of the WHvRunVirtualProcessor function call. The value returned by this function is constant 
        for a respective version of the DLL implementation. 
*/

UINT32 
WHvGetRunContextBufferSize(); 
```

### Canceling the Execution of a Virtual Processor

#### WHvCancelRunVirtualProcessor

Canceling the execution of a virtual processor allows an application to abort the call to run the virtual processor (WHvRunVirtualProcessor) by another thread, and to return the control to that thread. The virtualization stack can use this function to return the control of a virtual processor back to the virtualization stack in case it needs to change the state of a VM or to inject an event into the processor. 

```C
/*!
    \param Partition – Handle to the partition object. 
    \param VpIndex – Specifies the index of the virtual processor for that the execution should be stopped. 
    \param Flags – Unused, must be zero. 
*/

HRESULT 
WHvCancelRunVirtualProcessor( 
    _In_ WHV_PARTITION_HANDLE Partition, 
    _In_ UINT32 VpIndex, 
    _In_ UINT32 Flags 
); 
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
