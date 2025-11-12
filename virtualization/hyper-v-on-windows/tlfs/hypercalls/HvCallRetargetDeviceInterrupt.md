---
title: HvCallRetargetDeviceInterrupt
description: HvCallRetargetDeviceInterrupt hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference

---

# HvCallRetargetDeviceInterrupt

This hypercall retargets a device interrupt, which may be useful for rebalancing IRQs within a guest.

## Interface

 ```c
HV_STATUS
HvRetargetDeviceInterrupt(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ UINT64 DeviceId,
    _In_ HV_INTERRUPT_ENTRY InterruptEntry,
    _In_ UINT64 Reserved,
    _In_ HV_DEVICE_INTERRUPT_TARGET InterruptTarget
    );
 ```

## Call Code
`0x007e` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `PartitionId`           | 0          | 8        | Partition Id (can be HV_PARTITION_ID_SELF)   |
| `DeviceId`              | 8          | 6        | Supplies the unique (within a guest) logical device ID that is assigned by the host.   |
| RsvdZ                   | 32         | 8        | Reserved                                  |
| `InterruptEntry`        | 16         | 16       | Supplies the MSI address and data that identifies the interrupt. |
| `InterruptTarget`       | 40         | 16       | Specifies a mask representing VPs to target|

## See also

[HV_INTERRUPT_ENTRY](../datatypes/HV_INTERRUPT_ENTRY.md)
[HV_DEVICE_INTERRUPT_TARGET](../datatypes/HV_DEVICE_INTERRUPT_TARGET.md)
