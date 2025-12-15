---
title: HV_REGISTER_NAME
description: HV_REGISTER_NAME
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference
---

# HV_REGISTER_NAME

Virtual processor registers are uniquely identified by register names (32-bit identifiers).
## Syntax

```c
typedef enum
{
    // Register names, see below
} HV_REGISTER_NAME;
 ```

## Common Registers (Architecture Neutral)

### Suspend / Migration
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterExplicitSuspend | 0x00000000 | Explicit VP suspend (set/clear by caller) |
| HvRegisterInterceptSuspend | 0x00000001 | VP suspended due to intercept / hypervisor action |
| HvRegisterInstructionEmulationHints | 0x00000002 | Instruction emulation hints / statistics (if supported) |
| HvRegisterDispatchSuspend | 0x00000003 | Scheduler dispatch induced suspension |
| HvRegisterInternalActivityState | 0x00000004 | Internal state summary (read-only) |

### Version & Feature Discovery (128-bit unless noted)
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterHypervisorVersion | 0x00000100 | Matches CPUID 0x40000002 |
| HvRegisterPrivilegesAndFeaturesInfo | 0x00000200 | Matches CPUID 0x40000003 |
| HvRegisterFeaturesInfo | 0x00000201 | Matches CPUID 0x40000004 |
| HvRegisterImplementationLimitsInfo | 0x00000202 | Matches CPUID 0x40000005 |
| HvRegisterHardwareFeaturesInfo | 0x00000203 | Matches CPUID 0x40000006 |
| HvRegisterCpuManagementFeaturesInfo | 0x00000204 | Matches CPUID 0x40000007 |
| HvRegisterPasidFeaturesInfo | 0x00000205 | Matches CPUID 0x40000008 |
| HvRegisterNestedVirtFeaturesInfo | 0x00000207 | Matches CPUID 0x4000000A |
| HvRegisterIptFeaturesInfo | 0x00000208 | Matches CPUID 0x4000000B |

### Guest Crash Registers
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterGuestCrashP0 | 0x00000210 | Crash parameter 0 |
| HvRegisterGuestCrashP1 | 0x00000211 | Crash parameter 1 |
| HvRegisterGuestCrashP2 | 0x00000212 | Crash parameter 2 |
| HvRegisterGuestCrashP3 | 0x00000213 | Crash parameter 3 |
| HvRegisterGuestCrashP4 | 0x00000214 | Crash parameter 4 |
| HvRegisterGuestCrashCtl | 0x00000215 | Crash control / notification |

### Frequency / Timing
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterProcessorClockFrequency | 0x00000240 | Nominal core frequency (kHz) |
| HvRegisterInterruptClockFrequency | 0x00000241 | Timer frequency (kHz) |

### Idle & Debug
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterGuestIdle | 0x00000250 | Guest idle hint / residency info |
| HvRegisterDebugDeviceOptions | 0x00000260 | Debug / device options |
| HvRegisterMemoryZeroingControl | 0x00000270 | Memory zeroing behavior control |

### Pending Events & Interrupt State (common encodings differ per arch)
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterPendingEvent0 | 0x00010004 | Pending event slot 0 |
| HvRegisterPendingEvent1 | 0x00010005 | Pending event slot 1 |
| HvRegisterDeliverabilityNotifications | 0x00010006 | Deliverability notification bitmap |
| HvRegisterPendingEvent2 | 0x00010008 | Pending event slot 2 |
| HvRegisterPendingEvent3 | 0x00010009 | Pending event slot 3 |

### Runtime / Context
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterVpRuntime | 0x00090000 | VP runtime (time units) |
| HvRegisterGuestOsId | 0x00090002 | Guest OS identification |
| HvRegisterVpIndex | 0x00090003 | VP index (read-only) |
| HvRegisterTimeRefCount | 0x00090004 | Time reference counter |
| HvRegisterCpuManagementVersion | 0x00090007 | CPU management interface version |
| HvRegisterVpAssistPage | 0x00090013 | VP assist page GPA |
| HvRegisterVpRootSignalCount | 0x00090014 | Root signal count |
| HvRegisterReferenceTsc | 0x00090017 | Reference TSC page GPA |
| HvRegisterReferenceTscSequence | 0x0009001A | Reference TSC sequence |
| HvRegisterNestedVpIndex | 0x00091003 | Nested VP index |

### Performance Statistics
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterStatsPartitionRetail | 0x00090020 | Partition stats (retail subset) |
| HvRegisterStatsVpRetail | 0x00090022 | VP stats (retail) |

### Synthetic Interrupt Controller (SynIC) – Primary
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterSint0 | 0x000A0000 | Synthetic interrupt vector 0 |
| HvRegisterSint1 | 0x000A0001 | Synthetic interrupt vector 1 |
| HvRegisterSint2 | 0x000A0002 | Synthetic interrupt vector 2 |
| HvRegisterSint3 | 0x000A0003 | Synthetic interrupt vector 3 |
| HvRegisterSint4 | 0x000A0004 | Synthetic interrupt vector 4 |
| HvRegisterSint5 | 0x000A0005 | Synthetic interrupt vector 5 |
| HvRegisterSint6 | 0x000A0006 | Synthetic interrupt vector 6 |
| HvRegisterSint7 | 0x000A0007 | Synthetic interrupt vector 7 |
| HvRegisterSint8 | 0x000A0008 | Synthetic interrupt vector 8 |
| HvRegisterSint9 | 0x000A0009 | Synthetic interrupt vector 9 |
| HvRegisterSint10 | 0x000A000A | Synthetic interrupt vector 10 |
| HvRegisterSint11 | 0x000A000B | Synthetic interrupt vector 11 |
| HvRegisterSint12 | 0x000A000C | Synthetic interrupt vector 12 |
| HvRegisterSint13 | 0x000A000D | Synthetic interrupt vector 13 |
| HvRegisterSint14 | 0x000A000E | Synthetic interrupt vector 14 |
| HvRegisterSint15 | 0x000A000F | Synthetic interrupt vector 15 |
| HvRegisterScontrol | 0x000A0010 | SynIC control |
| HvRegisterSversion | 0x000A0011 | SynIC version |
| HvRegisterSifp | 0x000A0012 | SynIC EOI/FIFO page |
| HvRegisterSipp | 0x000A0013 | SynIC interrupt parameter page |
| HvRegisterEom | 0x000A0014 | End-of-message |
| HvRegisterSirbp | 0x000A0015 | Resend bitmap pointer |

### Synthetic Timers
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterStimer0Config | 0x000B0000 | Timer 0 config |
| HvRegisterStimer0Count | 0x000B0001 | Timer 0 count |
| HvRegisterStimer1Config | 0x000B0002 | Timer 1 config |
| HvRegisterStimer1Count | 0x000B0003 | Timer 1 count |
| HvRegisterStimer2Config | 0x000B0004 | Timer 2 config |
| HvRegisterStimer2Count | 0x000B0005 | Timer 2 count |
| HvRegisterStimer3Config | 0x000B0006 | Timer 3 config |
| HvRegisterStimer3Count | 0x000B0007 | Timer 3 count |
| HvRegisterStimeUnhaltedTimerConfig | 0x000B0100 | Unhalted timer config |
| HvRegisterStimeUnhaltedTimerCount | 0x000B0101 | Unhalted timer count |

### Virtual Secure Mode (VSM) / Isolation
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterVsmCodePageOffsets | 0x000D0002 | VSM code page offsets |
| HvRegisterVsmVpStatus | 0x000D0003 | VSM VP status |
| HvRegisterVsmPartitionStatus | 0x000D0004 | VSM partition status |
| HvRegisterVsmVina | 0x000D0005 | VSM VINA |
| HvRegisterVsmCapabilities | 0x000D0006 | VSM capability bits |
| HvRegisterVsmPartitionConfig | 0x000D0007 | VSM partition config |
| HvRegisterVsmVpSecureConfigVtl0 | 0x000D0010 | Secure config VTL0 |
| HvRegisterVsmVpSecureConfigVtl1 | 0x000D0011 | Secure config VTL1 |
| HvRegisterVsmVpSecureConfigVtl2 | 0x000D0012 | Secure config VTL2 |
| HvRegisterVsmVpSecureConfigVtl3 | 0x000D0013 | Secure config VTL3 |
| HvRegisterVsmVpSecureConfigVtl4 | 0x000D0014 | Secure config VTL4 |
| HvRegisterVsmVpSecureConfigVtl5 | 0x000D0015 | Secure config VTL5 |
| HvRegisterVsmVpSecureConfigVtl6 | 0x000D0016 | Secure config VTL6 |
| HvRegisterVsmVpSecureConfigVtl7 | 0x000D0017 | Secure config VTL7 |
| HvRegisterVsmVpSecureConfigVtl8 | 0x000D0018 | Secure config VTL8 |
| HvRegisterVsmVpSecureConfigVtl9 | 0x000D0019 | Secure config VTL9 |
| HvRegisterVsmVpSecureConfigVtl10 | 0x000D001A | Secure config VTL10 |
| HvRegisterVsmVpSecureConfigVtl11 | 0x000D001B | Secure config VTL11 |
| HvRegisterVsmVpSecureConfigVtl12 | 0x000D001C | Secure config VTL12 |
| HvRegisterVsmVpSecureConfigVtl13 | 0x000D001D | Secure config VTL13 |
| HvRegisterVsmVpSecureConfigVtl14 | 0x000D001E | Secure config VTL14 |
| HvRegisterVsmVpWaitForTlbLock | 0x000D0020 | Wait for TLB lock (synchronization) |
| HvRegisterIsolationCapabilities | 0x000D0100 | Isolation capability bits |

