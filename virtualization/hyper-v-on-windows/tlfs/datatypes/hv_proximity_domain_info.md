---
title: HV_PROXIMITY_DOMAIN_INFO
description: HV_PROXIMITY_DOMAIN_INFO data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference

---

# HV_PROXIMITY_DOMAIN_INFO

HV_PROXIMITY_DOMAIN_INFO specifies NUMA (Non-Uniform Memory Access) proximity domain information for memory allocation preferences.

## Syntax

```c
typedef struct
{
    UINT32 ProximityPreferred:1;
    UINT32 Reserved:30;
    UINT32 ProximityInfoValid:1;
} HV_PROXIMITY_DOMAIN_FLAGS;

typedef struct
{
    HV_PROXIMITY_DOMAIN_ID Id;
    HV_PROXIMITY_DOMAIN_FLAGS Flags;

} HV_PROXIMITY_DOMAIN_INFO;
```

This structure allows specification of NUMA topology preferences for resource allocation.

**Fields**
* **Id** – Proximity domain identifier (`HV_PROXIMITY_DOMAIN_ID`).
* **Flags** – Bitfield controlling how the `Id` is applied. See table below.

### Flag Bit Definitions (HV_PROXIMITY_DOMAIN_FLAGS)
| Bit | Name | Meaning |
|-----|------|---------|
| 0 | ProximityPreferred | If 1, allocate from this domain preferentially; fall back permitted if insufficient local memory. If 0, allocation is restricted to this single domain only. |
| 30:1 | Reserved | Reserved; must be zero on write; ignored on read. | 
| 31 | ProximityInfoValid | If 1, `Id` is valid and enforced per above flags. If 0, allocator may choose any domain. |

## See also
* [HV_PROXIMITY_DOMAIN_ID](hv_proximity_domain_id.md)
* [HvCallCreatePort](../hypercalls/HvCallCreatePort.md)