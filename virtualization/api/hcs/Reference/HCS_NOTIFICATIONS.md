# HCS_NOTIFICATIONS

## Description

Notifications indicated to callbacks registered by [HcsSetComputeSystemCallback](./HcsSetComputeSystemCallback.md) or [HcsSetProcessCallback](./HcsSetProcessCallback.md)

## Syntax

```cpp
typedef enum HCS_NOTIFICATIONS
{
    HcsNotificationInvalid = 0x00000000,
    HcsNotificationSystemExited = 0x00000001,
    HcsNotificationSystemCreateCompleted = 0x00000002,
    HcsNotificationSystemStartCompleted = 0x00000003,
    HcsNotificationSystemPauseCompleted = 0x00000004,
    HcsNotificationSystemResumeCompleted = 0x00000005,
    HcsNotificationSystemCrashReport = 0x00000006,
    HcsNotificationSystemSiloJobCreated = 0x00000007,
    HcsNotificationSystemSaveCompleted = 0x00000008,
    HcsNotificationSystemRdpEnhancedModeStateChanged = 0x00000009,
    HcsNotificationSystemShutdownFailed = 0x0000000A,
    HcsNotificationSystemShutdownCompleted = 0x0000000A,
    HcsNotificationSystemGetPropertiesCompleted = 0x0000000B,
    HcsNotificationSystemModifyCompleted = 0x0000000C,
    HcsNotificationSystemCrashInitiated =  0x0000000D,
    HcsNotificationSystemGuestConnectionClosed = 0x0000000E,
    HcsNotificationProcessExited = 0x00010000,
    HcsNotificationServiceDisconnect = 0x01000000,
    HcsNotificationFlagsReserved = 0xF0000000
} HCS_NOTIFICATIONS;
```

## Constants

|||
|---|---|
|HcsNotificationInvalid|Nofitication is invalid|
|HcsNotificationSystemExited|The notification of HCS_SYSTEM handle for system exited|
|HcsNotificationSystemCreateCompleted|The notification of HCS_SYSTEM handle for system create completed|
|HcsNotificationSystemStartCompleted|The notification of HCS_SYSTEM handle for system start completed|
|HcsNotificationSystemPauseCompleted|The notification of HCS_SYSTEM handle for system pause completed|
|HcsNotificationSystemResumeCompleted|The notification of HCS_SYSTEM handle for system resume completed|
|HcsNotificationSystemCrashReport|The notification of HCS_SYSTEM handle for system crash report|
|HcsNotificationSystemSiloJobCreated|The notification of HCS_SYSTEM handle for Silo container job created|
|HcsNotificationSystemSaveCompleted|The notification of HCS_SYSTEM handle for system save completed|
|HcsNotificationSystemRdpEnhancedModeStateChanged|The notification of HCS_SYSTEM handle for Rdp enhanced mode state changed|
|HcsNotificationSystemShutdownFailed|The notification of HCS_SYSTEM handle for system shut down failed|
|HcsNotificationSystemShutdownCompleted|The notification of HCS_SYSTEM handle for system shut down completed|
|HcsNotificationSystemGetPropertiesCompleted|The notification of HCS_SYSTEM handle for GetProperties completed|
|HcsNotificationSystemModifyCompleted|The notification of HCS_SYSTEM handle for modify completed|
|HcsNotificationSystemCrashInitiated|The notification of HCS_SYSTEM handle for system crash initiated|
|HcsNotificationSystemGuestConnectionClosed|The notification of HCS_SYSTEM handle for guest connection closed|
|HcsNotificationProcessExited|The notification of HCS_PROCESS handle for process exited|
|HcsNotificationServiceDisconnect|The notification of service disconnect|


## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
