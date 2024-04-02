---
title: The GuestVirtualAddressToPhysicalAddress function
description: Translates a virtual address to a physical address using information found in the guest's memory and processor's state.
ms.date: 04/19/2022
author: sethmanheim
ms.author: sethm
---

# GuestVirtualAddressToPhysicalAddress function

Translates a virtual address to a pysical address using information found in the guest's memory and processor's state.

## Syntax

```C
HRESULT
WINAPI
GuestVirtualAddressToPhysicalAddress(
    _In_    VM_SAVED_STATE_DUMP_HANDLE      VmSavedStateDumpHandle,
    _In_    UINT32                          VpId,
    _In_    const GUEST_VIRTUAL_ADDRESS     VirtualAddress,
    _Out_   GUEST_PHYSICAL_ADDRESS*         PhysicalAddress
    );
```

## Parameters

`VmSavedStateDumpHandle`

Supplies a handle to a dump provider instance.

`VpId`

Supplies the VP from where the virtual address is read.

`VirtualAddress`

Supplies the virtual address to translate.

`PhysicalAddress`

Returns the physical address assigned to the supplied virtual address.

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