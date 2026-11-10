---
title: HV_X64_PENDING_EVENT Data Type in Hyper-V
description: HV_X64_PENDING_EVENT defines a 32-byte x64 pending-event encoding. Learn its layout, registers, event types, fields, and injection requirements.
keywords: hyper-v
author: hvdev
ms.author: hvdev
ms.date: 11/03/2026
ms.topic: reference
ai-usage: ai-assisted
---

# HV_X64_PENDING_EVENT

`HV_X64_PENDING_EVENT` represents an event that Hyper-V delivers to an x64 virtual processor. Hyper-V also uses this value to report an intercept in `HV_TRANSLATE_GVA_RESULT_EX`. Understanding this encoding helps you inspect or supply events through a virtual processor's pending-event registers.

This reference explains the layout, event-specific formats, and requirements for valid register writes.

Architecture: x64 only.

## HV_X64_PENDING_EVENT layout

The type occupies 32 bytes and has 16-byte alignment. It consists of two 128-bit portions:

| Offset | Size | Portion | Corresponding VP register |
|--------|------|---------|---------------------------|
| 0 | 16 | `Reg0` | `HvRegisterPendingEvent0` |
| 16 | 16 | `Reg1` | `HvRegisterPendingEvent1` |

These registers are portions of the same event, not independent event slots. The generic view of
`Reg0` contains the following header byte and an `EventData[15]` array. Event-specific data can
also extend into `Reg1`. Offsets below are relative to the beginning of the event.

| Byte | Bits | Field | Meaning |
|------|------|-------|---------|
| 0 | 0 | `EventPending` | One if an event is pending; zero if no event is pending. |
| 0 | 3:1 | `EventType` | Selects the event-specific format. |
| 0 | 7:4 | `Reserved` | Reserved. |

When `EventPending` is zero, the remaining event fields are not meaningful. Fields marked reserved
must be zero when supplying an event and must be ignored when reading one.

## HV_X64_PENDING_EVENT event types

| Value | Name | View | Size |
|-------|------|------|------|
| 0 | `HvX64PendingEventException` | `HV_X64_PENDING_EXCEPTION_EVENT` | 16 bytes |
| 1 | `HvX64PendingEventMemoryIntercept` | `HV_X64_PENDING_MEMORY_INTERCEPT_EVENT` | 32 bytes |
| 2 | `HvX64PendingEventNestedMemoryIntercept` | `HV_X64_PENDING_NESTED_MEMORY_INTERCEPT_EVENT` | 32 bytes |
| 3 | `HvX64PendingEventVirtualizationFault` | `HV_X64_PENDING_VIRTUALIZATION_FAULT_EVENT` | 16 bytes |
| 5 | `HvX64PendingExtInt` | `HV_X64_PENDING_EXT_INT_EVENT` | 16 bytes |

Other event types and their payloads are not defined by this specification. Software must not
construct an event using an unrecognized type. When constructing one of the formats below,
initialize the unused portions of the pending-event value to zero.

## HV_X64_PENDING_EXCEPTION_EVENT

The 16-byte `HV_X64_PENDING_EXCEPTION_EVENT` (`Exception`) view uses `EventType` 0 (`HvX64PendingEventException`). It contains the common `EventPending` and `EventType` header fields and the following exception fields:

| Offset | Size | Field | Meaning |
|--------|------|-------|---------|
| 1 | 1 | `DeliverErrorCode`, reserved | Bit 0 indicates that `ErrorCode` is delivered with the exception. Bits 7:1 are reserved. |
| 2 | 2 | `Vector` | Exception vector. |
| 4 | 4 | `ErrorCode` | Error code, when `DeliverErrorCode` is set. |
| 8 | 8 | `ExceptionParameter` | Exception-specific parameter, described below. |

When injecting an exception, `Vector` must identify an exception supported by the target VP, and
`DeliverErrorCode` must match whether that exception delivers an error code. If an error code is
delivered, only bits valid for that exception and the target VP's features may be set.

For a page fault (`#PF`), `ExceptionParameter` supplies the faulting linear address for CR2. For a
debug exception (`#DB`), it supplies DR6 status bits B0-B3, BD, BS, BT, and RTM (bits 3:0 and
16:13); all other bits must be zero. For other exceptions, `ExceptionParameter` must be zero.

## HV_X64_PENDING_MEMORY_INTERCEPT_EVENT

The 32-byte `HV_X64_PENDING_MEMORY_INTERCEPT_EVENT` (`MemoryIntercept`) view uses `EventType` 1 (`HvX64PendingEventMemoryIntercept`). It contains the common `EventPending` and `EventType` header fields and the following memory-intercept fields:

