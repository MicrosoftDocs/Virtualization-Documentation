# Hypercall Reference

The following table lists supported hypercalls by call code.

| Call Code | Type    | Hypercall                                                                           |
|-----------|---------|-------------------------------------------------------------------------------------|
| 0x0001    | Simple  | HvCallSwitchVirtualAddressSpace                                                     |
| 0x0002    | Simple  | HvCallFlushVirtualAddressSpace                                                      |
| 0x0003    | Rep     | HvCalFlushVirtualAddressList                                                        |
| 0x0008    | Simple  | HvCallNotifyLongSpinWait                                                            |
| 0x000b    | Simple  | HvCallSendSyntheticClusterIpi                                                       |
| 0x000c    | Rep     | HvCallModifyVtlProtectionMask                                                       |
| 0x000d    | Simple  | HvCallEnablePartitionVtl                                                            |
| 0x000e    | Simple  | HvCallDisablePartitionVtl                                                           |
| 0x000f    | Simple  | HvCallEnableVpVtl                                                                   |
| 0x0010    | Simple  | HvCallDisableVpVtl                                                                  |
| 0x0011    | Simple  | HvCallVtlCall                                                                       |
| 0x0012    | Simple  | HvCallVtlReturn                                                                     |
| 0x0013    | Simple  | HvCallFlushVirtualAddressSpaceEx                                                    |
| 0x0014    | Rep     | HvCallFlushVirtualAddressListEx                                                     |
| 0x0015    | Simple  | HvCallSendSyntheticClusterIpiEx                                                     |
| 0x005C    | Simple  | HvPostMessage                                                                       |
| 0x0069    | Simple  | HvPostDebugData                                                                     |
| 0x006A    | Simple  | HvRetrieveDebugData                                                                 |
| 0x006B    | Simple  | HvResetDebugSession                                                                 |
| 0x0099    | Simple  | [HvCallStartVirtualProcessor](HvCallStartVirtualProcessor.md)                       |
| 0x009A    | Rep     | [HvCallGetVpIndexFromApicId](HvCallGetVpIndexFromApicId.md)                         |
| 0x00AF    | Simple  | HvCallFlushGuestPhysicalAddressSpace                                                |
| 0x00B0    | Rep     | HvCallFlushGuestPhysicalAddressList                                                 |

The following table lists supported extended hypercalls by call code.

| Call Code | Type    | Hypercall                                                                           |
|-----------|---------|-------------------------------------------------------------------------------------|
| 0x8001    | Simple  | [HvExtCallQueryCapabilities](HvExtCallQueryCapabilities.md)                         |
| 0x8002    | Simple  | HvExtCallGetBootZeroedMemory                                                        |
| 0x8003    | Simple  | HvExtCallMemoryHeatHint                                                             |
| 0x8004    | Simple  | HvExtCallEpfSetup                                                                   |
| 0x8006    | Simple  | HvExtCallMemoryHeatHintAsync                                                        |
