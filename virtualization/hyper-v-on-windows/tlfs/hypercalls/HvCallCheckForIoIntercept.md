---
title: HvCallCheckForIoIntercept
description: HvCallCheckForIoIntercept hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference

---

# HvCallCheckForIoIntercept

HvCallCheckForIoIntercept determines if I/O to a specific port would cause an intercept for a virtual processor in a specified partition. This hypercall allows the hypervisor to check if I/O operations will be intercepted without actually performing the I/O operation.

Architecture: x64 only.

## Interface

 ```c
HV_STATUS
HvCallCheckForIoIntercept(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VP_INDEX     VpIndex,
    _In_ HV_INPUT_VTL    TargetVtl,
    _In_ HV_IO_PORT      Port,
    _In_ UINT8           Size,
    _In_ BOOLEAN         IsWrite,
    _Out_ BOOLEAN*       Intercept
);
 ```

## Call Code

`0x00AD` (Simple)


## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `PartitionId`           | 0          | 8        | Specifies the ID of the target partition. |
| `VpIndex`               | 8          | 4        | Specifies the index of the virtual processor. |
| `TargetVtl`             | 12         | 1        | Specifies the target VTL.                 |
| Padding (should be zero) | 13         | 1        | Alignment to 2-byte boundary. |
| `Port`                  | 14         | 2        | Specifies the I/O port to check.          |
| `Size`                  | 16         | 1        | Specifies the size of the I/O operation (1, 2, or 4 bytes). |
| `IsWrite`               | 17         | 1        | Specifies whether this is a write operation (TRUE) or read operation (FALSE). |

## Output Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `Intercept`             | 0          | 1        | Returns TRUE if the I/O operation would cause an intercept, FALSE otherwise. |
