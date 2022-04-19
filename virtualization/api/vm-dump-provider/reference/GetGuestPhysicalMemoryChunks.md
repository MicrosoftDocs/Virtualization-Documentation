---
title: The GetGuestPhysicalMemoryChunks function
description: Returns the layout of the physical memory of the guest. This information contains the chunks of memory with consecutive pages and from where each one starts. If the supplied count is less than the amount of chunks for this guest, then this function returns the expected chunk count.
ms.date: 04/18/2022
author: mattbriggs
ms.author: mabrigg
---
# GetGuestPhysicalMemoryChunks function

Returns the layout of the physical memory of the guest. This information contains the chunks of memory with consecutive pages and from where each one starts. If the supplied count is less than the amount of chunks for this guest, then this function returns the expected chunk count.

## Syntax

```C
HRESULT
WINAPI
GetGuestPhysicalMemoryChunks(
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle,
    _Out_   UINT64*                         MemoryChunkPageSize,
    _Out_   GPA_MEMORY_CHUNK*               MemoryChunks,
    _Inout_ UINT64*                         MemoryChunkCount
    );
```

## Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`MemoryChunkPageSize`

Returns the size of a page in the memory chunk layout.

`MemoryChunks`

Supplies a buffer of memory chunk structures that are filled up with the requested information if the buffer size is the same or bigger than the memory chunks count for this guest.

`MemoryChunkCount`

Supplies the size of the MemoryChunks buffer. If this count is lower than what the guest really has, then it returns the expected count. If it was higher than what the guest has, then it returns the exact count.

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