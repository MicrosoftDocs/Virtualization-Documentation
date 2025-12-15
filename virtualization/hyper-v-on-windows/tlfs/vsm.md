---
title: Virtual Secure Mode
description: Virtual Secure Mode
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# Virtual Secure Mode

Virtual Secure Mode (VSM) is a set of hypervisor capabilities and enlightenments offered to host and guest partitions which enables the creation and management of new security boundaries within operating system software. VSM is the hypervisor facility on which Windows security features including Device Guard, Credential Guard, virtual TPMs and shielded VMs are based. These security features were introduced in Windows 10 and Windows Server 2016.

VSM enables operating system software in the root and guest partitions to create isolated regions of memory for storage and processing of system security assets. Access to these isolated regions is controlled and granted solely through the hypervisor, which is a highly privileged, highly trusted part of the system’s Trusted Compute Base (TCB). Because the hypervisor runs at a higher privilege level than operating system software and has exclusive control of key system hardware resources such as memory access permission controls in the CPU MMU and IOMMU early in system initialization, the hypervisor can protect these isolated regions from unauthorized access, even from operating system software (e.g., OS kernel and device drivers) with supervisor mode access (i.e. CPL0, or “Ring 0”).

With this architecture, even if normal system level software running in supervisor mode (e.g. kernel, drivers, etc.) is compromised by malicious software, the assets in isolated regions protected by the hypervisor can remain secured.

## Virtual Trust Level (VTL)

VSM achieves and maintains isolation through Virtual Trust Levels (VTLs). VTLs are enabled and managed on both a per-partition and per-virtual processor basis.

Virtual Trust Levels are hierarchical, with higher levels being more privileged than lower levels. VTL0 is the least privileged level, with VTL1 being more privileged than VTL0, VTL2 being more privileged than VTL1, etc.

Architecturally, up to 16 levels of VTLs are supported; however a hypervisor may choose to implement fewer than 16 VTL’s. Currently, only two VTLs are implemented.

 ```c
typedef UINT8 HV_VTL, *PHV_VTL;

#define HV_NUM_VTLS 2
#define HV_INVALID_VTL ((HV_VTL) -1)
#define HV_VTL_ALL 0xF
 ```

Each VTL has its own set of memory access protections. These access protections are managed by the hypervisor in a partition’s physical address space, and thus cannot be modified by system level software running in the partition.

Since more privileged VTLs can enforce their own memory protections, higher VTLs can effectively protect areas of memory from lower VTLs. In practice, this allows a lower VTL to protect isolated memory regions by securing them with a higher VTL. For example, VTL0 could store a secret in VTL1, at which point only VTL1 could access it. Even if VTL0 is compromised, the secret would be safe.

### VTL Protections

There are multiple facets to achieving isolation between VTLs:

- Memory Access Protections: Each VTL maintains a set of guest physical memory access protections. Software running at a particular VTL can only access memory in accordance with these protections.
- Virtual Processor State: Virtual processors maintain separate per-VTL state. For example, each VTL defines a set of a private VP registers. Software running at a lower VTL cannot access the higher VTL’s private virtual processor’s register state.
- Interrupts: Along with a separate processor state, each VTL also has its own interrupt subsystem (local APIC on x64, GIC CPU interface on ARM64). This allows higher VTLs to process interrupts without risking interference from a lower VTL.
- Overlay Pages: Certain overlay pages are maintained per-VTL such that higher VTLs have reliable access. E.g. there is a separate hypercall overlay page per VTL.

## VSM Detection and Status

The VSM capability is advertised to partitions via the AccessVsm partition privilege flag. Only partitions with all of the following privileges may utilize VSM: AccessVsm, AccessVpRegisters, and AccessSynicRegs.

### VSM Capability Detection

Guests can access a report on VSM capabilities through a synthetic register.

#### On x64 Platforms

On x64 platforms, this register is accessed via an MSR:

| MSR address      | Register Name                   | Description                                                    |
|------------------|---------------------------------|----------------------------------------------------------------|
| 0x000D0006       | HV_X64_REGISTER_VSM_CAPABILITIES| Report on VSM capabilities.                                    |

#### On ARM64 Platforms

On ARM64 platforms, this register is accessed via HvRegisterVsmCapabilities using the HvCallGetVpRegisters hypercall.

#### Register Format

#### On x64 Platforms

| Bits          | Description                         | Attributes                                                  |
|---------------|-------------------------------------|-------------------------------------------------------------|
| 63            | Dr6Shared                           | Read                                                        |
| 62:47         | MbecVtlMask                         | Read                                                        |
| 46            | DenyLowerVtlStartup                 | Read                                                        |
| 45:0          | RsvdZ                               | Read                                                        |

#### On ARM64 Platforms

| Bits          | Description                         | Attributes                                                  |
|---------------|-------------------------------------|-------------------------------------------------------------|
| 63            | RsvdZ                               | Read                                                        |
| 62:47         | MbecVtlMask                         | Read                                                        |
| 46            | DenyLowerVtlStartup                 | Read                                                        |
| 45:0          | RsvdZ                               | Read                                                        |

#### Field Descriptions

Dr6Shared (x64 only): Indicates to the guest whether Dr6 is a shared register between the VTLs.