## x64 Architecture Registers

### Interrupt & Pending State (x64 additions)
| Register | Identifier | Comment |
|----------|------------|---------|
| HvRegisterPendingInterruption | 0x00010002 | Pending interruption descriptor |
| HvRegisterInterruptState | 0x00010003 | Interrupt state flags |
| HvX64RegisterPendingDebugException | 0x00010007 | Pending debug exception info |

### General Purpose & Instruction State
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterRax | 0x00020000 | RAX |
| HvX64RegisterRcx | 0x00020001 | RCX |
| HvX64RegisterRdx | 0x00020002 | RDX |
| HvX64RegisterRbx | 0x00020003 | RBX |
| HvX64RegisterRsp | 0x00020004 | RSP |
| HvX64RegisterRbp | 0x00020005 | RBP |
| HvX64RegisterRsi | 0x00020006 | RSI |
| HvX64RegisterRdi | 0x00020007 | RDI |
| HvX64RegisterR8 | 0x00020008 | R8 |
| HvX64RegisterR9 | 0x00020009 | R9 |
| HvX64RegisterR10 | 0x0002000A | R10 |
| HvX64RegisterR11 | 0x0002000B | R11 |
| HvX64RegisterR12 | 0x0002000C | R12 |
| HvX64RegisterR13 | 0x0002000D | R13 |
| HvX64RegisterR14 | 0x0002000E | R14 |
| HvX64RegisterR15 | 0x0002000F | R15 |
| HvX64RegisterRip | 0x00020010 | RIP |
| HvX64RegisterRflags | 0x00020011 | RFLAGS |

### Floating Point / SIMD
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterXmm0 | 0x00030000 | XMM0 |
| HvX64RegisterXmm1 | 0x00030001 | XMM1 |
| HvX64RegisterXmm2 | 0x00030002 | XMM2 |
| HvX64RegisterXmm3 | 0x00030003 | XMM3 |
| HvX64RegisterXmm4 | 0x00030004 | XMM4 |
| HvX64RegisterXmm5 | 0x00030005 | XMM5 |
| HvX64RegisterXmm6 | 0x00030006 | XMM6 |
| HvX64RegisterXmm7 | 0x00030007 | XMM7 |
| HvX64RegisterXmm8 | 0x00030008 | XMM8 |
| HvX64RegisterXmm9 | 0x00030009 | XMM9 |
| HvX64RegisterXmm10 | 0x0003000A | XMM10 |
| HvX64RegisterXmm11 | 0x0003000B | XMM11 |
| HvX64RegisterXmm12 | 0x0003000C | XMM12 |
| HvX64RegisterXmm13 | 0x0003000D | XMM13 |
| HvX64RegisterXmm14 | 0x0003000E | XMM14 |
| HvX64RegisterXmm15 | 0x0003000F | XMM15 |
| HvX64RegisterFpMmx0 | 0x00030010 | ST0 / MMX0 |
| HvX64RegisterFpMmx1 | 0x00030011 | ST1 / MMX1 |
| HvX64RegisterFpMmx2 | 0x00030012 | ST2 / MMX2 |
| HvX64RegisterFpMmx3 | 0x00030013 | ST3 / MMX3 |
| HvX64RegisterFpMmx4 | 0x00030014 | ST4 / MMX4 |
| HvX64RegisterFpMmx5 | 0x00030015 | ST5 / MMX5 |
| HvX64RegisterFpMmx6 | 0x00030016 | ST6 / MMX6 |
| HvX64RegisterFpMmx7 | 0x00030017 | ST7 / MMX7 |
| HvX64RegisterFpControlStatus | 0x00030018 | x87 control/status |
| HvX64RegisterXmmControlStatus | 0x00030019 | MXCSR |

### Control & Intermediate Control Registers
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterCr0 | 0x00040000 | CR0 |
| HvX64RegisterCr2 | 0x00040001 | CR2 |
| HvX64RegisterCr3 | 0x00040002 | CR3 |
| HvX64RegisterCr4 | 0x00040003 | CR4 |
| HvX64RegisterCr8 | 0x00040004 | CR8 |
| HvX64RegisterXfem | 0x00040005 | Extended feature enable mask |
| HvX64RegisterIntermediateCr0 | 0x00041000 | Virtualization shadow CR0 |
| HvX64RegisterIntermediateCr4 | 0x00041003 | Virtualization shadow CR4 |
| HvX64RegisterIntermediateCr8 | 0x00041004 | Virtualization shadow CR8 |

### Debug Registers
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterDr0 | 0x00050000 | DR0 |
| HvX64RegisterDr1 | 0x00050001 | DR1 |
| HvX64RegisterDr2 | 0x00050002 | DR2 |
| HvX64RegisterDr3 | 0x00050003 | DR3 |
| HvX64RegisterDr6 | 0x00050004 | DR6 |
| HvX64RegisterDr7 | 0x00050005 | DR7 |

### Segment Registers
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterEs | 0x00060000 | ES |
| HvX64RegisterCs | 0x00060001 | CS |
| HvX64RegisterSs | 0x00060002 | SS |
| HvX64RegisterDs | 0x00060003 | DS |
| HvX64RegisterFs | 0x00060004 | FS |
| HvX64RegisterGs | 0x00060005 | GS |
| HvX64RegisterLdtr | 0x00060006 | LDTR |
| HvX64RegisterTr | 0x00060007 | Task register |

### Table Registers
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterIdtr | 0x00070000 | IDT descriptor |
| HvX64RegisterGdtr | 0x00070001 | GDT descriptor |

### Virtualized MSRs – Core & System
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterTsc | 0x00080000 | TSC |
| HvX64RegisterEfer | 0x00080001 | EFER |
| HvX64RegisterKernelGsBase | 0x00080002 | KERNEL_GS_BASE |
| HvX64RegisterApicBase | 0x00080003 | APIC_BASE |
| HvX64RegisterPat | 0x00080004 | PAT |
| HvX64RegisterSysenterCs | 0x00080005 | SYSENTER_CS |
| HvX64RegisterSysenterEip | 0x00080006 | SYSENTER_EIP |
| HvX64RegisterSysenterEsp | 0x00080007 | SYSENTER_ESP |
| HvX64RegisterStar | 0x00080008 | STAR |
| HvX64RegisterLstar | 0x00080009 | LSTAR |
| HvX64RegisterCstar | 0x0008000A | CSTAR |
| HvX64RegisterSfmask | 0x0008000B | SFMASK |
| HvX64RegisterInitialApicId | 0x0008000C | Initial APIC ID |

