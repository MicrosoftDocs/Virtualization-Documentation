---
title: HcsRevokeVmAccess
description: HcsRevokeVmAccess
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name: HcsRevokeVmAccess
api_location: computecore.dll
api_type: DllExport
topic_type: apiref
---
# HcsRevokeVmAccess

## Description

This function removes the entry in the ACL of a file that granted access to the file for the user account used to run the VM.

## Syntax

```Cpp
HRESULT WINAPI
HcsRevokeVmAccess(
    _In_ PCWSTR vmId,
    _In_ PCWSTR filePath
    );
```

## Parameters

`vmId`

Unique Id of the VM's compute system.

`filePath`

Path to teh file for which to update the ACL.

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