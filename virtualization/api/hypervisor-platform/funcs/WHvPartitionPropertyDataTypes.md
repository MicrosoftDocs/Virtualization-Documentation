---
title: Partition Property Data Types
description: Descriptive content for managing WHvPartitionPropertyDataTypes and understanding its requirements and remarks. 
author: Juarezhm
ms.author: hajuarez
ms.date: 05/31/2019
---

# Partition Property Data Types


## Syntax
```C
typedef enum { 
    WHvPartitionPropertyCodeExtendedVmExits        = 0x00000001,
    WHvPartitionPropertyCodeExceptionExitBitmap     = 0x00000002, 
    WHvPartitionPropertyCodeSeparateSecurityDomain  = 0x00000003,

    WHvPartitionPropertyCodeProcessorFeatures      = 0x00001001, 
    WHVPartitionPropertyCodeProcessorClFlushSize   = 0x00001002, 
    WHvPartitionPropertyCodeCpuidExitList           = 0x00001003,
    WHvPartitionPropertyCodeCpuidResultList         = 0x00001004,
    WHvPartitionPropertyCodeLocalApicEmulationMode  = 0x00001005,
    WHvPartitionPropertyCodeProcessorXsaveFeatures  = 0x00001006,

    WHvPartitionPropertyCodeProcessorCount         = 0x00001fff 
} WHV_PARTITION_PROPERTY_CODE; 

//
// WHvPartitionPropertyCodeCpuidResultList input buffer list element.
//
typedef struct WHV_X64_CPUID_RESULT
{
    UINT32 Function;
    UINT32 Reserved[3];
    UINT32 Eax;
    UINT32 Ebx;
    UINT32 Ecx;
    UINT32 Edx;
} WHV_X64_CPUID_RESULT;
 
//
// WHvPartitionPropertyCodeExceptionBitmap enumeration values.
//
typedef enum WHV_EXCEPTION_TYPE
{
    WHvX64ExceptionTypeDivideErrorFault = 0x0,
    WHvX64ExceptionTypeDebugTrapOrFault = 0x1,
    WHvX64ExceptionTypeBreakpointTrap = 0x3,
    WHvX64ExceptionTypeOverflowTrap = 0x4,
    WHvX64ExceptionTypeBoundRangeFault = 0x5,
    WHvX64ExceptionTypeInvalidOpcodeFault = 0x6,
    WHvX64ExceptionTypeDeviceNotAvailableFault = 0x7,
    WHvX64ExceptionTypeDoubleFaultAbort = 0x8,
    WHvX64ExceptionTypeInvalidTaskStateSegmentFault = 0x0A,
    WHvX64ExceptionTypeSegmentNotPresentFault = 0x0B,
    WHvX64ExceptionTypeStackFault = 0x0C,
    WHvX64ExceptionTypeGeneralProtectionFault = 0x0D,
    WHvX64ExceptionTypePageFault = 0x0E,
    WHvX64ExceptionTypeFloatingPointErrorFault = 0x10,
    WHvX64ExceptionTypeAlignmentCheckFault = 0x11,
    WHvX64ExceptionTypeMachineCheckAbort = 0x12,
    WHvX64ExceptionTypeSimdFloatingPointFault = 0x13,
} WHV_EXCEPTION_TYPE;

typedef enum WHV_X64_LOCAL_APIC_EMULATION_MODE
{
    WHvX64LocalApicEmulationModeNone,
    WHvX64LocalApicEmulationModeXApic,
} WHV_X64_LOCAL_APIC_EMULATION_MODE;

//
// Return value for WHvCapabilityCodeX64MsrExits and input buffer for
// WHvPartitionPropertyCodeX64MsrcExits
//
typedef union WHV_X64_MSR_EXIT_BITMAP
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 UnhandledMsrs:1;
        UINT64 TscMsrWrite:1;
        UINT64 TscMsrRead:1;
        UINT64 Reserved:61;
    };

} WHV_X64_MSR_EXIT_BITMAP;

//
// WHvGetPartitionProperty output buffer / WHvSetPartitionProperty input buffer
//
typedef union WHV_PARTITION_PROPERTY
{
    WHV_EXTENDED_VM_EXITS ExtendedVmExits;
    WHV_PROCESSOR_FEATURES ProcessorFeatures;
    WHV_PROCESSOR_XSAVE_FEATURES ProcessorXsaveFeatures;
    UINT8 ProcessorClFlushSize;
    UINT32 ProcessorCount;
    UINT32 CpuidExitList[1];
    WHV_X64_CPUID_RESULT CpuidResultList[1];
    UINT64 ExceptionExitBitmap;
    WHV_X64_LOCAL_APIC_EMULATION_MODE LocalApicEmulationMode;
    BOOL SeparateSecurityDomain;
    BOOL NestedVirtualization;
    WHV_X64_MSR_EXIT_BITMAP X64MsrExitBitmap;
    UINT64 ProcessorClockFrequency;
    UINT64 InterruptClockFrequency;
} WHV_PARTITION_PROPERTY;
```


## Remarks

The `WHvPartitionPropertyCodeExtendedVmExits` property controls the set of additional operations by a virtual processor that should cause the execution of the processor to exit and to return to the caller of the [`WHvRunVirtualProcessor`](WHvRunVirtualProcessor.md) function.

The `WHvPartitionPropertyCodeProcessorXXX` properties control the processor features that are made available to the virtual processor of the partition. These properties can only be configured during the initial creation of the partition, prior to calling [`WHvSetupPartition`](WHvSetupPartition.md).

## Requirements

Minimum supported build:    Insider Preview Builds (19H2) Experimental:
`NestedVirtualization`
`X64MsrExitBitmap`
`ProcessorClockFrequency`
`InterruptClockFrequency`