### Cache Control (MTRR Set)
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterMsrMtrrCap | 0x0008000D | MTRR capability |
| HvX64RegisterMsrMtrrDefType | 0x0008000E | Default type |
| HvX64RegisterMsrMtrrPhysBase0 | 0x00080010 | Variable range base 0 |
| HvX64RegisterMsrMtrrPhysBase1 | 0x00080011 | Variable range base 1 |
| HvX64RegisterMsrMtrrPhysBase2 | 0x00080012 | Variable range base 2 |
| HvX64RegisterMsrMtrrPhysBase3 | 0x00080013 | Variable range base 3 |
| HvX64RegisterMsrMtrrPhysBase4 | 0x00080014 | Variable range base 4 |
| HvX64RegisterMsrMtrrPhysBase5 | 0x00080015 | Variable range base 5 |
| HvX64RegisterMsrMtrrPhysBase6 | 0x00080016 | Variable range base 6 |
| HvX64RegisterMsrMtrrPhysBase7 | 0x00080017 | Variable range base 7 |
| HvX64RegisterMsrMtrrPhysBase8 | 0x00080018 | Variable range base 8 |
| HvX64RegisterMsrMtrrPhysBase9 | 0x00080019 | Variable range base 9 |
| HvX64RegisterMsrMtrrPhysBaseA | 0x0008001A | Variable range base A |
| HvX64RegisterMsrMtrrPhysBaseB | 0x0008001B | Variable range base B |
| HvX64RegisterMsrMtrrPhysBaseC | 0x0008001C | Variable range base C |
| HvX64RegisterMsrMtrrPhysBaseD | 0x0008001D | Variable range base D |
| HvX64RegisterMsrMtrrPhysBaseE | 0x0008001E | Variable range base E |
| HvX64RegisterMsrMtrrPhysBaseF | 0x0008001F | Variable range base F |
| HvX64RegisterMsrMtrrPhysMask0 | 0x00080040 | Variable range mask 0 |
| HvX64RegisterMsrMtrrPhysMask1 | 0x00080041 | Variable range mask 1 |
| HvX64RegisterMsrMtrrPhysMask2 | 0x00080042 | Variable range mask 2 |
| HvX64RegisterMsrMtrrPhysMask3 | 0x00080043 | Variable range mask 3 |
| HvX64RegisterMsrMtrrPhysMask4 | 0x00080044 | Variable range mask 4 |
| HvX64RegisterMsrMtrrPhysMask5 | 0x00080045 | Variable range mask 5 |
| HvX64RegisterMsrMtrrPhysMask6 | 0x00080046 | Variable range mask 6 |
| HvX64RegisterMsrMtrrPhysMask7 | 0x00080047 | Variable range mask 7 |
| HvX64RegisterMsrMtrrPhysMask8 | 0x00080048 | Variable range mask 8 |
| HvX64RegisterMsrMtrrPhysMask9 | 0x00080049 | Variable range mask 9 |
| HvX64RegisterMsrMtrrPhysMaskA | 0x0008004A | Variable range mask A |
| HvX64RegisterMsrMtrrPhysMaskB | 0x0008004B | Variable range mask B |
| HvX64RegisterMsrMtrrPhysMaskC | 0x0008004C | Variable range mask C |
| HvX64RegisterMsrMtrrPhysMaskD | 0x0008004D | Variable range mask D |
| HvX64RegisterMsrMtrrPhysMaskE | 0x0008004E | Variable range mask E |
| HvX64RegisterMsrMtrrPhysMaskF | 0x0008004F | Variable range mask F |
| HvX64RegisterMsrMtrrFix64k00000 | 0x00080070 | Fixed range |
| HvX64RegisterMsrMtrrFix16k80000 | 0x00080071 | Fixed range |
| HvX64RegisterMsrMtrrFix16kA0000 | 0x00080072 | Fixed range |
| HvX64RegisterMsrMtrrFix4kC0000 | 0x00080073 | Fixed 4K C0000 |
| HvX64RegisterMsrMtrrFix4kC8000 | 0x00080074 | Fixed 4K C8000 |
| HvX64RegisterMsrMtrrFix4kD0000 | 0x00080075 | Fixed 4K D0000 |
| HvX64RegisterMsrMtrrFix4kD8000 | 0x00080076 | Fixed 4K D8000 |
| HvX64RegisterMsrMtrrFix4kE0000 | 0x00080077 | Fixed 4K E0000 |
| HvX64RegisterMsrMtrrFix4kE8000 | 0x00080078 | Fixed 4K E8000 |
| HvX64RegisterMsrMtrrFix4kF0000 | 0x00080079 | Fixed 4K F0000 |
| HvX64RegisterMsrMtrrFix4kF8000 | 0x0008007A | Fixed 4K F8000 |

### Additional Virtualized MSRs & Controls
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterTscAux | 0x0008007B | TSC_AUX |
| HvX64RegisterBndcfgs | 0x0008007C | MPX BNDcfgs |
| HvX64RegisterDebugCtl | 0x0008007D | DEBUGCTL |
| HvX64RegisterMCount | 0x0008007E | Machine count (internal) |
| HvX64RegisterACount | 0x0008007F | Auxiliary count (internal) |
| HvX64RegisterSgxLaunchControl0 | 0x00080080 | SGX launch control 0 |
| HvX64RegisterSgxLaunchControl1 | 0x00080081 | SGX launch control 1 |
| HvX64RegisterSgxLaunchControl2 | 0x00080082 | SGX launch control 2 |
| HvX64RegisterSgxLaunchControl3 | 0x00080083 | SGX launch control 3 |
| HvX64RegisterSpecCtrl | 0x00080084 | IA32_SPEC_CTRL |
| HvX64RegisterPredCmd | 0x00080085 | IA32_PRED_CMD |
| HvX64RegisterVirtSpecCtrl | 0x00080086 | Virtual spec control |
| HvX64RegisterTscVirtualOffset | 0x00080087 | Virtual TSC offset |
| HvX64RegisterTsxCtrl | 0x00080088 | TSX control |
| HvX64RegisterXss | 0x0008008B | IA32_XSS |
| HvX64RegisterUCet | 0x0008008C | User CET |
| HvX64RegisterSCet | 0x0008008D | Supervisor CET |
| HvX64RegisterSsp | 0x0008008E | Shadow stack pointer |
| HvX64RegisterPl0Ssp | 0x0008008F | PL0 shadow stack pointer |
| HvX64RegisterPl1Ssp | 0x00080090 | PL1 shadow stack pointer |
| HvX64RegisterPl2Ssp | 0x00080091 | PL2 shadow stack pointer |
| HvX64RegisterPl3Ssp | 0x00080092 | PL3 shadow stack pointer |
| HvX64RegisterInterruptSspTableAddr | 0x00080093 | IST-like SSP table |
| HvX64RegisterTscDeadline | 0x00080095 | TSC deadline |
| HvX64RegisterTscAdjust | 0x00080096 | TSC adjust |
| HvX64RegisterUmwaitControl | 0x00080098 | UMWAIT/TPAUSE control |
| HvX64RegisterXfd | 0x00080099 | XFD |
| HvX64RegisterXfdErr | 0x0008009A | XFD error status |

### Feature / Nested Virtualization Capability MSRs
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterMsrIa32MiscEnable | 0x000800A0 | IA32_MISC_ENABLE |
| HvX64RegisterIa32FeatureControl | 0x000800A1 | IA32_FEATURE_CONTROL |
| HvX64RegisterIa32VmxBasic | 0x000800A2 | VMX Basic |
| HvX64RegisterIa32VmxPinbasedCtls | 0x000800A3 | VMX Pinbased controls |
| HvX64RegisterIa32VmxExitCtls | 0x000800A5 | VMX Exit controls |
| HvX64RegisterIa32VmxEntryCtls | 0x000800A6 | VMX Entry controls |
| HvX64RegisterIa32VmxMisc | 0x000800A7 | VMX misc |
| HvX64RegisterIa32VmxCr0Fixed0 | 0x000800A8 | VMX CR0 fixed0 |
| HvX64RegisterIa32VmxCr0Fixed1 | 0x000800A9 | VMX CR0 fixed1 |
| HvX64RegisterIa32VmxCr4Fixed0 | 0x000800AA | VMX CR4 fixed0 |
| HvX64RegisterIa32VmxCr4Fixed1 | 0x000800AB | VMX CR4 fixed1 |
| HvX64RegisterIa32VmxVmcsEnum | 0x000800AC | VMX VMCS enum |
| HvX64RegisterIa32VmxProcbasedCtls2 | 0x000800AD | Secondary proc-based controls |
| HvX64RegisterIa32VmxEptVpidCap | 0x000800AE | EPT/VPID capabilities |
| HvX64RegisterIa32VmxTruePinbasedCtls | 0x000800AF | VMX True pinbased controls |
| HvX64RegisterIa32VmxTrueProcbasedCtls | 0x000800B0 | VMX True primary proc-based controls |
| HvX64RegisterIa32VmxTrueExitCtls | 0x000800B1 | VMX True exit controls |
| HvX64RegisterIa32VmxTrueEntryCtls | 0x000800B2 | VMX True entry controls |
| HvX64RegisterAmdVmHsavePa | 0x000800B3 | SVM HSAVE PA |
| HvX64RegisterAmdVmCr | 0x000800B4 | SVM VM_CR |

### Performance Monitoring & Tracing
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterPerfGlobalCtrl | 0x00081000 | Perf global control |
| HvX64RegisterPerfGlobalStatus | 0x00081001 | Perf global status |
| HvX64RegisterPerfGlobalInUse | 0x00081002 | Perf in-use mask |
| HvX64RegisterFixedCtrCtrl | 0x00081003 | Fixed counter control |
| HvX64RegisterDsArea | 0x00081004 | DS area base |
| HvX64RegisterPebsEnable | 0x00081005 | PEBS enable |
| HvX64RegisterPebsLdLat | 0x00081006 | PEBS load latency |
| HvX64RegisterPebsFrontend | 0x00081007 | PEBS frontend |
| HvX64RegisterRtitCtl | 0x00081008 | PT control |
| HvX64RegisterRtitStatus | 0x00081009 | PT status |
| HvX64RegisterRtitOutputBase | 0x0008100A | PT output base |
| HvX64RegisterRtitOutputMaskPtrs | 0x0008100B | PT output mask/ptrs |
| HvX64RegisterRtitCr3Match | 0x0008100C | PT CR3 match |
| HvX64RegisterPerfEvtSel0 | 0x00081100 | First programmable event select |
| HvX64RegisterPmc0 | 0x00081200 | First PMC |
| HvX64RegisterFixedCtr0 | 0x00081300 | Fixed counter 0 |
| HvX64RegisterLbrTos | 0x00082000 | LBR top of stack |
| HvX64RegisterLbrSelect | 0x00082001 | LBR select |
| HvX64RegisterLerFromLip | 0x00082002 | Last exception from |
| HvX64RegisterLerToLip | 0x00082003 | Last exception to |
| HvX64RegisterLbrFrom0 | 0x00082100 | LBR from 0 |
| HvX64RegisterLbrTo0 | 0x00082200 | LBR to 0 |
| HvX64RegisterLbrInfo0 | 0x00083300 | LBR info 0 |

