---
title: HdvCreateSectionBackedMmioRange
description: HdvCreateSectionBackedMmioRange
author: sethmanheim
ms.author: roharwoo
ms.topic: reference
ms.date: 02/05/2024
api_name:
- HdvCreateSectionBackedMmioRange
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HdvCreateSectionBackedMmioRange

## Description

Maps a section into device MMIO space, so that accesses to those addresses are backed by the section. The caller is responsible for pausing and unpausing the guest around this call if an atomic update of device space is required.

## Syntax

```C++
HRESULT WINAPI
HdvCreateSectionBackedMmioRange(
    _In_     HDV_DEVICE             Requestor,
    _In_     HDV_PCI_BAR_SELECTOR   BarIndex,
    _In_     UINT64                 OffsetInPages,
    _In_     UINT64                 LengthInPages,
    _In_     HDV_MMIO_MAPPING_FLAGS MappingFlags,
    _In_     HANDLE                 SectionHandle,
    _In_     UINT64                 SectionOffsetInPages
    );
```

## Parameters

|Parameter|Description|
|---|---|---|---|---|---|---|---|
|`Requestor` | Handle to the device requesting the MMIO section mapping.|
|`BarIndex`  | The index of the BAR containing MMIO space.|
|`OffsetInPages` | The offset within the BAR to the first page to be mapped.|
|`LengthInPages` | The number of pages from the section mapped into MMIO space.|
|`MappingFlags`  | Flags for the request.|
|`SectionHandle` | The handle to the section object.|
|`SectionOffsetInPages` | The offset within the section to the first page to map.|
|     |     |

## Return Values

|Return Value     |Description|
|---|---|
|`S_OK` | Returned if function succeeds.|
|`HRESULT` | An error code is returned if the function fails.
|     |     |

## Requirements

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
|    |    |
