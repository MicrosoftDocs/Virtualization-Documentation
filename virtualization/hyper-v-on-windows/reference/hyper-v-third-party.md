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

```C
// TODO
```

#### WHvGetPartitionProperty

```C
/*!
    \param Partition – Handle to the partition object. 
    \param Property – Specifies the property that is queried.
    \param PropertyBuffer – Specifies the output buffer that receives the value of the requested property. 
    \param PropertyBufferSizeInBytes – Specifies the size of the output buffer, in bytes. For the currently available set of properties, the buffer should be large enough to hold a 64-bit value. 
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
// TODO
```

## VM Memory Management

### Mapping GPA Ranges

#### WHvMapGpaRange

```C
// TODO
```

### Unmapping GPA Ranges

#### WHvUnmapGpaRange

```C
// TODO
```

### Translating Guest Virtual Addresses

#### WHvTranslateVirtualAddress

```C
// TODO
```

## Virtual Processor Execution

### Virtual Processor Creation

#### WHvCreateVirtualProcessor

```C
// TODO
```

### Virtual Processor Deletion

#### WHvDeleteVirtualProcessor

```C
// TODO
```

### Running a Virtual Processor

#### Exit Contexts

```C
// TODO
```

##### Memory Access

```C
// TODO
```

##### I/O Port Access

```C
// TODO
```

##### MSR Access

```C
// TODO
```

##### CPUID Access

```C
// TODO
```

##### Virtual Processor Exception

```C
// TODO
```

##### Unrecoverable Exception

```C
// TODO
```

##### Unsupported Feature

```C
// TODO
```

##### Execution Cancelled

```C
// TODO
```

#### WHvRunVirtualProcessor

```C
// TODO
```

#### WHvGetRunContextBufferSize

```C
// TODO
```

### Canceling the Execution of a Virtual Processor

#### WHvCancelRunVirtualProcessor

```C
// TODO
```

### Virtual Processor Registers

#### Data Types

```C
// TODO
```

#### WHvGetVirtualProcessorRegisters

```C
// TODO
```

#### WHvSetVirtualProcessorRegisters

```C
// TODO
```