### APIC (x2APIC Mapped) Registers
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterApicId | 0x00084802 | APIC ID |
| HvX64RegisterApicVersion | 0x00084803 | APIC version |
| HvX64RegisterApicTpr | 0x00084808 | Task priority |
| HvX64RegisterApicPpr | 0x0008480A | Processor priority |
| HvX64RegisterApicEoi | 0x0008480B | End of interrupt |
| HvX64RegisterApicLdr | 0x0008480D | Logical dest |
| HvX64RegisterApicSpurious | 0x0008480F | Spurious vector |
| HvX64RegisterApicIsr0 | 0x00084810 | In-service 0 |
| HvX64RegisterApicIsr1 | 0x00084811 | In-service 1 |
| HvX64RegisterApicIsr2 | 0x00084812 | In-service 2 |
| HvX64RegisterApicIsr3 | 0x00084813 | In-service 3 |
| HvX64RegisterApicIsr4 | 0x00084814 | In-service 4 |
| HvX64RegisterApicIsr5 | 0x00084815 | In-service 5 |
| HvX64RegisterApicIsr6 | 0x00084816 | In-service 6 |
| HvX64RegisterApicIsr7 | 0x00084817 | In-service 7 |
| HvX64RegisterApicTmr0 | 0x00084818 | Trigger mode 0 |
| HvX64RegisterApicTmr1 | 0x00084819 | Trigger mode 1 |
| HvX64RegisterApicTmr2 | 0x0008481A | Trigger mode 2 |
| HvX64RegisterApicTmr3 | 0x0008481B | Trigger mode 3 |
| HvX64RegisterApicTmr4 | 0x0008481C | Trigger mode 4 |
| HvX64RegisterApicTmr5 | 0x0008481D | Trigger mode 5 |
| HvX64RegisterApicTmr6 | 0x0008481E | Trigger mode 6 |
| HvX64RegisterApicTmr7 | 0x0008481F | Trigger mode 7 |
| HvX64RegisterApicIrr0 | 0x00084820 | Interrupt request 0 |
| HvX64RegisterApicIrr1 | 0x00084821 | Interrupt request 1 |
| HvX64RegisterApicIrr2 | 0x00084822 | Interrupt request 2 |
| HvX64RegisterApicIrr3 | 0x00084823 | Interrupt request 3 |
| HvX64RegisterApicIrr4 | 0x00084824 | Interrupt request 4 |
| HvX64RegisterApicIrr5 | 0x00084825 | Interrupt request 5 |
| HvX64RegisterApicIrr6 | 0x00084826 | Interrupt request 6 |
| HvX64RegisterApicIrr7 | 0x00084827 | Interrupt request 7 |
| HvX64RegisterApicEse | 0x00084828 | Extended state enable |
| HvX64RegisterApicIcr | 0x00084830 | Interrupt command |
| HvX64RegisterApicLvtTimer | 0x00084832 | LVT Timer |
| HvX64RegisterApicLvtThermal | 0x00084833 | LVT Thermal |
| HvX64RegisterApicLvtPerfmon | 0x00084834 | LVT PerfMon |
| HvX64RegisterApicLvtLint0 | 0x00084835 | LVT LINT0 |
| HvX64RegisterApicLvtLint1 | 0x00084836 | LVT LINT1 |
| HvX64RegisterApicLvtError | 0x00084837 | LVT Error |
| HvX64RegisterApicInitCount | 0x00084838 | Timer initial count |
| HvX64RegisterApicCurrentCount | 0x00084839 | Timer current count |
| HvX64RegisterApicDivide | 0x0008483E | Divide config |
| HvX64RegisterApicSelfIpi | 0x0008483F | Self IPI |

### Hypervisor-defined (Misc) & Synthetic MSRs
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterHypercall | 0x00090001 | Hypercall control MSR |
| HvX64RegisterSyntheticEoi | 0x00090010 | Synthetic EOI |
| HvX64RegisterSyntheticIcr | 0x00090011 | Synthetic ICR |
| HvX64RegisterSyntheticTpr | 0x00090012 | Synthetic TPR |
| HvX64RegisterEmulatedTimerPeriod | 0x00090030 | Timer assist period |
| HvX64RegisterEmulatedTimerControl | 0x00090031 | Timer assist control |
| HvX64RegisterPmTimerAssist | 0x00090032 | PM timer assist |

### AMD SEV Configuration
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterSevControl | 0x00090040 | SEV control |
| HvX64RegisterSevGhcbGpa | 0x00090041 | GHCB GPA |
| HvX64RegisterSevAvicGpa | 0x00090043 | See [HV_X64_REGISTER_SEV_GPA_PAGE](./hv_x64_register_sev_gpa_page.md) |

### Nested State
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterNestedGuestState | 0x00090050 | Nested guest state blob |
| HvX64RegisterNestedCurrentVmGpa | 0x00090051 | Current nested VM GPA |
| HvX64RegisterNestedVmxInvEpt | 0x00090052 | INV_EPT descriptor |
| HvX64RegisterNestedVmxInvVpid | 0x00090053 | INV_VPID descriptor |

### Intercept Control
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterCrInterceptControl | 0x000E0000 | Intercept control mask |
| HvX64RegisterCrInterceptCr0Mask | 0x000E0001 | CR0 intercept mask |
| HvX64RegisterCrInterceptCr4Mask | 0x000E0002 | CR4 intercept mask |
| HvX64RegisterCrInterceptIa32MiscEnableMask | 0x000E0003 | IA32_MISC_ENABLE intercept mask |

### x64 GHCB (SEV-ES/SNP)
| Register | Identifier | Comment |
|----------|------------|---------|
| HvX64RegisterGhcb | 0x00090019 | GHCB MSR proxy (guest) |

## ARM64 Architecture Registers

Deprecated registers are documented for compatibility with older OS releases.

### General Purpose
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterX0 | 0x00020000 | X0 |
| HvArm64RegisterX1 | 0x00020001 | X1 |
| HvArm64RegisterX2 | 0x00020002 | X2 |
| HvArm64RegisterX3 | 0x00020003 | X3 |
| HvArm64RegisterX4 | 0x00020004 | X4 |
| HvArm64RegisterX5 | 0x00020005 | X5 |
| HvArm64RegisterX6 | 0x00020006 | X6 |
| HvArm64RegisterX7 | 0x00020007 | X7 |
| HvArm64RegisterX8 | 0x00020008 | X8 |
| HvArm64RegisterX9 | 0x00020009 | X9 |
| HvArm64RegisterX10 | 0x0002000A | X10 |
| HvArm64RegisterX11 | 0x0002000B | X11 |
| HvArm64RegisterX12 | 0x0002000C | X12 |
| HvArm64RegisterX13 | 0x0002000D | X13 |
| HvArm64RegisterX14 | 0x0002000E | X14 |
| HvArm64RegisterX15 | 0x0002000F | X15 |
| HvArm64RegisterX16 | 0x00020010 | X16 |
| HvArm64RegisterX17 | 0x00020011 | X17 |
| HvArm64RegisterX18 | 0x00020012 | X18 |
| HvArm64RegisterX19 | 0x00020013 | X19 |
| HvArm64RegisterX20 | 0x00020014 | X20 |
| HvArm64RegisterX21 | 0x00020015 | X21 |
| HvArm64RegisterX22 | 0x00020016 | X22 |
| HvArm64RegisterX23 | 0x00020017 | X23 |
| HvArm64RegisterX24 | 0x00020018 | X24 |
| HvArm64RegisterX25 | 0x00020019 | X25 |
| HvArm64RegisterX26 | 0x0002001A | X26 |
| HvArm64RegisterX27 | 0x0002001B | X27 |
| HvArm64RegisterX28 | 0x0002001C | X28 |
| HvArm64RegisterFp (X29) | 0x0002001D | Frame pointer |
| HvArm64RegisterLr (X30) | 0x0002001E | Link register |
| HvArm64RegisterSp | 0x0002001F | Stack pointer (Deprecated) |
| HvArm64RegisterSpEl0 | 0x00020020 | SP_EL0 (Deprecated) |
| HvArm64RegisterSpEl1 | 0x00020021 | SP_EL1 (Deprecated) |
| HvArm64RegisterPc | 0x00020022 | Program counter |
| HvArm64RegisterXzr | 0x0002FFFE | Zero register |

