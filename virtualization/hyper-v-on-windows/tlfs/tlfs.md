---
title: #Required; page title displayed in search results. Include the brand.
description: #Required; article description that is displayed in search results.
author: #Required; your GitHub user alias, with correct capitalization.
ms.author: #Required; microsoft alias of author; optional team alias.
ms.service: #Required; service per approved list. service slug assigned to your service by ACOM.
ms.topic: overview #Required
ms.date: #Required; mm/dd/yyyy format.
---

# Hypervisor Top Level Functional Specification

This document is the top-level functional specification (TLFS) of the fifth-generation Microsoft hypervisor. It specifies the hypervisor’s externally-visible behavior. The document assumes familiarity with the goals of the project and the high-level hypervisor architecture.

This specification is provided under the Microsoft Open Specification Promise. For further details on the Microsoft Open Specification Promise, please refer to: http://www.microsoft.com/interop/osp/default.mspx. Microsoft may have patents, patent applications, trademarks, copyrights, or other intellectual property rights covering subject matter in these materials. Except as expressly provided in the Microsoft Open Specification Promise, the furnishing of these materials does not give you any license to these patents, trademarks, copyrights, or other intellectual property.

## Glossary

- **Partition** – Hyper-V supports isolation in terms of a partition. A partition is a logical unit of isolation, supported by the hypervisor, in which operating systems execute.
- **Root Partition** – The root partition (a.k.a the “parent” or “host”) is a privileged management partition. The root partition manages machine-level functions such as device drivers, power management, and device addition/removal. The virtualization stack runs in the parent partition and has direct access to the hardware devices. The root partition then creates the child partitions which host the guest operating systems.
- **Child Partition** – The child partition (a.k.a. the “guest”) hosts a guest operating system. All access to physical memory and devices by a child partition is provided via the Virtual Machine Bus (VMBus) or the hypervisor.
- **Hypercall** – Hypercalls are an interface for communication with the hypervisor.

## Specification Style

This specification is informal; that is, the interfaces are not specified in a formal language. Nevertheless, it is a goal to be precise. It is also a goal to specify which behaviors are architectural and which are implementation-specific. Callers should not rely on behaviors that fall into the latter category because they may change in future implementations.
Segments of code and algorithms are presented with a grey background.

### Reserved Values

This specification documents some fields as “reserved.” These fields may be given specific meaning in future versions of the hypervisor architecture. For maximum forward compatibility, clients of the hypervisor interface should follow the guidance provided within this document. In general, two forms of guidance are provided. Preserve value (documented as RsvdP in diagrams and ReservedP in code segments) – For maximum forward compatibility, clients should preserve the value within this field. This is typically done by reading the current value, modifying the values of the non-reserved fields, and writing the value back. Zero value (documented as RsvdZ in diagrams and ReservedZ in code segments) – For maximum forward compatibility, clients should zero the value within this field.

Reserved fields within read-only structures are simply documented as Rsvd in diagrams and simply as Reserved in code segments. For maximum forward compatibility, the values within these fields should be ignored. Clients should not assume these values will always be zero.

### Simple Scalar Types

Hypervisor data types are built up from simple scalar types UINT8, UINT16, UINT32, UINT64 and UINT128. Each of these represents a simple unsigned integer scalar with the specified bit count. Several corresponding signed integer scalars are also defined: INT8, INT16, INT32, and INT64.
The hypervisor uses neither floating point instructions nor floating point types.

### Hypercall Status Code

Every hypercall returns a 16-bit status code of type HV_STATUS.

 ```c
typedef UINT16 HV_STATUS;
 ```

### Memory Address Space Types

The hypervisor architecture defines three independent address spaces:

- **System physical addresses (SPAs)** define the physical address space of the underlying hardware as seen by the CPUs. There is only one system physical address space for the entire machine.
- **Guest physical addresses (GPAs)** define the guest’s view of physical memory. GPAs can be mapped to underlying SPAs. There is one guest physical address space per partition.
- **Guest virtual addresses (GVAs)** are used within the guest when it enables address translation and provides a valid guest page table.
-
All three of these address spaces are up to 264 bytes in size. The following types are thus defined:

 ```c
typedef UINT64 HV_SPA;
typedef UINT64 HV_GPA;
typedef UINT64 HV_GVA;
 ```

Many hypervisor interfaces act on pages of memory rather than single bytes. The minimum page size is architecture-dependent. For x64, it is defined as 4K.

 ```c
#define X64_PAGE_SIZE 0x1000

#define HV_X64_MAX_PAGE_NUMBER (MAXUINT64/X64_PAGE_SIZE)
#define HV_PAGE_SIZE X64_PAGE_SIZE
#define HV_LARGE_PAGE_SIZE X64_LARGE_PAGE_SIZE
#define HV_PAGE_MASK (HV_PAGE_SIZE - 1)

typedef UINT64 HV_SPA_PAGE_NUMBER;
typedef UINT64 HV_GPA_PAGE_NUMBER;
typedef UINT64 HV_GVA_PAGE_NUMBER;
typedef UINT32 HV_SPA_PAGE_OFFSET
typedef HV_GPA_PAGE_NUMBER *PHV_GPA_PAGE_NUMBER;
 ```

To convert an `HV_SPA` to an `HV_SPA_PAGE_NUMBER`, simply divide by `HV_PAGE_SIZE`.

### Structures, Enumerations and Bit Fields

Many data structures and constant values defined later in this specification are defined in terms of C-style enumerations and structures. The C language purposely avoids defining certain implementation details. However, this document assumes the following:

- All enumerations declared with the “enum” keyword define 32-bit signed integer values.
- All structures are padded in such a way that fields are aligned naturally (that is, an 8-byte field is aligned to an offset of 8 bytes and so on).
- All bit fields are packed from low-order to high-order bits with no padding.

### Endianness

The hypervisor interface is designed to be endian-neutral (that is, it should be possible to port the hypervisor to a big-endian or little-endian system), but some of the data structures defined later in this specification assume little-endian layout. Such data structures will need to be amended if and when a big-endian port is attempted.

### Pointer Naming Convention

The document uses a naming convention for pointer types. In particular, a “P” prepended to a defined type indicates a pointer to that type. A “PC” prepended to a defined type indicates a pointer to a constant value of that type.

## FOO4