MbecVtlMask: Indicates to the guest the VTLs for which MBEC can be enabled.

DenyLowerVtlStartup: Indicates to the guest whether a VTL can deny a VP reset by a lower VTL.

### VSM Status Register

In addition to a partition privilege flag, two virtual registers can be used to learn additional information about VSM status: `HvRegisterVsmPartitionStatus` and `HvRegisterVsmVpStatus`.

#### HvRegisterVsmPartitionStatus

HvRegisterVsmPartitionStatus is a per-partition read-only register that is shared across all VTLs. This register provides information about which VTLs have been enabled for the partition, which VTLs have Mode Based Execution Controls enabled, as well as the maximum VTL allowed.

```c
typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 EnabledVtlSet : 16;
        UINT64 MaximumVtl : 4;
        UINT64 MbecEnabledVtlSet: 16;
        UINT64 ReservedZ : 28;
    };
} HV_REGISTER_VSM_PARTITION_STATUS;
```

#### HvRegisterVsmVpStatus

HvRegisterVsmVpStatus is a read-only register and is shared across all VTLs. It is a per-VP register, meaning each virtual processor maintains its own instance. This register provides information about which VTLs have been enabled, which is active, as well as the MBEC mode active on a VP.

```c
typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 ActiveVtl : 4;
        UINT64 ActiveMbecEnabled : 1;
        UINT64 ReservedZ0 : 11;
        UINT64 EnabledVtlSet : 16;
        UINT64 ReservedZ1 : 32;
    };
} HV_REGISTER_VSM_VP_STATUS;
```

ActiveVtl is the ID of the VTL context that is currently active on the virtual processor.

ActiveMbecEnabled specifies that MBEC is currently active on the virtual processor.

EnabledVtlSet is a bitmap of the VTL’s that are enabled on the virtual processor.

### Partition VTL Initial state

When a partition starts or resets, it begins running in VTL0. All other VTLs are disabled at partition creation.

## VTL Enablement

To begin using a VTL, a lower VTL must initiate the following:

1. Enable the target VTL for the partition. This makes the VTL generally available for the partition.
2. Enable the target VTL on one or more virtual processors. This makes the VTL available for a VP, and sets its initial context. It is recommended that all VPs have the same enabled VTLs. Having a VTL enabled on some VPs (but not all) can lead to unexpected behavior.
3. Once the VTL is enabled for a partition and VP, it can begin setting access protections once the EnableVtlProtection flag has been set.

Note that VTLs need not be consecutive.

### Enabling a Target VTL for a Partition

The [HvCallEnablePartitionVtl](hypercalls/HvCallEnablePartitionVtl.md) hypercall is used to enable a VTL for a certain partition. Note that before software can actually execute in a particular VTL, that VTL must be enabled on virtual processors in the partition.

### Enabling a Target VTL for Virtual Processors

Once a VTL is enabled for a partition, it can be enabled on the partition’s virtual processors. The [HvCallEnableVpVtl](hypercalls/HvCallEnableVpVtl.md) hypercall can be used to enable VTLs for a virtual processor, which sets its initial context.

Virtual processors have one “context” per VTL. If a VTL is switched, the VTL's [private state](#private-state) is also switched.

## VTL Configuration

Once a VTL has been enabled, its configuration can be changed by a VP running at an equal or higher VTL.

### Partition Configuration

Partition-wide attributes can be configured using the HvRegisterVsmPartitionConfig register. There is one instance of this register for each VTL (greater than 0) on every partition.

Every VTL can modify its own instance of HV_REGISTER_VSM_PARTITION_CONFIG, as well as instances for lower VTLs. VTLs may not modify this register for higher VTLs.

```c
typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 EnableVtlProtection : 1;
        UINT64 DefaultVtlProtectionMask : 4;
        UINT64 ZeroMemoryOnReset : 1;
        UINT64 DenyLowerVtlStartup : 1;
        UINT64 ReservedZ : 2;
        UINT64 InterceptVpStartup : 1;
        UINT64 ReservedZ : 54; };
} HV_REGISTER_VSM_PARTITION_CONFIG;
```

The fields of this register are described below.

#### Enable VTL Protections

Once a VTL has been enabled, the EnableVtlProtection flag must be set before it can begin applying memory protections.
This flag is write-once, meaning that once it has been set, it cannot be modified.

#### Default Protection Mask

By default, the system applies RWX protections to all currently mapped pages, and any future “hot-added” pages. Hot-added pages refer to any memory that is added to a partition during a resize operation.

A higher VTL can set a different default memory protection policy by specifying DefaultVtlProtectionMask in HV_REGISTER_VSM_PARTITION_CONFIG. This mask must be set at the time the VTL is enabled. It cannot be changed once it is set, and is only cleared by a partition reset.

| Bit       | Description                                                                          |
|-----------|--------------------------------------------------------------------------------------|
| 0         | Read                                                                                 |
| 1         | Write                                                                                |
| 2         | Kernel Mode Execute (KMX)                                                            |
| 3         | User Mode Execute (UMX)                                                              |

#### Zero Memory on Reset

ZeroMemOnReset is a bit that controls if memory is zeroed before a partition is reset. This configuration is on by default. If the bit is set, the partition’s memory is zeroed upon reset so that a higher VTL’s memory cannot be compromised by a lower VTL.
If this bit is cleared, the partition’s memory is not zeroed on reset.

