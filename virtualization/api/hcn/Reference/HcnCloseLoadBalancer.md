---
title: HcnCloseLoadBalancer
description: HcnCloseLoadBalancer
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HcnCloseLoadBalancer
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnCloseLoadBalancer

## Description

Close a handle to a load balancer.

## Syntax

```cpp
HRESULT
WINAPI
HcnCloseLoadBalancer(
    _In_ HCN_LOADBALANCER LoadBalancer
    );```

## Parameters

`LoadBalancer`

Handle to a LoadBalancer [`HCN_LOADBALANCER`](./HCN_LOADBALANCER.md)

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


