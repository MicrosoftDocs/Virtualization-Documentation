---
title: The GetArchitecture function
description: Learn about the GetArchitecture function.
ms.date: 04/18/2022
author: sethmanheim
ms.author: roharwoo
---

# GetArchitecture function

Queries for the current Architecture/ISA the virtual processor was running at the time the saved state file was generated.

## Syntax

```C
HRESULT
WINAPI
GetArchitecture(
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle,
    _In_    UINT32                          VpId,
    _Out_   VIRTUAL_PROCESSOR_ARCH*         Architecture
    );
```
## Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`VpId`

Supplies the VP to query.

`Architecture`

Returns the architecture of the supplied vp.

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
