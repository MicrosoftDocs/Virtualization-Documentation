# HvCallSendSyntheticClusterIpiEx

This hypercall sends a virtual fixed interrupt to the specified virtual processor set. It does not support NMIs. This version differs from [HvCallSendSyntheticClusterIpi](HvCallSendSyntheticClusterIpi.md) in that a variable sized VP set can be specified.

The following checks should be used to infer the availability of this hypercall:

- ExProcessorMasks must be indicated via CPUID leaf 0x40000004.

## Interface

 ```c
HV_STATUS
HvCallSendSyntheticClusterIpiEx(
    _In_ UINT32 Vector,
    _In_ HV_INPUT_VTL TargetVtl,
    _In_ HV_VP_SET ProcessorSet
    );
 ```

## Call Code
`0x0015` (Simple)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `Vector`                | 0          | 4        | Specified the vector asserted. Must be between >= 0x10 and <= 0xFF.  |
| `TargetVtl`             | 4          | 1        | Target VTL                                |
| Padding                 | 5          | 3        |                                           |
| `ProcessorSet`          | 8          | Variable | Specifies a processor set representing VPs to target|

## See also

[HV_VP_SET](../datatypes/HV_VP_SET.md)
