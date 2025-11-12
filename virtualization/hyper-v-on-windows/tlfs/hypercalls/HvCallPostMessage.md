---
title: HvCallPostMessage
description: HvCallPostMessage hypercall
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference

---

# HvCallPostMessage

The HvCallPostMessage hypercall attempts to post (that is, send asynchronously) a message to the specified connection, which has an associated destination port. If the message is successfully posted, then it will be queued for delivery to a virtual processor within the partition associated with the port.

## Interface

 ```c
HV_STATUS
HvCallPostMessage(
    _In_ HV_CONNECTION_ID ConnectionId,
    _In_ HV_MESSAGE_TYPE MessageType,
    _In_ UINT32 PayloadSize,
    _In_reads_bytes_(PayloadSize) PCVOID Message
    );
 ```

## Call Code

`0x005C` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `ConnectionId`          | 0          | 4        | Specifies the ID of the connection.       |
| RsvdZ                   | 4          | 4        |                                           |
| `MessageType`           | 8          | 4        | Specifies the message type that will appear within the message header. The caller can specify any 32-bit message type whose most significant bit is cleared, with the exception of zero. |
| `PayloadSize`           | 12         | 4        | Specifies the number of bytes that are included in the message. |
| `Message`               | 16         | 240      | Secifies the payload of the message—up to 240 bytes total. Only the first n bytes are actually sent to the destination partition, where n is provided in the PayloadSize parameter. |

## Return Values

| Status code                         | Error Condition                                       |
|-------------------------------------|-------------------------------------------------------|
| `HV_STATUS_ACCESS_DENIED`           | The caller’s partition does not possess the PostMessages privilege. |
| `HV_STATUS_INVALID_CONNECTION_ID`   | The specified connection ID is invalid.               |
| `HV_STATUS_INVALID_PORT_ID`         | The port associated with the specified connection has been deleted. |
|                                     | The port associated with the specified connection belongs to a partition that is not in the “active” state. |
|                                     | The port associated with the specified connection is not a "message" type port. |
| `HV_STATUS_INVALID_PARAMETER`       | The most significant bit of the specified message type is set. |
|                                     | The MessageType parameter specifies a value of zero.  |
|                                     | The specified payload size exceeds 240 bytes.         |
| `HV_STATUS_INSUFFICIENT_BUFFERS`    | The port has no available guest message buffers.      |
| `HV_STATUS_INVALID_VP_INDEX`        | The target VP no longer exists or there are no available VPs to which the message can be posted. |
| `HV_STATUS_INVALID_SYNIC_STATE`     | The target VP’s SynIC is disabled and cannot accept posted messages. |
|                                     | The target VP’s SIM page is disabled.                 |