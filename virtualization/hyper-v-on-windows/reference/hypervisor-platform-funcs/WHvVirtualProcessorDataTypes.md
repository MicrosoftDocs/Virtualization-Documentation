# Virtual Processor Register Names and Values
**Note: These APIs are not yet publically available and will be included in a future Windows release.  Subject to change.**

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

    // Interrupt / Event Registers
    WHvRegisterPendingInterruption = 0x80000000,
    WHvRegisterInterruptState      = 0x80000001,
    WHvRegisterPendingEvent0       = 0x80000002,
    WHvRegisterPendingEvent1       = 0x80000003,
    WHvX64RegisterDeliverabilityNotifications = 0x80000004,

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
} WHV_REGISTER_VALUE;
```

## Remarks

The data types for the virtual processor registers