### Floating Point / SIMD / SVE
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterQ0 | 0x00030000 | Q0 |
| HvArm64RegisterQ1 | 0x00030001 | Q1 |
| HvArm64RegisterQ2 | 0x00030002 | Q2 |
| HvArm64RegisterQ3 | 0x00030003 | Q3 |
| HvArm64RegisterQ4 | 0x00030004 | Q4 |
| HvArm64RegisterQ5 | 0x00030005 | Q5 |
| HvArm64RegisterQ6 | 0x00030006 | Q6 |
| HvArm64RegisterQ7 | 0x00030007 | Q7 |
| HvArm64RegisterQ8 | 0x00030008 | Q8 |
| HvArm64RegisterQ9 | 0x00030009 | Q9 |
| HvArm64RegisterQ10 | 0x0003000A | Q10 |
| HvArm64RegisterQ11 | 0x0003000B | Q11 |
| HvArm64RegisterQ12 | 0x0003000C | Q12 |
| HvArm64RegisterQ13 | 0x0003000D | Q13 |
| HvArm64RegisterQ14 | 0x0003000E | Q14 |
| HvArm64RegisterQ15 | 0x0003000F | Q15 |
| HvArm64RegisterQ16 | 0x00030010 | Q16 |
| HvArm64RegisterQ17 | 0x00030011 | Q17 |
| HvArm64RegisterQ18 | 0x00030012 | Q18 |
| HvArm64RegisterQ19 | 0x00030013 | Q19 |
| HvArm64RegisterQ20 | 0x00030014 | Q20 |
| HvArm64RegisterQ21 | 0x00030015 | Q21 |
| HvArm64RegisterQ22 | 0x00030016 | Q22 |
| HvArm64RegisterQ23 | 0x00030017 | Q23 |
| HvArm64RegisterQ24 | 0x00030018 | Q24 |
| HvArm64RegisterQ25 | 0x00030019 | Q25 |
| HvArm64RegisterQ26 | 0x0003001A | Q26 |
| HvArm64RegisterQ27 | 0x0003001B | Q27 |
| HvArm64RegisterQ28 | 0x0003001C | Q28 |
| HvArm64RegisterQ29 | 0x0003001D | Q29 |
| HvArm64RegisterQ30 | 0x0003001E | Q30 |
| HvArm64RegisterQ31 | 0x0003001F | Q31 |
| HvArm64RegisterZ0 | 0x00030100 | Z0 |
| HvArm64RegisterZ1 | 0x00030101 | Z1 |
| HvArm64RegisterZ2 | 0x00030102 | Z2 |
| HvArm64RegisterZ3 | 0x00030103 | Z3 |
| HvArm64RegisterZ4 | 0x00030104 | Z4 |
| HvArm64RegisterZ5 | 0x00030105 | Z5 |
| HvArm64RegisterZ6 | 0x00030106 | Z6 |
| HvArm64RegisterZ7 | 0x00030107 | Z7 |
| HvArm64RegisterZ8 | 0x00030108 | Z8 |
| HvArm64RegisterZ9 | 0x00030109 | Z9 |
| HvArm64RegisterZ10 | 0x0003010A | Z10 |
| HvArm64RegisterZ11 | 0x0003010B | Z11 |
| HvArm64RegisterZ12 | 0x0003010C | Z12 |
| HvArm64RegisterZ13 | 0x0003010D | Z13 |
| HvArm64RegisterZ14 | 0x0003010E | Z14 |
| HvArm64RegisterZ15 | 0x0003010F | Z15 |
| HvArm64RegisterZ16 | 0x00030110 | Z16 |
| HvArm64RegisterZ17 | 0x00030111 | Z17 |
| HvArm64RegisterZ18 | 0x00030112 | Z18 |
| HvArm64RegisterZ19 | 0x00030113 | Z19 |
| HvArm64RegisterZ20 | 0x00030114 | Z20 |
| HvArm64RegisterZ21 | 0x00030115 | Z21 |
| HvArm64RegisterZ22 | 0x00030116 | Z22 |
| HvArm64RegisterZ23 | 0x00030117 | Z23 |
| HvArm64RegisterZ24 | 0x00030118 | Z24 |
| HvArm64RegisterZ25 | 0x00030119 | Z25 |
| HvArm64RegisterZ26 | 0x0003011A | Z26 |
| HvArm64RegisterZ27 | 0x0003011B | Z27 |
| HvArm64RegisterZ28 | 0x0003011C | Z28 |
| HvArm64RegisterZ29 | 0x0003011D | Z29 |
| HvArm64RegisterZ30 | 0x0003011E | Z30 |
| HvArm64RegisterZ31 | 0x0003011F | Z31 |
| HvArm64RegisterP0 | 0x00030120 | P0 |
| HvArm64RegisterP1 | 0x00030121 | P1 |
| HvArm64RegisterP2 | 0x00030122 | P2 |
| HvArm64RegisterP3 | 0x00030123 | P3 |
| HvArm64RegisterP4 | 0x00030124 | P4 |
| HvArm64RegisterP5 | 0x00030125 | P5 |
| HvArm64RegisterP6 | 0x00030126 | P6 |
| HvArm64RegisterP7 | 0x00030127 | P7 |
| HvArm64RegisterP8 | 0x00030128 | P8 |
| HvArm64RegisterP9 | 0x00030129 | P9 |
| HvArm64RegisterP10 | 0x0003012A | P10 |
| HvArm64RegisterP11 | 0x0003012B | P11 |
| HvArm64RegisterP12 | 0x0003012C | P12 |
| HvArm64RegisterP13 | 0x0003012D | P13 |
| HvArm64RegisterP14 | 0x0003012E | P14 |
| HvArm64RegisterP15 | 0x0003012F | P15 |
| HvArm64RegisterFFR | 0x00030130 | SVE first-fault predicate |

### Special Purpose / Status
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterCurrentEl | 0x00021003 | Current EL |
| HvArm64RegisterDaif | 0x00021004 | Interrupt mask bits |
| HvArm64RegisterDit | 0x00021005 | Data independent timing |
| HvArm64RegisterPstate | 0x00020023 | PSTATE (Deprecated) |
| HvArm64RegisterElrEl1 | 0x00040015 | ELR_EL1 (Deprecated) |
| HvArm64RegisterElrElx | 0x0002100C | Current EL return address |
| HvArm64RegisterFpcr | 0x00040012 | FPCR (Deprecated) |
| HvArm64RegisterFpsr | 0x00040013 | FPSR (Deprecated) |
| HvArm64RegisterNzcv | 0x00021006 | NZCV flags |
| HvArm64RegisterPan | 0x00021007 | PAN state |
| HvArm64RegisterSpSel | 0x00021008 | SP selection |
| HvArm64RegisterSpsrEl1 | 0x00040014 | SPSR_EL1 (Deprecated) |
| HvArm64RegisterSpsrElx | 0x0002100D | Current EL SPSR |
| HvArm64RegisterSsbs | 0x00021009 | Speculative store bypass safe |
| HvArm64RegisterTco | 0x0002100A | Tag check override |
| HvArm64RegisterUao | 0x0002100B | User access override |

### ID Registers 
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterIdMidrEl1 | 0x00022000 | Main ID |
| HvArm64RegisterIdMpidrEl1 | 0x00022005 | Multiprocessor Affinity |
| HvArm64RegisterIdAa64Pfr0El1 | 0x00022020 | AArch64 feature 0 |
| HvArm64RegisterIdAa64Pfr1El1 | 0x00022021 | AArch64 feature 1 |
| HvArm64RegisterIdAa64Pfr2El1 | 0x00022022 | AArch64 feature 2 |
| HvArm64RegisterIdAa64Zfr0El1 | 0x00022024 | SVE feature 0 |
| HvArm64RegisterIdAa64Smfr0El1 | 0x00022025 | SME feature 0 |
| HvArm64RegisterIdAa64Dfr0El1 | 0x00022028 | Debug feature 0 |
| HvArm64RegisterIdAa64Isar0El1 | 0x00022030 | ISA attribute 0 |
| HvArm64RegisterIdAa64Mmfr0El1 | 0x00022038 | Memory model feature 0 |
| HvArm64RegisterIdAa64Mmfr1El1 | 0x00022039 | Memory model feature 1 |
| HvArm64RegisterIdAa64Mmfr2El1 | 0x0002203A | Memory model feature 2 |
| HvArm64RegisterIdAa64Mmfr3El1 | 0x0002203B | Memory model feature 3 |
| HvArm64RegisterIdAa64Mmfr4El1 | 0x0002203C | Memory model feature 4 |

