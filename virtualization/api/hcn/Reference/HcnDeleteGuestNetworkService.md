---
title: HcnDeleteGuestNetworkService
description: HcnDeleteGuestNetworkService
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HcnDeleteGuestNetworkService
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnDeleteGuestNetworkService

## Description

Deletes a guest network service.

## Syntax

```cpp
HRESULT
WINAPI
HcnDeleteGuestNetworkService(
    _In_ REFGUID Id,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`Id`

Id of the guest network service to delete.

`ErrorRecord`

Receives a JSON document with extended errorCode information. The caller must release the buffer using CoTaskMemFree.

## Return Values

The function returns [HRESULT](./HCNHResult.md).

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeNetwork.h |
| **Library** | ComputeNetwork.lib |
| **Dll** | ComputeNetwork.dll |



