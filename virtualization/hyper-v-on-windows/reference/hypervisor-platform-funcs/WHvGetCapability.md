# WHvGetCapability
**Note: These APIs are not yet publically available and will be included in a future Windows release.  Subject to change.**


## Syntax
```C
typedef enum WHV_CAPABILITY_CODE
{
    // Capabilities of the API implementation
    WHvCapabilityCodeHypervisorPresent      = 0x00000000,
    WHvCapabilityCodeFeatures               = 0x00000001,
    WHvCapabilityCodeExtendedVmExits        = 0x00000002,

    // Capabilities of the system's processor
    WHvCapabilityCodeProcessorVendor        = 0x00001000,
    WHvCapabilityCodeProcessorFeatures      = 0x00001001,
    WHvCapabilityCodeProcessorClFlushSize   = 0x00001002
} WHV_CAPABILITY_CODE;

//
// Return values for WhvCapabilityCodeFeatures
//
typedef union WHV_CAPABILITY_FEATURES
{
    struct
    {
        UINT64 Reserved : 64;
    };

    UINT64 AsUINT64;
} WHV_CAPABILITY_FEATURES;

//
// Return values for WhvCapabilityCodeExtendedVmExits
//
typedef union WHV_EXTENDED_VM_EXITS
{
    struct
    {
        UINT64 X64CpuidExit  : 1; // RunVpExitReasonX64CPUID supported
        UINT64 X64MsrExit    : 1; // RunVpExitX64ReasonMSRAccess supported
        UINT64 ExceptionExit : 1; // RunVpExitReasonException supported
        UINT64 Reserved      : 61;
    };

    UINT64 AsUINT64;
} WHV_EXTENDED_VM_EXITS;

//
// Return values for WhvCapabilityCodeProcessorVendor
//
typedef enum WHV_PROCESSOR_VENDOR
{
    WHvProcessorVendorAmd   = 0x0000,
    WHvProcessorVendorIntel = 0x0001

} WHV_PROCESSOR_VENDOR;

//
// Return values for WhvCapabilityCodeProcessorFeatures
//
typedef union WHV_PROCESSOR_FEATURES
{
    struct
    {
        UINT64 Sse3Support : 1;
        UINT64 LahfSahfSupport : 1;
        UINT64 Ssse3Support : 1;
        UINT64 Sse4_1Support : 1;
        UINT64 Sse4_2Support : 1;
        UINT64 Sse4aSupport : 1;
        UINT64 XopSupport : 1;
        UINT64 PopCntSupport : 1;
        UINT64 Cmpxchg16bSupport : 1;
        UINT64 Altmovcr8Support : 1;
        UINT64 LzcntSupport : 1;
        UINT64 MisAlignSseSupport : 1;
        UINT64 MmxExtSupport : 1;
        UINT64 Amd3DNowSupport : 1;
        UINT64 ExtendedAmd3DNowSupport : 1;
        UINT64 Page1GbSupport : 1;
        UINT64 AesSupport : 1;
        UINT64 PclmulqdqSupport : 1;
        UINT64 PcidSupport : 1;
        UINT64 Fma4Support : 1;
        UINT64 F16CSupport : 1;
        UINT64 RdRandSupport : 1;
        UINT64 RdWrFsGsSupport : 1;
        UINT64 SmepSupport : 1;
        UINT64 EnhancedFastStringSupport : 1;
        UINT64 Bmi1Support : 1;
        UINT64 Bmi2Support : 1;
        UINT64 Reserved1 : 2;
        UINT64 MovbeSupport : 1;
        UINT64 Npiep1Support : 1;
        UINT64 DepX87FPUSaveSupport : 1;
        UINT64 RdSeedSupport : 1;
        UINT64 AdxSupport : 1;
        UINT64 IntelPrefetchSupport : 1;
        UINT64 SmapSupport : 1;
        UINT64 HleSupport : 1;
        UINT64 RtmSupport : 1;
        UINT64 RdtscpSupport : 1;
        UINT64 ClflushoptSupport : 1;
        UINT64 ClwbSupport : 1;
        UINT64 ShaSupport : 1;
        UINT64 X87PointersSavedSupport : 1;
        UINT64 Reserved2 : 21;
    };

    UINT64 AsUINT64;
} WHV_PROCESSOR_FEATURES;

//
// WHvGetCapability output buffer
//
typedef struct WHV_CAPABILITY
{
    WHV_CAPABILITY_CODE CapabilityCode;

    union
    {
        BOOL HypervisorPresent;
        WHV_CAPABILITY_FEATURES Features;
        WHV_EXTENDED_VM_EXITS ExtendedVmExits;
        WHV_PROCESSOR_VENDOR ProcessorVendor;
        WHV_PROCESSOR_FEATURES ProcessorFeatures;
        UINT8 ProcessorClFlushSize;
    };
} WHV_CAPABILITY;

HRESULT
WINAPI
WHvGetCapability(
    _In_ WHV_CAPABILITY_CODE CapabilityCode,
    _Out_writes_bytes_(CapabilityBufferSizeInBytes) VOID* CapabilityBuffer,
    _In_ UINT32 CapabilityBufferSizeInBytes
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

