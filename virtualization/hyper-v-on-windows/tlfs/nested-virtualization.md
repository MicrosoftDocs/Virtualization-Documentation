---
title: Nested Virtualization
description: Nested Virtualization
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# Nested Virtualization

Nested virtualization refers to the Hyper-V hypervisor emulating hardware virtualization extensions. These emulated extensions can be used by other virtualization software (e.g. a nested hypervisor) to run on the Hyper-V platform.

This capability is only available to guest partitions. It must be enabled per virtual machine. Nested virtualization is not supported in a Windows root partition.

The following terminology is used to define various levels of nested virtualization:

| Term                   | Definition                                                              |
|------------------------|-------------------------------------------------------------------------|
| **L0 Hypervisor**      | The Hyper-V hypervisor running on physical hardware.                    |
| **L1 Root**            | The Windows root operating system.                                      |
| **L1 Guest**           | A Hyper-V virtual machine without a nested hypervisor.                  |
| **L1 Hypervisor**      | A nested hypervisor running within a Hyper-V virtual machine.           |
| **L2 Root**            | A root Windows operating system, running within the context of a Hyper-V virtual machine.|
| **L2 Guest**           | A nested virtual machine, running within the context of a Hyper-V virtual machine. |

Compared to bare-metal, hypervisors can incur a significant performance regression when running in a VM. L1 hypervisors can be optimized to run in a Hyper-V VM by using enlightened interfaces provided by the L0 hypervisor.

## Enlightened VMCS (Intel)

On Intel platforms, virtualization software uses virtual machine control data structures (VMCSs) to configure processor behavior related to virtualization. VMCSs must be made active using a VMPTRLD instruction and modified using VMREAD and VMWRITE instructions. These instructions are often a significant bottleneck for nested virtualization because they must be emulated.

The hypervisor exposes an “enlightened VMCS” feature which can be used to control virtualization-related processor behavior using a data structure in guest physical memory. This data structure can be modified using normal memory access instructions, thus there is no need for the L1 hypervisor to execute VMREAD or VMWRITE or VMPTRLD instructions.

