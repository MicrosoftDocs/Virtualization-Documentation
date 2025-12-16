---
title: Timers
description: Hypervisor Timers
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# Timers

The hypervisor provides simple timing services. These are based on a constant-rate reference time source (typically the ACPI timer on x64 systems).

The following timer services are provided:

- A per-partition reference time counter.
- Four synthetic timers per virtual processor. Each synthetic timer is a single-shot or periodic timer that delivers a message or asserts an interrupt when it expires.
- One virtual APIC timer per virtual processor.
- A partition reference time enlightenment, based on the host platform’s support for an Invariant Time Stamp Counter (iTSC).

## Reference Counter

The hypervisor maintains a per-partition reference time counter. It has the characteristic that successive accesses to it return strictly monotonically increasing (time) values as seen by any and all virtual processors of a partition. Furthermore, the reference counter is rate constant and unaffected by processor or bus speed transitions or deep processor power savings states. A partition’s reference time counter is initialized to zero when the partition is created. The reference counter for all partitions count at the same rate, but at any time, their absolute values will typically differ because partitions will have different creation times.

The reference counter continues to count up as long as at least one virtual processor is not explicitly suspended.

### Partition Reference Counter Register

#### On x64 Platforms

On x64 platforms, a partition's reference counter can be accessed through a partition-wide MSR.

| MSR address      | Register Name              | Description                                                                 |
|------------------|----------------------------|-----------------------------------------------------------------------------|
| 0x40000020       | HV_X64_MSR_TIME_REF_COUNT  | Time reference count (partition-wide)                                       |

#### On ARM64 Platforms

On ARM64 platforms, a partition's reference counter is accessed via the HvRegisterTimeRefCount synthetic register using the HvCallGetVpRegisters and HvCallSetVpRegisters hypercalls.

| Register Name              | Description                                                                 |
|----------------------------|-----------------------------------------------------------------------------|
| HvRegisterTimeRefCount     | Time reference count (partition-wide)                                       |

#### Register Behavior

When a partition is created, the value of the reference counter register is set to 0x0000000000000000. This value cannot be modified by a virtual processor. On x64 platforms, any attempt to write to the MSR results in a #GP fault. On ARM64 platforms, attempts to write via HvCallSetVpRegisters return HV_STATUS_INVALID_PARAMETER.

### Partition Reference Time Enlightenment

The partition reference time enlightenment presents a reference time source to a partition which does not require an intercept into the hypervisor. This enlightenment is available only when the underlying platform provides support of an invariant processor Time Stamp Counter (TSC), or iTSC. In such platforms, the processor TSC frequency remains constant irrespective of changes in the processor’s clock frequency due to the use of power management states such as ACPI processor performance states, processor idle sleep states (ACPI C-states), etc.

The partition reference time enlightenment uses a virtual TSC value, an offset and a multiplier to enable a guest partition to compute the normalized reference time since partition creation, in 100nS units. The mechanism also allows a guest partition to atomically compute the reference time when the guest partition is migrated to a platform with a different TSC rate, and provides a fallback mechanism to support migration to platforms without the constant rate TSC feature.

This facility is not intended to be used a source of wall clock time, since the reference time computed using this facility will appear to stop during the time that a guest partition is saved until the subsequent restore.

#### Partition Reference Time Stamp Counter Page

The hypervisor provides a partition-wide virtual reference TSC page which is overlaid on the partition’s GPA space. A partition’s reference time stamp counter page is accessed through the Reference TSC MSR.

The reference TSC page is defined using the following structure:

 ```c
typedef struct
{
    volatile UINT32 TscSequence;
    UINT32 Reserved1;
    volatile UINT64 TscScale;
    volatile INT64 TscOffset;
    UINT64 Reserved2[509];
} HV_REFERENCE_TSC_PAGE;
 ```

#### Reference Time Stamp Counter (TSC) Page Register

A guest wishing to access its reference TSC page must use a synthetic register. A partition which possesses the AccessPartitionReferenceTsc privilege may access the register.

##### On x64 Platforms

On x64 platforms, the reference TSC page is accessed via an MSR.

| MSR address      | Register Name              | Description                                                                 |
|------------------|----------------------------|-----------------------------------------------------------------------------|
| 0x40000021       | HV_X64_MSR_REFERENCE_TSC   | Reference TSC page                                                          |

