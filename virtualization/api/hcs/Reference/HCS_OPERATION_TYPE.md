---
title: HCS_OPERATION_TYPE
description: HCS_OPERATION_TYPE
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# HCS_OPERATION_TYPE

## Description

Defines the type of an operation, which is used as return value in [HcsGetOperationType](./HcsGetOperationType.md). The operation type is determined by the called HCS API that leverages an hcs operation for asynchronous tracking.

## Syntax

```cpp
typedef enum HCS_OPERATION_TYPE
{
    HcsOperationTypeNone = -1,
    HcsOperationTypeEnumerate = 0,
    HcsOperationTypeCreate = 1,
    HcsOperationTypeStart = 2,
    HcsOperationTypeShutdown = 3,
    HcsOperationTypePause = 4,
    HcsOperationTypeResume = 5,
    HcsOperationTypeSave = 6,
    HcsOperationTypeTerminate = 7,
    HcsOperationTypeModify = 8,
    HcsOperationTypeGetProperties = 9,
    HcsOperationTypeCreateProcess = 10,
    HcsOperationTypeSignalProcess = 11,
    HcsOperationTypeGetProcessInfo = 12,
    HcsOperationTypeGetProcessProperties = 13,
    HcsOperationTypeModifyProcess = 14,
    HcsOperationTypeCrash = 15
} HCS_OPERATION_TYPE;
```

## Constants

|||
|---|---|
|`HcsOperationTypeNone`|Return if the operation has not yet been used to track a function call.|
|`HcsOperationTypeEnumerate`|Return if the operation is tracking function [HcsEnumerateComputeSystems](./HcsEnumerateComputeSystems.md).|
|`HcsOperationTypeCreate`|Return if the operation is tracking function [HcsCreateComputeSystem](./HcsCreateComputeSystem.md).|
|`HcsOperationTypeStart`|Return if the operation is tracking function [HcsStartComputeSystem](./HcsStartComputeSystem.md).|
|`HcsOperationTypeShutdown`|Return if the operation is tracking function [HcsShutDownComputeSystem](./HcsShutDownComputeSystem.md).|
|`HcsOperationTypePause`|Return if the operation is tracking function [HcsPauseComputeSystem](./HcsPauseComputeSystem.md).|
|`HcsOperationTypeResume`|Return if the operation is tracking function [HcsResumeComputeSystem](./HcsResumeComputeSystem.md).|
|`HcsOperationTypeSave`|Return if the operation is tracking function [HcsSaveComputeSystem](./HcsSaveComputeSystem.md).|
|`HcsOperationTypeTerminate`|Return if the operation is tracking function [HcsTerminateComputeSystem](./HcsTerminateComputeSystem.md).|
|`HcsOperationTypeModify`|Return if the operation is tracking function [HcsModifyComputeSystem](./HcsModifyComputeSystem.md).|
|`HcsOperationTypeGetProperties`|Return if the operation is tracking function [HcsGetComputeSystemProperties](./HcsGetComputeSystemProperties.md).|
|`HcsOperationTypeCreateProcess`|Return if the operation is tracking function [HcsCreateProcess](./HcsCreateProcess.md).|
|`HcsOperationTypeSignalProcess`|Return if the operation is tracking function [HcsSignalProcess](./HcsSignalProcess.md).|
|`HcsOperationTypeGetProcessInfo`|Return if the operation is tracking function [HcsGetProcessInfo](./HcsGetProcessInfo.md).|
|`HcsOperationTypeGetProcessProperties`|Return if the operation is tracking function [HcsGetProcessProperties](./HcsGetProcessProperties.md).|
|`HcsOperationTypeModifyProcess`|Return if the operation is tracking function [HcsModifyProcess](./HcsModifyProcess.md).|
|`HcsOperationTypeCrash`|Return if the operation is tracking function [HcsCrashComputeSystem](./HcsCrashComputeSystem.md).|

## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
