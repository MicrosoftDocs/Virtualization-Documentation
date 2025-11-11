---
title: HV_IO_PORT
description: HV_IO_PORT data type
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 08/28/2025
ms.topic: reference
ms.prod: windows-10-hyperv
---

# HV_IO_PORT

HV_IO_PORT represents an I/O port address used for port-based I/O operations on x64 platforms.

## Syntax

```c
typedef UINT16 HV_IO_PORT;
```

The I/O port is a 16-bit unsigned integer that specifies a port address in the I/O address space. This data type is only relevant on x64 and x86 architectures where port-based I/O is supported.

## See also

[HvCallCheckForIoIntercept](../hypercalls/HvCallCheckForIoIntercept.md)