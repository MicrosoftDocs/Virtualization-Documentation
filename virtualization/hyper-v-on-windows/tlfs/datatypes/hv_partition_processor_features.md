# hv_partition_processor_features

## Overview

Represents processor features that can be enabled or disabled for a partition. This structure defines hardware processor capabilities that are exposed to guest virtual processors (VPs) and can be masked during partition creation. The structure is architecture-specific and uses a banked approach to support future feature expansion.

## Syntax

```c
typedef union HV_PARTITION_PROCESSOR_FEATURES {
    UINT64 AsUINT64[2];
    
#if defined(_ARM64_)

    struct
    {
        UINT64 Asid16:1;
        UINT64 TGran16:1;
        UINT64 TGran64:1;
        UINT64 Haf:1;
        UINT64 Hdbs:1;
        UINT64 Pan:1;
        UINT64 AtS1E1:1;
        UINT64 Uao:1;
        UINT64 El0Aarch32:1;
        UINT64 Fp:1;
        UINT64 FpHp:1;
        UINT64 AdvSimd:1;
        UINT64 AdvSimdHp:1;
        UINT64 GicV3V4:1;
        UINT64 Res0:2;
        UINT64 PmuV3:1;
        UINT64 PmuV3ArmV81:1;
        UINT64 Res1:2;
        UINT64 Aes:1;
        UINT64 PolyMul:1;
        UINT64 Sha1:1;
        UINT64 Sha256:1;
        UINT64 Sha512:1;
        UINT64 Crc32:1;
        UINT64 Atomic:1;
        UINT64 Rdm:1;
        UINT64 Sha3:1;
        UINT64 Sm3:1;
        UINT64 Sm4:1;
        UINT64 Dp:1;
        UINT64 Fhm:1;
        UINT64 DcCvap:1;
        UINT64 DcCvadp:1;
        UINT64 ApaBase:1;
        UINT64 ApaEp:1;
        UINT64 ApaEp2:1;
        UINT64 ApaEp2Fp:1;
        UINT64 ApaEp2Fpc:1;
        UINT64 Jscvt:1;
        UINT64 Fcma:1;
        UINT64 RcpcV83:1;
        UINT64 RcpcV84:1;
        UINT64 Gpa:1;
        UINT64 L1ipPipt:1;
        UINT64 DzPermitted:1;
        UINT64 Ssbs:1;
        UINT64 SsbsRw:1;
        UINT64 Res2:4;
        UINT64 Csv2:1;
        UINT64 Csv3:1;
        UINT64 Sb:1;
        UINT64 Idc:1;
        UINT64 Dic:1;
        UINT64 TlbiOs:1;
        UINT64 TlbiOsRange:1;
        UINT64 FlagsM:1;
        UINT64 FlagsM2:1;
        UINT64 Bf16:1;
        UINT64 Ebf16:1;

        // Second bank starts here.
        UINT64 SveBf16:1;
        UINT64 SveEbf16:1;
        UINT64 I8mm:1;
        UINT64 SveI8mm:1;
        UINT64 Frintts:1;
        UINT64 Specres:1;
        UINT64 Res3:1;
        UINT64 Rpres:1;
        UINT64 Exs:1;
        UINT64 SpecSei:1;
        UINT64 Ets:1;
        UINT64 Afp:1;
        UINT64 Iesb:1;
        UINT64 Rng:1;
        UINT64 Lse2:1;
        UINT64 Idst:1;
        UINT64 Res4:6;
        UINT64 Ccidx:1;
        UINT64 Res5:12;
        UINT64 TtCnp:1;
        UINT64 Hpds:1;
        UINT64 Sve:1;
        UINT64 SveV2:1;
        UINT64 SveV2P1:1;
        UINT64 SpecFpacc:1;
        UINT64 SveAes:1;
        UINT64 SveBitPerm:1;
        UINT64 SveSha3:1;
        UINT64 SveSm4:1;
        UINT64 E0PD:1;
        UINT64 ReservedBank1 : 18;
    };

#else

    struct
    {
        UINT64 Sse3Support:1;
        UINT64 LahfSahfSupport:1;
        UINT64 Ssse3Support:1;
        UINT64 Sse4_1Support:1;
        UINT64 Sse4_2Support:1;
        UINT64 Sse4aSupport:1;
        UINT64 XopSupport:1;
        UINT64 PopCntSupport:1;
        UINT64 Cmpxchg16bSupport:1;
        UINT64 Altmovcr8Support:1;
        UINT64 LzcntSupport:1;
        UINT64 MisAlignSseSupport:1;
        UINT64 MmxExtSupport:1;
        UINT64 Amd3DNowSupport:1;
        UINT64 ExtendedAmd3DNowSupport:1;
        UINT64 Page1GbSupport:1;
        UINT64 AesSupport:1;
        UINT64 PclmulqdqSupport:1;
        UINT64 PcidSupport:1;
        UINT64 Fma4Support:1;
        UINT64 F16CSupport:1;
        UINT64 RdRandSupport:1;
        UINT64 RdWrFsGsSupport:1;
        UINT64 SmepSupport:1;
        UINT64 EnhancedFastStringSupport:1;
        UINT64 Bmi1Support:1;
        UINT64 Bmi2Support:1;
        UINT64 Res1:2;
        UINT64 MovbeSupport:1;
        UINT64 Npiep1Support:1;
        UINT64 DepX87FPUSaveSupport:1;
        UINT64 RdSeedSupport:1;
        UINT64 AdxSupport:1;
        UINT64 IntelPrefetchSupport:1;
        UINT64 SmapSupport:1;
        UINT64 HleSupport:1;
        UINT64 RtmSupport:1;
        UINT64 RdtscpSupport:1;
        UINT64 ClflushoptSupport:1;
        UINT64 ClwbSupport:1;
        UINT64 ShaSupport:1;
        UINT64 X87PointersSavedSupport:1;
        UINT64 InvpcidSupport:1;
        UINT64 IbrsSupport:1;
        UINT64 StibpSupport:1;
        UINT64 IbpbSupport: 1;
        UINT64 UnrestrictedGuestSupport:1;
        UINT64 Res2:1;
        UINT64 FastShortRepMovSupport:1;
        UINT64 Res3:2;
        UINT64 IbrsAllSupport:1;
        UINT64 Res4:4;
        UINT64 RdPidSupport:1;
        UINT64 UmipSupport:1;
        UINT64 MdsNoSupport : 1;
        UINT64 MdClearSupport : 1;
        UINT64 TaaNoSupport:1;
        UINT64 TsxCtrlSupport:1;
        UINT64 ReservedBank0:1;

        // Second bank starts here.
        UINT64 ACountMCountSupport:1;
        UINT64 TscInvariantSupport:1;
        UINT64 ClZeroSupport:1;
        UINT64 RdpruSupport:1;
        UINT64 La57Support:1;
        UINT64 MbecSupport:1;
        UINT64 NestedVirtSupport:1;
        UINT64 PsfdSupport:1;
        UINT64 CetSsSupport:1;
        UINT64 CetIbtSupport:1;
        UINT64 VmxExceptionInjectSupport:1;
        UINT64 Res5:1;
        UINT64 UmwaitTpauseSupport:1;
        UINT64 MovdiriSupport:1;
        UINT64 Movdir64bSupport:1;
        UINT64 CldemoteSupport:1;
        UINT64 SerializeSupport:1;
        UINT64 TscDeadlineTmrSupport:1;
        UINT64 TscAdjustSupport:1;
        UINT64 FZLRepMovsb:1;
        UINT64 FSRepStosb:1;
        UINT64 FSRepCmpsb:1;
        UINT64 TsxLdTrkSupport:1;
        UINT64 VmxInsOutsExitInfoSupport:1;
        UINT64 HlatSupport:1;
        UINT64 SbdrSsdpNoSupport:1;
        UINT64 FbsdpNoSupport:1;
        UINT64 PsdpNoSupport:1;
        UINT64 FbClearSupport:1;
        UINT64 BtcNoSupport:1;
        UINT64 IbpbRsbFlushSupport:1;
        UINT64 StibpAlwaysOnSupport:1;
        UINT64 PerfGlobalCtrlSupport:1;
        UINT64 NptExecuteOnlySupport:1;
        UINT64 NptADFlagsSupport:1;
        UINT64 Npt1GbPageSupport:1;
        UINT64 Res6:4;
        UINT64 CmpccxaddSupport:1;
        UINT64 Res7:4;
        UINT64 PrefetchISupport:1;
        UINT64 Sha512Support:1;
        UINT64 Res8:3;
        UINT64 SM3Support:1;
        UINT64 SM4Support:1;
        UINT64 Res9:2;
        UINT64 SbpbSupported:1;
        UINT64 IbpbBrTypeSupported:1;
        UINT64 SrsoNoSupported:1;
        UINT64 SrsoUserKernelNoSupported:1;
        UINT64 Res10:6;
    };

#endif

} HV_PARTITION_PROCESSOR_FEATURES;
```
## See Also

- [hv_partition_creation_properties](hv_partition_creation_properties.md)
- [HvCallCreatePartition](../hypercalls/HvCallCreatePartition.md)