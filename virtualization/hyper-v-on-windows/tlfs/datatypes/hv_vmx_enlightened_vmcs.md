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
    UINT64 Rsvd6[7];
    UINT64 XssExitingBitmap;
    UINT64 EnclsExitingBitmap;
    UINT64 Rsvd7[6];
} HV_VMX_ENLIGHTENED_VMCS;
 ```

## Physical VMCS Encoding

The following table maps the Intel physical VMCS encoding to its corresponding enlightened VMCS field name, as well as its corresponding clean field name. Note that some enlightened VMCS fields are synthetic, and therefore will not have a corresponding physical VMCS encoding.

| VMCS Encoding  | Enlightened Name            | Size   |  Clean Field Name                                            |
|----------------|-----------------------------|--------|--------------------------------------------------------------|
| 0x0000681e     | GuestRip                    | 8      | HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                          |
| 0x0000401c     | TprThreshold                | 4      | HV_VMX_ENLIGHTENED_CLEAN_FIELD_NONE                          |
| 0x0000681c     | GuestRsp                    | 8      | HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC                   |
| 0x00006820     | GuestRflags                 | 8      | HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC                   |
| 0x00004824     | GuestInterruptibility       | 4      | HV_VMX_ENLIGHTENED_CLEAN_FIELD_GUEST_BASIC                   |
| 0x00004002     | ProcessorControls           | 4      | HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_PROC                  |
| 0x00004004     | ExceptionBitmap             | 4      | HV_VMX_ENLIGHTENED_CLEAN_FIELD_CONTROL_EXCPN                 |
