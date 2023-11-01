---
title: The ReadGuestRawSavedMemory function
description: Reads raw memory from the saved state file. This function reads raw memory from the saved state file as if it were a flat memory layout, regardless of the guest memory layout.
ms.date: 04/19/2022
author: sethmanheim
ms.author: mabrigg
---

# ReadGuestRawSavedMemory function

Reads raw memory from the saved state file. This function reads raw memory from the saved state file as if it were a flat memory layout, regardless of the guest memory layout. If BytesRead returns something lower than BufferSize, then the end of memory has been reached.

## Syntax

```C
HRESULT
WINAPI
ReadGuestRawSavedMemory(
    _In_        VM_SAVED_STATE_DUMP_HANDLE  VmSavedStateDumpHandle,
    _In_        UINT64                      RawSavedMemoryOffset,
    _Out_writes_bytes_(BufferSize) LPVOID   Buffer,
    _In_        UINT32                      BufferSize,
    _Out_opt_   UINT32*                     BytesRead
    );
```

## Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`RawSavedMemoryOffset`

Byte offset on the raw saved memory from where to start reading.

`Buffer`

Returns the raw memory read on the current raw memory offset.

`BufferSize`

Supplies the requested byte count to read.

`BytesRead`

Optionally returns the bytes actually read.

## Return Value

If the operation completes successfully, the return value is `S_OK`.

## Requirements

|Parameter|Description|
|---|---|---|---|---|---|---|---|
| **Minimum supported client** | Windows 10, version 1607 |
| **Minimum supported server** | Windows Server 2016 |
| **Target Platform** | Windows |
| **Library** | ComputeCore.ext |
| **Dll** | ComputeCore.ext |
|    |    |