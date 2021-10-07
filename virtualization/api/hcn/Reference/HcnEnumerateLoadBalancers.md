---
title: HcnEnumerateLoadBalancers
description: HcnEnumerateLoadBalancers
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HcnEnumerateLoadBalancers
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnEnumerateLoadBalancers

## Description

Enumerates the load balancers.

## Syntax

```cpp
HRESULT
WINAPI
HcnEnumerateLoadBalancers(
    _In_ PCWSTR Query,
    _Outptr_ PWSTR* LoadBalancer,
    _Outptr_opt_ PWSTR* ErrorRecord
    );```

## Parameters

`Query`

Optional JSON document of [HostComputeQuery](./../HNS_Schema.md#HostComputeQuery).

`LoadBalancer`

A list of IDs for each Load Bbalancer.

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

