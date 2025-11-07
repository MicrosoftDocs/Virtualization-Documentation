````markdown
# HV_UNMAP_GPA_FLAGS

## Overview
Flags influencing behavior of GPA unmapping operations.

## Syntax
```c
typedef UINT32 HV_UNMAP_GPA_FLAGS;
```

## Defined Bits
| Bit | Name | Meaning |
|-----|------|---------|
| 1 | HV_UNMAP_GPA_KEEP_PRECOMMITTED | Keep pages in a precommitted state (do not uncommit underlying memory) |
| 2 | HV_UNMAP_GPA_LARGE_PAGE | Treat the repetition count as large (2 MiB) pages |

## Usage Notes
- When `HV_UNMAP_GPA_LARGE_PAGE` is set the repetition count is in units of large pages (architecture-defined 2 MiB size for this interface); partial coverage or misalignment fails with partial progress.
- `HV_UNMAP_GPA_KEEP_PRECOMMITTED` suppresses automatic uncommit of the pages being unmapped. The guest (or its parent) may later map them again without redeposit overhead.
- Large-page and keep-precommitted flags are orthogonal and MAY be combined.

## See Also
* [HvCallUnmapGpaPages](../hypercalls/HvCallUnmapGpaPages.md)
* [HvCallMapGpaPages](../hypercalls/HvCallMapGpaPages.md)
````
