# HV_CPUID_RESULT

The HV_CPUID_RESULT data type contains the result of a CPUID instruction execution. This structure holds the register values returned by the CPUID instruction for a specific function and subfunction.

Architecture: x64 only.

## Syntax

```c
typedef union {
    UINT32 AsUINT32[4];
    struct
    {
        UINT32 Eax;
        UINT32 Ebx;
        UINT32 Ecx;
        UINT32 Edx;
    };
} HV_CPUID_RESULT;
```

### Members

- **Eax**: The value returned in the EAX register by the CPUID instruction
- **Ebx**: The value returned in the EBX register by the CPUID instruction
- **Ecx**: The value returned in the ECX register by the CPUID instruction
- **Edx**: The value returned in the EDX register by the CPUID instruction

The CPUID instruction returns processor identification and feature information in these four 32-bit registers. The specific meaning of each register's contents depends on the CPUID function and subfunction that was executed.

## See also

* [HvCallGetVpCpuidValues](../hypercalls/HvCallGetVpCpuidValues.md)
* [HV_PARTITION_ID](hv_partition_id.md)
* [HV_VP_INDEX](hv_vp_index.md)
