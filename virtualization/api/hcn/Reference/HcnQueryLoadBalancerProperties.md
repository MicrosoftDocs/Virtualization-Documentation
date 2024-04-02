---
title: HcnQueryLoadBalancerProperties
description: HcnQueryLoadBalancerProperties
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HcnQueryLoadBalancerProperties
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnQueryLoadBalancerProperties

## Description

Queries the properties of a load balancer.

## Syntax

```cpp
HRESULT
WINAPI
HcnQueryLoadBalancerProperties(
    _In_ HCN_LOADBALANCER LoadBalancer,
    _In_ PCWSTR Query,
    _Outptr_ PWSTR* Properties,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`LoadBalancer`

Handle to an load balancer [`HCN_LOADBALANCER`](./HCN_LOADBALANCER.md)

`Query`

Optional JSON document of [HostComputeQuery](./../HNS_Schema.md#HostComputeLoadBalancer).

`Properties`

The properties in the form of a JSON document of [HostComputeLoadBalancer](./../HNS_Schema.md#HostComputeLoadBalancer).

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



