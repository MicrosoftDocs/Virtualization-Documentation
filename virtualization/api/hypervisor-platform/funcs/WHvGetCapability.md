# WHvGetCapability



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
    WHvCapabilityCodeProcessorClFlushSize   = 0x00001002,
    WHvCapabilityCodeProcessorXsaveFeatures = 0x00001003,
} WHV_CAPABILITY_CODE;

//
// Return values for WHvCapabilityCodeFeatures
//
typedef union WHV_CAPABILITY_FEATURES
{
    struct
    {
        UINT64 PartialUnmap : 1;
        UINT64 LocalApicEmulation : 1;
        UINT64 Xsave : 1;
        UINT64 DirtyPageTracking : 1;
        UINT64 SpeculationControl : 1;
        UINT64 Reserved : 59;
    };

    UINT64 AsUINT64;
} WHV_CAPABILITY_FEATURES;

C_ASSERT(sizeof(WHV_CAPABILITY_FEATURES) == sizeof(UINT64));

//
// Return values for WHvCapabilityCodeExtendedVmExits
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

C_ASSERT(sizeof(WHV_EXTENDED_VM_EXITS) == sizeof(UINT64));

//
// Return values for WHvCapabilityCodeProcessorVendor
//
typedef enum WHV_PROCESSOR_VENDOR
{
    WHvProcessorVendorAmd   = 0x0000,
    WHvProcessorVendorIntel = 0x0001,
    WHvProcessorVendorHygon = 0x0002

} WHV_PROCESSOR_VENDOR;

//
// Return values for WHvCapabilityCodeProcessorFeatures
//
typedef union WHV_PROCESSOR_FEATURES
{
    struct
    {
        /* CPUID.01H:ECX.SSE3[bit 0] = 1 */
        UINT64 Sse3Support : 1;
        /* CPUID.80000001H:ECX.LAHF-SAHF[bit 0] = 1 */
        UINT64 LahfSahfSupport : 1;
        /* CPUID.01H:ECX.SSSE3[bit 9] = 1 */
        UINT64 Ssse3Support : 1;
        /* CPUID.01H:ECX.SSE4_1[bit 19] = 1 */
        UINT64 Sse4_1Support : 1;
        /* CPUID.01H:ECX.SSE4_2[bit 20] = 1 */
        UINT64 Sse4_2Support : 1;
        /* CPUID.80000001H:ECX.SSE4A[bit 6] */
        UINT64 Sse4aSupport : 1;
        /* CPUID.80000001H:ECX.XOP[bit 11] */
        UINT64 XopSupport : 1;
        /* CPUID.01H:ECX.POPCNT[bit 23] = 1 */
        UINT64 PopCntSupport : 1;
        /* CPUID.01H:ECX.CMPXCHG16B[bit 13] = 1 */
        UINT64 Cmpxchg16bSupport : 1;
        /* CPUID.80000001H:ECX.AltMovCr8[bit 4] */
        UINT64 Altmovcr8Support : 1;
        /* CPUID.80000001H:ECX.LZCNT[bit 5] = 1 */
        UINT64 LzcntSupport : 1;
        /* CPUID.80000001H:ECX.MisAlignSse[bit 7] */
        UINT64 MisAlignSseSupport : 1;
        /* CPUID.80000001H:EDX.MmxExt[bit 22] */
        UINT64 MmxExtSupport : 1;
        /* CPUID.80000001H:EDX.3DNow[bit 31] */
        UINT64 Amd3DNowSupport : 1;
        /* CPUID.80000001H:EDX.3DNowExt[bit 30] */
        UINT64 ExtendedAmd3DNowSupport : 1;
        /* CPUID.80000001H:EDX.Page1GB[bit 26] = 1 */
        UINT64 Page1GbSupport : 1;
        /* CPUID.01H:ECX.AES[bit 25] */
        UINT64 AesSupport : 1;
        /* CPUID.01H:ECX.PCLMULQDQ[bit 1] = 1 */
        UINT64 PclmulqdqSupport : 1;
        /* CPUID.01H:ECX.PCID[bit 17] */
        UINT64 PcidSupport : 1;
        /* CPUID.80000001H:ECX.FMA4[bit 16] = 1 */
        UINT64 Fma4Support : 1;
        /* CPUID.01H:ECX.F16C[bit 29] = 1 */
        UINT64 F16CSupport : 1;
        /* CPUID.01H:ECX.RDRAND[bit 30] = 1 */
        UINT64 RdRandSupport : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.FSGSBASE[bit 0] */
        UINT64 RdWrFsGsSupport : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.SMEP[bit 7] */
        UINT64 SmepSupport : 1;
        /* IA32_MISC_ENABLE.FastStringsEnable[bit 0] = 1 */
        UINT64 EnhancedFastStringSupport : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.BMI1[bit 3] = 1 */
        UINT64 Bmi1Support : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.BMI2[bit 8] = 1 */
        UINT64 Bmi2Support : 1;
        UINT64 Reserved1 : 2;
        /* CPUID.01H:ECX.MOVBE[bit 22] = 1 */
        UINT64 MovbeSupport : 1;
        UINT64 Reserved : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX[bit 13] = 1 */
        UINT64 DepX87FPUSaveSupport : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.RDSEED[bit 18] = 1 */
        UINT64 RdSeedSupport : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.ADX[bit 19] */
        UINT64 AdxSupport : 1;
        /* CPUID.80000001H:ECX.PREFETCHW[bit 8] = 1 */
        UINT64 IntelPrefetchSupport : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.SMAP[bit 20] = 1 */
        UINT64 SmapSupport : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.HLE[bit 4] = 1 */
        UINT64 HleSupport : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.RTM[bit 11] = 1 */
        UINT64 RtmSupport : 1;
        /* CPUID.80000001H:EDX.RDTSCP[bit 27] = 1 */
        UINT64 RdtscpSupport : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.CLFLUSHOPT[bit 23] */
        UINT64 ClflushoptSupport : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.CLWB[bit 24] = 1 */
        UINT64 ClwbSupport : 1;
        /* CPUID.(EAX=07H, ECX=0H):EBX.SHA[bit 29] */
        UINT64 ShaSupport : 1;
        /* CPUID.80000008H:EBX[bit 2] = 1 (AMD only) */
        UINT64 X87PointersSavedSupport : 1;
        UINT64 InvpcidSupport : 1;
        UINT64 IbrsSupport : 1;
        UINT64 StibpSupport : 1;
        UINT64 IbpbSupport : 1;
        UINT64 Reserved2 : 1;
        UINT64 SsbdSupport : 1;
        UINT64 FastShortRepMovSupport : 1;
        UINT64 Reserved3 : 1;
        UINT64 RdclNo : 1;
        UINT64 IbrsAllSupport : 1;
        UINT64 Reserved4 : 1;
        UINT64 SsbNo : 1;
        UINT64 RsbANo : 1;
        UINT64 Reserved5 : 8;
    };

    UINT64 AsUINT64;
} WHV_PROCESSOR_FEATURES;

