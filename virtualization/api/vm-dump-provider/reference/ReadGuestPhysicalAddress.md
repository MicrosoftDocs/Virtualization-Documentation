---
title: The ReadGuestPhysicalAddress function
description: Reads from the saved state file the given guest physical address range and then it is written into the supplied buffer.
ms.date: 04/19/2022
---

# ReadGuestPhysicalAddress function

Reads from the saved state file the given guest physical address range and then it is written into the supplied buffer. If BytesRead returns something lower than BufferSize, then the end of memory has been reached.

## Syntax

```C
HRESULT
WINAPI
ReadGuestPhysicalAddress(
    _In_        VM_SAVED_STATE_DUMP_HANDLE  VmSavedStateDumpHandle,
    _In_        GUEST_PHYSICAL_ADDRESS      PhysicalAddress,
    _Out_writes_bytes_(BufferSize) LPVOID   Buffer,
    _In_        UINT32                      BufferSize,
    _Out_opt_   UINT32*                     BytesRead
    );
```

## Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`PhysicalAddress`

Supplies the physical address to read.

`Buffer`

Returns the read memory range on the given address.

`BufferSize`

Supplies the requested byte count to read.

`BytesRead`

Optionally returns the bytes actually read

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