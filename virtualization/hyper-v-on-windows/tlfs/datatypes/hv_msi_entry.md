# HV_MSI_ENTRY

## Syntax

 ```c
typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT32 Address;
        UINT32 Data;
    };
} HV_MSI_ENTRY;
 ```