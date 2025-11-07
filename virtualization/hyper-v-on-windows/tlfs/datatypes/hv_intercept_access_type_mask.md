# HV_INTERCEPT_ACCESS_TYPE_MASK

## Overview
Bitmask selecting which access directions (read / write) trigger an intercept for parameterized intercept types.

## Syntax

```c
typedef UINT32 HV_INTERCEPT_ACCESS_TYPE_MASK;
```

## Bit Definitions

| Bit | Mask | Name | Meaning |
|-----|------|------|---------|
| 0 | 0x01 | HV_INTERCEPT_ACCESS_MASK_READ | Trap reads |
| 1 | 0x02 | HV_INTERCEPT_ACCESS_MASK_WRITE | Trap writes |
| 2 | 0x04 | HV_INTERCEPT_ACCESS_MASK_EXECUTE | Trap execution |

## See also

* [HV_INTERCEPT_PARAMETERS](hv_intercept_parameters.md)
* [HV_INTERCEPT_PARAMETERS_EX](hv_intercept_parameters_ex.md)
