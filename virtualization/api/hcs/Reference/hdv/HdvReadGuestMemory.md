---
title: HdvReadGuestMemory
description: HdvReadGuestMemory
author: faymeng
ms.author: mabriggs
ms.topic: reference
ms.prod: virtualization
ms.date: 06/09/2021
api_name:
- HdvReadGuestMemory
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HdvReadGuestMemory

## Description

Reads guest primary memory (RAM) contents into the supplied buffer.

## Syntax

```C++
HRESULT WINAPI
HdvReadGuestMemory(
    _In_                    HDV_DEVICE Requestor,
    _In_                    UINT64     GuestPhysicalAddress,
    _In_                    UINT32     ByteCount,
    _Out_writes_(ByteCount) BYTE*      Buffer
    );
```

## Parameters

|Parameter|Description|
|---|---|---|---|---|---|---|---|
|`Requestor` |Handle to the device requesting memory access.|
|`GuestPhysicalAddress`|Guest physical address at which the read operation starts.|
|`ByteCount`|Number of bytes to read.|
|`Buffer`|Target buffer for the read operation. |
|    |    |

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
