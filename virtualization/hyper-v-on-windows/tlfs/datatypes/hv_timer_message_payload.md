---
title: HV_TIMER_MESSAGE_PAYLOAD
description: HV_TIMER_MESSAGE_PAYLOAD
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# HV_TIMER_MESSAGE_PAYLOAD

Timer expiration messages are sent when a timer event fires. This structure defines the message payload.

## Syntax

```c
typedef struct
{
    UINT32          TimerIndex;
    UINT32          Reserved;
    HV_NANO100_TIME ExpirationTime;     // When the timer expired
    HV_NANO100_TIME DeliveryTime;       // When the message was delivered
} HV_TIMER_MESSAGE_PAYLOAD;
 ```

TimerIndex is the index of the synthetic timer (0 through 3) that generated the message. This allows a client to configure multiple timers to use the same interrupt vector and differentiate between their messages.

ExpirationTime is the expected expiration time of the timer measured in 100-nanosecond units by using the time base of the partition’s reference time counter. Note that the expiration message may arrive after the expiration time.

DeliveryTime is the time when the message is placed into the respective message slot of the SIM page. The time is measured in 100-nanosecond units based on the partition’s reference time counter.

## See also

 [HV_MESSAGE](HV_MESSAGE.md)