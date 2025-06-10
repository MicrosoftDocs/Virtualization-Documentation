---
title: The GetRegisterValue function
description: Queries for a specific register value for a given VP in a VmSavedStateDump.
ms.date: 04/19/2022
author: sethmanheim
ms.author: roharwoo
---

# GetRegisterValue function

Queries for a specific register value for a given VP in a VmSavedStateDump. Callers must specify architecture and register ID in paremeter Register, and this function returns the regsiter value through it.

## Syntax

```C
HRESULT
WINAPI
GetRegisterValue(
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle,
    _In_    UINT32                          VpId,
    _Inout_ VIRTUAL_PROCESSOR_REGISTER*     Register
    );
```

## Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`VpId`

Supplies the Virtual Processor Id.

`Register`

Supplies an enumeration value with the register being queried. Returns the queried register value.

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
