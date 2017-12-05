# WHvGetCapability

## Syntax
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

typedef struct{
    WHV_CAPABILITY_CODE CapabilityCode;

    union {
        WHV_CAPABILITY_FEATURES Features;
        WHV_EXTENDED_VM_EXITS ExtendedVmExits;
        WHV_PROCESSOR_VENDOR ProcessorVendor; // HV_PROCESSOR_VENDOR
        WHV_PROCESSOR_FEATURES ProcessorFeatures; // HV_PARTITION_PROCESSOR_FEATURES
        UINT8 ProcessorClFlushSize;
    };
} WHV_CAPABILITY;

HRESULT
WHvGetCapability(
    _In_  WHV_CAPABILITY_CODE Capability,
    _Out_ VOID* CapabilityBuffer,
    _In_  SIZE_T CapabilityBufferSize
);
```

### Parameters

`Capability` 

Specifies the capability that is queried.

`CababilityBuffer` 

Specifies the output buffer that receives the value of the capability:

    The `WHvCapabilityCodeHypervisorPresent` capability can be used to determine whether the Hyper-V Hypervisor is running on a host and the functions of the platform APIs can be used to create VM partitions.

    The `WHvFeatures` capability is reserved for future use, it returns 0.

    For the `WHvCapabilityCodeExtendedVmExits` capability, the buffer contains a bit field that specifies which additional exit reasons are available that can be configured to cause the execution of a virtual processor to be halted (see Running a Virtual Processor).

    The values returned for the processor properties are based on the capabilities of the physical processor on the system (i.e., they are retrieved by querying the corresponding properties of the root partition.

`CapabilityBufferSize` 

Specifies the size of the output buffer, in bytes. For the currently defined set capabilities, the output buffer should be large enough to hold a 64-bit value. 

## Return Value
If the operation completed successfully, the return value is `S_OK`.

The function returns `E_WHV_UNKNOWN_CAPABILITY` if an unknown capability is requested. The functionality that corresponds to the requested capability must be treated as being not available on the system.

## Remarks
Platform capabilities are a generic way for callers to query properties and capabilities of the hypervisor, of the API implementation, and of the hardware platform that the application is running on. The platform API uses these capabilities to publish the availability of extended functionality of the API as well as the set of features that the processor on the current system supports. Applications must query the availability of a feature prior to calling the corresponding APIs or allowing a VM to use a processor feature.