### General System Control Registers
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterAccdataEl1 | 0x00040020 | ACCDATA |
| HvArm64RegisterActlrEl1 | 0x00040003 | ACTLR_EL1 |
| HvArm64RegisterAfsr0El1 | 0x00040016 | Asynchronous fault status 0 (EL1) |
| HvArm64RegisterAfsr0Elx | 0x00040073 | Asynchronous fault status 0 (ELx combined) |
| HvArm64RegisterAfsr1Elx | 0x00040074 | Asynchronous fault status 1 (ELx combined) |
| HvArm64RegisterAidrEl1 | 0x00040024 | Auxiliary ID |
| HvArm64RegisterAmairEl1 | 0x00040018 | Memory attribute indirection (EL1) |
| HvArm64RegisterAmairElx | 0x00040075 | Memory attribute indirection (ELx combined) |
| HvArm64RegisterApdAKeyHiEl1 | 0x00040026 | APDAKeyHi_EL1 |
| HvArm64RegisterApdAKeyLoEl1 | 0x00040027 | APDAKeyLo_EL1 |
| HvArm64RegisterApdBKeyHiEl1 | 0x00040028 | APDBKeyHi_EL1 |
| HvArm64RegisterApdBKeyLoEl1 | 0x00040029 | APDBKeyLo_EL1 |
| HvArm64RegisterApgAKeyHiEl1 | 0x0004002A | APGAKeyHi_EL1 |
| HvArm64RegisterApgAKeyLoEl1 | 0x0004002B | APGAKeyLo_EL1 |
| HvArm64RegisterApiAKeyHiEl1 | 0x0004002C | APIAKeyHi_EL1 |
| HvArm64RegisterApiAKeyLoEl1 | 0x0004002D | APIAKeyLo_EL1 |
| HvArm64RegisterApiBKeyHiEl1 | 0x0004002E | APIBKeyHi_EL1 |
| HvArm64RegisterApiBKeyLoEl1 | 0x0004002F | APIBKeyLo_EL1 |
| HvArm64RegisterCcsidrEl1 / Ccsidr2El1 | 0x00040030 /0x00040031 | Cache size ID |
| HvArm64RegisterClidrEl1 | 0x00040032 | Cache level ID |
| HvArm64RegisterContextidrEl1 | 0x0004000D | Context ID (EL1) |
| HvArm64RegisterContextidrElx | 0x00040076 | Context ID (ELx combined) |
| HvArm64RegisterCpacrEl1 | 0x00040004 | Coprocessor access (CPACR_EL1) |
| HvArm64RegisterCpacrElx | 0x00040077 | Coprocessor access (ELx combined) |
| HvArm64RegisterCsselrEl1 | 0x00040035 | Cache size selection |
| HvArm64RegisterCtrEl0 | 0x00040036 | Cache type |
| HvArm64RegisterDczidEl0 | 0x00040038 | DC ZVA parameters |
| HvArm64RegisterEsrEl1 | 0x00040008 | Exception syndrome (EL1) |
| HvArm64RegisterEsrElx | 0x00040078 | Exception syndrome (ELx combined) |
| HvArm64RegisterFarEl1 | 0x00040009 | Fault address (EL1) |
| HvArm64RegisterFarElx | 0x00040079 | Fault address (ELx combined) |
| HvArm64RegisterGcrEl1 | 0x0004003C | Guarded control |
| HvArm64RegisterGmidEl1 | 0x0004003D | Guest memory ID |
| HvArm64RegisterIsrEl1 | 0x0004004A | Interrupt status |
| HvArm64RegisterLorcEl1 | 0x0004004B | LORegion control |
| HvArm64RegisterLoreaEl1 | 0x0004004C | LORegion end address |
| HvArm64RegisterLoridEl1 | 0x0004004D | LORegion ID |
| HvArm64RegisterLornEl1 | 0x0004004E | LORegion number |
| HvArm64RegisterLorsaEl1 | 0x0004004F | LORegion start address |
| HvArm64RegisterMairEl1 | 0x0004000B | Memory attribute indirection (EL1) |
| HvArm64RegisterMairElx | 0x0004007A | Memory attribute indirection (ELx combined) |
| HvArm64RegisterMidrEl1 | 0x00040051 | MIDR (Deprecated) |
| HvArm64RegisterMpidrEl1 | 0x00040001 | MPIDR (Deprecated) |
| HvArm64RegisterMvfr0El1 | 0x00040052 | Media & VFP features 0 |
| HvArm64RegisterMvfr1El1 | 0x00040053 | Media & VFP features 1 |
| HvArm64RegisterMvfr2El1 | 0x00040054 | Media & VFP features 2 |
| HvArm64RegisterParEl1 | 0x0004000A | Physical address register |
| HvArm64RegisterRevidrEl1 | 0x00040055 | Revision ID |
| HvArm64RegisterRgsrEl1 | 0x00040056 | Random number generator seed status |
| HvArm64RegisterRndr | 0x00040057 | Random number (RNDR) |
| HvArm64RegisterRndrrs | 0x00040058 | Random number reseeded (RNDRRS) |
| HvArm64RegisterSctlrEl1 | 0x00040002 | System control (EL1) |
| HvArm64RegisterSctlrElx | 0x0004007B | System control (ELx combined) |
| HvArm64RegisterScxtnumEl0 | 0x0004005A | Context number (EL0) |
| HvArm64RegisterScxtnumEl1 | 0x0004005B | Context number (EL1) |
| HvArm64RegisterSmcrEl1 | 0x0004005D | SME control (EL1) |
| HvArm64RegisterSmidrEl1 | 0x0004005F | SME ID |
| HvArm64RegisterSmpriEl1 | 0x00040060 | SME priority (EL1) |
| HvArm64RegisterTcrEl1 | 0x00040007 | Translation control (EL1) |
| HvArm64RegisterTcrElx | 0x0004007C | Translation control (ELx combined) |
| HvArm64RegisterTfsre0El1 | 0x00040063 | Fault status (TFSRE0_EL1) |
| HvArm64RegisterTfsrEl1 | 0x00040064 | Fault status (TFSR_EL1) |
| HvArm64RegisterTpidr2El0 | 0x00040066 | TPIDR2 |
| HvArm64RegisterTpidrEl0 | 0x00040011 | Thread pointer (EL0) |
| HvArm64RegisterTpidrEl1 | 0x0004000E | Thread pointer (EL1) |
| HvArm64RegisterTpidrroEl0 | 0x00040010 | Read-only thread pointer |
| HvArm64RegisterTtbr0El1 | 0x00040005 | Translation table base 0 (EL1) |
| HvArm64RegisterTtbr0Elx | 0x0004007D | Translation table base 0 (ELx combined) |
| HvArm64RegisterTtbr1El1 | 0x00040006 | Translation table base 1 (EL1) |
| HvArm64RegisterTtbr1Elx | 0x0004007F | Translation table base 1 (ELx combined) |
| HvArm64RegisterVbarEl1 | 0x0004000C | Vector base (EL1) |
| HvArm64RegisterVbarElx | 0x00040080 | Vector base (ELx combined) |
| HvArm64RegisterZcrEl1 | 0x00040071 | SVE vector length control (EL1) |
| HvArm64RegisterZcrElx | 0x00040081 | SVE vector length control (ELx combined) |