##### On ARM64 Platforms

On ARM64 platforms, the reference TSC page is accessed via the HvRegisterReferenceTsc synthetic register using the HvCallGetVpRegisters and HvCallSetVpRegisters hypercalls.

| Register Name              | Description                                                                 |
|----------------------------|-----------------------------------------------------------------------------|
| HvRegisterReferenceTsc     | Reference TSC page                                                          |

##### Register Layout

| Bits          | Description                         | Attributes                                                  |
|---------------|-------------------------------------|-------------------------------------------------------------|
| 63:12         | GPA Page Number                     | Read / Write                                                |
| 11:1          | RsvdP (value should be preserved)   | Read / Write                                                |
| 0             | Enable                              | Read / Write                                                |

At the guest partition creation time, the value of the reference TSC MSR is 0x0000000000000000. Thus, the reference TSC page is disabled by default. The guest must enable the reference TSC page by setting bit 0. If the specified base address is beyond the end of the partition’s GPA space, the reference TSC page will not be accessible to the guest. When modifying the register, guests should preserve the value of the reserved bits (1 through 11) for future compatibility.

#### Partition Reference TSC Mechanism

The partition reference time is computed by the following formula:

ReferenceTime = ((VirtualTsc * TscScale) >> 64) + TscOffset

The multiplication is a 64 bit multiplication, which results in a 128 bit number which is then shifted 64 times to the right to obtain the high 64 bits.

The TscScale value is used to adjust the Virtual TSC value across migration events to mitigate TSC frequency changes from one platform to another.

The TscSequence value is used to synchronize access to the enlightened reference time if the scale and/or the offset fields are changed during save/restore or live migration. This field serves as a sequence number which is incremented whenever the scale and/or the offset fields are modified. A special value of 0x0 is used to indicate that this facility is no longer a reliable source of reference time and the VM must fall back to a different source.

The recommended code for computing the partition reference time using this enlightenment is shown below:

```c
do
{
    StartSequence = ReferenceTscPage->TscSequence;
    if (StartSequence == 0)
    {
        // 0 means that the Reference TSC enlightenment is not available at
        // the moment, and the Reference Time can only be obtained from
        // reading the Reference Counter MSR.
        ReferenceTime = rdmsr(HV_X64_MSR_TIME_REF_COUNT);
        return ReferenceTime;
    }

    Tsc = rdtsc();

    // Assigning Scale and Offset should neither happen before
    // setting StartSequence, nor after setting EndSequence.
    Scale = ReferenceTscPage->TscScale;
    Offset = ReferenceTscPage->TscOffset;

    EndSequence = ReferenceTscPage->TscSequence;
} while (EndSequence != StartSequence);

// The result of the multiplication is treated as a 128-bit value.
ReferenceTime = ((Tsc * Scale) >> 64) + Offset;
return ReferenceTime;
```

## Synthetic Timers

Synthetic timers provide a mechanism for generating an interrupt after some specified time in the future. Both one-shot and periodic timers are supported. A synthetic timer sends a message to a specified SynIC SINTx (synthetic interrupt source) upon expiration, or asserts an interrupt, depending on how it is configured.

The hypervisor guarantees that a timer expiration signal will never be delivered before the expiration time. The signal may arrive any time after the expiration time.

### Periodic Timers

The hypervisor attempts to signal periodic timers on a regular basis. However, if the virtual processor used to signal the expiration is not available, some of the timer expirations may be delayed. A virtual processor may be unavailable because it is suspended (for example, during intercept handling) or because the hypervisor’s scheduler decided that the virtual processor should not be scheduled on a logical processor (for example, because another virtual processor is using the logical processor or the virtual processor has exceeded its quota).

If a virtual processor is unavailable for a sufficiently long period of time, a full timer period may be missed. In this case, the hypervisor uses one of two techniques.

The first technique involves timer period modulation, in effect shortening the period until the timer “catches up”. If a significant number of timer signals have been missed, the hypervisor may be unable to compensate by using period modulation. In this case, some timer expiration signals may be skipped completely.

For timers that are marked as lazy, the hypervisor uses a second technique for dealing with the situation in which a virtual processor is unavailable for a long period of time. In this case, the timer signal is deferred until this virtual processor is available. If it doesn’t become available until shortly before the next timer is due to expire, it is skipped entirely.

### Ordering of Timer Expirations

Synthetic and virtualized timers generate interrupts at or near their designated expiration time. Due to hardware and other scheduling interactions, interrupts could potentially be delayed. No ordering may be assumed between any set of timers.

### Direct Synthetic Timers

“Direct” synthetic timers assert an interrupt upon timer expiration instead of sending a message to a SynIc synthetic interrupt source. A synthetic timer is set to “direct” mode by setting the “DirectMode” field of the synthetic timer configuration MSRs. The “ApicVector” field controls the interrupt vector that is asserted upon timer expiration.

### Synthetic Timer Registers

Synthetic timers are configured by using synthetic registers associated with each virtual processor. Each of the four synthetic timers has an associated pair of registers (configuration and count).

#### On x64 Platforms

On x64 platforms, synthetic timers are accessed via MSRs using the RDMSR and WRMSR instructions.

| MSR address      | Register Name                   | Description                                                    |
|------------------|---------------------------------|----------------------------------------------------------------|
| 0x400000B0       | HV_X64_MSR_STIMER0_CONFIG       | Configuration register for synthetic timer 0.                  |
| 0x400000B1       | HV_X64_MSR_STIMER0_COUNT        | Expiration time or period for synthetic timer 0.               |
| 0x400000B2       | HV_X64_MSR_STIMER1_CONFIG       | Configuration register for synthetic timer 1.                  |
| 0x400000B3       | HV_X64_MSR_STIMER1_COUNT        | Expiration time or period for synthetic timer 1.               |
| 0x400000B4       | HV_X64_MSR_STIMER2_CONFIG       | Configuration register for synthetic timer 2.                  |
| 0x400000B5       | HV_X64_MSR_STIMER2_COUNT        | Expiration time or period for synthetic timer 2.               |
| 0x400000B6       | HV_X64_MSR_STIMER3_CONFIG       | Configuration register for synthetic timer 3.                  |
| 0x400000B7       | HV_X64_MSR_STIMER3_COUNT        | Expiration time or period for synthetic timer 3.               |

#### On ARM64 Platforms

On ARM64 platforms, synthetic timers are accessed via synthetic registers using the HvCallGetVpRegisters and HvCallSetVpRegisters hypercalls.

| Register Name                   | Description                                                    |
|---------------------------------|----------------------------------------------------------------|
| HvRegisterStimer0Config         | Configuration register for synthetic timer 0.                  |
| HvRegisterStimer0Count          | Expiration time or period for synthetic timer 0.               |
| HvRegisterStimer1Config         | Configuration register for synthetic timer 1.                  |
| HvRegisterStimer1Count          | Expiration time or period for synthetic timer 1.               |
| HvRegisterStimer2Config         | Configuration register for synthetic timer 2.                  |
| HvRegisterStimer2Count          | Expiration time or period for synthetic timer 2.               |
| HvRegisterStimer3Config         | Configuration register for synthetic timer 3.                  |
| HvRegisterStimer3Count          | Expiration time or period for synthetic timer 3.               |

> **Note:** On ARM64, synthetic timers are optional because the ARM Generic Timer (GIT) can be used directly without incurring virtualization overhead. Guest operating systems should prefer using the architectural generic timer for better performance.

#### Register Layout

##### Synthetic Timer Configuration Register

| Bits          | Description                         | Attributes                                                  |
|---------------|-------------------------------------|-------------------------------------------------------------|
| 63:20         | RsvdZ (value should be set to zero) | Read / Write                                                |
| 19:16         | SINTx - synthetic interrupt source  | Read / Write                                                |
| 15:13         | RsvdZ (value should be set to zero) | Read / Write                                                |
| 12            | Direct Mode - Assert and interrupt upon timer expiration. | Read / Write                          |
| 11:4          | ApicVector - Controls the asserted interrupt vector in direct mode | Read / Write                 |
| 3             | AutoEnable - Set if writing the corresponding counter implicitly causes the timer to be enabled | Read / Write |
| 2             | Lazy - Set if timer is lazy          | Read / Write                                               |
| 1             | Periodic - Set if timer is periodic  | Read / Write                                               |
| 0             | Enabled - set if timer is enabled    | Read / Write                                               |

When a virtual processor is created and reset, the value of all synthetic timer configuration registers (HV_X64_MSR_STIMER0_CONFIG through HV_X64_MSR_STIMER3_CONFIG) are set to 0x0000000000000000. Thus, all synthetic timers are disabled by default.

