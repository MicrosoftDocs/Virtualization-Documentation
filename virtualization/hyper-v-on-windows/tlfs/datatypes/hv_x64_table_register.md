# HV_X64_TABLE_REGISTER

Table registers are similar to segment registers, but they have no selector or attributes, and the limit is restricted to 16 bits.

## Syntax

```c
typedef struct
{
    UINT16 Pad[3];
    UINT16 Limit;
    UINT64 Base;
} HV_X64_TABLE_REGISTER;
 ```
