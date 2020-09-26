# HvCallFlushVirtualAddressSpaceEx

The HvCallFlushVirtualAddressSpaceEx hypercall is similar to [HvCallFlushVirtualAddressSpace](HvCallFlushVirtualAddressSpace.md), but can take a variably-sized sparse VP set as an input.

The following checks should be used to infer the availability of this hypercall:
- ExProcessorMasks must be indicated via CPUID leaf 0x40000004.

## Interface

 ```c
HV_STATUS
HvFlushVirtualAddressSpaceEx(
    _In_ HV_ADDRESS_SPACE_ID AddressSpace,
    _In_ HV_FLUSH_FLAGS Flags,
    _In_ HV_VP_SET ProcessorSet
    );
 ```

## Call Code
`0x0013` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `AddressSpace`          | 0          | 8        | Specifies an address space ID (a CR3 value). |
| `Flags`                 | 8          | 8        | Set of flag bits that modify the operation of the flush. |
| `ProcessorSet`          | 16         | Variable | Processor set indicating which processors should be affected by the flush operation. |

## See also

[HV_VP_SET](../datatypes/HV_VP_SET.md)
