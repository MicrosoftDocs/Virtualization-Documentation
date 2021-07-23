---
title: HcsGrantVmGroupAccess
description: HcsGrantVmGroupAccess
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name: HcsGrantVmGroupAccess
api_location: computecore.dll
api_type: DllExport
topic_type: apiref
---
# HcsGrantVmGroupAccess

## Description

This function adds a group of entries to a files ACL that grants access to the user account used to run the VM.

## Syntax

```cpp
HRESULT WINAPI
HcsGrantVmGroupAccess(
    _In_ PCWSTR filePath
    );
```

## Parameters

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