#### DenyLowerVtlStartup

The DenyLowerVtlStartup flag controls if a virtual processor may be started or reset by lower VTLs. This includes architectural ways of resetting a virtual processor (e.g. SIPI on X64) as well as the [HvCallStartVirtualProcessor](hypercalls/HvCallStartVirtualProcessor.md) hypercall.

#### InterceptVpStartup

If InterceptVpStartup flag is set, starting or resetting a virtual processor generates an intercept to the higher VTL.

### Configuring Lower VTLs

The following register can be used by higher VTLs to configure the behavior of lower VTLs:

```c
typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 MbecEnabled : 1;
        UINT64 TlbLocked : 1;
        UINT64 ReservedZ : 62;
    };
} HV_REGISTER_VSM_VP_SECURE_VTL_CONFIG;
```

Each VTL (higher than 0) has an instance of this register for every VTL lower than itself. For example, VTL2 would have two instances of this register – one for VTL1, and a second for VTL0.

The fields of this register are described below.

#### MbecEnabled

This field configures whether MBEC is enabled for the lower VTL.

#### TlbLocked

This field locks the lower VTL’s TLB. This capability can be used to prevent lower VTLs from causing TLB invalidations which might interfere with a higher VTL. When this bit is set, all address space flush requests from the lower VTL are blocked until the lock is lifted.

To unlock the TLB, the higher VTL can clear this bit. Also, once a VP returns to a lower VTL, it releases all TLB locks which it holds at the time.

## VTL Entry

A VTL is “entered” when a VP switches from a lower VTL to a higher one. This can happen for the following reasons:

1. VTL call: this is when software explicitly wishes to invoke code in a higher VTL.
2. Secure interrupt: if an interrupt is received for a higher VTL, the VP will enter the higher VTL.
3. Secure intercept: certain actions will trigger a secure interrupt (accessing certain MSRs for example).

Once a VTL is entered, it must voluntarily exit. A higher VTL cannot be preempted by a lower VTL.

### Identifying VTL Entry Reason

In order to react appropriately to an entry, a higher VTL might need to know the reason it was entered. To discern between entry reasons, the VTL entry is included in the [HV_VP_VTL_CONTROL](datatypes/HV_VP_VTL_CONTROL.md) structure.

### VTL Call

A "VTL call" is when a lower VTL initiates an entry into a higher VTL (for example, to protect a region of memory with the higher VTL) through the [HvCallVtlCall](hypercalls/HvCallVtlCall.md) hypercall.

VTL calls preserve the state of shared registers across VTL switches. Private registers are preserved on a per-VTL level. The exception to these restrictions are the registers/instructions required by the VTL call sequence.

#### On x64 Platforms

The following registers are required for a VTL call on x64:

| x64     | x86     | Description                                                 |
|---------|---------|-------------------------------------------------------------|
| RCX     | EDX:EAX | Specifies a VTL call control input to the hypervisor        |
| RAX     | ECX     | Reserved                                                    |

All bits in the VTL call control input are currently reserved.

#### On ARM64 Platforms

On ARM64 platforms, a VTL call is initiated using the HVC instruction with immediate value 2. The hypervisor decodes this specific immediate value and processes it as an HvCallVtlCall hypercall. No specific register state is required for the control input on ARM64.

#### VTL Call Restrictions

