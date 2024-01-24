---
title: HcnCreateLoadBalancer
description: HcnCreateLoadBalancer
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HcnCreateLoadBalancer
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnCreateLoadBalancer

## Description

Creates a load balancer.

## Syntax

```cpp
HRESULT
WINAPI
HcnCreateLoadBalancer(
    _In_ REFGUID Id,
    _In_ PCWSTR Settings,
    _Out_ PHCN_LOADBALANCER LoadBalancer,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`Id`

Id for the new load balancer.

`Settings`

JSON document specifying the settings of the [load balancer](./../HNS_Schema.md#HostComputeLoadBalancer).

`LoadBalancer`

Receives a handle to the newly created load balancer. It is the responsibility of the caller to release the handle using [HcnCloseLoadBalancer](./HcnCloseLoadBalancer.md) once it is no longer in use.

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

