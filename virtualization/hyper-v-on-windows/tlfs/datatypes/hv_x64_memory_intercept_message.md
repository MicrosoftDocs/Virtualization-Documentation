---
title: HV_X64_MEMORY_INTERCEPT_MESSAGE
description: Payload for an x64 memory-access intercept message
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 10/13/2026
ms.topic: reference
---

# HV_X64_MEMORY_INTERCEPT_MESSAGE

`HV_X64_MEMORY_INTERCEPT_MESSAGE` defines the payload for an intercepted x64 memory access. The payload contains the available virtual
processor context, access type, address information, and up to 16 instruction-stream bytes. The following message types use this payload:

| Message type | Value | Meaning |
|--------------|-------|---------|
| `HvMessageTypeUnmappedGpa` | `0x80000000` | Access to an unmapped GPA. |
| `HvMessageTypeGpaIntercept` | `0x80000001` | GPA access requiring an intercept, such as an access disallowed by the GPA mapping's permissions. |
| `HvMessageTypeUnacceptedGpa` | `0x80000003` | Access to an unaccepted GPA. |

Architecture: x64 only.

## Syntax

```c
typedef struct
{
    HV_X64_INTERCEPT_MESSAGE_HEADER Header;
    HV_CACHE_TYPE CacheType;
    UINT8 InstructionByteCount;
    HV_X64_MEMORY_ACCESS_INFO MemoryAccessInfo;
    UINT8 TprPriority;
    UINT8 Reserved1;
    UINT64 GuestVirtualAddress;
    UINT64 GuestPhysicalAddress;
    UINT8 InstructionBytes[16];
} HV_X64_MEMORY_INTERCEPT_MESSAGE;
```

## Layout

| Offset | Size | Field | Description |
|--------|------|-------|-------------|
| 0 | 40 | `Header` | Common x64 intercept context, including the virtual processor index and access type. Instruction length is not supplied. |
| 40 | 4 | `CacheType` | Cache-type encoding. |
| 44 | 1 | `InstructionByteCount` | Number of valid bytes in `InstructionBytes`, in the range 0 to 16, inclusive. This field does not specify the decoded instruction length. |
| 45 | 1 | `MemoryAccessInfo` | Address-validity and intercept-state flags. |
| 46 | 1 | `TprPriority` | Low four bits of the virtual processor's CR8 (virtual APIC task-priority class), when register context is available. |
| 47 | 1 | `Reserved1` | Reserved. Software must ignore this field. |
| 48 | 8 | `GuestVirtualAddress` | GVA associated with the access when `MemoryAccessInfo.GvaValid` is set. |
| 56 | 8 | `GuestPhysicalAddress` | GPA associated with the access. The GVA-to-GPA translation pair is valid only if `MemoryAccessInfo.GvaGpaValid` is set. |
| 64 | 16 | `InstructionBytes` | Bytes beginning at the intercepted instruction. Only the first `InstructionByteCount` bytes are valid. |

The structure is 80 bytes.

## Access type

`Header.InterceptAccessType` describes the operation that caused the intercept:

| Value | Name | Meaning |
|-------|------|---------|
| 0 | `HV_INTERCEPT_ACCESS_READ` | Memory read |
| 1 | `HV_INTERCEPT_ACCESS_WRITE` | Memory write |
| 2 | `HV_INTERCEPT_ACCESS_EXECUTE` | Instruction fetch |

This field encodes one access type. It is not the access mask specified when installing an intercept.

## Cache type values

| Value | Name |
|-------|------|
| 0 | `HvCacheTypeUncached` |
| 1 | `HvCacheTypeWriteCombining` |
| 4 | `HvCacheTypeWriteThrough` |
| 5 | `HvCacheTypeWriteProtected` |
| 6 | `HvCacheTypeWriteBack` |

## Processing requirements

- Only the first `InstructionByteCount` bytes of `InstructionBytes` are valid. The count may be zero. The supplied bytes may represent
  only part of an instruction, including when the instruction crosses a page boundary.
- `Header.InstructionLength` is zero. Neither this field nor `InstructionByteCount` specifies the amount by which to advance RIP.
  Software emulating the instruction must decode it to determine its length.
- `GuestVirtualAddress` is valid only if `MemoryAccessInfo.GvaValid` is set. The GVA-to-GPA translation pair is valid only if
  `MemoryAccessInfo.GvaGpaValid` is set. `GuestPhysicalAddress` identifies the intercepted physical access independently of these flags.
- A memory intercept may occur during instruction execution, event delivery, or a pending hypercall-output write. It does not necessarily
  correspond to an explicit load or store by the instruction at RIP.
- For hardware-isolated partitions, the common header does not disclose CS, RIP, RFLAGS, or the full execution state. Instruction bytes
  and `TprPriority` are not supplied. The zero values in these fields do not represent architectural register state.

## See also

* [HV_X64_MEMORY_ACCESS_INFO](hv_x64_memory_access_info.md)
* [HV_MESSAGE](hv_message.md)
* [HV_MESSAGE_TYPE](hv_message_type.md)
