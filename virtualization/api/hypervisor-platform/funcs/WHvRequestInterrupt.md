---
title: WHvRequestInterrupt
description: Description on WHvRequestInterrupt and understanding its syntax, parameters, and return value
author: jstarks
ms.author: jostarks
ms.date: 06/06/2019
---

# WHvRequestInterrupt

## Syntax

```
HRESULT
WINAPI
WHvRequestInterrupt(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ const WHV_INTERRUPT_CONTROL* Interrupt,
    _In_ UINT32 InterruptControlSize
    );

typedef enum WHV_INTERRUPT_TYPE
{
    WHvX64InterruptTypeFixed            = 0,
    WHvX64InterruptTypeLowestPriority   = 1,
    WHvX64InterruptTypeNmi              = 4,
    WHvX64InterruptTypeInit             = 5,
    WHvX64InterruptTypeSipi             = 6,
    WHvX64InterruptTypeLocalInt1        = 9,
} WHV_INTERRUPT_TYPE;

typedef enum WHV_INTERRUPT_DESTINATION_MODE
{
    WHvX64InterruptDestinationModePhysical,
    WHvX64InterruptDestinationModeLogical,
} WHV_INTERRUPT_DESTINATION_MODE;

typedef enum WHV_INTERRUPT_TRIGGER_MODE
{
    WHvX64InterruptTriggerModeEdge,
    WHvX64InterruptTriggerModeLevel,
} WHV_INTERRUPT_TRIGGER_MODE;

typedef struct WHV_INTERRUPT_CONTROL
{
    UINT64 Type : 8;             // WHV_INTERRUPT_TYPE
    UINT64 DestinationMode : 4;  // WHV_INTERRUPT_DESTINATION_MODE
    UINT64 TriggerMode : 4;      // WHV_INTERRUPT_TRIGGER_MODE
    UINT64 Reserved : 48;
    UINT32 Destination;
    UINT32 Vector;
} WHV_INTERRUPT_CONTROL;
```

### Parameters

`Partition`

Specifies the partition to interrupt.

`Interrupt`

Specifies the interrupt's characteristics and destination.

`InterruptControlSize`

Specifies the size of `Interrupt`, in bytes.

## Return Value

If the function succeeds, the return value is S_OK.
