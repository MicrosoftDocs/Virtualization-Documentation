---
title: HcsGrantVmAccess
description: HcsGrantVmAccess
author: sethmanheim
ms.author: sethm
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsGrantVmAccess
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsGrantVmAccess

## Description

This function adds an entry to a files ACL that grants access to the user account used to run the VM. The user account is based on an internal GUID that is derived from the compute system ID of the VM's HCS compute system object. See [sample code](./UtilityFunctionSample.md#CreateFilesGrantAccess).

## Syntax

```cpp
HRESULT WINAPI
HcsGrantVmAccess(
    _In_ PCWSTR vmId,
    _In_ PCWSTR filePath
    );
```

## Parameters

`vmId`

Unique Id of the VM's compute system.

`filePath`

Path to the file for which to update the ACL.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |