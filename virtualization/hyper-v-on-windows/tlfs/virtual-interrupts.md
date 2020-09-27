# Virtual Interrupt Controller

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

### Synthetic Cluster IPI

A hypervisor supports hypercalls which allow to send virtual fixed interrupts to an arbitrary set of virtual processors.

| Hypercall                                                                           | Description                                     |
|-------------------------------------------------------------------------------------|-------------------------------------------------|
| [HvCallSendSyntheticClusterIpi](hypercalls/HvCallSendSyntheticClusterIpi.md)      | Sends a virtual fixed interrupt to the specified virtual processor set. |
| [HvCallSendSyntheticClusterIpiEx](hypercalls/HvCallSendSyntheticClusterIpiEx.md)  | Similar to HvCallSendSyntheticClusterIpi, takes a sparse VP set as input.    |

### EOI Assist

One field in the [Virtual Processor Assist Page](../vp-properties.md#Virtual-Processor-Assist-Page) is the EOI Assist field. The EOI Assist field resides at offset 0 of the overlay page and is 32-bits in size. The format of the EOI assist field is as follows:

| Bits          | Description                         | Attributes                                                  |
|---------------|-------------------------------------|-------------------------------------------------------------|
| 31:1          | RsvdZ                               | Read / Write                                                |
| 0             | No EOI Required                     | Read / Write                                                |

The guest OS performs an EOI by atomically writing zero to the EOI Assist field of the virtual VP assist page and checking whether the “No EOI required” field was previously zero. If it was, the OS must write to the HV_X64_APIC_EOI MSR thereby triggering an intercept into the hypervisor. The following code is recommended to perform an EOI:

```
lea rcx, [VirtualApicAssistVa]
btr [rcx], 0
jc NoEoiRequired

mov ecx, HV_X64_APIC_EOI
wrmsr

NoEoiRequired:
```

The hypervisor sets the “No EOI required” bit when it injects a virtual interrupt if the following conditions are satisfied:

- The virtual interrupt is edge-triggered, and
- There are no lower priority interrupts pending

If, at a later time, a lower priority interrupt is requested, the hypervisor clears the “No EOI required” such that a subsequent EOI causes an intercept.

In case of nested interrupts, the EOI intercept is avoided only for the highest priority interrupt. This is necessary since no count is maintained for the number of EOIs performed by the OS. Therefore only the first EOI can be avoided and since the first EOI clears the “No EOI Required” bit, the next EOI generates an intercept. However nested interrupts are rare, so this is not a problem in the common case.

Note that devices and/or the I/O APIC (physical or synthetic) need not be notified of an EOI for an edge-triggered interrupt – the hypervisor intercepts such EOIs only to update the virtual APIC state. In some cases, the virtual APIC state can be lazily updated – in such cases, the “NoEoiRequired” bit is set by the hypervisor indicating to the guest that an EOI intercept is not necessary. At a later instant, the hypervisor can derive the state of the local APIC depending on the current value of the “NoEoiRequired” bit.

Enabling and disabling this enlightenment can be done at any time independently of the interrupt activity and the APIC state at that moment. While the enlightenment is enabled, conventional EOIs can still be performed irrespective of the “No EOI required” value but they will not realize the performance benefit of the enlightenment.
