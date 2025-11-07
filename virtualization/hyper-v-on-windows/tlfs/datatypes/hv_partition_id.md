---
title: HV_PARTITION_ID
description: HV_PARTITION_ID
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/07/2025
ms.topic: reference
---

# HV_PARTITION_ID

The HV_PARTITION_ID data type represents a unique identifier for a partition within the hypervisor. Each partition is assigned a unique partition ID when it is created, which is used to reference the partition in subsequent hypercalls.

## Syntax

```c
typedef UINT64 HV_PARTITION_ID;
```

The HV_PARTITION_ID is a 64-bit unsigned integer that uniquely identifies a partition. The hypervisor assigns partition IDs sequentially, starting from 1.

## Constants

| Name | Value | Description |
|------|-------|-------------|
| HV_PARTITION_ID_INVALID | 0x0000000000000000 | Sentinel that never refers to a real partition |
| HV_PARTITION_ID_SELF | 0xFFFFFFFFFFFFFFFF | Pseudo-identifier that refers to the caller's own partition. |

## See also

* [HvCallCreatePartition](../hypercalls/HvCallCreatePartition.md)
* [HvCallDeletePartition](../hypercalls/HvCallDeletePartition.md)
