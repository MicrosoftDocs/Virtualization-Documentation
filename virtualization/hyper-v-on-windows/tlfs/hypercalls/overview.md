---
title: Hypercall Reference
description: List of supported hypercalls
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference

---

# Hypercall Reference

The following table lists supported hypercalls by call code.

| Call Code | Type    | Hypercall                                                                           |
|-----------|---------|-------------------------------------------------------------------------------------|
| 0x0001    | Simple  | HvCallSwitchVirtualAddressSpace                                                     |
| 0x0002    | Simple  | [HvCallFlushVirtualAddressSpace](HvCallFlushVirtualAddressSpace.md)                 |
| 0x0003    | Rep     | [HvCallFlushVirtualAddressList](HvCallFlushVirtualAddressList.md)                   |
| 0x0008    | Simple  | [HvCallNotifyLongSpinWait](HvCallNotifyLongSpinWait.md)                             |
| 0x000b    | Simple  | [HvCallSendSyntheticClusterIpi](HvCallSendSyntheticClusterIpi.md)                   |
| 0x000c    | Rep     | [HvCallModifyVtlProtectionMask](HvCallModifyVtlProtectionMask.md)                   |
| 0x000d    | Simple  | [HvCallEnablePartitionVtl](HvCallEnablePartitionVtl.md)                             |
| 0x000f    | Simple  | [HvCallEnableVpVtl](HvCallEnableVpVtl.md)                                           |
| 0x0011    | Simple  | [HvCallVtlCall](HvCallVtlCall.md)                                                   |
| 0x0012    | Simple  | [HvCallVtlReturn](HvCallVtlReturn.md)                                               |
| 0x0013    | Simple  | [HvCallFlushVirtualAddressSpaceEx](HvCallFlushVirtualAddressSpaceEx.md)             |
| 0x0014    | Rep     | [HvCallFlushVirtualAddressListEx](HvCallFlushVirtualAddressListEx.md)               |
| 0x0015    | Simple  | [HvCallSendSyntheticClusterIpiEx](HvCallSendSyntheticClusterIpiEx.md)               |
| 0x0050    | Rep     | [HvCallGetVpRegisters](HvCallGetVpRegisters.md)                                     |
| 0x0051    | Rep     | [HvCallSetVpRegisters](HvCallSetVpRegisters.md)                                     |
| 0x005C    | Simple  | [HvCallPostMessage](HvCallPostMessage.md)                                           |
| 0x005D    | Simple  | [HvCallSignalEvent](HvCallSignalEvent.md)                                           |
| 0x007e    | Simple  | [HvCallRetargetDeviceInterrupt](HvCallRetargetDeviceInterrupt.md)                   |
| 0x0099    | Simple  | [HvCallStartVirtualProcessor](HvCallStartVirtualProcessor.md)                       |
| 0x009A    | Rep     | [HvCallGetVpIndexFromApicId](HvCallGetVpIndexFromApicId.md)                         |
| 0x00AF    | Simple  | [HvCallFlushGuestPhysicalAddressSpace](HvCallFlushGuestPhysicalAddressSpace.md)     |
| 0x00B0    | Rep     | [HvCallFlushGuestPhysicalAddressList](HvCallFlushGuestPhysicalAddressList.md)       |

The following table lists supported extended hypercalls by call code.

| Call Code | Type    | Hypercall                                                                           |
|-----------|---------|-------------------------------------------------------------------------------------|
| 0x8001    | Simple  | [HvExtCallQueryCapabilities](HvExtCallQueryCapabilities.md)                         |
| 0x8002    | Simple  | [HvExtCallGetBootZeroedMemory](HvExtCallGetBootZeroedMemory.md)                     |
| 0x8003    | Simple  | HvExtCallMemoryHeatHint                                                             |
| 0x8004    | Simple  | HvExtCallEpfSetup                                                                   |
| 0x8006    | Simple  | HvExtCallMemoryHeatHintAsync                                                        |