### Debug Registers
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterDbgauthstatusEl1 | 0x00050040 | Debug auth status |
| HvArm64RegisterDbgbcr0El1 | 0x00050000 | Breakpoint control 0 |
| HvArm64RegisterDbgbcr1El1 | 0x00050001 | Breakpoint control 1 |
| HvArm64RegisterDbgbcr2El1 | 0x00050002 | Breakpoint control 2 |
| HvArm64RegisterDbgbcr3El1 | 0x00050003 | Breakpoint control 3 |
| HvArm64RegisterDbgbcr4El1 | 0x00050004 | Breakpoint control 4 |
| HvArm64RegisterDbgbcr5El1 | 0x00050005 | Breakpoint control 5 |
| HvArm64RegisterDbgbcr6El1 | 0x00050006 | Breakpoint control 6 |
| HvArm64RegisterDbgbcr7El1 | 0x00050007 | Breakpoint control 7 |
| HvArm64RegisterDbgbcr8El1 | 0x00050008 | Breakpoint control 8 |
| HvArm64RegisterDbgbcr9El1 | 0x00050009 | Breakpoint control 9 |
| HvArm64RegisterDbgbcr10El1 | 0x0005000A | Breakpoint control 10 |
| HvArm64RegisterDbgbcr11El1 | 0x0005000B | Breakpoint control 11 |
| HvArm64RegisterDbgbcr12El1 | 0x0005000C | Breakpoint control 12 |
| HvArm64RegisterDbgbcr13El1 | 0x0005000D | Breakpoint control 13 |
| HvArm64RegisterDbgbcr14El1 | 0x0005000E | Breakpoint control 14 |
| HvArm64RegisterDbgbcr15El1 | 0x0005000F | Breakpoint control 15 |
| HvArm64RegisterDbgbvr0El1 | 0x00050020 | Breakpoint value 0 |
| HvArm64RegisterDbgbvr1El1 | 0x00050021 | Breakpoint value 1 |
| HvArm64RegisterDbgbvr2El1 | 0x00050022 | Breakpoint value 2 |
| HvArm64RegisterDbgbvr3El1 | 0x00050023 | Breakpoint value 3 |
| HvArm64RegisterDbgbvr4El1 | 0x00050024 | Breakpoint value 4 |
| HvArm64RegisterDbgbvr5El1 | 0x00050025 | Breakpoint value 5 |
| HvArm64RegisterDbgbvr6El1 | 0x00050026 | Breakpoint value 6 |
| HvArm64RegisterDbgbvr7El1 | 0x00050027 | Breakpoint value 7 |
| HvArm64RegisterDbgbvr8El1 | 0x00050028 | Breakpoint value 8 |
| HvArm64RegisterDbgbvr9El1 | 0x00050029 | Breakpoint value 9 |
| HvArm64RegisterDbgbvr10El1 | 0x0005002A | Breakpoint value 10 |
| HvArm64RegisterDbgbvr11El1 | 0x0005002B | Breakpoint value 11 |
| HvArm64RegisterDbgbvr12El1 | 0x0005002C | Breakpoint value 12 |
| HvArm64RegisterDbgbvr13El1 | 0x0005002D | Breakpoint value 13 |
| HvArm64RegisterDbgbvr14El1 | 0x0005002E | Breakpoint value 14 |
| HvArm64RegisterDbgbvr15El1 | 0x0005002F | Breakpoint value 15 |
| HvArm64RegisterDbgclaimclrEl1 | 0x00050041 | Claim tag clear |
| HvArm64RegisterDbgclaimsetEl1 | 0x00050042 | Claim tag set |
| HvArm64RegisterDbgdtrrxEl0 | 0x00050043 | Debug data transfer receive |
| HvArm64RegisterDbgdtrtxEl0 | 0x00050044 | Debug data transfer transmit |
| HvArm64RegisterDbgprcrEl1 | 0x00050045 | External debug power/priv control |
| HvArm64RegisterDbgwcr0El1 | 0x00050010 | Watchpoint control 0 |
| HvArm64RegisterDbgwcr1El1 | 0x00050011 | Watchpoint control 1 |
| HvArm64RegisterDbgwcr2El1 | 0x00050012 | Watchpoint control 2 |
| HvArm64RegisterDbgwcr3El1 | 0x00050013 | Watchpoint control 3 |
| HvArm64RegisterDbgwcr4El1 | 0x00050014 | Watchpoint control 4 |
| HvArm64RegisterDbgwcr5El1 | 0x00050015 | Watchpoint control 5 |
| HvArm64RegisterDbgwcr6El1 | 0x00050016 | Watchpoint control 6 |
| HvArm64RegisterDbgwcr7El1 | 0x00050017 | Watchpoint control 7 |
| HvArm64RegisterDbgwcr8El1 | 0x00050018 | Watchpoint control 8 |
| HvArm64RegisterDbgwcr9El1 | 0x00050019 | Watchpoint control 9 |
| HvArm64RegisterDbgwcr10El1 | 0x0005001A | Watchpoint control 10 |
| HvArm64RegisterDbgwcr11El1 | 0x0005001B | Watchpoint control 11 |
| HvArm64RegisterDbgwcr12El1 | 0x0005001C | Watchpoint control 12 |
| HvArm64RegisterDbgwcr13El1 | 0x0005001D | Watchpoint control 13 |
| HvArm64RegisterDbgwcr14El1 | 0x0005001E | Watchpoint control 14 |
| HvArm64RegisterDbgwcr15El1 | 0x0005001F | Watchpoint control 15 |
| HvArm64RegisterDbgwvr0El1 | 0x00050030 | Watchpoint value 0 |
| HvArm64RegisterDbgwvr1El1 | 0x00050031 | Watchpoint value 1 |
| HvArm64RegisterDbgwvr2El1 | 0x00050032 | Watchpoint value 2 |
| HvArm64RegisterDbgwvr3El1 | 0x00050033 | Watchpoint value 3 |
| HvArm64RegisterDbgwvr4El1 | 0x00050034 | Watchpoint value 4 |
| HvArm64RegisterDbgwvr5El1 | 0x00050035 | Watchpoint value 5 |
| HvArm64RegisterDbgwvr6El1 | 0x00050036 | Watchpoint value 6 |
| HvArm64RegisterDbgwvr7El1 | 0x00050037 | Watchpoint value 7 |
| HvArm64RegisterDbgwvr8El1 | 0x00050038 | Watchpoint value 8 |
| HvArm64RegisterDbgwvr9El1 | 0x00050039 | Watchpoint value 9 |
| HvArm64RegisterDbgwvr10El1 | 0x0005003A | Watchpoint value 10 |
| HvArm64RegisterDbgwvr11El1 | 0x0005003B | Watchpoint value 11 |
| HvArm64RegisterDbgwvr12El1 | 0x0005003C | Watchpoint value 12 |
| HvArm64RegisterDbgwvr13El1 | 0x0005003D | Watchpoint value 13 |
| HvArm64RegisterDbgwvr14El1 | 0x0005003E | Watchpoint value 14 |
| HvArm64RegisterDbgwvr15El1 | 0x0005003F | Watchpoint value 15 |
| HvArm64RegisterDlrEl0 | 0x00050047 | Debug link register |
| HvArm64RegisterDspsrEl0 | 0x00050048 | Debug saved PSR |
| HvArm64RegisterMdccintEl1 | 0x00050049 | Monitor debug comms channel int |
| HvArm64RegisterMdccsrEl0 | 0x0005004A | Monitor debug comms channel status |
| HvArm64RegisterMdrarEl1 | 0x0005004C | Monitor debug ROM addr |
| HvArm64RegisterMdscrEl1 | 0x0005004D | Monitor debug system control |
| HvArm64RegisterOsdlrEl1 | 0x0005004E | OS double lock |
| HvArm64RegisterOsdtrrxEl1 | 0x0005004F | OS data transfer receive |
| HvArm64RegisterOsdtrtxEl1 | 0x00050050 | OS data transfer transmit |
| HvArm64RegisterOseccrEl1 | 0x00050051 | OS external debug context |
| HvArm64RegisterOslarEl1 | 0x00050052 | OS lock access |
| HvArm64RegisterOslsrEl1 | 0x00050053 | OS lock status |
| HvArm64RegisterTrfcrEl1 | 0x00050055 | Trace filter control (EL1) |
| HvArm64RegisterTrfcrElx | 0x00050057 | Trace filter control (ELx combined) |

