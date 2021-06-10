---
title: HcsRevokeVmAccess
description: HcsRevokeVmAccess
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# HcsRevokeVmGroupAccess

## Description

This function removes a group of entries in the ACL of a file that granted access to the file for the user account used to run the VM.

## Syntax

```Cpp
HRESULT WINAPI
HcsRevokeVmGroupAccess(
    _In_ PCWSTR filePath
    );
```

## Parameters

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