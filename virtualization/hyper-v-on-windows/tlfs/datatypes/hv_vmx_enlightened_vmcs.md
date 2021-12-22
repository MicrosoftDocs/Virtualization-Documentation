---
title: HV_VMX_ENLIGHTENED_VMCS
description: HV_VMX_ENLIGHTENED_VMCS
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_VMX_ENLIGHTENED_VMCS

Below is the type definition for the enlightened VMCS.

## Syntax

```c
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE (0)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_IO_BITMAP (1 << 0)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_MSR_BITMAP (1 << 1)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP2 (1 << 2)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_GRP1 (1 << 3)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC (1 << 4)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EVENT (1 << 5)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_ENTRY (1 << 6)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EXCPN (1 << 7)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CRDR (1 << 8)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_XLAT (1 << 9)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC (1 << 10)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP1 (1 << 11)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_GRP2 (1 << 12)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_POINTER (1 << 13)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_HOST_GRP1 (1 << 14)
#define HV_VMX_ENLIGHTENED_CLEAN_FIELD_ENLIGHTENMENTSCONTROL (1 << 15)

typedef struct
{
    UINT32 VersionNumber;
    UINT32 AbortIndicator;
    UINT16 HostEsSelector;
    UINT16 HostCsSelector;
    UINT16 HostSsSelector;
    UINT16 HostDsSelector;
    UINT16 HostFsSelector;
    UINT16 HostGsSelector;
    UINT16 HostTrSelector;
    UINT64 HostPat;
    UINT64 HostEfer;
    UINT64 HostCr0;
    UINT64 HostCr3;
    UINT64 HostCr4;
    UINT64 HostSysenterEspMsr;
    UINT64 HostSysenterEipMsr;
    UINT64 HostRip;
    UINT32 HostSysenterCsMsr;
    UINT32 PinControls;
    UINT32 ExitControls;
    UINT32 SecondaryProcessorControls;
    HV_GPA IoBitmapA;
    HV_GPA IoBitmapB;
    HV_GPA MsrBitmap;
    UINT16 GuestEsSelector;
    UINT16 GuestCsSelector;
    UINT16 GuestSsSelector;
    UINT16 GuestDsSelector;
    UINT16 GuestFsSelector;
    UINT16 GuestGsSelector;
    UINT16 GuestLdtrSelector;
    UINT16 GuestTrSelector;
    UINT32 GuestEsLimit;
    UINT32 GuestCsLimit;
    UINT32 GuestSsLimit;
    UINT32 GuestDsLimit;
    UINT32 GuestFsLimit;
    UINT32 GuestGsLimit;
    UINT32 GuestLdtrLimit;
    UINT32 GuestTrLimit;
    UINT32 GuestGdtrLimit;
    UINT32 GuestIdtrLimit;
    UINT32 GuestEsAttributes;
    UINT32 GuestCsAttributes;
    UINT32 GuestSsAttributes;
    UINT32 GuestDsAttributes;
    UINT32 GuestFsAttributes;
    UINT32 GuestGsAttributes;
    UINT32 GuestLdtrAttributes;
    UINT32 GuestTrAttributes;
    UINT64 GuestEsBase;
    UINT64 GuestCsBase;
    UINT64 GuestSsBase;
    UINT64 GuestDsBase;
    UINT64 GuestFsBase;
    UINT64 GuestGsBase;
    UINT64 GuestLdtrBase;
    UINT64 GuestTrBase;
    UINT64 GuestGdtrBase;
    UINT64 GuestIdtrBase;
    UINT64 Rsvd1[3];
    HV_GPA ExitMsrStoreAddress;
    HV_GPA ExitMsrLoadAddress;
    HV_GPA EntryMsrLoadAddress;
    UINT64 Cr3Target0;
    UINT64 Cr3Target1;
    UINT64 Cr3Target2;
    UINT64 Cr3Target3;
    UINT32 PfecMask;
    UINT32 PfecMatch;
    UINT32 Cr3TargetCount;
    UINT32 ExitMsrStoreCount;
    UINT32 ExitMsrLoadCount;
    UINT32 EntryMsrLoadCount;
    UINT64 TscOffset;
    HV_GPA VirtualApicPage;
    HV_GPA GuestWorkingVmcsPtr;
    UINT64 GuestIa32DebugCtl;
    UINT64 GuestPat;
    UINT64 GuestEfer;
    UINT64 GuestPdpte0;
    UINT64 GuestPdpte1;
    UINT64 GuestPdpte2;
    UINT64 GuestPdpte3;
    UINT64 GuestPendingDebugExceptions;
    UINT64 GuestSysenterEspMsr;
    UINT64 GuestSysenterEipMsr;
    UINT32 GuestSleepState;
    UINT32 GuestSysenterCsMsr;
    UINT64 Cr0GuestHostMask;
    UINT64 Cr4GuestHostMask;
    UINT64 Cr0ReadShadow;
    UINT64 Cr4ReadShadow;
    UINT64 GuestCr0;
    UINT64 GuestCr3;
    UINT64 GuestCr4;
    UINT64 GuestDr7;
    UINT64 HostFsBase;
    UINT64 HostGsBase;
    UINT64 HostTrBase;
    UINT64 HostGdtrBase;
    UINT64 HostIdtrBase;
    UINT64 HostRsp;
    UINT64 EptRoot;
    UINT16 Vpid;
    UINT16 Rsvd2[3];
    UINT64 Rsvd3[5];
    UINT64 ExitEptFaultGpa;
    UINT32 ExitInstructionError;
    UINT32 ExitReason;
    UINT32 ExitInterruptionInfo;
    UINT32 ExitExceptionErrorCode;
    UINT32 ExitIdtVectoringInfo;
    UINT32 ExitIdtVectoringErrorCode;
    UINT32 ExitInstructionLength;
    UINT32 ExitInstructionInfo;
    UINT64 ExitQualification;
    UINT64 ExitIoInstructionEcx;
    UINT64 ExitIoInstructionEsi;
    UINT64 ExitIoInstructionEdi;
    UINT64 ExitIoInstructionEip;
    UINT64 GuestLinearAddress;
    UINT64 GuestRsp;
    UINT64 GuestRflags;
    UINT32 GuestInterruptibility;
    UINT32 ProcessorControls;
    UINT32 ExceptionBitmap;
    UINT32 EntryControls;
    UINT32 EntryInterruptInfo;
    UINT32 EntryExceptionErrorCode;
    UINT32 EntryInstructionLength;
    UINT32 TprThreshold;
    UINT64 GuestRip;

    UINT32 CleanFields;
    UINT32 Rsvd4;
    UINT32 SyntheticControls;
    union
    {
        UINT32 AsUINT32;
        struct
        {
            UINT32 NestedFlushVirtualHypercall : 1;
            UINT32 MsrBitmap : 1;
            UINT32 Reserved : 30;
        };
     } EnlightenmentsControl;

    UINT32 VpId;
    UINT64 VmId;
    UINT64 PartitionAssistPage;
    UINT64 Rsvd5[4];

    UINT64 GuestBndcfgs;
    UINT64 GuestPerfGlobalCtrl;
    UINT64 GuestSCet;
    UINT64 GuestSsp;
    UINT64 GuestInterruptSspTableAddr;
    UINT64 GuestLbrCtl;
    UINT64 Rsvd6[2];

    UINT64 XssExitingBitmap;
    UINT64 EnclsExitingBitmap;
    UINT64 HostPerfGlobalCtrl;
    UINT64 TscMultiplier;
    UINT64 HostSCet;
    UINT64 HostSsp;
    UINT64 HostInterruptSspTableAddr;
    UINT64 Rsvd7;
} HV_VMX_ENLIGHTENED_VMCS;
 ```

