---
title: HCN_NOTIFICATIONS
description: HCN_NOTIFICATIONS
author: Keith-Mange
ms.author: kemange
ms.topic: reference
ms.service: virtualization
ms.date: 10/31/2021
api_name:
- HCN_NOTIFICATIONS
api_location:
- computenetwork.dll
api_type:
- DllExport
topic_type:
- apiref
---
# HCN\_NOTIFICATIONS

## Description

Function type for compute system event callbacks.

## Syntax

```cpp
typedef enum HCN_NOTIFICATIONS
{
       HcnNotificationInvalid                                  = 0x00000000,

       /// Notifications for HCN_SERVICE handles
       HcnNotificationNetworkPreCreate                         = 0x00000001,
       HcnNotificationNetworkCreate                            = 0x00000002,
       HcnNotificationNetworkPreDelete                         = 0x00000003,
       HcnNotificationNetworkDelete                            = 0x00000004,

       /// Namespace Notifications
       HcnNotificationNamespaceCreate                          = 0x00000005,
       HcnNotificationNamespaceDelete                          = 0x00000006,

       /// Notifications for HCN_SERVICE handles
       HcnNotificationGuestNetworkServiceCreate                = 0x00000007,
       HcnNotificationGuestNetworkServiceDelete                = 0x00000008,

       /// Notifications for HCN_NETWORK handles
       HcnNotificationNetworkEndpointAttached                  = 0x00000009,
       HcnNotificationNetworkEndpointDetached                  = 0x00000010,

       /// Notifications for HCN_GUESTNETWORKSERVICE handles
       HcnNotificationGuestNetworkServiceStateChanged          = 0x00000011,
       HcnNotificationGuestNetworkServiceInterfaceStateChanged = 0x00000012,

       /// Common notifications
       HcnNotificationServiceDisconnect                        = 0x01000000,

       /// The upper 4 bits are reserved for flags
       HcnNotificationFlagsReserved                            = 0xF0000000
} HCN_NOTIFICATIONS;
```


## Requirements

|Parameter|Description|
|---|---|
| **Minimum supported client** | Windows 10, version 1809 |
| **Minimum supported server** | Windows Server 2019 |
| **Target Platform** | Windows |
| **Header** | ComputeNetwork.h |

