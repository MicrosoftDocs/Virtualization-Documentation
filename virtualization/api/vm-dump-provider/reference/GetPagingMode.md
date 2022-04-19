---
title: The GetPagingMode function
description: Queries for the current Paging Mode in use by the virtual processor at the time the
saved state file was generated.
ms.date: 04/19/2022
---


# GetPagingMode function

Queries for the current Paging Mode in use by the virtual processor at the time the
saved state file was generated.

## Syntax

```C
HRESULT
WINAPI
GetPagingMode(
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle,
    _In_    UINT32                          VpId,
    _Out_   PAGING_MODE*                    PagingMode
    );
```

## Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`VpId`

Supplies the Virtual Processor Id.

`PagingMode`

Returns the paging mode.

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