# Asynchronous Model


## Compute System Notifications
Since the HCS is an asynchronous API, notifications provide context when a function is called. By registering for notifications, a user can see the notification type, context, status, and additional data. Registering for notifications can only occur after the compute system is created. Since notifications provide this additional context about the compute system, it is recommended to register for notifications prior to starting the compute system (guest VM).

The enum for HCS notifications is as follows: 

```C
public enum HCS_NOTIFICATIONS : uint
    {
        HcsNotificationInvalid = 0x00000000,

        /// Notifications for HCS_SYSTEM handles
        HcsNotificationSystemExited = 0x00000001,
        HcsNotificationSystemCreateCompleted = 0x00000002,
        HcsNotificationSystemStartCompleted = 0x00000003,
        HcsNotificationSystemPauseCompleted = 0x00000004,
        HcsNotificationSystemResumeCompleted = 0x00000005,
        HcsNotificationSystemCrashReport = 0x00000006,

        /// Notifications for HCS_PROCESS handles
        HcsNotificationProcessExited = 0x00010000,

        /// Common notifications
        HcsNotificationServiceDisconnect = 0x01000000,

        /// The upper 4 bits are reserved for flags. See HCS_NOTIFICATION_FLAGS
        HcsNotificationFlagsReserved = 0xF0000000
```
The HCS has sticky notification in which the HCS only expects to receive once. These notifications include `HcsNotificationSystemExited` and `HcsNotificationServiceDisconnect`. If these notifications are received, the HCS will mark any remaining tasks as failed since they system is disconnected or has exited.