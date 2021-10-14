---
title: HCN_NOTIFICATION_CALLBACK
description: HCN_NOTIFICATION_CALLBACK
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 10/31/2021
api_name:
- HCN_NOTIFICATION_CALLBACK
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HCN\_NOTIFICATION\_CALLBACK

## Description

Function type for HNS notification callbacks.

## Syntax

```cpp
typedef void (CALLBACK *HCN_NOTIFICATION_CALLBACK)(
    _In_            DWORD  NotificationType,
    _In_opt_        void*  Context,
    _In_            HRESULT NotificationStatus,
    _In_opt_        PCWSTR NotificationData
    );
```

## Parameters

`NotificationType`

The type of notification [`HCN_NOTIFICATIONS`](./HCN_NOTIFICATIONS.md).

`Context`

Handle for context of callback.

`NotificationStatus`

Notification Status.

`NotificationData`

Data associated with the notification.


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeNetwork.h |

