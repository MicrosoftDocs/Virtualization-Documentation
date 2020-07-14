# Asynchronous Model

## Compute System Notifications
Since the HCS is an asynchronous API, notifications provide context when a function is called. By registering for notifications, a user can see the notification type, context, status, and additional data. Registering for notifications can only occur after the compute system is created. Since notifications provide this additional context about the compute system, it is recommended to register for notifications prior to starting the compute system (guest VM).

The HCS has sticky notification in which the HCS only expects to receive once. If these notifications are received, the HCS will mark any remaining tasks as failed since they system is disconnected or has exited.

<a name = "HcsOperationHandle"></a>
## HCS_OPERATION Handle

If the return value is `S_OK`, it means the operation starts successfully.

<a name = "HcsOperationResult"></a>
## HCS_OPERATION Expected Result