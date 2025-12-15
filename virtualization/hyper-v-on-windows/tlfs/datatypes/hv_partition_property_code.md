---
title: HV_PARTITION_PROPERTY_CODE
description: HV_PARTITION_PROPERTY_CODE
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/07/2025
ms.topic: reference
---

# HV_PARTITION_PROPERTY_CODE

The HV_PARTITION_PROPERTY_CODE enumeration defines the  property selectors used with the partition property hypercalls.

## Syntax
```c
typedef enum {
    // Privilege properties
    HvPartitionPropertyPrivilegeFlags                       = 0x00010000,
    HvPartitionPropertySyntheticProcFeatures                = 0x00010001,

    // Scheduling properties
    HvPartitionPropertySuspend                              = 0x00020000,
    HvPartitionPropertyCpuReserve                           = 0x00020001,
    HvPartitionPropertyCpuCap                               = 0x00020002,
    HvPartitionPropertyCpuWeight                            = 0x00020003,
    HvPartitionPropertyCpuGroupId                           = 0x00020004,

    // Time properties
    HvPartitionPropertyTimeFreeze                           = 0x00030003,
    HvPartitionPropertyReferenceTime                        = 0x00030005,

    // Resource properties
    HvPartitionPropertyVirtualTlbPageCount                  = 0x00050000,
    HvPartitionPropertyVsmConfig                            = 0x00050001,
    HvPartitionPropertyZeroMemoryOnReset                    = 0x00050002,
    HvPartitionPropertyProcessorsPerSocket                  = 0x00050003,
    HvPartitionPropertyNestedTlbSize                        = 0x00050004,
    HvPartitionPropertyGpaPageAccessTracking                = 0x00050005,
    HvPartitionPropertyVsmPermissionsDirtySinceLastQuery    = 0x00050006,
    HvPartitionPropertyIsolationState                       = 0x0005000C,
    HvPartitionPropertyIsolationControl                     = 0x0005000D,
    HvPartitionPropertyAllocationId                         = 0x0005000E,
    HvPartitionPropertyMonitoringId                         = 0x0005000F,
    HvPartitionPropertyImplementedPhysicalAddressBits       = 0x00050010,
    HvPartitionPropertyNonArchitecturalCoreSharing          = 0x00050011,
    HvPartitionPropertyHypercallDoorbellPage                = 0x00050012,
    HvPartitionPropertyIsolationPolicy                      = 0x00050014,
    HvPartitionPropertyUnimplementedMsrAction               = 0x00050017,
    HvPartitionPropertySevVmgexitOffloads                   = 0x00050022,
    HvPartitionPropertyPartitionDiagBufferConfig            = 0x00050026,
    HvPartitionPropertyGicdBaseAddress                      = 0x00050028,
    HvPartitionPropertyGitsTranslaterBaseAddress            = 0x00050029,

    // Compatibility properties
    HvPartitionPropertyProcessorVendor                      = 0x00060000,
    HvPartitionPropertyProcessorXsaveFeatures               = 0x00060002,
    HvPartitionPropertyProcessorCLFlushSize                 = 0x00060003,
    HvPartitionPropertyEnlightenmentModifications           = 0x00060004,
    HvPartitionPropertyCompatibilityVersion                 = 0x00060005,
    HvPartitionPropertyPhysicalAddressWidth                 = 0x00060006,
    HvPartitionPropertyXsaveStates                          = 0x00060007,
    HvPartitionPropertyMaxXsaveDataSize                     = 0x00060008,
    HvPartitionPropertyProcessorClockFrequency              = 0x00060009,
    HvPartitionPropertyProcessorFeatures0                   = 0x0006000A,
    HvPartitionPropertyProcessorFeatures1                   = 0x0006000B,

    // Guest software properties
    HvPartitionPropertyGuestOsId                            = 0x00070000,

    // Nested virtualization properties
    HvPartitionPropertyProcessorVirtualizationFeatures      = 0x00080000,

    // Extended properties
    HvPartitionPropertyVmmCapabilities                      = 0x00090007,

    // VP-scoped properties
    HvPartitionVpPropertySchedulingAffinitySet              = 0x10001000,
} HV_PARTITION_PROPERTY_CODE;
```

## Architecture Notes

The following properties are x64-specific:
- `HvPartitionPropertyProcessorXsaveFeatures` - XSAVE is an x64 feature
- `HvPartitionPropertyXsaveStates` - XSAVE states
- `HvPartitionPropertyMaxXsaveDataSize` - XSAVE data size
- `HvPartitionPropertySevVmgexitOffloads` - AMD SEV-specific

The following properties are ARM64-specific:
- `HvPartitionPropertyGicdBaseAddress` - GIC Distributor base address
- `HvPartitionPropertyGitsTranslaterBaseAddress` - GIC ITS Translater base address

## Overview
Extended property codes require the *Ex* hypercall variants when their value representation exceeds 64 bits or is banked / variable sized.

### Early Properties
The following partition properties are classified as "early properties" that can be set before the partition is initialized:

* `HvPartitionPropertyPrivilegeFlags`
* `HvPartitionPropertySyntheticProcFeatures`
* `HvPartitionPropertyHypercallDoorbellPage`
* `HvPartitionPropertyPartitionDiagBufferConfig`
* `HvPartitionPropertyGicdBaseAddress`
* `HvPartitionPropertyGitsTranslaterBaseAddress`
* `HvPartitionPropertyPhysicalAddressWidth`
* `HvPartitionPropertyVmmCapabilities`

Early properties can be set after partition creation but before partition initialization, while regular properties generally require the partition to be in an initialized state.

## See Also
* [HvCallGetPartitionProperty](../hypercalls/HvCallGetPartitionProperty.md)
* [HvCallSetPartitionProperty](../hypercalls/HvCallSetPartitionProperty.md)
* [HvCallSetPartitionPropertyEx](../hypercalls/HvCallSetPartitionPropertyEx.md)
* [HV_PARTITION_ID](hv_partition_id.md)
* [HV_PARTITION_PRIVILEGE_MASK](hv_partition_privilege_mask.md)