### Performance Monitors & Activity Monitors
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterPmccfiltrEl0 | 0x00052000 | PMU cycle counter filter |
| HvArm64RegisterPmccntrEl0 | 0x00052001 | Cycle counter |
| HvArm64RegisterPmceid0El0 | 0x00052002 | Event ID 0 |
| HvArm64RegisterPmceid1El0 | 0x00052003 | Event ID 1 |
| HvArm64RegisterPmcntenclrEl0 | 0x00052004 | Counter enable clear |
| HvArm64RegisterPmcntensetEl0 | 0x00052005 | Counter enable set |
| HvArm64RegisterPmcrEl0 | 0x00052006 | PMU control |
| HvArm64RegisterPmevcntr0El0 | 0x00052007 | Event counter 0 |
| HvArm64RegisterPmevcntr1El0 | 0x00052008 | Event counter 1 |
| HvArm64RegisterPmevcntr2El0 | 0x00052009 | Event counter 2 |
| HvArm64RegisterPmevcntr3El0 | 0x0005200A | Event counter 3 |
| HvArm64RegisterPmevcntr4El0 | 0x0005200B | Event counter 4 |
| HvArm64RegisterPmevcntr5El0 | 0x0005200C | Event counter 5 |
| HvArm64RegisterPmevcntr6El0 | 0x0005200D | Event counter 6 |
| HvArm64RegisterPmevcntr7El0 | 0x0005200E | Event counter 7 |
| HvArm64RegisterPmevcntr8El0 | 0x0005200F | Event counter 8 |
| HvArm64RegisterPmevcntr9El0 | 0x00052010 | Event counter 9 |
| HvArm64RegisterPmevcntr10El0 | 0x00052011 | Event counter 10 |
| HvArm64RegisterPmevcntr11El0 | 0x00052012 | Event counter 11 |
| HvArm64RegisterPmevcntr12El0 | 0x00052013 | Event counter 12 |
| HvArm64RegisterPmevcntr13El0 | 0x00052014 | Event counter 13 |
| HvArm64RegisterPmevcntr14El0 | 0x00052015 | Event counter 14 |
| HvArm64RegisterPmevcntr15El0 | 0x00052016 | Event counter 15 |
| HvArm64RegisterPmevcntr16El0 | 0x00052017 | Event counter 16 |
| HvArm64RegisterPmevcntr17El0 | 0x00052018 | Event counter 17 |
| HvArm64RegisterPmevcntr18El0 | 0x00052019 | Event counter 18 |
| HvArm64RegisterPmevcntr19El0 | 0x0005201A | Event counter 19 |
| HvArm64RegisterPmevcntr20El0 | 0x0005201B | Event counter 20 |
| HvArm64RegisterPmevcntr21El0 | 0x0005201C | Event counter 21 |
| HvArm64RegisterPmevcntr22El0 | 0x0005201D | Event counter 22 |
| HvArm64RegisterPmevcntr23El0 | 0x0005201E | Event counter 23 |
| HvArm64RegisterPmevcntr24El0 | 0x0005201F | Event counter 24 |
| HvArm64RegisterPmevcntr25El0 | 0x00052020 | Event counter 25 |
| HvArm64RegisterPmevcntr26El0 | 0x00052021 | Event counter 26 |
| HvArm64RegisterPmevcntr27El0 | 0x00052022 | Event counter 27 |
| HvArm64RegisterPmevcntr28El0 | 0x00052023 | Event counter 28 |
| HvArm64RegisterPmevcntr29El0 | 0x00052024 | Event counter 29 |
| HvArm64RegisterPmevcntr30El0 | 0x00052025 | Event counter 30 |
| HvArm64RegisterPmevtyper0El0 | 0x00052026 | Event type 0 |
| HvArm64RegisterPmevtyper1El0 | 0x00052027 | Event type 1 |
| HvArm64RegisterPmevtyper2El0 | 0x00052028 | Event type 2 |
| HvArm64RegisterPmevtyper3El0 | 0x00052029 | Event type 3 |
| HvArm64RegisterPmevtyper4El0 | 0x0005202A | Event type 4 |
| HvArm64RegisterPmevtyper5El0 | 0x0005202B | Event type 5 |
| HvArm64RegisterPmevtyper6El0 | 0x0005202C | Event type 6 |
| HvArm64RegisterPmevtyper7El0 | 0x0005202D | Event type 7 |
| HvArm64RegisterPmevtyper8El0 | 0x0005202E | Event type 8 |
| HvArm64RegisterPmevtyper9El0 | 0x0005202F | Event type 9 |
| HvArm64RegisterPmevtyper10El0 | 0x00052030 | Event type 10 |
| HvArm64RegisterPmevtyper11El0 | 0x00052031 | Event type 11 |
| HvArm64RegisterPmevtyper12El0 | 0x00052032 | Event type 12 |
| HvArm64RegisterPmevtyper13El0 | 0x00052033 | Event type 13 |
| HvArm64RegisterPmevtyper14El0 | 0x00052034 | Event type 14 |
| HvArm64RegisterPmevtyper15El0 | 0x00052035 | Event type 15 |
| HvArm64RegisterPmevtyper16El0 | 0x00052036 | Event type 16 |
| HvArm64RegisterPmevtyper17El0 | 0x00052037 | Event type 17 |
| HvArm64RegisterPmevtyper18El0 | 0x00052038 | Event type 18 |
| HvArm64RegisterPmevtyper19El0 | 0x00052039 | Event type 19 |
| HvArm64RegisterPmevtyper20El0 | 0x0005203A | Event type 20 |
| HvArm64RegisterPmevtyper21El0 | 0x0005203B | Event type 21 |
| HvArm64RegisterPmevtyper22El0 | 0x0005203C | Event type 22 |
| HvArm64RegisterPmevtyper23El0 | 0x0005203D | Event type 23 |
| HvArm64RegisterPmevtyper24El0 | 0x0005203E | Event type 24 |
| HvArm64RegisterPmevtyper25El0 | 0x0005203F | Event type 25 |
| HvArm64RegisterPmevtyper26El0 | 0x00052040 | Event type 26 |
| HvArm64RegisterPmevtyper27El0 | 0x00052041 | Event type 27 |
| HvArm64RegisterPmevtyper28El0 | 0x00052042 | Event type 28 |
| HvArm64RegisterPmevtyper29El0 | 0x00052043 | Event type 29 |
| HvArm64RegisterPmevtyper30El0 | 0x00052044 | Event type 30 |
| HvArm64RegisterPmintenclrEl1 | 0x00052045 | Interrupt enable clear |
| HvArm64RegisterPmintensetEl1 | 0x00052046 | Interrupt enable set |
| HvArm64RegisterPmovsclrEl0 | 0x00052048 | Overflow status clear |
| HvArm64RegisterPmovssetEl0 | 0x00052049 | Overflow status set |
| HvArm64RegisterPmselrEl0 | 0x0005204A | Event counter select |
| HvArm64RegisterPmuserenrEl0 | 0x0005204C | User enable |
| HvArm64RegisterPmxevcntrEl0 | 0x0005204D | Selected event counter |
| HvArm64RegisterPmxevtyperEl0 | 0x0005204E | Selected event type |
| HvArm64RegisterAmevcntr00El0 | 0x00053000 | Activity monitor counter 00 |
| HvArm64RegisterAmevcntr01El0 | 0x00053001 | Activity monitor counter 01 |
| HvArm64RegisterAmevcntr02El0 | 0x00053002 | Activity monitor counter 02 |
| HvArm64RegisterAmevcntr03El0 | 0x00053003 | Activity monitor counter 03 |

### Statistical Profiling Extension (SPE)
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterPmbidrEl1 | 0x00054000 | SPE buffer ID |
| HvArm64RegisterPmblimitrEl1 | 0x00054001 | SPE buffer limit |
| HvArm64RegisterPmbptrEl1 | 0x00054002 | SPE buffer write pointer |
| HvArm64RegisterPmbsrEl1 | 0x00054003 | SPE status |
| HvArm64RegisterPmscrEl1 | 0x00054004 | SPE control EL1 |
| HvArm64RegisterPmsevfrEl1 | 0x00054006 | SPE exception filtering |
| HvArm64RegisterPmsfcrEl1 | 0x00054007 | SPE filter control |
| HvArm64RegisterPmsicrEl1 | 0x00054008 | SPE interrupt control |
| HvArm64RegisterPmsidrEl1 | 0x00054009 | SPE ID |
| HvArm64RegisterPmsirrEl1 | 0x0005400A | SPE interrupt status |
| HvArm64RegisterPmslatfrEl1 | 0x0005400B | SPE latency filtering |
| HvArm64RegisterPmsnevfrEl1 | 0x0005400C | SPE negative event filtering |

### RAS Registers
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterDisrEl1 | 0x00056000 | RAS status |
| HvArm64RegisterErrselrEl1 | 0x00056002 | Error select |
| HvArm64RegisterErxaddrEl1 | 0x00056003 | Error record address |
| HvArm64RegisterErxctlrEl1 | 0x00056004 | Error control |
| HvArm64RegisterErrxfrEl1 | 0x00056005 | Error guest address |
| HvArm64RegisterErxmisc0El1 | 0x00056006 | Error record misc 0 |
| HvArm64RegisterErxmisc1El1 | 0x00056007 | Error record misc 1 |
| HvArm64RegisterErxmisc2El1 | 0x00056008 | Error record misc 2 |
| HvArm64RegisterErxmisc3El1 | 0x00056009 | Error record misc 3 |
| HvArm64RegisterErxpfgcdnEl1 | 0x0005600A | Pseudo-fault gen code low |
| HvArm64RegisterErxpfgctlEl1 | 0x0005600B | Pseudo-fault generation control |
| HvArm64RegisterErxpfgfEl1 | 0x0005600C | Pseudo-fault generation feature/status |
| HvArm64RegisterErxstatusEl1 | 0x0005600D | Error record status |

### Generic Timer
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterCntfrqEl0 | 0x00058000 | Counter frequency |
| HvArm64RegisterCntkctlEl1 | 0x00058008 | Kernel timer control |
| HvArm64RegisterCntkctlElx | 0x00058013 | CntkctlEl1 or CnthctlEl2 depending on EL. |
| HvArm64RegisterCntpCtlEl0 | 0x00058009 | Physical timer control |
| HvArm64RegisterCntpCtlElx | 0x00058014 | CntpCtlEl0 or CnthpCtlEl2 depending on EL. |
| HvArm64RegisterCntpCvalEl0 | 0x0005800A | Physical timer compare |
| HvArm64RegisterCntpCvalElx | 0x00058015 | CntpCvalEl0 or CnthpCvalEl2 depending on EL. |
| HvArm64RegisterCntpTvalEl0 | 0x0005800B | Physical timer value |
| HvArm64RegisterCntpTvalElx | 0x00058016 | CntpTvalEl0 or CnthpTvalEl2 depending on EL. |
| HvArm64RegisterCntpctEl0 | 0x0005800C | Physical counter |
| HvArm64RegisterCntvCtlEl0 | 0x0005800E | Virtual timer control |
| HvArm64RegisterCntvCtlElx | 0x00058017 | CntvCtlEl0 or CnthvCtlEl2 depending on EL. |
| HvArm64RegisterCntvCvalEl0 | 0x0005800F | Virtual timer compare |
| HvArm64RegisterCntvCvalElx | 0x00058018 | CntvCvalEl0 or CnthvCvalEl2 depending on EL. |
| HvArm64RegisterCntvTvalEl0 | 0x00058010 | Virtual timer value |
| HvArm64RegisterCntvTvalElx | 0x00058019 | CntvTvalEl0 or CnthvTvalEl2 depending on EL. |
| HvArm64RegisterCntvctEl0 | 0x00058011 | Virtual counter |

### GIC Redistributor
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterGicrBaseGpa | 0x00063000 | Redistributor base GPA |

### Synthetic / Hypervisor Added
| Register | Identifier | Comment |
|----------|------------|---------|
| HvArm64RegisterPartitionInfoPage | 0x00090015 | Partition info page GPA |

## See Also
* [HvCallGetVpRegisters](../hypercalls/HvCallGetVpRegisters.md)
* [HvCallSetVpRegisters](../hypercalls/HvCallSetVpRegisters.md)
* [HV_REGISTER_VALUE](hv_register_value.md)