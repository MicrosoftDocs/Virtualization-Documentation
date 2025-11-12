---
title: HvCallPostMessageDirect
description: HvCallPostMessageDirect hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/01/2025
ms.topic: reference

---

# HvCallPostMessageDirect

The HvCallPostMessageDirect hypercall posts a message directly to a target virtual processor's message queue without going through the traditional message port mechanism.

## Interface

 ```c
HV_STATUS
HvCallPostMessageDirect(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VP_INDEX VpIndex,
    _In_ HV_VTL Vtl,
    _In_ HV_SYNIC_SINT_INDEX SintIndex,
    _In_reads_bytes_(HV_MESSAGE_SIZE) UINT8* Message
);
 ```

## Call Code

`0x00C1` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| PartitionId             | 0          | 8        | Partition ID of the target partition      |
| VpIndex                 | 8          | 4        | Target virtual processor index            |
| Vtl                     | 12         | 1        | Virtual Trust Level                       |
| SintIndex               | 13         | 1        | Synthetic interrupt index                 |
| Message                 | 16         | 240      | Message data to post (HV_MESSAGE_SIZE)    |

## See also

[HV_PARTITION_ID](../datatypes/hv_partition_id.md)
[HV_VP_INDEX](../datatypes/hv_vp_index.md)
[HV_VTL](../datatypes/hv_vtl.md)
[HV_SYNIC_SINT_INDEX](../datatypes/hv_synic_sint_index.md)
[HV_MESSAGE](../datatypes/hv_message.md)
[HvCallSignalEventDirect](HvCallSignalEventDirect.md)