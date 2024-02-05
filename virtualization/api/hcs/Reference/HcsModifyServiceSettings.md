---
title: HcsModifyServiceSettings
description: HcsModifyServiceSettings
author: sethmanheim
ms.author: sethm
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- HcsModifyServiceSettings
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# HcsModifyServiceSettings

## Description

This function modifies the settings of the Host Compute System, see [sample code](./ServiceSample.md#ModifyServiceSettings).

## Syntax

```cpp
HRESULT WINAPI
HcsModifyServiceSettings(
    _In_ PCWSTR settings,
    _Outptr_opt_ PWSTR* result
    );
```

## Parameters

`settings`

JSON document of [ModificationRequest](./../SchemaReference.md#ModificationRequest) specifying the settings to modify.

`result`

On failure, it can optionally receive an error JSON document represented by a [ResultError](./../SchemaReference.md#ResultError); it's not guaranteed to be always returned and depends on the property type that is being modified.

## Return Values

The function returns [HRESULT](./HCSHResult.md).

## Remarks

The [ModificationRequest](./../SchemaReference.md#ModificationRequest) JSON document has a property called `"Settings"` of type `Any`. In JSON, `Any` means an arbitrary object with no restrictions. Refer to the following table to know what JSON type HCS expects for each [ModifyPropertyType](./../SchemaReference.md#ModifyPropertyType).

|`ModifyPropertyType`|`"Setting"` JSON Type|
|---|---|
|`"CpuGroup"`|[HostProcessorModificationRequest](./../SchemaReference.md#HostProcessorModificationRequest)|
|`"ContainerCredentialGuard"`|[ContainerCredentialGuardOperationRequest](./../SchemaReference.md#ContainerCredentialGuardOperationRequest)|


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
