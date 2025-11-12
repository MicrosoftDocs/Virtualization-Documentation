---
title: HV_SYNIC_SINT_INDEX
description: HV_SYNIC_SINT_INDEX data type for synthetic interrupt index
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference

---

# HV_SYNIC_SINT_INDEX

The HV_SYNIC_SINT_INDEX type represents an index into the synthetic interrupt (SINT) table for the synthetic interrupt controller (SynIC).

## Syntax

```c
typedef UINT32 HV_SYNIC_SINT_INDEX;
```

The HV_SYNIC_SINT_INDEX is a 32-bit unsigned integer that identifies a specific synthetic interrupt source. Valid SINT indices range from 0 to 15, allowing for up to 16 different synthetic interrupt sources per virtual processor.

## See also


[HvCallPostMessageDirect](../hypercalls/HvCallPostMessageDirect.md)
