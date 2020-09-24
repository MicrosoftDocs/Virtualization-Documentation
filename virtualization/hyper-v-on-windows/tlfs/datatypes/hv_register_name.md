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
| HvX64RegisterEs                        | 0x00060001      |                                      |
| HvX64RegisterEs                        | 0x00060002      |                                      |
| HvX64RegisterCs                        | 0x00060003      |                                      |
| HvX64RegisterSs                        | 0x00060004      |                                      |
| HvX64RegisterDs                        | 0x00060005      |                                      |
| HvX64RegisterFs                        | 0x00060006      |                                      |
| HvX64RegisterGs                        | 0x00060007      |                                      |
| HvX64RegisterLdtr                      | 0x00070000      |                                      |
| HvX64RegisterTr                        | 0x00070001      |                                      |
