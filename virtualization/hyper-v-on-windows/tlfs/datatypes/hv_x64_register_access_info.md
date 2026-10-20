---
title: HV_X64_REGISTER_ACCESS_INFO
description: Operand information for an x64 register intercept
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 10/13/2026
ms.topic: reference
---

# HV_X64_REGISTER_ACCESS_INFO

`HV_X64_REGISTER_ACCESS_INFO` specifies operand information for an intercepted virtual processor register access. The access direction and
the `IsMemoryOp` field of the containing message select the applicable union member.

Architecture: x64 only.

## Syntax

```c
typedef union
{
    HV_REGISTER_VALUE SourceValue;
    HV_REGISTER_NAME DestinationRegister;
    UINT64 SourceAddress;
    UINT64 DestinationAddress;
} HV_X64_REGISTER_ACCESS_INFO;
```

The union occupies 16 bytes and has 16-byte alignment, as required by its `HV_REGISTER_VALUE` member.

## Member selection

| Intercept access type | `IsMemoryOp` | Active member | Meaning |
|-----------------------|--------------|---------------|---------|
| `HV_INTERCEPT_ACCESS_WRITE` | 0 | `SourceValue` | Value supplied by the intercepted register write. |
| `HV_INTERCEPT_ACCESS_WRITE` | 1 | `SourceAddress` | Memory-source member. |
| `HV_INTERCEPT_ACCESS_READ` | 0 | `DestinationRegister` | Destination register, if specified. A value of zero indicates that no destination register is specified. |
| `HV_INTERCEPT_ACCESS_READ` | 1 | `DestinationAddress` | Memory-destination member. |

Only the selected member is valid. For a read intercept, `SourceValue` does not contain the result of the read. Guest crash MSR read
notifications do not specify `DestinationRegister`. Software completes these reads using the MSR's RAX/RDX convention and the applicable
intercept-completion mechanism.

## See also

* [HV_X64_REGISTER_INTERCEPT_MESSAGE](hv_x64_register_intercept_message.md)
* [HV_REGISTER_NAME](hv_register_name.md)
* [HV_REGISTER_VALUE](hv_register_value.md)
