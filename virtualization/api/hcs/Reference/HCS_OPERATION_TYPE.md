# HCS_OPERATION_TYPE

## Description

Defines the type of an operation, which is used as return value in [HcsGetOperationType](./HcsGetOperationType.md).

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
|HcsOperationTypeNone|Return if the operation has not yet been used in a function call|
|HcsOperationTypeEnumerate|Return if the operation is [HcsEnumerateComputeSystems](./HcsEnumerateComputeSystems.md)|
|HcsOperationTypeCreate|Return if the operation is [HcsCreateComputeSystem](./HcsCreateComputeSystem.md)|
|HcsOperationTypeStart|Return if the operation is [HcsStartComputeSystem](./HcsStartComputeSystem.md)|
|HcsOperationTypeShutdown|Return if the operation is [HcsShutDownComputeSystem](./HcsShutDownComputeSystem.md)|
|HcsOperationTypePause|Return if the operation is [HcsPauseComputeSystem](./HcsPauseComputeSystem.md)|
|HcsOperationTypeResume|Return if the operation is [HcsResumeComputeSystem](./HcsResumeComputeSystem.md)|
|HcsOperationTypeSave|Return if the operation is [HcsSaveComputeSystem](./HcsSaveComputeSystem.md)|
|HcsOperationTypeTerminate|Return if the operation is [HcsTerminateComputeSystem](./HcsTerminateComputeSystem.md)|
|HcsOperationTypeModify|Return if the operation is [HcsModifyComputeSystem](./HcsModifyComputeSystem.md)|
|HcsOperationTypeGetProperties|Return if the operation is [HcsGetComputeSystemProperties](./HcsGetComputeSystemProperties.md)|
|HcsOperationTypeCreateProcess|Return if the operation is [HcsCreateProcess](./HcsCreateProcess.md)|
|HcsOperationTypeSignalProcess|Return if the operation is [HcsSignalProcess](./HcsSignalProcess.md)|
|HcsOperationTypeGetProcessInfo|Return if the operation is [HcsGetProcessInfo](./HcsGetProcessInfo.md)|
|HcsOperationTypeGetProcessProperties|Return if the operation is [HcsGetProcessProperties](./HcsGetProcessProperties.md)|
|HcsOperationTypeModifyProcess|Return if the operation is [HcsModifyProcess](./HcsModifyProcess.md)|
|HcsOperationTypeCrash|Return if the operation is [HcsCrashComputeSystem](./HcsCrashComputeSystem.md)|

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
