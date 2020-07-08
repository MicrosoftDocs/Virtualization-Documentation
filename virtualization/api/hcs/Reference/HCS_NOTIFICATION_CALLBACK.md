# HCS_NOTIFICATION_CALLBACK

## Description

Function type for compute system notification callbacks

## Syntax

```cpp
typedef void (CALLBACK *HCS_NOTIFICATION_CALLBACK)(
    _In_ DWORD notificationType,
    _In_opt_ void*  context,
    _In_ HRESULT notificationStatus,
    _In_opt_ PCWSTR notificationData
    );
```

## Parameters

`notificationType`

`context`

Handle for context of callback

`notificationStatus`

`notificationData`

## Requirements

|Parameter     |Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeDefs.h |
