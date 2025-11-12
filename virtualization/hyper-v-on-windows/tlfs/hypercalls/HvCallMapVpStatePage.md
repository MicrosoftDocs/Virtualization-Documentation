---
title: HvCallMapVpStatePage
description: HvCallMapVpStatePage hypercall
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/31/2025
ms.topic: reference

---

# HvCallMapVpStatePage

The HvCallMapVpStatePage hypercall maps a virtual processor state page into the guest physical address space of a partition. It allows access to virtual processor state information such as registers and other VP-specific data.

## Interface

 ```c
HV_STATUS
HvCallMapVpStatePage(
    _In_ HV_PARTITION_ID PartitionId,
    _In_ HV_VP_INDEX VpIndex,
    _In_ UINT16 Type,
    _In_ HV_INPUT_VTL InputVtl,
    _In_ UINT8 Flags,
    _In_ HV_GPA_PAGE_NUMBER RequestedMapLocation,
    _Out_ HV_GPA_PAGE_NUMBER* MapLocation
);
 ```

## Call Code

`0x00E1` (Simple)

## Input Parameters

| Name                | Offset | Size | Information Provided |
|---------------------|--------|------|----------------------|
| PartitionId         | 0      | 8    | Target partition |
| VpIndex             | 8      | 4    | Virtual processor index |
| Type                | 12     | 2    | State page type ([HV_VP_STATE_PAGE_TYPE](../datatypes/hv_vp_state_page_type.md)) |
| InputVtl            | 14     | 1    | VTL context |
| Flags               | 15     | 1    | Control flags. |
| RequestedMapLocation| 16     | 8    | Desired GPA page |

## Control Flags

| Name | Value | Notes |
|------|-------|-------|
| MapLocationProvided | 1 | RequestedMapLocation is valid.

## Remarks

- Layered Virtualization Hosts must specify the `MapLocationProvided` flag and set the `RequestedMapLocation` value.

## Output Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| MapLocation             | 0          | 8        | GPA page number where state page is mapped|

## See also

[HV_PARTITION_ID](../datatypes/hv_partition_id.md)
[HV_VP_INDEX](../datatypes/hv_vp_index.md)
[HV_INPUT_VTL](../datatypes/hv_input_vtl.md)
[HV_VP_STATE_PAGE_TYPE](../datatypes/hv_vp_state_page_type.md)
[HV_GPA_PAGE_NUMBER](../datatypes/hv_gpa_page_number.md)
[HvCallUnmapVpStatePage](HvCallUnmapVpStatePage.md)
