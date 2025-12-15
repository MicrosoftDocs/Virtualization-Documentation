# HV_MAP_GPA_FLAGS

## Overview
`HV_MAP_GPA_FLAGS` defines the access permissions and mapping attributes applied when creating or modifying guest physical address (GPA) mappings via mapping and protection hypercalls.

## Syntax
```c
typedef UINT32 HV_MAP_GPA_FLAGS; /* 32-bit flags field */
```

## Permission Bits (Low 4 Bits)
| Bit | Mask | Meaning |
|-----|------|---------|
| 0 | HV_MAP_GPA_READABLE (0x1) | GPA readable by the guest |
| 1 | HV_MAP_GPA_WRITABLE (0x2) | GPA writable by the guest |
| 2 | HV_MAP_GPA_KERNEL_EXECUTABLE (0x4) | Executable in kernel / privileged mode (architecture specific) |
| 3 | HV_MAP_GPA_USER_EXECUTABLE (0x8) | Executable in user mode (if applicable) |

### Special Page Encodings (Mutually Exclusive)
The following mutually exclusive values occupy bits 16–17. Only one may be specified and they override normal backing behavior:

| Value | Name | Meaning |
|-------|------|---------|
| 0x10000 | HV_MAP_GPA_NO_ACCESS | No access (access faults). Used to withdraw permissions without unmapping. |
| 0x20000 | HV_MAP_GPA_ZEROED | Maps to a shared zero page (readable, executable zero fill unless combined with reduced permissions). |
| 0x30000 | HV_MAP_GPA_ONES | Not-present / ones pattern mapping (readable, executable 1 fill unless combined with reduced permissions). |

### Mapping Attribute Bits
| Bit | Mask | Meaning |
|-----|------|---------|
| 20 | HV_MAP_GPA_NO_OVERLAY (0x100000) | Disallow overlay of this mapping. |
| 21 | HV_MAP_GPA_NOT_CACHED (0x200000) | Uncached mapping. |

### Accessed / Dirty Manipulation (State Update Operations)
Bits 24–27 form the accessed/dirty set/clear controls.

| Bit | Mask | Meaning |
|-----|------|---------|
| 24 | HV_MAP_GPA_CLEAR_ACCESSED (0x01000000) | Clear accessed bit |
| 25 | HV_MAP_GPA_SET_ACCESSED (0x02000000) | Set accessed bit |
| 26 | HV_MAP_GPA_CLEAR_DIRTY (0x04000000) | Clear dirty bit |
| 27 | HV_MAP_GPA_SET_DIRTY (0x08000000) | Set dirty bit |
| 28 | HV_MAP_GPA_DONT_SET_RANGE_ACCESSED (0x10000000) | Suppresses access bit |

### Large Page Mapping
| Bit | Mask | Meaning |
|-----|------|---------|
| 31 | HV_MAP_GPA_LARGE_PAGE (0x80000000) | Mapping uses a large page size; caller must meet alignment & size rules or mapping fails. |

## See Also
* [HV_GPA_PAGE_NUMBER](hv_gpa_page_number.md)
* [HV_GPA_MAPPING](hv_gpa_mapping.md)
* [HvCallMapGpaPages](../hypercalls/HvCallMapGpaPages.md)
* [HvCallMapSparseGpaPages](../hypercalls/HvCallMapSparseGpaPages.md)
* [HvCallModifySparseGpaPages](../hypercalls/HvCallModifySparseGpaPages.md)
* [HvCallModifyVtlProtectionMask](../hypercalls/HvCallModifyVtlProtectionMask.md)