If AutoEnable is set, then writing a non-zero value to the corresponding count register will cause Enable to be set and activate the counter. Otherwise, Enable should be set after writing the corresponding count register in order to activate the counter. For information about the Count register, see the following section.

When a one-shot timer expires, it is automatically marked as disabled. Periodic timers remain enabled until explicitly disabled.

If a one-shot is enabled and the specified count is in the past, it will expire immediately.

It is not permitted to set the SINTx field to zero for an enabled timer (that is not in direct mode). If attempted, the timer will be marked disabled (that is, bit 0 cleared) immediately.

Writing the configuration register of a timer that is already enabled may result in undefined behavior. For example, merely changing a timer from one-shot to periodic may not produce what is intended. Timers should always be disabled prior to changing any other properties.

##### Synthetic Timer Count Register

| Bits          | Description                                                             | Attributes              |
|---------------|-------------------------------------------------------------------------|-------------------------|
| 63:0          | Count—expiration time for one-shot timers, duration for periodic timers | Read / Write            |

The value programmed into the Count register is a time value measured in 100 nanosecond units. Writing the value zero to the Count register will stop the counter, thereby disabling the timer, independent of the setting of AutoEnable in the configuration register.

Note that the Count register is permitted to wrap. Wrapping will have no effect on the behavior of the timer, regardless of any timer property.

For one-shot timers, it represents the absolute timer expiration time. The timer expires when the reference counter for the partition is equal to or greater than the specified count value.

For periodic timers, the count represents the period of the timer. The first period begins when the synthetic timer is enabled.

### Synthetic Timer Expiration Message

Timer expiration messages are sent when a timer event fires. Refer to the [HV_TIMER_MESSAGE_PAYLOAD](datatypes/HV_TIMER_MESSAGE_PAYLOAD.md) for the definition of the message payload.

### Synthetic Time-Unhalted Timer Registers

Synthetic Time-Unhalted Timer registers are available on x64 platforms if a partition has the AccessSyntheticTimerRegs privilege. Availability is indicated by EDX bit 23 in the Hypervisor Feature Identification CPUID leaf 0x40000003. This feature is not available on ARM64 platforms.

Guest software may program the synthetic time-unhalted timer to generate a periodic interrupt after executing for a specified amount of time in 100ns units. When the interrupt fires, the SyntheticTimeUnhaltedTimerExpired field in the VP Assist Page will be set to TRUE. Guest software may reset this field to FALSE. Unlike architectural performance counters, the synthetic timer is never reset by the hypervisor and runs continuously between interrupts. If the Vector field is set to 2 (the x64 NMI vector), the timer delivers a Non-Maskable Interrupt; otherwise, it delivers a fixed interrupt using the specified vector.

Unlike regular synthetic timers that accumulate time when the guest has halted (ie: gone idle), the Synthetic Time-Unhalted Timer accumulates time only while the guest is not halted.

#### On x64 Platforms

On x64 platforms, the synthetic time-unhalted timer is accessed via MSRs using the RDMSR and WRMSR instructions.

| MSR address      | Register Name                          | Description                                             |
|------------------|----------------------------------------|---------------------------------------------------------|
| 0x40000114       | HV_X64_MSR_STIME_UNHALTED_TIMER_CONFIG | Synthetic Time-Unhalted Timer Configuration             |
| 0x40000115       | HV_X64_MSR_STIME_UNHALTED_TIMER_COUNT  | Synthetic Time-Unhalted Timer Count                     |

#### Register Layout

##### Synthetic Time-Unhalted Timer Configuration Register

| Bits          | Description                         | Attributes                                                  |
|---------------|-------------------------------------|-------------------------------------------------------------|
| 63:9          | RsvdZ (value should be set to zero) | Read / Write                                                |
| 8             | Enabled                             | Read / Write                                                |
| 7:0           | Vector                              | Read / Write                                                |

The Vector field must be either 2 (to deliver an NMI) or a value ≥ 16 (to deliver a fixed interrupt). Other values are invalid.

##### Synthetic Time-Unhalted Timer Count Register

| Bits          | Description                                                             | Attributes              |
|---------------|-------------------------------------------------------------------------|-------------------------|
| 63:0          | Periodic rate of interrupts in 100 ns units                             | Read / Write            |