C_ASSERT(sizeof(WHV_PROCESSOR_FEATURES) == sizeof(UINT64));

typedef union _WHV_PROCESSOR_XSAVE_FEATURES
{
    struct
    {
        UINT64 XsaveSupport : 1;
        UINT64 XsaveoptSupport : 1;
        UINT64 AvxSupport : 1;
        UINT64 Avx2Support : 1;
        UINT64 FmaSupport : 1;
        UINT64 MpxSupport : 1;
        UINT64 Avx512Support : 1;
        UINT64 Avx512DQSupport : 1;
        UINT64 Avx512CDSupport : 1;
        UINT64 Avx512BWSupport : 1;
        UINT64 Avx512VLSupport : 1;
        UINT64 XsaveCompSupport : 1;
        UINT64 XsaveSupervisorSupport : 1;
        UINT64 Xcr1Support : 1;
        UINT64 Avx512BitalgSupport : 1;
        UINT64 Avx512IfmaSupport : 1;
        UINT64 Avx512VBmiSupport : 1;
        UINT64 Avx512VBmi2Support : 1;
        UINT64 Avx512VnniSupport : 1;
        UINT64 GfniSupport : 1;
        UINT64 VaesSupport : 1;
        UINT64 Avx512VPopcntdqSupport : 1;
        UINT64 VpclmulqdqSupport : 1;
        UINT64 Reserved : 41;
    };

    UINT64 AsUINT64;
} WHV_PROCESSOR_XSAVE_FEATURES, *PWHV_PROCESSOR_XSAVE_FEATURES;

C_ASSERT(sizeof(WHV_PROCESSOR_XSAVE_FEATURES) == sizeof(UINT64));

//
// WHvGetCapability output buffer
//
typedef union WHV_CAPABILITY
{
    union
    {
        BOOL HypervisorPresent;
        WHV_CAPABILITY_FEATURES Features;
        WHV_EXTENDED_VM_EXITS ExtendedVmExits;
        WHV_PROCESSOR_VENDOR ProcessorVendor;
        WHV_PROCESSOR_FEATURES ProcessorFeatures;
        WHV_PROCESSOR_XSAVE_FEATURES ProcessorXsaveFeatures;
        UINT8 ProcessorClFlushSize;
    };
} WHV_CAPABILITY;

HRESULT
WINAPI
WHvGetCapability(
    _In_ WHV_CAPABILITY_CODE CapabilityCode,
    _Out_writes_bytes_to_(CapabilityBufferSizeInBytes, *WrittenSizeInBytes) VOID* CapabilityBuffer,
    _In_ UINT32 CapabilityBufferSizeInBytes,
    _Out_opt_ UINT32 *WrittenSizeInBytes
    );
```

### Parameters

`CapabilityCode`

Specifies the capability that is queried.

`CapabilityBuffer`

Specifies the output buffer that receives the value of the capability:

The `WHvCapabilityCodeHypervisorPresent` capability can be used to determine whether the Windows Hypervisor is running on a host and the functions of the platform APIs can be used to create VM partitions.

The `WHvCapabilityCodeFeatures` capability is reserved for future use, it returns 0.

For the `WHvCapabilityCodeExtendedVmExits` capability, the buffer contains a bit field that specifies which additional exit reasons are available that can be configured to cause the execution of a virtual processor to be halted (see [`WHvRunVirtualProcessor`](WHvRunVirtualProcessor.md)).

The values returned for the processor properties are based on the capabilities of the physical processor on the system (i.e., they are retrieved by querying the corresponding properties of the root partition.

`CapabilityBufferSizeInBytes`

Specifies the size of the output buffer, in bytes. For the currently defined set capabilities, the output buffer should be large enough to hold a 64-bit value.

`WrittenSizeInBytes`

Receives the written size in bytes of the `CapabilityBuffer`.

## Return Value
If the operation completed successfully, the return value is `S_OK`.

The function returns `WHV_E_UNKNOWN_CAPABILITY` if an unknown capability is requested. The functionality that corresponds to the requested capability must be treated as being not available on the system.

## Remarks
Platform capabilities are a generic way for callers to query properties and capabilities of the hypervisor, of the API implementation, and of the hardware platform that the application is running on. The platform API uses these capabilities to publish the availability of extended functionality of the API as well as the set of features that the processor on the current system supports. Applications must query the availability of a feature prior to calling the corresponding APIs or allowing a VM to use a processor feature.

