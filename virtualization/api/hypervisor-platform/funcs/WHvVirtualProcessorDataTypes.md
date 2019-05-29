# Virtual Processor Register Names and Values

## Syntax

```C
//
// Virtual Processor Register Definitions
//
typedef enum WHV_REGISTER_NAME
{
    // X64 General purpose registers
    WHvX64RegisterRax              = 0x00000000,
    WHvX64RegisterRcx              = 0x00000001,
    WHvX64RegisterRdx              = 0x00000002,
    WHvX64RegisterRbx              = 0x00000003,
    WHvX64RegisterRsp              = 0x00000004,
    WHvX64RegisterRbp              = 0x00000005,
    WHvX64RegisterRsi              = 0x00000006,
    WHvX64RegisterRdi              = 0x00000007,
    WHvX64RegisterR8               = 0x00000008,
    WHvX64RegisterR9               = 0x00000009,
    WHvX64RegisterR10              = 0x0000000A,
    WHvX64RegisterR11              = 0x0000000B,
    WHvX64RegisterR12              = 0x0000000C,
    WHvX64RegisterR13              = 0x0000000D,
    WHvX64RegisterR14              = 0x0000000E,
    WHvX64RegisterR15              = 0x0000000F,
    WHvX64RegisterRip              = 0x00000010,
    WHvX64RegisterRflags           = 0x00000011,

    // X64 Segment registers
    WHvX64RegisterEs               = 0x00000012,
    WHvX64RegisterCs               = 0x00000013,
    WHvX64RegisterSs               = 0x00000014,
    WHvX64RegisterDs               = 0x00000015,
    WHvX64RegisterFs               = 0x00000016,
    WHvX64RegisterGs               = 0x00000017,
    WHvX64RegisterLdtr             = 0x00000018,
    WHvX64RegisterTr               = 0x00000019,

    // X64 Table registers
    WHvX64RegisterIdtr             = 0x0000001A,
    WHvX64RegisterGdtr             = 0x0000001B,

    // X64 Control Registers
    WHvX64RegisterCr0              = 0x0000001C,
    WHvX64RegisterCr2              = 0x0000001D,
    WHvX64RegisterCr3              = 0x0000001E,
    WHvX64RegisterCr4              = 0x0000001F,
    WHvX64RegisterCr8              = 0x00000020,

    // X64 Debug Registers
    WHvX64RegisterDr0              = 0x00000021,
    WHvX64RegisterDr1              = 0x00000022,
    WHvX64RegisterDr2              = 0x00000023,
    WHvX64RegisterDr3              = 0x00000024,
    WHvX64RegisterDr6              = 0x00000025,
    WHvX64RegisterDr7              = 0x00000026,

    // X64 Extended Control Registers
    WHvX64RegisterXCr0             = 0x00000027,

    // X64 Floating Point and Vector Registers
    WHvX64RegisterXmm0             = 0x00001000,
    WHvX64RegisterXmm1             = 0x00001001,
    WHvX64RegisterXmm2             = 0x00001002,
    WHvX64RegisterXmm3             = 0x00001003,
    WHvX64RegisterXmm4             = 0x00001004,
    WHvX64RegisterXmm5             = 0x00001005,
    WHvX64RegisterXmm6             = 0x00001006,
    WHvX64RegisterXmm7             = 0x00001007,
    WHvX64RegisterXmm8             = 0x00001008,
    WHvX64RegisterXmm9             = 0x00001009,
    WHvX64RegisterXmm10            = 0x0000100A,
    WHvX64RegisterXmm11            = 0x0000100B,
    WHvX64RegisterXmm12            = 0x0000100C,
    WHvX64RegisterXmm13            = 0x0000100D,
    WHvX64RegisterXmm14            = 0x0000100E,
    WHvX64RegisterXmm15            = 0x0000100F,
    WHvX64RegisterFpMmx0           = 0x00001010,
    WHvX64RegisterFpMmx1           = 0x00001011,
    WHvX64RegisterFpMmx2           = 0x00001012,
    WHvX64RegisterFpMmx3           = 0x00001013,
    WHvX64RegisterFpMmx4           = 0x00001014,
    WHvX64RegisterFpMmx5           = 0x00001015,
    WHvX64RegisterFpMmx6           = 0x00001016,
    WHvX64RegisterFpMmx7           = 0x00001017,
    WHvX64RegisterFpControlStatus  = 0x00001018,
    WHvX64RegisterXmmControlStatus = 0x00001019,

    // X64 MSRs
    WHvX64RegisterTsc              = 0x00002000,
    WHvX64RegisterEfer             = 0x00002001,
    WHvX64RegisterKernelGsBase     = 0x00002002,
    WHvX64RegisterApicBase         = 0x00002003,
    WHvX64RegisterPat              = 0x00002004,
    WHvX64RegisterSysenterCs       = 0x00002005,
    WHvX64RegisterSysenterEip      = 0x00002006,
    WHvX64RegisterSysenterEsp      = 0x00002007,
    WHvX64RegisterStar             = 0x00002008,
    WHvX64RegisterLstar            = 0x00002009,
    WHvX64RegisterCstar            = 0x0000200A,
    WHvX64RegisterSfmask           = 0x0000200B,

    WHvX64RegisterMsrMtrrCap         = 0x0000200D,
    WHvX64RegisterMsrMtrrDefType     = 0x0000200E,

    WHvX64RegisterMsrMtrrPhysBase0   = 0x00002010,
    WHvX64RegisterMsrMtrrPhysBase1   = 0x00002011,
    WHvX64RegisterMsrMtrrPhysBase2   = 0x00002012,
    WHvX64RegisterMsrMtrrPhysBase3   = 0x00002013,
    WHvX64RegisterMsrMtrrPhysBase4   = 0x00002014,
    WHvX64RegisterMsrMtrrPhysBase5   = 0x00002015,
    WHvX64RegisterMsrMtrrPhysBase6   = 0x00002016,
    WHvX64RegisterMsrMtrrPhysBase7   = 0x00002017,
    WHvX64RegisterMsrMtrrPhysBase8   = 0x00002018,
    WHvX64RegisterMsrMtrrPhysBase9   = 0x00002019,
    WHvX64RegisterMsrMtrrPhysBaseA   = 0x0000201A,
    WHvX64RegisterMsrMtrrPhysBaseB   = 0x0000201B,
    WHvX64RegisterMsrMtrrPhysBaseC   = 0x0000201C,
    WHvX64RegisterMsrMtrrPhysBaseD   = 0x0000201D,
    WHvX64RegisterMsrMtrrPhysBaseE   = 0x0000201E,
    WHvX64RegisterMsrMtrrPhysBaseF   = 0x0000201F,

    WHvX64RegisterMsrMtrrPhysMask0   = 0x00002040,
    WHvX64RegisterMsrMtrrPhysMask1   = 0x00002041,
    WHvX64RegisterMsrMtrrPhysMask2   = 0x00002042,
    WHvX64RegisterMsrMtrrPhysMask3   = 0x00002043,
    WHvX64RegisterMsrMtrrPhysMask4   = 0x00002044,
    WHvX64RegisterMsrMtrrPhysMask5   = 0x00002045,
    WHvX64RegisterMsrMtrrPhysMask6   = 0x00002046,
    WHvX64RegisterMsrMtrrPhysMask7   = 0x00002047,
    WHvX64RegisterMsrMtrrPhysMask8   = 0x00002048,
    WHvX64RegisterMsrMtrrPhysMask9   = 0x00002049,
    WHvX64RegisterMsrMtrrPhysMaskA   = 0x0000204A,
    WHvX64RegisterMsrMtrrPhysMaskB   = 0x0000204B,
    WHvX64RegisterMsrMtrrPhysMaskC   = 0x0000204C,
    WHvX64RegisterMsrMtrrPhysMaskD   = 0x0000204D,
    WHvX64RegisterMsrMtrrPhysMaskE   = 0x0000204E,
    WHvX64RegisterMsrMtrrPhysMaskF   = 0x0000204F,

    WHvX64RegisterMsrMtrrFix64k00000 = 0x00002070,
    WHvX64RegisterMsrMtrrFix16k80000 = 0x00002071,
    WHvX64RegisterMsrMtrrFix16kA0000 = 0x00002072,
    WHvX64RegisterMsrMtrrFix4kC0000  = 0x00002073,
    WHvX64RegisterMsrMtrrFix4kC8000  = 0x00002074,
    WHvX64RegisterMsrMtrrFix4kD0000  = 0x00002075,
    WHvX64RegisterMsrMtrrFix4kD8000  = 0x00002076,
    WHvX64RegisterMsrMtrrFix4kE0000  = 0x00002077,
    WHvX64RegisterMsrMtrrFix4kE8000  = 0x00002078,
    WHvX64RegisterMsrMtrrFix4kF0000  = 0x00002079,
    WHvX64RegisterMsrMtrrFix4kF8000  = 0x0000207A,

    WHvX64RegisterTscAux           = 0x0000207B,
    WHvX64RegisterSpecCtrl         = 0x00002084,
    WHvX64RegisterPredCmd          = 0x00002085,
    WHvX64RegisterTscVirtualOffset = 0x00002087,

    // APIC state (also accessible via WHv(Get/Set)VirtualProcessorInterruptControllerState)
    WHvX64RegisterApicId           = 0x00003002,
    WHvX64RegisterApicVersion      = 0x00003003,

    // Interrupt / Event Registers
    WHvRegisterPendingInterruption = 0x80000000,
    WHvRegisterInterruptState      = 0x80000001,
    WHvRegisterPendingEvent        = 0x80000002,
    WHvX64RegisterDeliverabilityNotifications = 0x80000004,
    WHvRegisterInternalActivityState = 0x80000005,

} WHV_REGISTER_NAME;

typedef union DECLSPEC_ALIGN(16) WHV_UINT128
{
    struct
    {
        UINT64  Low64;
        UINT64  High64;
    };

    UINT32  Dword[4];
} WHV_UINT128;

typedef union WHV_X64_FP_REGISTER
{
    struct
    {
        UINT64 Mantissa;
        UINT64 BiasedExponent:15;
        UINT64 Sign:1;
        UINT64 Reserved:48;
    };

    WHV_UINT128 AsUINT128;
} WHV_X64_FP_REGISTER;

typedef union WHV_X64_FP_CONTROL_STATUS_REGISTER
{
    struct
    {
        UINT16 FpControl;
        UINT16 FpStatus;
        UINT8  FpTag;
        UINT8  Reserved;
        UINT16 LastFpOp;
        union
        {
            // Long Mode
            UINT64 LastFpRip;

            // 32 Bit Mode
            struct
            {
                UINT32 LastFpEip;
                UINT16 LastFpCs;
            };
        };
    };

    WHV_UINT128 AsUINT128;
} WHV_X64_FP_CONTROL_STATUS_REGISTER;

typedef union WHV_X64_XMM_CONTROL_STATUS_REGISTER
{
    struct
    {
        union
        {
            // Long Mode
            UINT64 LastFpRdp;

            // 32 Bit Mode
            struct
            {
                UINT32 LastFpDp;
                UINT16 LastFpDs;
            };
        };
        UINT32 XmmStatusControl;
        UINT32 XmmStatusControlMask;
    };

    WHV_UINT128 AsUINT128;
} WHV_X64_XMM_CONTROL_STATUS_REGISTER;

typedef struct WHV_X64_SEGMENT_REGISTER
{
    UINT64 Base;
    UINT32 Limit;
    UINT16 Selector;

    union
    {
        struct
        {
            UINT16 SegmentType:4;
            UINT16 NonSystemSegment:1;
            UINT16 DescriptorPrivilegeLevel:2;
            UINT16 Present:1;
            UINT16 Reserved:4;
            UINT16 Available:1;
            UINT16 Long:1;
            UINT16 Default:1;
            UINT16 Granularity:1;
        };

        UINT16 Attributes;
    };
} WHV_X64_SEGMENT_REGISTER;

typedef struct WHV_X64_TABLE_REGISTER
{
    UINT16     Pad[3];
    UINT16     Limit;
    UINT64     Base;
} WHV_X64_TABLE_REGISTER;

typedef union WHV_X64_INTERRUPT_STATE_REGISTER
{
    struct
    {
        UINT64 InterruptShadow:1;
        UINT64 NmiMasked:1;
        UINT64 Reserved:62;
    };

    UINT64 AsUINT64;
} WHV_X64_INTERRUPT_STATE_REGISTER;

typedef union WHV_X64_PENDING_INTERRUPTION_REGISTER
{
    struct
    {
        UINT32 InterruptionPending:1;
        UINT32 InterruptionType:3;  // WHV_X64_PENDING_INTERRUPTION_TYPE
        UINT32 DeliverErrorCode:1;
        UINT32 InstructionLength:4;
        UINT32 NestedEvent:1;
        UINT32 Reserved:6;
        UINT32 InterruptionVector:16;
        UINT32 ErrorCode;
    };

    UINT64 AsUINT64;
} WHV_X64_PENDING_INTERRUPTION_REGISTER;

C_ASSERT(sizeof(WHV_X64_PENDING_INTERRUPTION_REGISTER) == sizeof(UINT64));

typedef union WHV_X64_DELIVERABILITY_NOTIFICATIONS_REGISTER
{
    struct
    {
        UINT64 NmiNotification:1;
        UINT64 InterruptNotification:1;
        UINT64 InterruptPriority:4;
        UINT64 Reserved:58;
    };

    UINT64 AsUINT64;
} WHV_X64_DELIVERABILITY_NOTIFICATIONS_REGISTER;

C_ASSERT(sizeof(WHV_X64_DELIVERABILITY_NOTIFICATIONS_REGISTER) == sizeof(UINT64));


typedef enum WHV_X64_PENDING_EVENT_TYPE
{
    WHvX64PendingEventException = 0,
    WHvX64PendingEventExtInt    = 5,
} WHV_X64_PENDING_EVENT_TYPE;

typedef union WHV_X64_PENDING_EXCEPTION_EVENT
{
    struct
    {
        UINT32 EventPending         : 1;
        UINT32 EventType            : 3; // Must be WHvX64PendingEventException
        UINT32 Reserved0            : 4;

        UINT32 DeliverErrorCode     : 1;
        UINT32 Reserved1            : 7;
        UINT32 Vector               : 16;
        UINT32 ErrorCode;
        UINT64 ExceptionParameter;
    };

    WHV_UINT128 AsUINT128;
} WHV_X64_PENDING_EXCEPTION_EVENT;

C_ASSERT(sizeof(WHV_X64_PENDING_EXCEPTION_EVENT) == sizeof(WHV_UINT128));

typedef union WHV_X64_PENDING_EXT_INT_EVENT
{
    struct
    {
        UINT64 EventPending     : 1;
        UINT64 EventType        : 3; // Must be WHvX64PendingEventExtInt
        UINT64 Reserved0        : 4;
        UINT64 Vector           : 8;
        UINT64 Reserved1        : 48;

        UINT64 Reserved2;
    };

    WHV_UINT128 AsUINT128;
} WHV_X64_PENDING_EXT_INT_EVENT;

C_ASSERT(sizeof(WHV_X64_PENDING_EXT_INT_EVENT) == sizeof(WHV_UINT128));

//
// Register values
//
typedef union WHV_REGISTER_VALUE
{
    WHV_UINT128 Reg128;
    UINT64 Reg64;
    UINT32 Reg32;
    UINT16 Reg16;
    UINT8 Reg8;
    WHV_X64_FP_REGISTER Fp;
    WHV_X64_FP_CONTROL_STATUS_REGISTER FpControlStatus;
    WHV_X64_XMM_CONTROL_STATUS_REGISTER XmmControlStatus;
    WHV_X64_SEGMENT_REGISTER Segment;
    WHV_X64_TABLE_REGISTER Table;
    WHV_X64_INTERRUPT_STATE_REGISTER InterruptState;
    WHV_X64_PENDING_INTERRUPTION_REGISTER PendingInterruption;
    WHV_X64_DELIVERABILITY_NOTIFICATIONS_REGISTER DeliverabilityNotifications;
    WHV_X64_PENDING_EXCEPTION_EVENT ExceptionEvent;
    WHV_X64_PENDING_EXT_INT_EVENT ExtIntEvent;
} WHV_REGISTER_VALUE;
```

## Remarks

The data types for the virtual processor registers