## Physical VMCS Encoding

The following table maps the Intel physical VMCS encoding to its corresponding enlightened VMCS field name, as well as its corresponding clean field name. Note that some enlightened VMCS fields are synthetic, and therefore will not have a corresponding physical VMCS encoding.

| VMCS Encoding  | Enlightened Name            | Size   |  Clean Field Name             |
|----------------|-----------------------------|--------|-------------------------------|
| 0x0000681e     | GuestRip                    | 8      | NONE                          |
| 0x0000401c     | TprThreshold                | 4      | NONE                          |
| 0x0000681c     | GuestRsp                    | 8      | GUEST_BASIC                   |
| 0x00006820     | GuestRflags                 | 8      | GUEST_BASIC                   |
| 0x00004824     | GuestInterruptibility       | 4      | GUEST_BASIC                   |
| 0x00004002     | ProcessorControls           | 4      | CONTROL_PROC                  |
| 0x00004004     | ExceptionBitmap             | 4      | CONTROL_EXCPN                 |
| 0x00004012     | EntryControls               | 4      | CONTROL_ENTRY                 |
| 0x00004016     | EntryInterruptInfo          | 4      | CONTROL_EVENT                 |
| 0x00004018     | EntryExceptionErrorCode     | 4      | CONTROL_EVENT                 |
| 0x0000401a     | EntryInstructionLength      | 4      | CONTROL_EVENT                 |
| 0x00000c00     | HostEsSelector              | 2      | HOST_GRP1                     |
| 0x00000c02     | HostCsSelector              | 2      | HOST_GRP1                     |
| 0x00000c04     | HostSsSelector              | 2      | HOST_GRP1                     |
| 0x00000c06     | HostDsSelector              | 2      | HOST_GRP1                     |
| 0x00000c08     | HostFsSelector              | 2      | HOST_GRP1                     |
| 0x00000c0a     | HostGsSelector              | 2      | HOST_GRP1                     |
| 0x00000c0c     | HostTrSelector              | 2      | HOST_GRP1                     |
| 0x00002c00     | HostPat                     | 8      | HOST_GRP1                     |
| 0x00002c02     | HostEfer                    | 8      | HOST_GRP1                     |
| 0x00006c00     | HostCr0                     | 8      | HOST_GRP1                     |
| 0x00006c02     | HostCr3                     | 8      | HOST_GRP1                     |
| 0x00006c04     | HostCr4                     | 8      | HOST_GRP1                     |
| 0x00006c10     | HostSysenterEspMsr          | 8      | HOST_GRP1                     |
| 0x00006c12     | HostSysenterEipMsr          | 8      | HOST_GRP1                     |
| 0x00006c16     | HostSysenterCsMsr           | 4      | HOST_GRP1                     |
| 0x00004000     | PinControls                 | 4      | CONTROL_GRP1                  |
| 0x0000400c     | ExitControls                | 4      | CONTROL_GRP1                  |
| 0x0000401e     | SecondaryProcessorControls  | 4      | CONTROL_GRP1                  |
| 0x00002000     | IoBitmapA                   | 8      | IO_BITMAP                     |
| 0x00002002     | IoBitmapB                   | 8      | IO_BITMAP                     |
| 0x00002004     | MsrBitmap                   | 8      | MSR_BITMAP                    |
| 0x00000800     | GuestEsSelector             | 2      | GUEST_GRP2                    |
| 0x00000802     | GuestCsSelector             | 2      | GUEST_GRP2                    |
| 0x00000804     | GuestSsSelector             | 2      | GUEST_GRP2                    |
| 0x00000806     | GuestDsSelector             | 2      | GUEST_GRP2                    |
| 0x00000808     | GuestFsSelector             | 2      | GUEST_GRP2                    |
| 0x0000080a     | GuestGsSelector             | 2      | GUEST_GRP2                    |
| 0x0000080c     | GuestLdtrSelector           | 2      | GUEST_GRP2                    |
| 0x0000080e     | GuestTrSelector             | 2      | GUEST_GRP2                    |
| 0x00004800     | GuestEsLimit                | 4      | GUEST_GRP2                    |
| 0x00004802     | GuestCsLimit                | 4      | GUEST_GRP2                    |
| 0x00004804     | GuestSsLimit                | 4      | GUEST_GRP2                    |
| 0x00004806     | GuestDsLimit                | 4      | GUEST_GRP2                    |
| 0x00004808     | GuestFsLimit                | 4      | GUEST_GRP2                    |
| 0x0000480a     | GuestGsLimit                | 4      | GUEST_GRP2                    |
| 0x0000480c     | GuestLdtrLimit              | 4      | GUEST_GRP2                    |
| 0x0000480e     | GuestTrLimit                | 4      | GUEST_GRP2                    |
| 0x00004810     | GuestGdtrLimit              | 4      | GUEST_GRP2                    |
| 0x00004812     | GuestIdtrLimit              | 4      | GUEST_GRP2                    |
| 0x00004814     | GuestEsAttributes           | 4      | GUEST_GRP2                    |
| 0x00004816     | GuestCsAttributes           | 4      | GUEST_GRP2                    |
| 0x00004818     | GuestSsAttributes           | 4      | GUEST_GRP2                    |
| 0x0000481a     | GuestDsAttributes           | 4      | GUEST_GRP2                    |
| 0x0000481c     | GuestFsAttributes           | 4      | GUEST_GRP2                    |
| 0x0000481e     | GuestGsAttributes           | 4      | GUEST_GRP2                    |
| 0x00004820     | GuestLdtrAttributes         | 4      | GUEST_GRP2                    |
| 0x00004822     | GuestTrAttributes           | 4      | GUEST_GRP2                    |
| 0x00006806     | GuestEsBase                 | 8      | GUEST_GRP2                    |
| 0x00006808     | GuestCsBase                 | 8      | GUEST_GRP2                    |
| 0x0000680a     | GuestSsBase                 | 8      | GUEST_GRP2                    |
| 0x0000680c     | GuestDsBase                 | 8      | GUEST_GRP2                    |
| 0x0000680e     | GuestFsBase                 | 8      | GUEST_GRP2                    |
| 0x00006810     | GuestGsBase                 | 8      | GUEST_GRP2                    |
| 0x00006812     | GuestLdtrBase               | 8      | GUEST_GRP2                    |
| 0x00006814     | GuestTrBase                 | 8      | GUEST_GRP2                    |
| 0x00006816     | GuestGdtrBase               | 8      | GUEST_GRP2                    |
| 0x00006818     | GuestIdtrBase               | 8      | GUEST_GRP2                    |
| 0x00002010     | TscOffset                   | 8      | CONTROL_GRP2                  |
| 0x00002012     | VirtualApicPage             | 8      | CONTROL_GRP2                  |
| 0x00002800     | GuestWorkingVmcsPtr         | 8      | GUEST_GRP1                    |
| 0x00002802     | GuestIa32DebugCtl           | 8      | GUEST_GRP1                    |
| 0x00002804     | GuestPat                    | 8      | GUEST_GRP1                    |
| 0x00002806     | GuestEfer                   | 8      | GUEST_GRP1                    |
| 0x0000280a     | GuestPdpte0                 | 8      | GUEST_GRP1                    |
| 0x0000280c     | GuestPdpte1                 | 8      | GUEST_GRP1                    |
| 0x0000280e     | GuestPdpte2                 | 8      | GUEST_GRP1                    |
| 0x00002810     | GuestPdpte3                 | 8      | GUEST_GRP1                    |
| 0x00006822     | GuestPendingDebugExceptions | 8      | GUEST_GRP1                    |
| 0x00006824     | GuestSysenterEspMsr         | 8      | GUEST_GRP1                    |
| 0x00006826     | GuestSysenterEipMsr         | 8      | GUEST_GRP1                    |
| 0x00004826     | GuestSleepState             | 4      | GUEST_GRP1                    |
| 0x0000482a     | GuestSysenterCsMsr          | 4      | GUEST_GRP1                    |
| 0x00006000     | Cr0GuestHostMask            | 8      | CRDR                          |
| 0x00006002     | Cr4GuestHostMask            | 8      | CRDR                          |
| 0x00006004     | Cr0ReadShadow               | 8      | CRDR                          |
| 0x00006006     | Cr4ReadShadow               | 8      | CRDR                          |
| 0x00006800     | GuestCr0                    | 8      | CRDR                          |
| 0x00006802     | GuestCr3                    | 8      | CRDR                          |
| 0x00006804     | GuestCr4                    | 8      | CRDR                          |
| 0x0000681a     | GuestDr7                    | 8      | CRDR                          |
| 0x00006c06     | HostFsBase                  | 8      | HOST_POINTER                  |
| 0x00006c08     | HostGsBase                  | 8      | HOST_POINTER                  |
| 0x00006c0a     | HostTrBase                  | 8      | HOST_POINTER                  |
| 0x00006c0c     | HostGdtrBase                | 8      | HOST_POINTER                  |
| 0x00006c0e     | HostIdtrBase                | 8      | HOST_POINTER                  |
| 0x00006c14     | HostRsp                     | 8      | HOST_POINTER                  |
| 0x00000000     | Vpid                        | 2      | CONTROL_XLAT                  |
| 0x0000201a     | EptRoot                     | 8      | CONTROL_XLAT                  |
| 0x00002812     | GuestBndcfgs                | 8      | GUEST_GRP1                    |
| 0x00002808     | GuestPerfGlobalCtrl         | 8      | GUEST_GRP1                    |
| 0x00006828     | GuestSCet                   | 8      | GUEST_GRP1                    |
| 0x0000682A     | GuestSsp                    | 8      | GUEST_BASIC                   |
| 0x0000682C     | GuestInterruptSspTableAddr  | 8      | GUEST_GRP1                    |
| 0x00002816     | GuestLbrCtl                 | 8      | GUEST_GRP1                    |
| 0x0000202c     | XssExitingBitmap            | 8      | CONTROL_GRP2                  |
| 0x0000202e     | EnclsExitingBitmap          | 8      | CONTROL_GRP2                  |
| 0x00002C04     | HostPerfGlobalCtrl          | 8      | HOST_GRP1                     |
| 0x00002032     | TscMultiplier               | 8      | CONTROL_GRP2                  |
| 0x00006C18     | HostSCet                    | 8      | HOST_GRP1                     |
| 0x00006C1A     | HostSsp                     | 8      | HOST_GRP1                     |
| 0x00006C1C     | HostInterruptSspTableAddr   | 8      | HOST_GRP1                     |
| 0x00002400     | ExitEptFaultGpa             | 8      | NONE (Read only)              |
| 0x00004400     | ExitInstructionError        | 4      | NONE (Read only)              |
| 0x00004402     | ExitReason                  | 4      | NONE (Read only)              |
| 0x00004404     | ExitInterruptionInfo        | 4      | NONE (Read only)              |
| 0x00004406     | ExitExceptionErrorCode      | 4      | NONE (Read only)              |
| 0x00004408     | ExitIdtVectoringInfo        | 4      | NONE (Read only)              |
| 0x0000440a     | ExitIdtVectoringErrorCode   | 4      | NONE (Read only)              |
| 0x0000440c     | ExitInstructionLength       | 4      | NONE (Read only)              |
| 0x0000440e     | ExitInstructionInfo         | 4      | NONE (Read only)              |
| 0x00006400     | ExitQualification           | 8      | NONE (Read only)              |
| 0x00006402     | ExitIoInstructionEcx        | 8      | NONE (Read only)              |
| 0x00006404     | ExitIoInstructionEsi        | 8      | NONE (Read only)              |
| 0x00006406     | ExitIoInstructionEdi        | 8      | NONE (Read only)              |
| 0x00006408     | ExitIoInstructionEip        | 8      | NONE (Read only)              |
| 0x0000640a     | GuestLinearAddress          | 8      | NONE (Read only)              |