The L1 hypervisor may choose to use enlightened VMCSs by writing 1 to the corresponding field in the [Virtual Processor Assist Page](vp-properties.md#virtual-processor-assist-page). Another field in the VP assist page controls the currently active enlightened VMCS. Each enlightened VMCS is exactly one page (4 KB) in size and must be initially zeroed. No VMPTRLD instruction must be executed to make an enlightened VMCS active or current.

After the L1 hypervisor performs a VM entry with an enlightened VMCS, the VMCS is considered active on the processor. An enlightened VMCS can only be active on a single processor at the same time. The L1 hypervisor can execute a VMCLEAR instruction to transition an enlightened VMCS from the active to the non-active state. Any VMREAD or VMWRITE instructions while an enlightened VMCS is active is unsupported and can result in unexpected behavior.

The [HV_VMX_ENLIGHTENED_VMCS](datatypes/HV_VMX_ENLIGHTENED_VMCS.md) structure defines the layout of the enlightened VMCS. All non-synthetic fields map to an Intel physical VMCS encoding.

### Clean Fields

The L0 hypervisor may choose to cache parts of the enlightened VMCS. The enlightened VMCS clean fields control which parts of the enlightened VMCS are reloaded from guest memory on a nested VM entry. The L1 hypervisor must clear the corresponding VMCS clean fields every time it modifies the enlightened VMCS, otherwise the L0 hypervisor might use a stale version.

The clean fields enlightenment is controlled via the synthetic “CleanFields” field of the enlightened VMCS. By default, all bits are set such that the L0 hypervisor must reload the corresponding VMCS fields for each nested VM entry.

### Feature Discovery

Support for an enlightened VMCS interface is reported with [CPUID leaf 0x40000004](feature-discovery.md#microsoft-hypervisor-cpuid-leaves).

The enlightened VMCS structure is versioned to account for future changes. Each enlightened VMCS structure contains a version field, which is reported by the L0 hypervisor.

The only VMCS version currently supported is 1.

### Hypervisor Implementation Considerations

For most VMCS fields, the corresponding enlightened VMCS field is supported for a VM if the VMCS field is supported for the VM, as determined through architectural feature discovery mechanisms. Exceptions are reported in [CPUID leaf 0x4000000A](feature-discovery.md#microsoft-hypervisor-cpuid-leaves).

In cases where architectural feature discovery mechanisms indicate support for a VMCS field for which no enlightened VMCS field is defined, the L1 hypervisor should not enable the feature if it chooses to use enlightened VMCS.

The Hyper-V L0 hypervisor will not indicate support for a VMCS field for which no enlightened VMCS field or exception is defined. If another L0 hypervisor needs a new enlightened VMCS field or exception to be defined, please contact Microsoft.

## Enlightened VMCB fields (AMD)

AMD has reserved space in the VMCB for hypervisor use, as well as an associated clean bit. The reserved bytes are in the control section, offset 0x3E0-3FF, of the VMCB. The clean bit is bit 31 (the clean bit must be invalidated whenever the hypervisor modifies the “enlightenments” area of the VMCB).

Hyper-V utilizes the reserved VMCB area to configure enlightenments. The [HV_SVM_ENLIGHTENED_VMCB_FIELDS](datatypes/HV_SVM_ENLIGHTENED_VMCB_FIELDS.md) structure documents the format.

## Enlightened MSR Bitmap

The L0 hypervisor emulates the “MSR-Bitmap” controls on both Intel and AMD platforms that allow virtualization software to control which MSR accesses generate intercepts.

The L1 hypervisor may collaborate with the L0 hypervisor to make MSR accesses more efficient. It can enable enlightened MSR bitmaps by setting the corresponding field in the enlightened VMCS / VMCB fields to 1. When enabled, the L0 hypervisor does not monitor the MSR bitmaps for changes. Instead, the L1 hypervisor must invalidate the corresponding clean field after making changes to one of the MSR bitmaps.

Support for the enlightened MSR bitmap is reported in [CPUID leaf 0x4000000A](feature-discovery.md#microsoft-hypervisor-cpuid-leaves).

## Compatibility with Live Migration

Hyper-V has the ability to live migrate a child partition from one host to another host. Live migrations are typically transparent to the child partition. However, in the case of nested virtualization, the L1 hypervisor may need to be aware of migrations.

### Live Migration Notification

An L1 hypervisor can request to be notified when its partition is migrated. This capability is enumerated in CPUID as “AccessReenlightenmentControls” privilege. The L0 hypervisor exposes a synthetic MSR (HV_X64_MSR_REENLIGHTENMENT_CONTROL) that may be used by the L1 hypervisor to configure an interrupt vector and target processor. The L0 hypervisor will inject an interrupt with the specified vector after each migration.

```c
#define HV_X64_MSR_REENLIGHTENMENT_CONTROL (0x40000106)

typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 Vector :8;
        UINT64 RsvdZ1 :8;
        UINT64 Enabled :1;
        UINT64 RsvdZ2 :15;
        UINT64 TargetVp :32;
    };
} HV_REENLIGHTENMENT_CONTROL;
```

The specified vector must correspond to a fixed APIC interrupt. TargetVp specifies the virtual processor index.

### TSC Emulation

A guest partition may be live migrated between two machines with different TSC frequencies. In those cases, the TscScale value from the [reference TSC page](timers.md#partition-reference-time-enlightenment) may need to be recomputed.

The L0 hypervisor optionally emulates all TSC accesses after a migration until the L1 hypervisor has had the opportunity to recompute the TscScale value. The L1 hypervisor can opt into TSC Emulation by writing to the HV_X64_MSR_TSC_EMULATION_CONTROL MSR. If opted in, the L0 hypervisor emulates TSC accesses after a migration takes place.

The L1 hypervisor can query if TSC accesses are currently being emulated using the HV_X64_MSR_TSC_EMULATION_STATUS MSR. For example, the L1 hypervisor could subscribe to [Live Migration notifications](#live-migration-notification) and query the TSC status after it receives the migration interrupt. It can also turn off TSC emulation (after it updates the TscScale value) using this MSR.

```c
#define HV_X64_MSR_TSC_EMULATION_CONTROL (0x40000107)
#define HV_X64_MSR_TSC_EMULATION_STATUS (0x40000108)

typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 Enabled :1;
        UINT64 RsvdZ :63;
    };
 } HV_TSC_EMULATION_CONTROL;

typedef union
{
    UINT64 AsUINT64;
    struct
    {
        UINT64 InProgress : 1;
        UINT64 RsvdP1 : 63;
    };
} HV_TSC_EMULATION_STATUS;
```

## Virtual TLB

The virtual TLB exposed by the hypervisor may be extended to cache translations from L2 GPAs to GPAs. As with the TLB on a logical processor, the virtual TLB is a non-coherent cache, and this non-coherence is visible to guests. The hypervisor exposes operations to manage the TLB.

### Direct Virtual Flush

The hypervisor exposes hypercalls ([HvCallFlushVirtualAddressSpace](hypercalls/HvCallFlushVirtualAddressSpace.md), [HvCallFlushVirtualAddressSpaceEx](hypercalls/HvCallFlushVirtualAddressSpaceEx.md), [HvCallFlushVirtualAddressList](hypercalls/HvCallFlushVirtualAddressList.md), and [HvCallFlushVirtualAddressListEx](hypercalls/HvCallFlushVirtualAddressListEx.md)) that allow operating systems to more efficiently manage the virtual TLB. The L1 hypervisor can choose to allow its guest to use those hypercalls and delegate the responsibility of handling them to the L0 hypervisor. This requires the use of a partition assist page (and a virtual VMCS on Intel platforms).

When in use, the virtual TLB tags all cached mappings with an identifier of the nested context (VMCS or VMCB) that created them. In response to a direct virtual flush hypercall from a L2 guest, the L0 hypervisor invalidates all cached mappings created by nested contexts where

- The VmId is the same as the caller’s VmId
- Either the VpId is contained in the specified ProcessorMask or HV_FLUSH_ALL_PROCESSORS is specified

Support for direct virtual flushes is reported in [CPUID leaf 0x4000000A](feature-discovery.md#microsoft-hypervisor-cpuid-leaves).

#### Configuration

Direct handling of virtual flush hypercalls is enabled by:

1. Setting the NestedEnlightenmentsControl.Features.DirectHypercall field of the [Virtual Processor Assist Page](vp-properties.md#virtual-processor-assist-page) to 1.
2. Setting the EnlightenmentsControl.NestedFlushVirtualHypercall field of an enlightened VMCS or VMCB to 1.

Before enabling it, the L1 hypervisor must configure the following additional fields of the enlightened VMCS / VMCB:

- VpId: ID of the virtual processor that the enlightened VMCS / VMCB controls.
- VmId: ID of the virtual machine that the enlightened VMCS / VMCB belongs to.
- PartitionAssistPage: Guest physical address of the partition assist page.

The L1 hypervisor must also expose the following capabilities to its guests via CPUID.

- UseHypercallForLocalFlush
- UseHypercallForRemoteFlush

#### Partition Assist Page

The partition assist page is a page-size aligned page-size region of memory that the L1 hypervisor must allocate and zero before direct flush hypercalls can be used. Its GPA must be written to the corresponding field in the enlightened VMCS / VMCB.

```c
struct
{
    UINT32 TlbLockCount;
} VM_PARTITION_ASSIST_PAGE;
```

#### Synthetic VM-Exit

If the TlbLockCount of the caller’s partition assist page is non-zero, the L0 hypervisor delivers a VM-Exit with a synthetic exit reason to the L1 hypervisor after handling a direct virtual flush hypercall.

On Intel platforms, a VM-Exit with exit reason `HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH` is delivered. On AMD platforms, a VM-Exit with exit code `HV_SVM_EXITCODE_ENL` is delivered and ExitInfo1 is set to `HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH`.

```c
#define HV_VMX_SYNTHETIC_EXIT_REASON_TRAP_AFTER_FLUSH 0x10000031

#define HV_SVM_EXITCODE_ENL 0xF0000000
#define HV_SVM_ENL_EXITCODE_TRAP_AFTER_FLUSH   (1)
```

### Second Level Address Translation

When nested virtualization is enabled for a guest partition, the memory management unit (MMU) exposed by the partition includes support for second level address translation. Second level address translation is a capability that can be used by the L1 hypervisor to virtualize physical memory. When in use, certain addresses that would be treated as guest physical addresses (GPAs) are treated as L2 guest physical addresses (L2 GPAs) and translated to GPAs by traversing a set of paging structures.

The L1 hypervisor can decide how and where to use second level address spaces. Each second level address space is identified by a guest defined 64-bit ID value. On Intel platforms, this value is the same as the EPT pointer. On AMD platforms, the value equals the nCR3 VMCB field.

#### Compatibility

The second level address translation capability exposed by the hypervisor is generally compatible with VMX or SVM support for address translation. However, the following guest-observable differences exist:

- Internally, the hypervisor may use shadow page tables that translate L2 GPAs to SPAs. In such implementations, these shadow page tables appear to software as large TLBs. However, several differences may be observable. First, shadow page tables can be shared between two virtual processors, whereas traditional TLBs are per-processor structures and are independent. This sharing may be visible because a page access by one virtual processor can fill a shadow page table entry that is subsequently used by another virtual processor.
- Some hypervisor implementations may use internal write protection of guest page tables to lazily flush MMU mappings from internal data structures (for example, shadow page tables). This is architecturally invisible to the guest because writes to these tables will be handled transparently by the hypervisor. However, writes performed to the underlying GPA pages by other partitions or by devices may not trigger the appropriate TLB flush.
- On some hypervisor implementations, a second level page fault might not invalidate cached mappings.

#### Enlightened Second Level TLB Flushes

The hypervisor also supports a set of enhancements that enable a guest to manage the second level TLB more efficiently. These enhanced operations can be used interchangeably with legacy TLB management operations.

The hypervisor supports the following hypercalls to invalidate TLBs:

| Hypercall                                                                           | Description                                     |
|-------------------------------------------------------------------------------------|-------------------------------------------------|
| [HvCallFlushGuestPhysicalAddressSpace](hypercalls/HvCallFlushGuestPhysicalAddressSpace.md)      | invalidates cached L2 GPA to GPA mappings within a second level address space.   |
| [HvCallFlushGuestPhysicalAddressList](hypercalls/HvCallFlushGuestPhysicalAddressList.md)  | invalidates cached GVA / L2 GPA to GPA mappings within a portion of a second level address space.    |

On AMD platforms, all TLB entries are architecturally tagged with an ASID (address space identifier). Invalidation of the ASID causes all TLB entires associated with the ASID to be invalidated. The nested hypervisor can optionally opt into an "enlightened TLB" by setting EnlightenedNptTlb to "1" in [HV_SVM_ENLIGHTENED_VMCB_FIELDS](datatypes/HV_SVM_ENLIGHTENED_VMCB_FIELDS.md). If the nested hypervisor opts into the enlightenment, ASID invalidations just flush TLB entires derived from first level address translation (i.e. the virtual address space). To flush TLB entries derived from the nested page table (NPT) and force the L0 hypervisor to rebuild shadow page tables, the HvCallFlushGuestPhysicalAddressSpace or HvCallFlushGuestPhysicalAddressList hypercalls must be used.

## Nested Virtualization Exceptions

On Intel platforms. the L1 hypervisor can opt in to combining virtualization exceptions in the page fault exception class. The L0 hypervisor advertises support for this enlightenment in the Hypervisor Nested Virtualization Features CPUID leaf.

This enlightenment can be enabled by setting VirtualizationException to “1” in [HV_NESTED_ENLIGHTENMENTS_CONTROL](datatypes/HV_NESTED_ENLIGHTENMENTS_CONTROL.md) data structure in the Virtual Processor Assist Page.

## Nested Virtualization MSRs

### Nested VP Index Register

The L1 hypervisor exposes a MSR that reports the current processor's underlying VP index.

| MSR address      | Register Name              | Description                                                                 |
|------------------|----------------------------|-----------------------------------------------------------------------------|
| 0x40001002       | HV_X64_MSR_NESTED_VP_INDEX | In a nested root partition, reports the current processor's underlying VP index. |

### Nested SynIC MSRs

In a nested root partition, the following MSRs allow access to the corresponding [SynIC MSRs](inter-partition-communication.md#synic-msrs) of the base hypervisor.

To find the index of the underlying processor, callers should first use HV_X64_MSR_NESTED_VP_INDEX.

| MSR address      | Register Name                 | Underlying MSR                                              |
|------------------|-------------------------------|--------------------------------------------------------------|
| 0x40001080       | HV_X64_MSR_NESTED_SCONTROL    | HV_X64_MSR_SCONTROL                                          |
| 0x40001081       | HV_X64_MSR_NESTED_SVERSION    | HV_X64_MSR_SVERSION                                          |
| 0x40001082       | HV_X64_MSR_NESTED_SIEFP       | HV_X64_MSR_SIEFP                                             |
| 0x40001083       | HV_X64_MSR_NESTED_SIMP        | HV_X64_MSR_SIMP                                              |
| 0x40001084       | HV_X64_MSR_NESTED_EOM         | HV_X64_MSR_EOM                                               |
| 0x40001090       | HV_X64_MSR_NESTED_SINT0       | HV_X64_MSR_SINT0                                             |
| 0x40001091       | HV_X64_MSR_NESTED_SINT1       | HV_X64_MSR_SINT1                                             |
| 0x40001092       | HV_X64_MSR_NESTED_SINT2       | HV_X64_MSR_SINT2                                             |
| 0x40001093       | HV_X64_MSR_NESTED_SINT3       | HV_X64_MSR_SINT3                                             |
| 0x40001094       | HV_X64_MSR_NESTED_SINT4       | HV_X64_MSR_SINT4                                             |
| 0x40001095       | HV_X64_MSR_NESTED_SINT5       | HV_X64_MSR_SINT5                                             |
| 0x40001096       | HV_X64_MSR_NESTED_SINT6       | HV_X64_MSR_SINT6                                             |
| 0x40001097       | HV_X64_MSR_NESTED_SINT7       | HV_X64_MSR_SINT7                                             |
| 0x40001098       | HV_X64_MSR_NESTED_SINT8       | HV_X64_MSR_SINT8                                             |
| 0x40001099       | HV_X64_MSR_NESTED_SINT9       | HV_X64_MSR_SINT9                                             |
| 0x4000109A       | HV_X64_MSR_NESTED_SINT10      | HV_X64_MSR_SINT10                                            |
| 0x4000109B       | HV_X64_MSR_NESTED_SINT11      | HV_X64_MSR_SINT11                                            |
| 0x4000109C       | HV_X64_MSR_NESTED_SINT12      | HV_X64_MSR_SINT12                                            |
| 0x4000109D       | HV_X64_MSR_NESTED_SINT13      | HV_X64_MSR_SINT13                                            |
| 0x4000109E       | HV_X64_MSR_NESTED_SINT14      | HV_X64_MSR_SINT14                                            |
| 0x4000109F       | HV_X64_MSR_NESTED_SINT15      | HV_X64_MSR_SINT15                                            |