| Offset | Size | Field | Meaning |
|--------|------|-------|---------|
| 1 | 1 | `TargetVtl` | Virtual trust level (VTL) that the memory intercept targets. |
| 2 | 1 | `AccessType` | Read, write, or execute, using [`HV_INTERCEPT_ACCESS_TYPE`](hv-x64-intercept-message-header.md#hv_intercept_access_type-value-definitions). |
| 3 | 1 | Flags | Bit 0 is `GuestLinearAddressValid`; bit 1 is `CausedByGpaAccess`. Bits 7:2 are reserved. |
| 4 | 4 | Reserved | Reserved. |
| 8 | 8 | `GuestLinearAddress` | Guest linear address, valid when `GuestLinearAddressValid` is one. |
| 16 | 8 | `GuestPhysicalAddress` | Guest physical address of the intercepted access. |
| 24 | 8 | Reserved | Reserved. |

`CausedByGpaAccess` distinguishes an access to the guest physical address from an access to a
page table during a page-table walk.

When injecting this event, `TargetVtl` must be allowed for the target partition. A caller in that
partition may target only a nonzero VTL lower than the caller's VTL. `GuestPhysicalAddress` must
be a valid guest physical address for the target partition.

## HV_X64_PENDING_NESTED_MEMORY_INTERCEPT_EVENT

The 32-byte `HV_X64_PENDING_NESTED_MEMORY_INTERCEPT_EVENT` (`NestedMemoryIntercept`) view uses `EventType` 2 (`HvX64PendingEventNestedMemoryIntercept`). It contains the common `EventPending` and `EventType` header fields. The following table defines the nested-memory-intercept fields:

| Offset | Size | Field | Meaning |
|--------|------|-------|---------|
| 1 | 1 | `AccessType` | Read, write, or execute, using [`HV_INTERCEPT_ACCESS_TYPE`](hv-x64-intercept-message-header.md#hv_intercept_access_type-value-definitions). |
| 2 | 1 | `GuestAccessPermission` | Access permissions from the guest hypervisor's nested page table. |
| 3 | 1 | Flags | Address, page-table, and shadow-stack flags, as defined below. |
| 4 | 1 | `EncryptedAccess`, reserved | Bit 0 indicates an encrypted access. Bits 7:1 are reserved. |
| 5 | 3 | Reserved | Reserved. |
| 8 | 8 | `GuestLinearAddress` | Guest linear address, valid when `GuestLinearAddressValid` is one. |
| 16 | 8 | `GuestNestedPhysicalAddress` | Nested guest physical address of the access. |
| 24 | 8 | Reserved | Reserved. |

The defined bits of `GuestAccessPermission` are read (`0x01`), write (`0x02`), supervisor execute
(`0x04`), and user execute (`0x08`). Bits 7:4 are reserved.

| Bit at offset 3 | Field | Meaning when set |
|-----------------|-------|------------------|
| 0 | `GuestLinearAddressValid` | `GuestLinearAddress` is valid. |
| 1 | `CausedByGpaAccess` | The fault was caused by a guest physical access rather than a page-table access during a walk. |
| 2 | `PageTableMisconfiguration` | The nested page table is misconfigured. |
| 3 | `GvaUserMode` | The linear address is user-mode. |
| 4 | `GvaReadWrite` | The linear address translates to a read/write page. |
| 5 | `GvaNoExecute` | The linear address translates to a no-execute page. |
| 6 | `ShadowStack` | The access is a shadow-stack access. |
| 7 | `EptSupervisorShadowStack` | The Extended Page Table (EPT) entry sets its supervisor shadow-stack bit. |

The availability of optional flags depends on the processor and nested-virtualization features
available to the target VP. Unsupported flags must be zero when constructing an event.
When injecting this event, the target VP must be in nested guest mode, and
`GuestNestedPhysicalAddress` must be a valid nested guest physical address.

## HV_X64_PENDING_VIRTUALIZATION_FAULT_EVENT

The 16-byte `HV_X64_PENDING_VIRTUALIZATION_FAULT_EVENT` (`VirtualizationFault`) view uses `EventType` 3 (`HvX64PendingEventVirtualizationFault`). It contains the common `EventPending` and `EventType` header fields and the following virtualization-fault fields:

| Offset | Size | Field | Meaning |
|--------|------|-------|---------|
| 1 | 1 | Reserved | Reserved. |
| 2 | 2 | `Parameter0` | First virtualization-fault parameter. |
| 4 | 4 | `Code` | Nonzero virtualization-fault code. |
| 8 | 8 | `Parameter1` | Second virtualization-fault parameter. |

The fields correspond to [`HV_VIRTUALIZATION_FAULT_INFORMATION`](hv_virtualization_fault_information.md).
Before injecting a virtualization fault, the caller must ensure that no virtualization fault is
already in progress for the target VP.

## HV_X64_PENDING_EXT_INT_EVENT

The 16-byte `HV_X64_PENDING_EXT_INT_EVENT` (`ExtInt`) view uses `EventType` 5 (`HvX64PendingExtInt`) to describe an external interrupt (ExtINT). It contains the common `EventPending` and `EventType` header fields and the following external-interrupt fields:

| Offset | Size | Field | Meaning |
|--------|------|-------|---------|
| 1 | 1 | `Vector` | Vector associated with the directly asserted ExtINT. |
| 2 | 14 | Reserved | Reserved. |

## Using the pending-event registers

A parent partition writing a target VP's pending-event registers must keep that VP explicitly
suspended or intercept-suspended while the registers are written. The complete event must be
valid before the VP resumes; acceptance of an individual register write does not by itself
guarantee delivery. Event support and delivery can depend on the VP's enabled features and state.

## See also

* [HV_REGISTER_NAME](hv_register_name.md)
* [HV_REGISTER_VALUE](hv_register_value.md)
* [HV_TRANSLATE_GVA_RESULT_EX](hv_translate_gva_result_ex.md)
* [HvCallSetVpRegisters](../hypercalls/HvCallSetVpRegisters.md)
