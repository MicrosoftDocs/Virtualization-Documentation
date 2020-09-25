# HV_X64_FP_REGISTER

Floating point registers are encoded as 80-bit values.

## Syntax

```c
typedef struct
{
    UINT64 Mantissa;
    UINT64 BiasedExponent:15;
    UINT64 Sign:1;
    UINT64 Reserved:48;
} HV_X64_FP_REGISTER;
 ```
