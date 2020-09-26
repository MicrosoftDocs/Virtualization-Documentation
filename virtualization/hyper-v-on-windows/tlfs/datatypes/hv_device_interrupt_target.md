# HV_DEVICE_INTERRUPT_TARGET

## Syntax

 ```c

#define HV_DEVICE_INTERRUPT_TARGET_MULTICAST 1
#define HV_DEVICE_INTERRUPT_TARGET_PROCESSOR_SET 2

typedef struct
{
    HV_INTERRUPT_VECTOR Vector;
    UINT32 Flags;
    union
    {
        UINT64 ProcessorMask;
        UINT64 ProcessorSet[];
    };
} HV_DEVICE_INTERRUPT_TARGET;
 ```

“Flags” supplies optional flags for the interrupt target. “Multicast” indicates that the interrupt is sent to all processors in the target set. By default, the interrupt is sent to an arbitrary single processor in the target set.
