# Virtual Interrupt Control

The hypervisor virtualizes interrupt delivery to virtual processors. This is done through the use of a synthetic interrupt controller (SynIC) which is an extension of a virtualized local APIC; that is, each virtual processor has a local APIC instance with the SynIC extensions. These extensions provide a simple inter-partition communication mechanism which is described in the following chapter.
Interrupts delivered to a partition fall into two categories: external and internal. External interrupts originate from other partitions or devices, and internal interrupts originate from within the partition itself.

External interrupts are generated in the following situations:

- A physical hardware device generates a hardware interrupt.
- A parent partition asserts a virtual interrupt (typically in the process of emulating a hardware device).
- The hypervisor delivers a message (for example, due to an intercept) to a partition.
- Another partition posts a message.
- Another partition signals an event.

Internal interrupts are generated in the following situations:

- A virtual processor accesses the APIC interrupt command register (ICR).
- A synthetic timer expires.

## Local APIC

The SynIC is a superset of a local APIC. The interface to this APIC is given by a set of 32-bit memory mapped registers. This local APIC (including the behavior of the memory mapped registers) is generally compatible with the local APIC on P4/Xeon systems as described in Intel’s and AMD's documentation.

The hypervisor’s local APIC virtualization may deviate from physical APIC operation in the following minor ways:

- On physical systems, the IA32_APIC_BASE MSR can be different for each processor in the system. The hypervisor may require that this MSR contains the same value for all virtual processors within a partition. As such, this MSR may be treated as a partition-wide value. If a virtual processor modifies this register, the value may effectively propagate to all virtual processors within the partition.
- The IA32_APIC_BASE MSR defines a “global enable” bit for enabling or disabling the APIC. The virtualized APIC may always be enabled. If so, this bit will always be set to 1.
- The hypervisor’s local APIC may not be able to generate virtual SMIs (system management interrupts).
- If multiple virtual processors within a partition are assigned identical APIC IDs, behavior of targeted interrupt delivery is boundedly undefined. That is, the hypervisor is free to deliver the interrupt to just one virtual processor, all virtual processors with the specified APIC ID, or no virtual processors. This situation is considered a guest programming error.
- Some of the memory mapped APIC registers may be accessed by way of virtual MSRs.
- The hypervisor may not allow a guest to modify its APIC IDs.

The remaining parts of this section describe only those aspects of SynIC functionality that are extensions of the local APIC.

### Local APIC MSR Accesses

The hypervisor provides accelerated MSR access to high usage memory mapped APIC registers. These are the TPR, EOI, and the ICR registers. The ICR low and ICR high registers are combined into one MSR. For performance reasons, the guest operating system should follow the hypervisor recommendation for the usage of the APIC MSRs.

| MSR address      | Register Name       | Description                                                                 |
|------------------|---------------------|-----------------------------------------------------------------------------|
| 0x40000070       | HV_X64_MSR_EOI      | Accesses the APIC EOI                                                       |
| 0x40000071       | HV_X64_MSR_ICR      | Accesses the APIC ICR-high and ICR-low                                      |
| 0x40000072       | HV_X64_MSR_TPR      | Access the APIC TPR                                                         |

#### HV_X64_MSR_EOI

| Bits          | Description                         | Attributes                                                  |
|---------------|-------------------------------------|-------------------------------------------------------------|
| 63:32         | RsvdZ (reserved, should be zero)    | Write                                                       |
| 31:0          | EOI value                           | Write                                                       |

#### HV_X64_MSR_ICR

| Bits          | Description                         | Attributes                                                  |
|---------------|-------------------------------------|-------------------------------------------------------------|
| 63:32         | ICR high value                      | Read / Write                                                |
| 31:0          | ICR low value                       | Read / Write                                                |

#### HV_X64_MSR_TPR

| Bits          | Description                         | Attributes                                                  |
|---------------|-------------------------------------|-------------------------------------------------------------|
| 63:8          | RsvdZ (reserved, should be zero)    | Read / Write                                                |
| 7:0           | TPR value                           | Read / Write                                                |

This MSR is intended to accelerate access to the TPR in 32-bit mode guest partitions. 64-bit mode guest partitions should set the TPR by way of CR8.
