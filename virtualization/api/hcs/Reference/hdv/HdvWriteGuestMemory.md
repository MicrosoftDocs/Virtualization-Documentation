---
title: HdvWriteGuestMemory
description: HdvWriteGuestMemory
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- HdvWriteGuestMemory
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HdvWriteGuestMemory

## Description

Writes the contents of the supplied buffer to guest primary memory (RAM).

## Syntax

```C++
HRESULT WINAPI
HdvWriteGuestMemory(
    _In_                        HDV_DEVICE Requestor,
    _In_                        UINT64     GuestPhysicalAddress,
    _In_                        UINT32     ByteCount,
    _In_reads_(ByteCount) const BYTE*      Buffer
    );
```

## Parameters

|Parameter|Description|
|---|---|---|---|---|---|---|---|
|`Requestor` |Handle to the device requesting memory access.|
|`GuestPhysicalAddress` |Guest physical address at which the write operation starts.|
|`ByteCount` |Number of bytes to write.|
|`Buffer` |Source buffer for the write operation.|

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
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    |
