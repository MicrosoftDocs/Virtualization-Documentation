---
title: HV_PROXIMITY_DOMAIN_ID
description: Numeric identifier for a NUMA proximity (memory / processor locality) domain exposed to guests.
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 09/01/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_PROXIMITY_DOMAIN_ID

`HV_PROXIMITY_DOMAIN_ID` is a 32-bit value identifying a guest-visible NUMA (Non-Uniform Memory Access) proximity domain. It is used in placement-sensitive hypervisor interfaces to express locality preferences or constraints for processor and memory resources.

## Syntax
```c
typedef UINT32 HV_PROXIMITY_DOMAIN_ID;
```

## Overview
Proximity domains group virtual processors and memory with relatively lower access latency. Guests supply a `HV_PROXIMITY_DOMAIN_ID` in structures such as [`HV_PROXIMITY_DOMAIN_INFO`](hv_proximity_domain_info.md) to bias or constrain allocation and scheduling decisions.

## Value Range
* Valid domain identifiers: 0–63

## See Also
* [HV_PROXIMITY_DOMAIN_INFO](hv_proximity_domain_info.md)
