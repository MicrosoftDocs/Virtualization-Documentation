---
title: HvCallSignalEvent
description: HvCallSignalEvent hypercall
keywords: hyper-v
author: alexgrest
ms.author: alegre
ms.date: 10/15/2020
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HvCallSignalEvent

The HvCallSignalEvent hypercall signals an event in a partition that owns the port associated with the specified connection.

The event is signaled by setting a bit within the SIEF page of one of the receive partition’s virtual processors. The caller specifies a relative flag number. The actual SIEF bit number is calculated by the hypervisor by adding the specified flag number to the base flag number associated with the port.

## Interface

 ```c
HV_STATUS
HvCallSignalEvent(
    _In_ HV_CONNECTION_ID ConnectionId,
    _In_ UINT16 FlagNumber
    );
 ```

## Call Code

`0x005D` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `ConnectionId`          | 0          | 4        | Specifies the ID of the connection.       |
| `FlagNumber`            | 4          | 2        | Specifies the relative index of the event flag that the caller wants to set within the target SIEF area. This number is relative to the base flag number associated with the port. |
| RsvdZ                   | 6          | 2        |                                           |

## Return Values

| Status code                         | Error Condition                                       |
|-------------------------------------|-------------------------------------------------------|
| `HV_STATUS_ACCESS_DENIED`           | The caller’s partition does not possess the SignalEvents privilege. |
| `HV_STATUS_INVALID_CONNECTION_ID`   | The specified connection ID is invalid.               |
| `HV_STATUS_INVALID_PORT_ID`         | The port associated with the specified connection has been deleted. |
|                                     | The port associated with the specified connection belongs to a partition that is not in the “active” state. |
|                                     | The port associated with the specified connection is not a "event" type port. |
| `HV_STATUS_INVALID_PARAMETER`       | The specified flag number is greater than or equal to the port’s flag count. |
| `HV_STATUS_INVALID_VP_INDEX`        | The target VP no longer exists or there are no available VPs to which the message can be posted. |
| `HV_STATUS_INVALID_SYNIC_STATE`     | The target VP’s SynIC is disabled and cannot accept signaled events. |
|                                     | The target VP’s SIEF page is disabled.                 |