VTL calls can only be initiated from the most privileged processor mode. For example, on x64 systems a VTL call can only come from CPL0, and on ARM64 systems from EL1. A VTL call initiated from a processor mode which is anything but the most privileged on the system results in the hypervisor injecting an exception into the virtual processor (#UD on x64, undefined instruction exception on ARM64).

A VTL call can only switch into the next highest VTL. In other words, if there are multiple VTLs enabled, a call cannot "skip" a VTL.
The following actions result in an exception (#UD on x64, undefined instruction on ARM64):

- A VTL call initiated from a processor mode which is anything but the most privileged on the system (architecture specific).
- A VTL call from real mode (x86/x64 only)
- A VTL call on a virtual processor where the target VTL is disabled (or has not been already enabled).
- A VTL call with an invalid control input value

## VTL Exit

A switch to a lower VTL is known as a “return”. Once a VTL has finished processing, it can initiate a VTL return in order to switch to a lower VTL. The only way a VTL return can occur is if a higher VTL voluntarily initiates one. A lower VTL can never preempt a higher one.

### VTL Return

A "VTL return" is when a higher VTL initiates a switch into a lower VTL through the [HvCallVtlReturn](hypercalls/HvCallVtlReturn.md) hypercall. Similar to a VTL call, private processor state is switched out, and shared state remains in place. If the lower VTL has explicitly called into the higher VTL, the hypervisor increments the higher VTL's instruction pointer before the return is complete so that it may continue after a VTL call.

#### On x64 Platforms

A VTL Return code sequence on x64 requires the use of the following registers:

| x64     | x86     | Description                                                 |
|---------|---------|-------------------------------------------------------------|
| RCX     | EDX:EAX | Specifies a VTL return control input to the hypervisor      |
| RAX     | ECX     | Reserved                                                    |

#### On ARM64 Platforms

On ARM64 platforms, a VTL return is initiated using the HVC instruction with immediate value 3. The hypervisor decodes this specific immediate value and processes it as an HvCallVtlReturn hypercall.

#### VTL Return Control Input

The VTL return control input has the following format:

| Bits      | Field           | Description                                                                 |
|-----------|-----------------|-----------------------------------------------------------------------------|
| 63:1      | RsvdZ           |                                                                             |
| 0         | Fast return     | Registers are not restored                                                  |

The following actions will generate a #UD exception:

- Attempting a VTL return when the lowest VTL is currently active
- Attempting a VTL return with an invalid control input value
- Attempting a VTL return from a processor mode which is anything but the most privileged on the system (architecture specific)

#### Fast Return

As a part of processing a return, the hypervisor can restore the lower VTL’s register state from the [HV_VP_VTL_CONTROL](datatypes/HV_VP_VTL_CONTROL.md) structure. For example, after processing a secure interrupt, a higher VTL may wish to return without disrupting the lower VTL’s state. Therefore, the hypervisor provides a mechanism to simply restore the lower VTL’s registers to their pre-call value stored in the VTL control structure.

If this behavior is not necessary, a higher VTL can use a “fast return”. A fast return is when the hypervisor does not restore register state from the control structure. This should be utilized whenever possible to avoid unnecessary processing.

This field can be set with bit 0 of the VTL return input. If it is set to 0, the registers are restored from the HV_VP_VTL_CONTROL structure. If this bit is set to 1, the registers are not restored (a fast return).

## Hypercall Page Assist (x64 Only)

On x64 platforms, the hypervisor provides mechanisms to assist with VTL calls and returns via the [hypercall page](hypercall-interface.md#establishing-the-hypercall-interface-x86x64). This page abstracts the specific code sequence required to switch VTLs.

The code sequences to execute VTL calls and returns may be accessed by executing specific instructions in the hypercall page. The call/return chunks are located at an offset in the hypercall page determined by the HvRegisterVsmCodePageOffsets virtual register. This is a read-only and partition-wide register, with a separate instance per-VTL.

A VTL can execute a VTL call/return using the CALL instruction. A CALL to the correct location in the hypercall page will initiate a VTL call/return.

```c
typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 VtlCallOffset : 12;
        UINT64 VtlReturnOffset : 12;
        UINT64 ReservedZ : 40;
    };
} HV_REGISTER_VSM_CODE_PAGE_OFFSETS;
```

To summarize, the steps for calling a code sequence using the hypercall page on x64 are as follows:

1. Map the hypercall page into a VTL's GPA space
2. Determine the correct offset for the code sequence (VTL call or return).
3. Execute the code sequence using CALL.

> **Note:** On ARM64 platforms, VTL calls and returns are performed directly using the HVC instruction with specific immediate values (2 for VTL call, 3 for VTL return) as described in the VTL Call and VTL Return sections. The HvRegisterVsmCodePageOffsets register is not available on ARM64.

## Memory Access Protections

One necessary protection provided by VSM is the ability to isolate memory accesses.

Higher VTLs have a high degree of control over the type of memory access permissible by lower VTLs. There are three basic types of protections that can be specified by a higher VTL for a particular GPA page: Read, Write, and eXecute. These are defined in the following table:

| Name                       | Description                                                         |
|----------------------------|---------------------------------------------------------------------|
| Read                       | Controls whether read access is allowed to a memory page            |
| Write                      | Controls whether write access allowed to a memory page              |
| Execute                    | Controls whether instruction fetches are allowed for a memory page. |

These three combine for the following types of memory protection:

1. No access
2. Read-only, no execute
3. Read-only, execute
4. Read/write, no execute
5. Read/write, execute

If “mode based execution control (MBEC)” is enabled, user and kernel mode execute protections can be set separately.

Higher VTLs can set the memory protection for a GPA through the [HvCallModifyVtlProtectionMask](hypercalls/HvCallModifyVtlProtectionMask.md) hypercall.

### Memory Protection Hierarchy

Memory access permissions can be set by a number of sources for a particular VTL. Each VTL’s permissions can potentially be restricted by a number of other VTLs, as well as by the host partition. The order in which protections are applied is the following:

1. Memory protections set by the host
2. Memory protections set by higher VTLs

In other words, VTL protections supersede host protections. Higher-level VTLs supersede lower-level VTLs. Note that a VTL may not set memory access permissions for itself.

A conformant interface is expected to not overlay any non-RAM type over RAM.

### Memory Access Violations

If a VP running at a lower VTL attempts to violate a memory protection set by a higher VTL, an intercept is generated. This intercept is received by the higher VTL which set the protection. This allows higher VTLs to deal with the violation on a case-by-case basis. For example, the higher VTL may choose to return a fault, or emulate the access.

### Mode Based Execute Control (MBEC)

When a VTL places a memory restriction on a lower VTL, it may wish to make a distinction between user and kernel mode when granting an “execute” privilege. For example, if code integrity checks were to take place in a higher VTL, the ability to distinguish between user-mode and kernel-mode would mean that a VTL could enforce code integrity for only kernel-mode applications.

Apart from the traditional three memory protections (read, write, execute), MBEC introduces a distinction between user-mode and kernel-mode for execute protections. Thus, if MBEC is enabled, a VTL has the opportunity to set four types of memory protections:

| Name                       | Description                                                         |
|----------------------------|---------------------------------------------------------------------|
| Read                       | Controls whether read access is allowed to a memory page            |
| Write                      | Controls whether write access allowed to a memory page              |
| User Mode Execute (UMX)    | Controls whether instruction fetches generated in user-mode are allowed for a memory page. NOTE: If MBEC is disabled, this setting is ignored. |
| Kernel Mode Execute (KMX)  | Controls whether instruction fetches generated in kernel-mode are allowed for a memory page. NOTE: If MBEC is disabled, this setting controls both user-mode and kernel-mode execute accesses. |

Memory marked with the “User-Mode Execute” protections would only be executable when the virtual processor is running in user-mode. Likewise, “Kernel-Mode Execute” memory would only be executable when the virtual processor is running in kernel-mode.

KMX and UMX can be independently set such that execute permissions are enforced differently between user and kernel mode. All combinations of UMX and KMX are supported, except for KMX=1, UMX=0. The behavior of this combination is undefined.

MBEC is disabled by default for all VTLs and virtual processors. When MBEC is disabled, the kernel-mode execute bit determines memory access restriction. Thus, if MBEC is disabled, KMX=1 code is executable in both kernel and user-mode.

#### Descriptor Tables (x64 Only)

On x64 platforms, any user-mode code that accesses descriptor tables must be in GPA pages marked as KMX=UMX=1. User-mode software accessing descriptor tables from a GPA page marked KMX=0 is unsupported and results in a general protection fault.

ARM64 does not use x86-style descriptor tables; memory access permissions are controlled through translation table entries and the EL-based privilege model.

#### MBEC configuration

To make use of Mode-based execution control, it must be enabled at two levels:

1. When the VTL is enabled for a partition, MBEC must be enabled using HvCallEnablePartitionVtl
2. MBEC must be configured on a per-VP and per-VTL basis, using HvRegisterVsmVpSecureConfigVtlX.

#### MBEC Interaction with Supervisor Mode Execution Prevention (SMEP) (x64 Only)

Supervisor-Mode Execution Prevention (SMEP) is a processor feature supported on x64 platforms. SMEP can impact the operation of MBEC due to its restriction of supervisor access to memory pages. The hypervisor adheres to the following policies related to SMEP:

- If SMEP is not available to the guest OS (whether it be because of hardware capabilities or processor compatibility mode), MBEC operates unaffected.
- If SMEP is available, and is enabled, MBEC operates unaffected.
- If SMEP is available, and is disabled, all execute restrictions are governed by the KMX control. Thus, only code marked KMX=1 will be allowed to execute.

## Virtual Processor State Isolation

Virtual processors maintain separate states for each active VTL. However, some of this state is private to a particular VTL, and the remaining state is shared among all VTLs.

The hypervisor maintains a per-VTL context for each virtual processor, storing all guest-visible processor state that must be isolated between VTLs. Each VTL has its own instance of private state including control registers, exception vectors, system configuration registers, and synthetic hypervisor registers. This per-VTL storage ensures complete isolation of execution context when switching between trust levels.

State which is preserved per VTL (a.k.a. private state) is saved by the hypervisor across VTL transitions. If a VTL switch is initiated, the hypervisor saves the current private state for the active VTL, and then switches to the private state of the target VTL. Shared state remains active regardless of VTL switches.

### Private State

Each VTL maintains its own complete execution context consisting of:

- **Execution State**: Instruction pointer (PC/RIP), stack pointer (SP/RSP), processor flags (PSTATE/RFLAGS)
- **Control Registers**: Memory management configuration (page tables, translation controls, memory attributes)
- **Exception Handling**: Exception/interrupt vectors, exception syndrome registers, fault address registers
- **System Configuration**: Processor feature controls, debug controls, timer configuration
- **Synthetic Registers**: Hypervisor interface registers specific to each VTL (hypercall page, guest OS ID, reference TSC, synthetic interrupt controller)

This isolation ensures that each VTL has independent control over its execution environment and cannot observe or interfere with the private state of other VTLs.

#### On x64 Platforms

On x64 platforms, each VTL maintains its own execution context through architecture-specific MSRs and registers. The hypervisor preserves these across VTL switches, ensuring complete isolation of the execution environment.

**Private MSRs** control system call mechanisms, memory attributes, processor features, and the hypervisor interface.

**Architectural MSRs:**

- SYSENTER_CS, SYSENTER_ESP, SYSENTER_EIP, STAR, LSTAR, CSTAR, SFMASK, EFER, PAT, KERNEL_GSBASE, FS.BASE, GS.BASE, TSC_AUX
- Local APIC registers (including CR8/TPR)

**Synthetic MSRs:**

- HV_X64_MSR_HYPERCALL
- HV_X64_MSR_GUEST_OS_ID
- HV_X64_MSR_REFERENCE_TSC
- HV_X64_MSR_APIC_FREQUENCY
- HV_X64_MSR_EOI
- HV_X64_MSR_ICR
- HV_X64_MSR_TPR
- HV_X64_MSR_VP_ASSIST_PAGE
- HV_X64_MSR_NPIEP_CONFIG
- HV_X64_MSR_SIRBP
- HV_X64_MSR_SCONTROL
- HV_X64_MSR_SVERSION
- HV_X64_MSR_SIEFP
- HV_X64_MSR_SIMP
- HV_X64_MSR_EOM
- HV_X64_MSR_SINT0 – HV_X64_MSR_SINT15
- HV_X64_MSR_STIMER0_CONFIG – HV_X64_MSR_STIMER3_CONFIG
- HV_X64_MSR_STIMER0_COUNT – HV_X64_MSR_STIMER3_COUNT

**Private registers** control the execution environment, memory management, and exception handling:

- **Execution State**: RIP (instruction pointer), RSP (stack pointer), RFLAGS (processor flags)
- **Memory Management**: CR0 (processor control), CR3 (page table base), CR4 (processor features)
- **Descriptor Tables**: IDTR (interrupt descriptor table), GDTR (global descriptor table)
- **Segment Registers**: CS, DS, ES, FS, GS, SS, TR, LDTR
- **Debug Control**: DR7 (debug control register)
- **Time Stamp**: TSC (time stamp counter, providing independent time reference per VTL)
- **Debug Status**: DR6 (debug status register - dependent on processor type; read HvRegisterVsmCapabilities to determine if shared or private)

#### On ARM64 Platforms

On ARM64 platforms, each VTL maintains its own complete system register context. The hypervisor preserves these registers across VTL switches, ensuring complete isolation of the execution and exception environment.

**Execution State** registers control program flow and processor mode:

- PC (program counter), SP_EL0, SP_EL1 (stack pointers)
- PSTATE (processor state flags), FPCR/FPSR (floating-point control/status)
- ELR_EL1, SPSR_EL1 (exception link register, saved program status)

**Memory Management and Translation Control** registers configure virtual memory:

- TTBR0_EL1, TTBR1_EL1 (translation table base registers)
- TCR_EL1 (translation control register)
- MAIR_EL1 (memory attribute indirection register)
- SCTLR_EL1 (system control register)
- CONTEXTIDR_EL1 (context identifier)

**Exception and Interrupt Handling** registers control exception behavior:

- VBAR_EL1 (vector base address register - exception vector table location)
- ESR_EL1 (exception syndrome register)
- FAR_EL1 (fault address register)
- AFSR0_EL1, AFSR1_EL1 (auxiliary fault status registers)

**System Configuration** registers control processor features:

- CPACR_EL1 (coprocessor access control)
- ACTLR_EL1 (auxiliary control register)
- AMAIR_EL1 (auxiliary memory attribute indirection register)
- ZCR_EL1, SMCR_EL1 (SVE/SME configuration if supported)

**Debug and Performance Monitoring** registers are VTL-private. This includes all debug system registers (MDSCR_EL1, DBGBCR_EL1[], DBGBVR_EL1[], DBGWCR_EL1[], DBGWVR_EL1[], etc.) and all performance monitor registers (PMCR_EL0 and related PMU registers)

**Timer Configuration** registers:

- CNTKCTL_EL1 (kernel timer control)
- CNTV_CTL_EL0, CNTV_CVAL_EL0 (virtual timer control and compare value)

**Thread Identification** registers:

- TPIDR_EL0, TPIDR_EL1, TPIDRRO_EL0 (thread ID registers)

**Synthetic Hypervisor Registers** (accessed via hypercalls, not directly as system registers):

- HvRegisterGuestOsId (guest OS identification)
- HvRegisterHypercallMsrValue (hypercall interface enablement)
- HvRegisterReferenceTsc (reference time stamp counter page)
- HvRegisterVpAssistPage (VP assist page for this VTL)
- Synthetic interrupt controller registers (SynIC)
- Synthetic timer registers (Stimer0-3)
- Local interrupt controller interface (GIC CPU interface)

This comprehensive per-VTL register isolation ensures that each VTL has complete control over its execution environment, memory management, exception handling, and hypervisor interface without interference from other VTLs.

### Shared State

VTLs share certain processor state to reduce the overhead of VTL transitions and enable efficient communication between trust levels. Shared state includes general-purpose registers used for computation and data passing, floating-point state, and certain system status registers that do not affect security boundaries.

By sharing general-purpose registers across VTLs, a VTL call can pass parameters directly in registers, and a VTL return can pass results back without requiring memory-based communication. This design significantly improves the performance of cross-VTL calls while maintaining the security isolation provided by private state.

#### On x64 Platforms

On x64 platforms, shared state includes general-purpose registers for computation, system information registers, and certain status registers that do not impact security isolation.

**Shared MSRs** provide system information and configuration that is common across VTLs:

- HV_X64_MSR_TSC_FREQUENCY
- HV_X64_MSR_VP_INDEX
- HV_X64_MSR_VP_RUNTIME
- HV_X64_MSR_RESET
- HV_X64_MSR_TIME_REF_COUNT
- HV_X64_MSR_GUEST_IDLE
- HV_X64_MSR_DEBUG_DEVICE_OPTIONS
- MTRRs
- MCG_CAP
- MCG_STATUS

**Shared registers** enable efficient data passing and computation across VTLs:

- **General-Purpose Registers**: Rax, Rbx, Rcx, Rdx, Rsi, Rdi, Rbp, R8-R15 (used for computation and parameter passing during VTL calls)
- **Exception Information**: CR2 (page fault linear address - shared for exception handling context)
- **Debug Data**: DR0-DR3 (debug address registers - used for breakpoint addresses)
- **Floating-Point and Vector State**: 
  - X87 floating point state (legacy floating-point computation)
  - XMM state (128-bit SSE vectors)
  - AVX state (256-bit vectors)
  - XCR0/XFEM (extended feature enable mask)
- **Debug Status**: DR6 (debug status register - dependent on processor type; read HvRegisterVsmCapabilities to determine if shared or private)

#### On ARM64 Platforms

On ARM64 platforms, shared state includes registers used for computation, data passing, and floating-point operations. This sharing enables efficient VTL calls by allowing parameters and results to be passed directly in registers.

**Shared registers** enable computation and communication across VTLs:

- **General-Purpose Registers**: X0-X17, X19-X28 (used for computation and parameter passing)
  - X0-X7 typically used for function parameters and return values during VTL calls
  - X8-X17, X19-X28 available for general computation
  - Note: X18 (platform register) and PC are private per-VTL for security reasons
  - Note: X29 (FP/frame pointer), X30 (LR/link register), and SP are private per-VTL
- **Floating-Point and Vector State**:
  - Q0-Q31 (128-bit NEON/floating-point registers for vector computation)
  - Advanced SIMD (NEON) state for vector operations
  - Note: SVE state (Z0-Z31, P0-P15, FFR) and SME state are VTL-private. The lower 128-bit portion (Q registers) is shared, but the upper bits of Z registers may be corrupted on VTL transitions. Software should not rely on Z register contents being preserved across VTL switches.
  - Note: SPE (Statistical Profiling Extension) state is shared across VTLs, except for PMBSR_EL1 which is VTL-private
- **System Information Registers** (read-only or non-security-critical):
  - System identification and feature registers
  - Cache and TLB type information

ARM64 follows the same principle as x64: general computation state is shared for efficiency, while control and configuration state that affects security boundaries remains private to each VTL.

### Real Mode (x64 Only)

Real mode is not supported for any VTL greater than 0 on x64 platforms. VTLs greater than 0 can run in 32-bit or 64-bit mode on x64.

## VTL Interrupt Management

In order to achieve a high level of isolation between Virtual Trust Levels, Virtual Secure Mode provides a separate interrupt subsystem for each VTL enabled on a virtual processor. This ensures that a VTL is able to both send and receive interrupts without interference from a less secure VTL.

Each VTL has its own interrupt controller, which is only active if the virtual processor is running in that particular VTL. If a virtual processor switches VTL states, the interrupt controller active on the processor is also switched.

On x64 platforms, each VTL has a separate local APIC instance. On ARM64 platforms, each VTL has a separate GIC.

An interrupt targeted at a VTL which is higher than the active VTL will cause an immediate VTL switch. The higher VTL can then receive the interrupt. If the higher VTL is unable to receive the interrupt because of its priority mask (TPR/CR8 on x64, GIC priority mask on ARM64), the interrupt is held as "pending" and the VTL does not switch. If there are multiple VTLs with pending interrupts, the highest VTL takes precedence (without notice to the lower VTL).

When an interrupt is targeted at a lower VTL, the interrupt is not delivered until the next time the virtual processor transitions into the targeted VTL.

On x64 platforms, INIT and startup IPIs targeted at a lower VTL are dropped on a virtual processor with a higher VTL enabled. Since architectural processor startup mechanisms may be blocked, the [HvCallStartVirtualProcessor](hypercalls/HvCallStartVirtualProcessor.md) hypercall should be used to start processors.

On ARM64 platforms, PSCI interface methods (such as CPU_ON) for bringing processors online are similarly blocked when a higher VTL is enabled. The [HvCallStartVirtualProcessor](hypercalls/HvCallStartVirtualProcessor.md) hypercall provides a consistent cross-platform mechanism to start processors.

### Interrupt Masking and VTL Switches

#### On x64 Platforms

For the purposes of switching VTLs, RFLAGS.IF does not affect whether a secure interrupt triggers a VTL switch. If RFLAGS.IF is cleared to mask interrupts, interrupts into higher VTLs will still cause a VTL switch to a higher VTL. Only the higher VTL's TPR/CR8 value is taken into account when deciding whether to immediately interrupt.

This behavior also affects pending interrupts upon a VTL return. If the RFLAGS.IF bit is cleared to mask interrupts in a given VTL, and the VTL returns (to a lower VTL), the hypervisor will reevaluate any pending interrupts. This will cause an immediate call back to the higher VTL.

#### On ARM64 Platforms

Similarly, the PSTATE interrupt mask bits (DAIF) do not affect whether a secure interrupt triggers a VTL switch. If interrupts are masked via PSTATE, interrupts targeted at higher VTLs will still cause a VTL switch. Only the higher VTL's GIC priority mask is taken into account when deciding whether to immediately deliver the interrupt.

### Virtual Interrupt Notification Assist

Higher VTLs may register to receive a notification if they are blocking immediate delivery of an interrupt to a lower VTL of the same virtual processor. Higher VTLs can enable Virtual Interrupt Notification Assist (VINA) via a virtual register HvRegisterVsmVina:

```c
typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 Vector : 8;
        UINT64 Enabled : 1;
        UINT64 AutoReset : 1;
        UINT64 AutoEoi : 1;
        UINT64 ReservedP : 53;
    };
} HV_REGISTER_VSM_VINA;
```

Each VTL on each VP has its own VINA instance, as well as its own version of HvRegisterVsmVina. The VINA facility will generate an edge triggered interrupt to the currently active higher VTL when an interrupt for the lower VTL is ready for immediate delivery.

In order to prevent a flood of interrupts occurring when this facility is enabled, the VINA facility includes some limited state. When a VINA interrupt is generated, the VINA facility’s state is changed to “Asserted.” Sending an end-of-interrupt to the SINT associated with the VINA facility will not clear the “Asserted” state. The asserted state can only be cleared in one of two ways:

1. The state can manually be cleared by writing to the VinaAsserted field of the [HV_VP_VTL_CONTROL](datatypes/HV_VP_VTL_CONTROL.md) structure.
2. The state is automatically cleared on the next entry to the VTL if the “auto-reset on VTL entry” option is enabled in the HvRegisterVsmVina register.

This allows code running at a secure VTL to just be notified of the first interrupt that is received for a lower VTL. If a secure VTL wishes to be notified of additional interrupts, it can clear the VinaAsserted field of the VP assist page, and it will be notified of the next new interrupt.

## Secure Intercepts

The hypervisor allows a higher VTL to install intercepts for events that take place in the context of a lower VTL. This gives higher VTLs an elevated level of control over lower-VTL resources. Secure intercepts can be used to protect system-critical resources, and prevent attacks from lower-VTLs.

A secure intercept is queued to the higher VTL, and that VTL is made runnable on the VP.

### Secure Intercept Types

| Intercept Type             | Intercept Applies To                                                |
|----------------------------|---------------------------------------------------------------------|
| Memory access              | Attempting to access GPA protections established by a higher VTL.   |
| Control register access    | Attempting to access a set of control registers specified by a higher VTL. |

### Nested Intercepts

Multiple VTLs can install secure intercepts for the same event in a lower VTL. Thus, a hierarchy is established to decide where nested intercepts are notified. The following list is the order of where intercept are notified:

1. Lower VTL
2. Higher VTL

### Handling Secure Intercepts

Once a VTL has been notified of a secure intercept, it must take action such that the lower VTL can continue.
The higher VTL can handle the intercept in a number of ways, including: injecting an exception, emulating the access, or providing a proxy to the access. In any case, if the private state of the lower VTL VP needs to be modified, [HvCallSetVpRegisters](hypercalls/HvCallSetVpRegisters.md) should be used.

### Secure Register Intercepts (x64 Only)

On x64 platforms, a higher VTL can intercept on accesses to certain control registers and MSRs. This is achieved by setting HvX64RegisterCrInterceptControl using the [HvCallSetVpRegisters](hypercalls/HvCallSetVpRegisters.md) hypercall. Setting the control bit in HvX64RegisterCrInterceptControl will trigger an intercept for every access of the corresponding control register.

This feature is specific to x64 as it intercepts x64 control registers (CR0, CR4, XCR0) and x64 MSRs (EFER, LSTAR, STAR, etc.). ARM64 platforms may support similar interception capabilities through different mechanisms.

```c
typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 Cr0Write : 1;
        UINT64 Cr4Write : 1;
        UINT64 XCr0Write : 1;
        UINT64 IA32MiscEnableRead : 1;
        UINT64 IA32MiscEnableWrite : 1;
        UINT64 MsrLstarRead : 1;
        UINT64 MsrLstarWrite : 1;
        UINT64 MsrStarRead : 1;
        UINT64 MsrStarWrite : 1;
        UINT64 MsrCstarRead : 1;
        UINT64 MsrCstarWrite : 1;
        UINT64 ApicBaseMsrRead : 1;
        UINT64 ApicBaseMsrWrite : 1;
        UINT64 MsrEferRead : 1;
        UINT64 MsrEferWrite : 1;
        UINT64 GdtrWrite : 1;
        UINT64 IdtrWrite : 1;
        UINT64 LdtrWrite : 1;
        UINT64 TrWrite : 1;
        UINT64 MsrSysenterCsWrite : 1;
        UINT64 MsrSysenterEipWrite : 1;
        UINT64 MsrSysenterEspWrite : 1;
        UINT64 MsrSfmaskWrite : 1;
        UINT64 MsrTscAuxWrite : 1;
        UINT64 MsrSgxLaunchControlWrite : 1;
        UINT64 RsvdZ : 39;
    };
} HV_REGISTER_CR_INTERCEPT_CONTROL;
```

#### Mask Registers

To allow for finer control, a subset of control registers also have corresponding mask registers. Mask registers can be used to install intercepts on a subset of the corresponding control registers. Where a mask register is not defined, any access (as defined by HvX64RegisterCrInterceptControl) will trigger an intercept.

The hypervisor supports the following mask registers: HvX64RegisterCrInterceptCr0Mask, HvX64RegisterCrInterceptCr4Mask and HvX64RegisterCrInterceptIa32MiscEnableMask.

## DMA and Devices

Devices effectively have the same privilege level as VTL0. When VSM is enabled, all device-allocated memory is marked as VTL0. Any DMA accesses have the same privileges as VTL0.
