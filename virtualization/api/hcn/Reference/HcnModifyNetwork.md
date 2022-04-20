---
title: HcnModifyNetwork
description: HcnModifyNetwork
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.date: 10/31/2021
api_name:
- HcnModifyNetwork
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnModifyNetwork

## Description

Modifies a network.

## Syntax

```cpp
HRESULT
WINAPI
HcnModifyNetwork(
    _In_ HCN_NETWORK Network,
    _In_ PCWSTR Settings,
    _Outptr_opt_ PWSTR* ErrorRecord
    );
```

## Parameters

`Network`

Network for the new network.

`Id`

The [HCN\_NETWORK](./HCN_NETWORK.md) to modify.

`Settings`

JSON document specifying the settings of the [HostComputeNetwork](./../HNS_Schema.md#HostComputeNetwork).

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






