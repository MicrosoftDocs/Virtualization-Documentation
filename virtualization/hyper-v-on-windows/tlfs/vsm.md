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
- Interrupts: Along with a separate processor state, each VTL also has its own interrupt subsystem (local APIC). This allows higher VTLs to process interrupts without risking interference from a lower VTL.
- Overlay Pages: Certain overlay pages are maintained per-VTL such that higher VTLs have reliable access. E.g. there is a separate hypercall overlay page per VTL.

## VSM Detection and Status

The VSM capability is advertised to partitions via the AccessVsm partition privilege flag. Only partitions with all of the following privileges may utilize VSM: AccessVsm, AccessVpRegisters, and AccessSynicRegs.

### VSM Capability Detection

Guests should use the following model-specific register to access a report on VSM capabilities:

| MSR address      | Register Name                   | Description                                                    |
|------------------|---------------------------------|----------------------------------------------------------------|
| 0x000D0006       | HV_X64_REGISTER_VSM_CAPABILITIES| Report on VSM capabilities.                                    |

The format of the Register VSM Capabilities MSR is as follows:

| Bits          | Description                         | Attributes                                                  |
|---------------|-------------------------------------|-------------------------------------------------------------|
| 63            | Dr6Shared                           | Read                                                        |
| 62:47         | MbecVtlMask                         | Read                                                        |
| 46            | DenyLowerVtlStartup                 | Read                                                        |
| 45:0          | RsvdZ                               | Read                                                        |

Dr6Shared indicates to the guest whether Dr6 is a shared register between the VTLs.

MvecVtlMask indicates to the guest the VTLs for which Mbec can be enabled.

DenyLowerVtlStartup indicates to the guest whether a Vtl can deny a VP reset by a lower VTL.

### VSM Status Register

In addition to a partition privilege flag, two virtual registers can be used to learn additional information about VSM status: `HvRegisterVsmPartitionStatus` and `HvRegisterVsmVpStatus`.

#### HvRegisterVsmPartitionStatus

HvRegisterVsmPartitionStatus is a per-partition read-only register that is shared across all VTLs. This register provides information about which VTLs have been enabled for the partition, which VTLs have Mode Based Execution Controls enabled, as well as the maximum VTL allowed.

```c
typedef union
{
    UINT64 AsUINT64;
    struct {
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
Virtual processors have one “context” per VTL. If a VTL is switched, the virtual processor context is also switched. See 15.11 for details on what state is switched.

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

By default, the system applies RWX protections to all currently mapped pages, and any future “hot-added” pages. Hot-added pages refer to any memory that is added to a partition during a resize operation. See section 15.9 for a description of memory access protections.

A higher VTL can set a different default memory protection policy by specifying DefaultVtlProtectionMask in HV_REGISTER_VSM_PARTITION_CONFIG. This mask must be set at the time the VTL is enabled. It cannot be changed once it is set, and is only cleared by a partition reset.

| Bit       | Description                                                                          |
|-----------|--------------------------------------------------------------------------------------|
| 0         | Read                                                                                 |
| 1         | Write                                                                                |
| 2         | User Mode Execute (UMX)                                                              |
| 3         | Kernel Mode Execute (KMX)                                                            |

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
2. Secure interrupt: if an interrupt is received for a higher VTL, the VP will enter the higher VTL. See 15.12.
3. Secure intercept: certain actions will trigger a secure interrupt (accessing certain MSRs for example). See 15.13.

Once a VTL is entered, it must voluntarily exit. A higher VTL cannot be preempted by a lower VTL.

### Identifying VTL Entry Reason

In order to react appropriately to an entry, a higher VTL might need to know the reason it was entered. To discern between entry reasons, the VTL entry is included in the [HV_VP_VTL_CONTROL](datatypes/HV_VP_VTL_CONTROL.md) structure.

### VTL Call

A “VTL call” is when a lower VTL initiates an entry into a higher VTL (for example, to protect a region of memory with the higher VTL) through the [HvCallVtlCall](hypercalls/HvCallVtlCall.md) hypercall.

VTL calls preserve the state of shared registers across VTL switches. Private registers are preserved on a per-VTL level. (See 15.11.1 and 15.11.2 for which state is shared/private). The exception to these restrictions are the registers required by the VTL call sequence. The following registers are required for a VTL call:

| x64     | x86     | Description                                                 |
|---------|---------|-------------------------------------------------------------|
| RCX     | EDX:EAX | Specifies a VTL call control input to the hypervisor        |
| RAX     | ECX     | Reserved                                                    |

All bits in the VTL call control input are currently reserved.

#### VTL Call Restrictions

VTL calls can only be initiated from the most privileged processor mode. For example, on x64 systems a VTL call can only come from CPL0. A VTL call initiated from a processor mode which is anything but the most privileged on the system results in the hypervisor injecting a #UD exception into the virtual processor.

A VTL call can only switch into the next highest VTL. In other words, if there are multiple VTLs enabled, a call cannot “skip” a VTL.
The following actions result in a #UD exception:

- A VTL call initiated from a processor mode which is anything but the most privileged on the system (architecture specific).
- A VTL call from real mode (x86/x64)
- A VTL call on a virtual processor where the target VTL is disabled (or has not been already enabled).
- A VTL call with an invalid control input value

## VTL Exit

A switch to a lower VTL is known as a “return”. Once a VTL has finished processing, it can initiate a VTL return in order to switch to a lower VTL. The only way a VTL return can occur is if a higher VTL voluntarily initiates one. A lower VTL can never preempt a higher one.

### VTL Return

A “VTL return” is when a higher VTL initiates a switch into a lower VTL through the [HvCallVtlReturn](hypercalls/HvCallVtlReturn.md) hypercall. Similar to a VTL call, private processor state is switched out, and shared state remains in place (See 15.11.1 and 15.11.2 for which state is shared/private). If the lower VTL has explicitly called into the higher VTL, the hypervisor increments the higher VTL’s instruction pointer before the return is complete so that it may continue after a VTL call.

A VTL Return code sequence requires the use of the following registers:

| x64     | x86     | Description                                                 |
|---------|---------|-------------------------------------------------------------|
| RCX     | EDX:EAX | Specifies a VTL return control input to the hypervisor      |
| RAX     | ECX     | Reserved                                                    |

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

## Hypercall Page Assist

The hypervisor provides mechanisms to assist with VTL calls and returns via the [hypercall page](hypercall-interface.md/#Establishing-the-Hypercall-Interface). This page abstracts the specific code sequence required to switch VTLs.

The code sequences to execute VTL calls and returns may be accessed by executing specific instructions in the hypercall page. The call/return chunks are located at an offset in the hypercall page determined by the HvRegisterVsmCodePageOffset virtual register. This is a read-only and partition-wide register, with a separate instance per-VTL.

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

To summarize, the steps for calling a code sequence using the hypercall page are as follows:

1. Map the hypercall page into a VTL’s GPA space
2. Determine the correct offset for the code sequence (VTL call or return).
3. Execute the code sequence using CALL.