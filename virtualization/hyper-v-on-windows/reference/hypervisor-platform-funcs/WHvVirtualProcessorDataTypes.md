# Virtual Processor Register Names and Values

## Syntax

```C
// Register names (subset of HV_REGISTER_NAME) 
typedef enum { 
    // General purpose registers 
    WHvX64RegisterRax...R15, 
    WHvX64RegisterRip, 
    WHvX64RegisterRflags, 
     
    // Segment registers 
    WhvX64RegisterCs..Gs, 
    WhvX64RegisterLdtr, 
    WhvX64RegisterTr, 
     
    // Table registers 
    WHvX64RegisterIdtr, 
    WHvX64RegisterGdtr, 
     
    // Floating-point registers 
    WhvX64RegisterXmm0...15, 
    WhvX64RegisterFpMmx0...7, 
    WhvX64RegisterFpControlStatus, 
    WhvX64RegisterXmmControlStatus, 
     
    // Control registers 
    WHvX64RegisterCr0...Cr8, 
     
    // Debug Registers 
    WHvX64RegisterDr0...Dr7, 
     
    // MSRs 
    WHvX64RegisterTsc, 
    WHvX64RegisterEfer, 
    WHvX64RegisterKernelGsBase, 
    WHvX64RegisterApicBase, 
    WHvX64RegisterPat, 
    WHvX64RegisterSysenterCs, 
    WHvX64RegisterSysenterRip, 
    WHvX64RegisterSysenterRsp, 
    WHvX64RegisterStar, 
    WHvX64RegisterLstar, 
    WHvX64RegisterCstar, 
    WHvX64RegisterSfmask, 
 
    // Interrupt Registers 
    WHvRegisterPendingInterruption, 
    WHvRegisterInterruptState, 
    WHvRegisterPendingEvent0, 
    WHvRegisterPendingEvent1, 
    WHvX64RegisterDeliverabilityNotifications 
} WHV_REGISTER_NAME; 
 
// Register value (HV_REGISTER_VALUE) 
typedef union { 
    WHV_UINT128 Reg128; 
    UINT64 Reg64; 
    UINT32 Reg32; 
    UINT16 Reg16; 
    UINT8  Reg8; 
    WHV_X64_FP_REGISTER Fp; 
    WHV_X64_FP_CONTROL_STATUS_REGISTER FpControlStatus; 
    WHV_X64_XMM_CONTROL_STATUS_REGISTER XmmControlStatus; 
    WHV_X64_SEGMENT_REGISTER Segment; 
    WHV_X64_TABLE_REGISTER Table; 
    WHV_X64_INTERRUPT_STATE_REGISTER InterruptState; 
    WHV_X64_PENDING_INTERRUPTION_REGISTER PendingInterruption; 
} WHV_REGISTER_VALUE; 
```

## Remarks

The data types for the virtual processor registers