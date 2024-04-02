---
title: HcnModifyLoadBalancer
description: HcnModifyLoadBalancer
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HcnModifyLoadBalancer
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnModifyLoadBalancer

## Description

Modifies a load balancer.

## Syntax

```cpp
HRESULT
WINAPI
HcnModifyLoadBalancer(
    _In_ HCN_LOADBALANCER LoadBalancer,
    _In_ PCWSTR Settings,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`LoadBalancer`

The [HCN\_LOADBALANCER](./HCN_LOADBALANCER.md) to modify.

`Settings`

JSON document specifying the settings of the [load balancer](./../HNS_Schema.md#HostComputeLoadBalancer).

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






