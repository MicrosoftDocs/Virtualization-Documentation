---
title: HvExtCallGetBootZeroedMemory
description: HvExtCallGetBootZeroedMemory hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 11/16/2022
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvExtCallGetBootZeroedMemory

The hypercall returns ranges that are known to be zeroed at the time the hypercall is made. Cacheable reads from reported ranges must return all zeroes.

Querying zeroed ranges may allow the virtual machine to avoid zeroing memory that was already zeroed by the hypervisor.

Ranges can include memory that don’t exist and can overlap. The hypervisor should attempt to report "best" / biggest zeroed ranges earlier in the list for optimal performance.

## Interface

 ```c
HV_STATUS
HvExtCallGetBootZeroedMemory(
    _Out_ UINT64* RangeCount,
    _Out_ HV_EXT_OUTPUT_BOOT_ZEROED_MEMORY_RANGE Ranges[]
    );
 ```

## Call Code

`0x8002` (Simple)

## Output Parameters

The hypercall output size is 0xFF8 bytes.

The first 8 bytes in the output indicates the number of zeroed ranges in the rest of the output. At most 255 ranges can be returned.

Each subsequent 16 bytes indicates a zeroed range. The first 8 bytes indicates the start guest physical page number of the range, the next 8 bytes indicates the total number of pages in the range.

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `RangeCount`            | 0          | 8        | Number of returned ranges                 |
| `Range 0 StartGpa`      | 8          | 8        | Start GPA page number of the first range  |
| `Range 0 PageCount`     | 16         | 8        | Page count of the first range             |
| `...`                   |            |          |                                           |
| `Range 254 StartGpa`    | 4072       | 8        | Start GPA page number of the last range   |
| `Range 254 PageCount`   | 4080       | 8        | Page count of the last range              |
