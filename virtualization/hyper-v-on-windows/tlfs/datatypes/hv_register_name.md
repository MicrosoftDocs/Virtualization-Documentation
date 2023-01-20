---
title: HV_REGISTER_NAME
description: HV_REGISTER_NAME
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_REGISTER_NAME

Virtual processor registers are uniquely identified by register names, 32-bit numbers.

## Syntax

```c
typedef enum
{
    // Register names, see below
} HV_REGISTER_NAME;
 ```

The following table lists all register names:

| Register                               | Identifier      | Comment                              |
|----------------------------------------|-----------------|--------------------------------------|
| HvRegisterExplicitSuspend              | 0x00000000      |                                      |
| HvRegisterInterceptSuspend             | 0x00000001      |                                      |
| HvRegisterHypervisorVersion            | 0x00000100      | 128-bit, same as CPUID 0x40000002    |
| HvRegisterPrivilegesAndFeaturesInfo    | 0x00000200      | 128-bit. same as CPUID 0x40000003    |
| HvRegisterFeaturesInfo                 | 0x00000201      | 128-bit. same as CPUID 0x40000004    |
| HvRegisterImplementationLimitsInfo     | 0x00000202      | 128-bit. same as CPUID 0x40000005    |
| HvRegisterHardwareFeaturesInfo         | 0x00000203      | 128-bit. same as CPUID 0x40000006    |
| HvRegisterGuestCrashP0                 | 0x00000210      |                                      |
| HvRegisterGuestCrashP1                 | 0x00000211      |                                      |
| HvRegisterGuestCrashP2                 | 0x00000212      |                                      |
| HvRegisterGuestCrashP3                 | 0x00000213      |                                      |
| HvRegisterGuestCrashP4                 | 0x00000214      |                                      |
| HvRegisterGuestCrashCtl                | 0x00000215      |                                      |
| HvRegisterProcessorClockFrequency      | 0x00000240      |                                      |
| HvRegisterInterruptClockFrequency      | 0x00000241      |                                      |
| HvRegisterGuestIdle                    | 0x00000250      |                                      |
| HvRegisterDebugDeviceOptions           | 0x00000260      |                                      |
| HvRegisterPendingInterruption          | 0x00010002      |                                      |
| HvRegisterInterruptState               | 0x00010003      |                                      |
| HvRegisterPendingEvent0                | 0x00010004      |                                      |
| HvRegisterPendingEvent1                | 0x00010005      |                                      |
| HvRegisterPendingEvent2                | 0x00010006      |                                      |
| HvRegisterPendingEvent3                | 0x00010007      |                                      |
| HvX64RegisterRax                       | 0x00020000      |                                      |
| HvX64RegisterRcx                       | 0x00020001      |                                      |
| HvX64RegisterRdx                       | 0x00020002      |                                      |
| HvX64RegisterRbx                       | 0x00020003      |                                      |
| HvX64RegisterRsp                       | 0x00020004      |                                      |
| HvX64RegisterRbp                       | 0x00020005      |                                      |
| HvX64RegisterRsi                       | 0x00020006      |                                      |
| HvX64RegisterRdi                       | 0x00020007      |                                      |
| HvX64RegisterR8                        | 0x00020008      |                                      |
| HvX64RegisterR9                        | 0x00020009      |                                      |
| HvX64RegisterR10                       | 0x0002000A      |                                      |
| HvX64RegisterR11                       | 0x0002000B      |                                      |
| HvX64RegisterR12                       | 0x0002000C      |                                      |
| HvX64RegisterR13                       | 0x0002000D      |                                      |
| HvX64RegisterR14                       | 0x0002000E      |                                      |
| HvX64RegisterR15                       | 0x0002000F      |                                      |
| HvX64RegisterRip                       | 0x00020010      |                                      |
| HvX64RegisterRflags                    | 0x00020011      |                                      |
| HvX64RegisterXmm0                      | 0x00030000      |                                      |
| HvX64RegisterXmm1                      | 0x00030001      |                                      |
| HvX64RegisterXmm2                      | 0x00030002      |                                      |
| HvX64RegisterXmm3                      | 0x00030003      |                                      |
| HvX64RegisterXmm4                      | 0x00030004      |                                      |
| HvX64RegisterXmm5                      | 0x00030005      |                                      |
| HvX64RegisterXmm6                      | 0x00030006      |                                      |
| HvX64RegisterXmm7                      | 0x00030007      |                                      |
| HvX64RegisterXmm8                      | 0x00030008      |                                      |
| HvX64RegisterXmm9                      | 0x00030009      |                                      |
| HvX64RegisterXmm10                     | 0x0003000A      |                                      |
| HvX64RegisterXmm11                     | 0x0003000B      |                                      |
| HvX64RegisterXmm12                     | 0x0003000C      |                                      |
| HvX64RegisterXmm13                     | 0x0003000D      |                                      |
| HvX64RegisterXmm14                     | 0x0003000E      |                                      |
| HvX64RegisterXmm15                     | 0x0003000F      |                                      |
| HvX64RegisterFpMmx0                    | 0x00030010      |                                      |
| HvX64RegisterFpMmx1                    | 0x00030011      |                                      |
| HvX64RegisterFpMmx2                    | 0x00030012      |                                      |
| HvX64RegisterFpMmx3                    | 0x00030013      |                                      |
| HvX64RegisterFpMmx4                    | 0x00030014      |                                      |
| HvX64RegisterFpMmx5                    | 0x00030015      |                                      |
| HvX64RegisterFpMmx6                    | 0x00030016      |                                      |
| HvX64RegisterFpMmx7                    | 0x00030017      |                                      |
| HvX64RegisterFpControlStatus           | 0x00030018      |                                      |
| HvX64RegisterXmmControlStatus          | 0x00030019      |                                      |
| HvX64RegisterCr0                       | 0x00040000      |                                      |
| HvX64RegisterCr2                       | 0x00040001      |                                      |
| HvX64RegisterCr3                       | 0x00040002      |                                      |
| HvX64RegisterCr4                       | 0x00040003      |                                      |
| HvX64RegisterCr5                       | 0x00040004      |                                      |
| HvX64RegisterXfem                      | 0x00040005      |                                      |
| HvX64RegisterIntermediateCr0           | 0x00041000      |                                      |
| HvX64RegisterIntermediateCr4           | 0x00041003      |                                      |
| HvX64RegisterIntermediateCr8           | 0x00041004      |                                      |
| HvX64RegisterDr0                       | 0x00050000      |                                      |
| HvX64RegisterDr1                       | 0x00050001      |                                      |
| HvX64RegisterDr2                       | 0x00050002      |                                      |
| HvX64RegisterDr3                       | 0x00050003      |                                      |
| HvX64RegisterDr6                       | 0x00050004      |                                      |
| HvX64RegisterDr7                       | 0x00050005      |                                      |
| HvX64RegisterEs                        | 0x00060000      |                                      |
| HvX64RegisterCs                        | 0x00060001      |                                      |
| HvX64RegisterSs                        | 0x00060002      |                                      |
| HvX64RegisterDs                        | 0x00060003      |                                      |
| HvX64RegisterFs                        | 0x00060004      |                                      |
| HvX64RegisterGs                        | 0x00060005      |                                      |
| HvX64RegisterLdtr                      | 0x00060006      |                                      |
| HvX64RegisterTr                        | 0x00060007      |                                      |
| HvX64RegisterIdtr                      | 0x00070000      |                                      |
| HvX64RegisterGdtr                      | 0x00070001      |                                      |
| HvX64RegisterTsc                       | 0x00080000      |                                      |
| HvX64RegisterEfer                      | 0x00080001      |                                      |
| HvX64RegisterKernelGsBase              | 0x00080002      |                                      |
| HvX64RegisterApicBase                  | 0x00080003      |                                      |
| HvX64RegisterPat                       | 0x00080004      |                                      |
| HvX64RegisterSysenterCs                | 0x00080005      |                                      |
| HvX64RegisterSysenterRip               | 0x00080006      |                                      |
| HvX64RegisterSysenterRsp               | 0x00080007      |                                      |
| HvX64RegisterStar                      | 0x00080008      |                                      |
| HvX64RegisterLstar                     | 0x00080009      |                                      |
| HvX64RegisterCstar                     | 0x0008000A      |                                      |
| HvX64RegisterSfmask                    | 0x0008000B      |                                      |
| HvX64RegisterInitialApicId             | 0x0008000C      |                                      |
| HvX64RegisterMtrrCap                   | 0x0008000D      |                                      |
| HvX64RegisterMtrrDefType               | 0x0008000E      |                                      |
| HvX64RegisterMtrrPhysBase0             | 0x00080010      |                                      |
| HvX64RegisterMtrrPhysBase1             | 0x00080011      |                                      |
| HvX64RegisterMtrrPhysBase2             | 0x00080012      |                                      |
| HvX64RegisterMtrrPhysBase3             | 0x00080013      |                                      |
| HvX64RegisterMtrrPhysBase4             | 0x00080014      |                                      |
| HvX64RegisterMtrrPhysBase5             | 0x00080015      |                                      |
| HvX64RegisterMtrrPhysBase6             | 0x00080016      |                                      |
| HvX64RegisterMtrrPhysBase7             | 0x00080017      |                                      |
| HvX64RegisterMtrrPhysBase8             | 0x00080018      |                                      |
| HvX64RegisterMtrrPhysBase9             | 0x00080019      |                                      |
| HvX64RegisterMtrrPhysBaseA             | 0x0008001A      |                                      |
| HvX64RegisterMtrrPhysBaseB             | 0x0008001B      |                                      |
| HvX64RegisterMtrrPhysBaseC             | 0x0008001C      |                                      |
| HvX64RegisterMtrrPhysBaseD             | 0x0008001D      |                                      |
| HvX64RegisterMtrrPhysBaseE             | 0x0008001E      |                                      |
| HvX64RegisterMtrrPhysBaseF             | 0x0008001F      |                                      |
| HvX64RegisterMtrrPhysMask0             | 0x00080040      |                                      |
| HvX64RegisterMtrrPhysMask1             | 0x00080041      |                                      |
| HvX64RegisterMtrrPhysMask2             | 0x00080042      |                                      |
| HvX64RegisterMtrrPhysMask3             | 0x00080043      |                                      |
| HvX64RegisterMtrrPhysMask4             | 0x00080044      |                                      |
| HvX64RegisterMtrrPhysMask5             | 0x00080045      |                                      |
| HvX64RegisterMtrrPhysMask6             | 0x00080046      |                                      |
| HvX64RegisterMtrrPhysMask7             | 0x00080047      |                                      |
| HvX64RegisterMtrrPhysMask8             | 0x00080048      |                                      |
| HvX64RegisterMtrrPhysMask9             | 0x00080049      |                                      |
| HvX64RegisterMtrrPhysMaskA             | 0x0008004A      |                                      |
| HvX64RegisterMtrrPhysMaskB             | 0x0008004B      |                                      |
| HvX64RegisterMtrrPhysMaskC             | 0x0008004C      |                                      |
| HvX64RegisterMtrrPhysMaskD             | 0x0008004D      |                                      |
| HvX64RegisterMtrrPhysMaskE             | 0x0008004E      |                                      |
| HvX64RegisterMtrrPhysMaskF             | 0x0008004F      |                                      |
| HvX64RegisterMtrrFix64k00000           | 0x00080070      |                                      |
| HvX64RegisterMtrrFix16k80000           | 0x00080071      |                                      |
| HvX64RegisterMtrrFix16kA0000           | 0x00080072      |                                      |
| HvX64RegisterMtrrFix4kC0000            | 0x00080073      |                                      |
| HvX64RegisterMtrrFix4kC8000            | 0x00080074      |                                      |
| HvX64RegisterMtrrFix4kD0000            | 0x00080075      |                                      |
| HvX64RegisterMtrrFix4kD8000            | 0x00080076      |                                      |
| HvX64RegisterMtrrFix4kE0000            | 0x00080077      |                                      |
| HvX64RegisterMtrrFix4kE8000            | 0x00080078      |                                      |
| HvX64RegisterMtrrFix4kF0000            | 0x00080079      |                                      |
| HvX64RegisterMtrrFix4kF8000            | 0x0008007A      |                                      |
| HvX64RegisterTscAux                    | 0x0008007B      |                                      |
| HvX64RegisterBndcfgs                   | 0x0008007C      |                                      |
| HvX64RegisterDebugCtl                  | 0x0008007D      |                                      |
| HvX64RegisterSgxLaunchControl0         | 0x00080080      |                                      |
| HvX64RegisterSgxLaunchControl1         | 0x00080081      |                                      |
| HvX64RegisterSgxLaunchControl2         | 0x00080082      |                                      |
| HvX64RegisterSgxLaunchControl3         | 0x00080083      |                                      |
| HvX64RegisterMsrIa32MiscEnable         | 0x000800A0      |                                      |
| HvX64RegisterIa32FeatureControl        | 0x000800A1      |                                      |
| HvX64RegisterVpRuntime                 | 0x00090000      |                                      |
| HvX64RegisterHypercall                 | 0x00090001      |                                      |
| HvRegisterGuestOsId                    | 0x00090002      |                                      |
| HvRegisterVpIndex                      | 0x00090003      |                                      |
| HvRegisterTimeRefCount                 | 0x00090004      |                                      |
| HvX64RegisterEoi                       | 0x00090010      |                                      |
| HvX64RegisterIcr                       | 0x00090011      |                                      |
| HvX64RegisterTpr                       | 0x00090012      |                                      |
| HvRegisterVpAssistPage                 | 0x00090013      |                                      |
| HvRegisterReferenceTsc                 | 0x00090017      |                                      |
| HvRegisterReferenceTscSequence         | 0x0009001A      |                                      |
| HvRegisterSint0                        | 0x000A0000      |                                      |
| HvRegisterSint1                        | 0x000A0001      |                                      |
| HvRegisterSint2                        | 0x000A0002      |                                      |
| HvRegisterSint3                        | 0x000A0003      |                                      |
| HvRegisterSint4                        | 0x000A0004      |                                      |
| HvRegisterSint5                        | 0x000A0005      |                                      |
| HvRegisterSint6                        | 0x000A0006      |                                      |
| HvRegisterSint7                        | 0x000A0007      |                                      |
| HvRegisterSint8                        | 0x000A0008      |                                      |
| HvRegisterSint9                        | 0x000A0009      |                                      |
| HvRegisterSint10                       | 0x000A000A      |                                      |
| HvRegisterSint11                       | 0x000A000B      |                                      |
| HvRegisterSint12                       | 0x000A000C      |                                      |
| HvRegisterSint13                       | 0x000A000D      |                                      |
| HvRegisterSint14                       | 0x000A000E      |                                      |
| HvRegisterSint15                       | 0x000A000F      |                                      |
| HvRegisterScontrol                     | 0x000A0010      |                                      |
| HvRegisterSversion                     | 0x000A0011      |                                      |
| HvRegisterSifp                         | 0x000A0012      |                                      |
| HvRegisterSipp                         | 0x000A0013      |                                      |
| HvRegisterEom                          | 0x000A0014      |                                      |
| HvRegisterSirbp                        | 0x000A0015      |                                      |
| HvRegisterStimer0Config                | 0x000B0000      |                                      |
| HvRegisterStimer0Count                 | 0x000B0001      |                                      |
| HvRegisterStimer1Config                | 0x000B0002      |                                      |
| HvRegisterStimer1Count                 | 0x000B0003      |                                      |
| HvRegisterStimer2Config                | 0x000B0004      |                                      |
| HvRegisterStimer2Count                 | 0x000B0005      |                                      |
| HvRegisterStimer3Config                | 0x000B0006      |                                      |
| HvRegisterStimer3Count                 | 0x000B0007      |                                      |
| HvRegisterStimeUnhaltedTimerConfig     | 0x000B0100      |                                      |
| HvRegisterStimeUnhaltedTimerCount      | 0x000B0101      |                                      |
| HvX64RegisterYmm0Low                   | 0x000C0000      |                                      |
| HvX64RegisterYmm1Low                   | 0x000C0001      |                                      |
| HvX64RegisterYmm2Low                   | 0x000C0002      |                                      |
| HvX64RegisterYmm3Low                   | 0x000C0003      |                                      |
| HvX64RegisterYmm4Low                   | 0x000C0004      |                                      |
| HvX64RegisterYmm5Low                   | 0x000C0005      |                                      |
| HvX64RegisterYmm6Low                   | 0x000C0006      |                                      |
| HvX64RegisterYmm7Low                   | 0x000C0007      |                                      |
| HvX64RegisterYmm8Low                   | 0x000C0008      |                                      |
| HvX64RegisterYmm9Low                   | 0x000C0009      |                                      |
| HvX64RegisterYmm10Low                  | 0x000C000A      |                                      |
| HvX64RegisterYmm11Low                  | 0x000C000B      |                                      |
| HvX64RegisterYmm12Low                  | 0x000C000C      |                                      |
| HvX64RegisterYmm13Low                  | 0x000C000D      |                                      |
| HvX64RegisterYmm14Low                  | 0x000C000E      |                                      |
| HvX64RegisterYmm15Low                  | 0x000C000F      |                                      |
| HvX64RegisterYmm0High                  | 0x000C0010      |                                      |
| HvX64RegisterYmm1High                  | 0x000C0011      |                                      |
| HvX64RegisterYmm2High                  | 0x000C0012      |                                      |
| HvX64RegisterYmm3High                  | 0x000C0013      |                                      |
| HvX64RegisterYmm4High                  | 0x000C0014      |                                      |
| HvX64RegisterYmm5High                  | 0x000C0015      |                                      |
| HvX64RegisterYmm6High                  | 0x000C0016      |                                      |
| HvX64RegisterYmm7High                  | 0x000C0017      |                                      |
| HvX64RegisterYmm8High                  | 0x000C0018      |                                      |
| HvX64RegisterYmm9High                  | 0x000C0019      |                                      |
| HvX64RegisterYmm10High                 | 0x000C001A      |                                      |
| HvX64RegisterYmm11High                 | 0x000C001B      |                                      |
| HvX64RegisterYmm12High                 | 0x000C001C      |                                      |
| HvX64RegisterYmm13High                 | 0x000C001D      |                                      |
| HvX64RegisterYmm14High                 | 0x000C001E      |                                      |
| HvX64RegisterYmm15High                 | 0x000C001F      |                                      |
| HvRegisterVsmCodePageOffsets           | 0x000D0002      |                                      |
| HvRegisterVsmVpStatus                  | 0x000D0003      |                                      |
| HvRegisterVsmPartitionStatus           | 0x000D0004      |                                      |
| HvRegisterVsmVina                      | 0x000D0005      |                                      |
| HvRegisterVsmCapabilities              | 0x000D0006      |                                      |
| HvRegisterVsmPartitionConfig           | 0x000D0007      |                                      |
| HvRegisterVsmVpSecureConfigVtl0        | 0x000D0010      |                                      |
| HvRegisterVsmVpSecureConfigVtl1        | 0x000D0011      |                                      |
| HvRegisterVsmVpSecureConfigVtl2        | 0x000D0012      |                                      |
| HvRegisterVsmVpSecureConfigVtl3        | 0x000D0013      |                                      |
| HvRegisterVsmVpSecureConfigVtl4        | 0x000D0014      |                                      |
| HvRegisterVsmVpSecureConfigVtl5        | 0x000D0015      |                                      |
| HvRegisterVsmVpSecureConfigVtl6        | 0x000D0016      |                                      |
| HvRegisterVsmVpSecureConfigVtl7        | 0x000D0017      |                                      |
| HvRegisterVsmVpSecureConfigVtl8        | 0x000D0018      |                                      |
| HvRegisterVsmVpSecureConfigVtl9        | 0x000D0019      |                                      |
| HvRegisterVsmVpSecureConfigVtl10       | 0x000D001A      |                                      |
| HvRegisterVsmVpSecureConfigVtl11       | 0x000D001B      |                                      |
| HvRegisterVsmVpSecureConfigVtl12       | 0x000D001C      |                                      |
| HvRegisterVsmVpSecureConfigVtl13       | 0x000D001D      |                                      |
| HvRegisterVsmVpSecureConfigVtl14       | 0x000D001E      |                                      |
| HvRegisterVsmVpWaitForTlbLock          | 0x000D0020      |                                      |
