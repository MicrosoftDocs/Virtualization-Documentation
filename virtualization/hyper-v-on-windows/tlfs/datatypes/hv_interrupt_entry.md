# HV_INTERRUPT_ENTRY

## Syntax

 ```c
typedef enum
{
    HvInterruptSourceMsi = 1,
} HV_INTERRUPT_SOURCE;

typedef struct
{
    HV_INTERRUPT_SOURCE InterruptSource;
    UINT32 Reserved;

    union
    {
        HV_MSI_ENTRY MsiEntry;
        UINT64 Data;
    };
} HV_INTERRUPT_ENTRY;
 ```

## See also

[HV_MSI_ENTRY](HV_MSI_ENTRY.md)