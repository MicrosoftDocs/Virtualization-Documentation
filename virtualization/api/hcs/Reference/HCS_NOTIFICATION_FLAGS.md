# HCS_NOTIFICATION_FLAGS

## Description

Flags applicable to [HCS_NOTIFICATIONS](./HCS_NOTIFICATIONS.md)

## Syntax

```cpp
typedef enum HCS_NOTIFICATION_FLAGS
{
    HcsNotificationFlagSuccess = 0x00000000,
    HcsNotificationFlagFailure = 0x80000000
} HCS_NOTIFICATION_FLAGS;
```

## Constants

|||
|---|---|
|HcsNotificationFlagSuccess|Notification is successful|
|HcsNotificationFlagFailure|Notification is failure|


## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
