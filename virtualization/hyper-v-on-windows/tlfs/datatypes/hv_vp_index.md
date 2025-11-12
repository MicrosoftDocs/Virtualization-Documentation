---
title: HV_VP_INDEX
description: HV_VP_INDEX data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference

---

# HV_VP_INDEX

HV_VP_INDEX represents the index of a virtual processor within a partition.

## Syntax

```c
typedef UINT32 HV_VP_INDEX;
```

The virtual processor index is a 32-bit unsigned integer that uniquely identifies a virtual processor within a partition.

**Special Values:**
- **HV_VP_INDEX_SELF (0xFFFFFFFE)**: Refers to the current virtual processor making the hypercall
- **HV_ANY_VP (0xFFFFFFFF)**: Refers to any virtual processor (used in some contexts where the specific VP doesn't matter)

**Usage Notes:**
- VP indices must be unique within a partition
- VP indices are assigned when virtual processors are created
- Not all indices in the valid range need to be used (sparse allocation is allowed)
- The VP index remains constant for the lifetime of the virtual processor
