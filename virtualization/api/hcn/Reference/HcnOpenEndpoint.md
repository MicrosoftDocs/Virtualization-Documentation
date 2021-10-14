---
title: HcnOpenEndpoint
description: HcnOpenEndpoint
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HcnOpenEndpoint
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HcnOpenEndpoint

## Description

Opens an endpoint.

## Syntax

```cpp
HRESULT
WINAPI
HcnOpenEndpoint(
    _In_ REFGUID Id,
    _Out_ PHCN_ENDPOINT Endpoint,
    _Outptr_opt_ PWSTR* ErrorRecord
    );```

## Parameters

`Id`

Id of the endpoint.

`Endpoint`

Receives a handle to the endpoint. It is the responsibility of the caller to release the handle using [HcnCloseEndpoint](./HcnCloseEndpoint.md) once it is no longer in use.

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





