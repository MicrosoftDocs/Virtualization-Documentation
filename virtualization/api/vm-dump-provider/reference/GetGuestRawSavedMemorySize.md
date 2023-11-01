---
title: The GetGuestRawSavedMemorySize function
description: Returns the size in bytes of the saved memory for a given VM saved state file.
ms.date: 04/18/2022
author: sethmanheim
ms.author: mabrigg
---
# GetGuestRawSavedMemorySize function

Returns the size in bytes of the saved memory for a given VM saved state file.


## Syntax

```C
HRESULT
WINAPI
GetGuestRawSavedMemorySize(
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle,
    _Out_   UINT64*                         GuestRawSavedMemorySize
    );
```

## Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`GuestRawSavedMemorySize`

Returns the size of the saved memory of a given guest in bytes.

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
