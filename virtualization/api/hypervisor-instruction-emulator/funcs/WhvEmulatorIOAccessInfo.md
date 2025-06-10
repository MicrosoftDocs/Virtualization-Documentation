---
title: WHV_EMULATOR_IO_ACCESS_INFO method
description: Learn about the WHV_EMULATOR_IO_ACCESS_INFO method. 
author: sethmanheim
ms.author: roharwoo
ms.date: 04/19/2022
---

# WHV_EMULATOR_IO_ACCESS_INFO


## Syntax

```c
typedef struct _WHV_EMULATOR_IO_ACCESS_INFO {
    UINT8 Direction; // 0 for in, 1 for out
    UINT16 Port;
    UINT16 AccessSize; // only 1, 2, 4
    UINT32 Data[4];
} WHV_EMULATOR_IO_ACCESS_INFO;
```
## Remarks
Information about the requested Io Port access by the emulator.

`Direction` is the same as for memory, a 0 for a read and 1 for a write.

`Port` is the Io Port the emulator is attempting to access.

`AccessSize` is the same as described above for memory, but limited to values of 1, 2 or 4.

`Data` is the data read/written to the Io Port, casted to the appropriate size value (UINT8, UINT16, UINT32).
