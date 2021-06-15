---
title: HcsCloseComputeSystem
description: HcsCloseComputeSystem
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# HcsCloseComputeSystem

## Description

Closes a handle to a compute system, see [sample code](./ComputeSystemSample.md#SaveCloseCS).

## Syntax

```cpp
void WINAPI
HcsCloseComputeSystem(
    _In_ HCS_SYSTEM computeSystem
    );
```

## Parameters

`computeSystem`
The handle to the compute system.

## Return Values

None.

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeCore.h |
| **Library** | ComputeCore.lib |
| **Dll** | ComputeCore.dll |
