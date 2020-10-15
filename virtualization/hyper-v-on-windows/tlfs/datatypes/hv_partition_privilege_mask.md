# HV_PARTITION_PRIVILEGE_MASK

A partition can query its privilege mask through the “Hypervisor Feature Identification” CPUID Leaf (0x40000003).

## Syntax

```c
typedef struct
{
    // Access to virtual MSRs
    UINT64 AccessVpRunTimeReg:1;
    UINT64 AccessPartitionReferenceCounter:1;
    UINT64 AccessSynicRegs:1;
    UINT64 AccessSyntheticTimerRegs:1;
    UINT64 AccessIntrCtrlRegs:1;
    UINT64 AccessHypercallMsrs:1;
    UINT64 AccessVpIndex:1;
    UINT64 AccessResetReg:1;
    UINT64 AccessStatsReg:1;
    UINT64 AccessPartitionReferenceTsc:1;
    UINT64 AccessGuestIdleReg:1;
    UINT64 AccessFrequencyRegs:1;
    UINT64 AccessDebugRegs:1;
    UINT64 AccessReenlightenmentControls:1
    UINT64 Reserved1:18;

    // Access to hypercalls
    UINT64 CreatePartitions:1;
    UINT64 AccessPartitionId:1;
    UINT64 AccessMemoryPool:1;
    UINT64 Reserved:1;
    UINT64 PostMessages:1;
    UINT64 SignalEvents:1;
    UINT64 CreatePort:1;
    UINT64 ConnectPort:1;
    UINT64 AccessStats:1;
    UINT64 Reserved2:2;
    UINT64 Debugging:1;
    UINT64 CpuManagement:1;
    UINT64 Reserved:1
    UINT64 Reserved:1;
    UINT64 Reserved:1;
    UINT64 AccessVSM:1;
    UINT64 AccessVpRegisters:1;
    UINT64 Reserved:1;
    UINT64 Reserved:1;
    UINT64 EnableExtendedHypercalls:1;
    UINT64 StartVirtualProcessor:1;
    UINT64 Reserved3:10;
} HV_PARTITION_PRIVILEGE_MASK;
 ```

Each privilege controls access to a set of synthetic MSRs or hypercalls.

| Privilege Flag                        | Meaning                                       |
|---------------------------------------|-----------------------------------------------|
|`AccessVpRunTimeReg`                   | The partition has access to the synthetic MSR HV_X64_MSR_VP_RUNTIME. |


| Privilege Flag                        | Meaning                                       |
|---------------------------------------|-----------------------------------------------|
|`AccessPartitionReferenceCounter`      | The partition has access to the partition-wide reference count MSR, HV_X64_MSR_TIME_REF_COUNT. |
|`AccessSynicRegs`                      | The partition has access to the synthetic MSRs associated with the Synic (HV_X64_MSR_SCONTROL through HV_X64_MSR_EOM and HV_X64_MSR_SINT0 through HV_X64_MSR_SINT15).|
|`AccessSyntheticTimerMsrs`             | The partition has access to the synthetic MSRs associated with the Synic (HV_X64_MSR_STIMER0_CONFIG through HV_X64_MSR_STIMER3_COUNT). |
|`AccessIntrCtrlRegs`                   | The partition has access to the synthetic MSRs associated with the APIC (HV_X64_MSR_EOI, HV_X64_MSR_ICR and HV_X64_MSR_TPR). |
|`AccessHypercallMsrs`                  | The partition has access to the synthetic MSRs related to the hypercall interface (HV_X64_MSR_GUEST_OS_ID and HV_X64_MSR_HYPERCALL). |
|`AccessVpIndex`                        | The partition has access to the synthetic MSR that returns the virtual processor index. |
|`AccessResetReg`                       | This partition has access to the synthetic MSR that resets the system. |
|`AccessStatsReg`                       | This partition has access to the synthetic MSRs that allows the guest to map and unmap its own statistics pages. |
|`AccessPartitionReferenceTsc`          | The partition has access to the reference TSC. |
|`AccessGuestIdleReg`                   | The partition has access to the synthetic MSR that allows the guest to enter the guest idle state. |
|`AccessFrequencyRegs`                  | The partition has access to the synthetic MSRs that supply the TSC and APIC frequencies, if supported. |
|`AccessDebugRegs`                      | The partition has access to the synthetic MSRs used for some forms of guest debugging. |
|`AccessReenlightenmentControls`        | The partition has access to reenlightenment controls. |
|`CreatePartitions`                     | The partition can invoke the hypercall HvCallCreatePartition. The partition also can make any other hypercall that is restricted to operating on children. |
|`AccessPartitionId`                    | The partition can invoke the hypercall HvCallGetPartitionId to obtain its own partition ID. |
|`AccessMemoryPool`                     | The partition can invoke the hypercalls HvCallDepositMemory, HvCallWithdrawMemory and HvCallGetMemoryBalance. |
|`PostMessages`                         | The partition can invoke the hypercall HvCallPostMessage. |
|`SignalEvents`                         | The partition can invoke the hypercall HvCallSignalEvent. |
|`CreatePort`                           | The partition can invoke the hypercall HvCallCreatePort.  |
|`PostMessages`                         | The partition can invoke the hypercall HvCallPostMessage. |
|`ConnectPort`                          | The partition can invoke the hypercall HvCallConnectPort. |
|`AccessStats`                          | The partition can invoke the hypercalls HvCAllMapStatsPage and HvCallUnmapStatsPage. |
|`Debugging`                            | The partition can invoke the hypercalls HvCallPostDebugData, HvCallRetrieveDebugData and HvCallResetDebugSession. |
|`CpuManagement`                        | The partition can invoke various hypercalls for CPU management. |
|`AccessVSM`                            | The partition can use VSM. |
|`AccessVpRegisters`                    | The partition can invoke the hypercalls HvCallSetVpRegisters and HvCallGetVpRegisters. |
|`EnableExtendedHypercalls`             | The partition can use the extended hypercall interface. |
|`StartVirtualPRocessor`                | The partition can use HvStartVirtualProcessor to initialize virtual processors. |
