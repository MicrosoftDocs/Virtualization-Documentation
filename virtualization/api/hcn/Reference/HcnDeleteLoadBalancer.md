---
title: HcnDeleteLoadBalancer
description: HcnDeleteLoadBalancer
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HcnDeleteLoadBalancer
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnDeleteLoadBalancer

## Description

Deletes a load balancer.

## Syntax

```cpp
HRESULT
WINAPI
HcnDeleteLoadBalancer(
    _In_ REFGUID Id,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`Id`

Id of the load balancer to delete.

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



