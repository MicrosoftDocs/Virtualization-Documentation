---
title: Hypercall Interface
description: Hypervisor Hypercall Interface
keywords: hyper-v
author: alexgrest
ms.author: hvdev
ms.date: 10/15/2020
ms.topic: reference
---

# Hypercall Interface

The hypervisor provides a calling mechanism for guests. Such calls are referred to as hypercalls. Each hypercall defines a set of input and/or output parameters. These parameters are specified in terms of a memory-based data structure. All elements of the input and output data structures are padded to natural boundaries up to 8 bytes (that is, two-byte elements must be on two-byte boundaries and so on).

A second hypercall calling convention can optionally be used for a subset of hypercalls – in particular, those that have two or fewer input parameters and no output parameters. When using this calling convention, the input parameters are passed in general-purpose registers.

A third hypercall calling convention can optionally be used for a subset of hypercalls where the input parameter block is up to 112 bytes. When using this calling convention, the input parameters are passed in registers, including the volatile XMM registers.

Input and output data structures must both be placed in memory on an 8-byte boundary and padded to a multiple of 8 bytes in size. The values within the padding regions are ignored by the hypervisor.

For output, the hypervisor is allowed to (but not guaranteed to) overwrite padding regions. If it overwrites padding regions, it will write zeros.

## Hypercall Classes

There are two classes of hypercalls: simple and rep (short for “repeat”). A simple hypercall performs a single operation and has a fixed-size set of input and output parameters. A rep hypercall acts like a series of simple hypercalls. In addition to a fixed-size set of input and output parameters, rep hypercalls involve a list of fixed-size input and/or output elements.

When a caller initially invokes a rep hypercall, it specifies a rep count that indicates the number of elements in the input and/or output parameter list. Callers also specify a rep start index that indicates the next input and/or output element that should be consumed. The hypervisor processes rep parameters in list order – that is, by increasing element index.

For subsequent invocations of the rep hypercall, the rep start index indicates how many elements have been completed – and, in conjunction with the rep count value – how many elements are left. For example, if a caller specifies a rep count of 25, and only 20 iterations are completed within the time constraints, the hypercall returns control back to the calling virtual processor after updating the rep start index to 20. When the hypercall is re-executed, the hypervisor will resume at element 20 and complete the remaining 5 elements.

If an error is encountered when processing an element, an appropriate status code is provided along with a reps completed count, indicating the number of elements that were successfully processed before the error was encountered. Assuming the specified hypercall control word is valid (see the following) and the input / output parameter lists are accessible, the hypervisor is guaranteed to attempt at least one rep, but it is not required to process the entire list before returning control back to the caller.

## Hypercall Continuation

A hypercall can be thought of as a complex instruction that takes many cycles. The hypervisor attempts to limit hypercall execution to 50μs or less before returning control to the virtual processor that invoked the hypercall. Some hypercall operations are sufficiently complex that a 50μs guarantee is difficult to make. The hypervisor therefore relies on a hypercall continuation mechanism for some hypercalls – including all rep hypercall forms.

The hypercall continuation mechanism is mostly transparent to the caller. If a hypercall is not able to complete within the prescribed time limit, control is returned back to the caller, but the instruction pointer is not advanced past the instruction that invoked the hypercall. This allows pending interrupts to be handled and other virtual processors to be scheduled. When the original calling thread resumes execution, it will re-execute the hypercall instruction and make forward progress toward completing the operation.

Most simple hypercalls are guaranteed to complete within the prescribed time limit. However, a small number of simple hypercalls might require more time. These hypercalls use hypercall continuation in a similar manner to rep hypercalls. In such cases, the operation involves two or more internal states. The first invocation places the object (for example, the partition or virtual processor) into one state, and after repeated invocations, the state finally transitions to a terminal state. For each hypercall that follows this pattern, the visible side effects of intermediate internal states is described.

## Hypercall Atomicity and Ordering

Except where noted, the action performed by a hypercall is atomic both with respect to all other guest operations (for example, instructions executed within a guest) and all other hypercalls being executed on the system. A simple hypercall performs a single atomic action; a rep hypercall performs multiple, independent atomic actions.

Simple hypercalls that use hypercall continuation may involve multiple internal states that are externally visible. Such calls comprise multiple atomic operations.

Each hypercall action may read input parameters and/or write results. The inputs to each action can be read at any granularity and at any time after the hypercall is made and before the action is executed. The results (that is, the output parameters) associated with each action may be written at any granularity and at any time after the action is executed and before the hypercall returns.

The guest must avoid the examination and/or manipulation of any input or output parameters related to an executing hypercall. While a virtual processor executing a hypercall will be incapable of doing so (as its guest execution is suspended until the hypercall returns), there is nothing to prevent other virtual processors from doing so. Guests behaving in this manner may crash or cause corruption within their partition.

## Legal Hypercall Environments

Hypercalls can be invoked only from the most privileged guest processor mode. On x64 platfoms, this means protected mode with a current privilege level (CPL) of zero. Although real-mode code runs with an effective CPL of zero, hypercalls are not allowed in real mode. An attempt to invoke a hypercall within an illegal processor mode will generate a #UD (undefined operation) exception.

All hypercalls should be invoked through the architecturally-defined hypercall interface (see below). An attempt to invoke a hypercall by any other means (for example, copying the code from the hypercall code page to an alternate location and executing it from there) might result in an undefined operation (#UD) exception. The hypervisor is not guaranteed to deliver this exception.

## Alignment Requirements

Callers must specify the 64-bit guest physical address (GPA) of the input and/or output parameters. GPA pointers must by 8-byte aligned. If the hypercall involves no input or output parameters, the hypervisor ignores the corresponding GPA pointer.

The input and output parameter lists cannot overlap or cross page boundaries. Hypercall input and output pages are expected to be GPA pages and not “overlay” pages. If the virtual processor writes the input parameters to an overlay page and specifies a GPA within this page, hypervisor access to the input parameter list is undefined.

The hypervisor will validate that the calling partition can read from the input page before executing the requested hypercall. This validation consists of two checks: the specified GPA is mapped and the GPA is marked readable. If either of these tests fails, the hypervisor generates a memory intercept message. For hypercalls that have output parameters, the hypervisor will validate that the partition can be write to the output page. This validation consists of two checks: the specified GPA is mapped and the GPA is marked writable.

## Hypercall Inputs

Callers specify a hypercall by a 64-bit value called a hypercall input value. It is formatted as follows:

| Field                   | Bits    | Information Provided                                        |
|-------------------------|---------|-------------------------------------------------------------|
| Call Code               | 15-0    | Specifies which hypercall is requested                      |
| Fast                    | 16      | Specifies whether the hypercall uses the register-based calling convention: 0 = memory-based, 1 = register-based |
| Variable header size    | 26-17   | The size of a variable header, in QWORDS.                   |
| RsvdZ                   | 30-27   | Must be zero                                                |
| Is Nested               | 31      | Specifies the hypercall should be handled by the L0 hypervisor in a nested environment. |
| Rep Count               | 43-32   | Total number of reps (for rep call, must be zero otherwise) |
| RsvdZ                   | 47-44   | Must be zero                                                |
| Rep Start Index         | 59-48   | Starting index (for rep call, must be zero otherwise)       |
| RsvdZ                   | 63-60   | Must be zero                                                |

For rep hypercalls, the rep count field indicates the total number of reps. The rep start index indicates the particular repetition relative to the start of the list (zero indicates that the first element in the list is to be processed). Therefore, the rep count value must always be greater than the rep start index.

Register mapping for hypercall inputs when the Fast flag is zero:

| x64     | x86     | Information Provided                                        |
|---------|---------|-------------------------------------------------------------|
| RCX     | EDX:EAX | Hypercall Input Value                                       |
| RDX     | EBX:ECX | Input Parameters GPA                                        |
| R8      | EDI:ESI | Output Parameters GPA                                       |

The hypercall input value is passed in registers along with a GPA that points to the input and output parameters.

On x64, the register mappings depend on whether the caller is running in 32-bit (x86) or 64-bit (x64) mode. The hypervisor determines the caller’s mode based on the value of EFER.LMA and CS.L. If both of these flags are set, the caller is assumed to be a 64-bit caller.

Register mapping for hypercall inputs when the Fast flag is one:

| x64     | x86     | Information Provided                                        |
|---------|---------|-------------------------------------------------------------|
| RCX     | EDX:EAX | Hypercall Input Value                                       |
| RDX     | EBX:ECX | Input Parameter                                             |
| R8      | EDI:ESI | Output Parameter                                            |

The hypercall input value is passed in registers along with the input parameters.

### Variable Sized Hypercall Input Headers

Most hypercall input headers have fixed size. The amount of header data being passed from the guest to the hypervisor is therefore implicitly specified by the hypercall code and need not be specified separately. However, some hypercalls require a variable amount of header data. These hypercalls typically have a fixed size input header and additional header input that is of variable size.

A variable sized header is similar to a fixed hypercall input (aligned to 8 bytes and sized to a multiple of 8 bytes). The caller must specify how much data it is providing as input headers. This size is provided as part of the hypercall input value (see “Variable header size” in table above).

Since the fixed header size is implicit, instead of supplying the total header size, only the variable portion is supplied in the input controls:

```
Variable Header Bytes = {Total Header Bytes - sizeof(Fixed Header)} rounded up to nearest multiple of 8

Variable HeaderSize = Variable Header Bytes / 8
```

It is illegal to specify a non-zero variable header size for a hypercall that is not explicitly documented as accepting variable sized input headers. In such a case the hypercall will result in a return code of `HV_STATUS_INVALID_HYPERCALL_INPUT`.

It is possible that for a given invocation of a hypercall that does accept variable sized input headers that all the header input fits entirely within the fixed size header. In such cases the variable sized input header is zero-sized and the corresponding bits in the hypercall input should be set to zero.

In all other regards, hypercalls accepting variable sized input headers are otherwise similar to fixed size input header hypercalls with regards to calling conventions. It is also possible for a variable sized header hypercall to additionally support rep semantics. In such a case the rep elements lie after the header in the usual fashion, except that the header's total size includes both the fixed and variable portions. All other rules remain the same, e.g. the first rep element must be 8 byte aligned.

### XMM Fast Hypercall Input

On x64 platforms, the hypervisor supports the use of XMM fast hypercalls, which allows some hypercalls to take advantage of the improved performance of the fast hypercall interface even though they require more than two input parameters. The XMM fast hypercall interface uses six XMM registers to allow the caller to pass an input parameter block up to 112 bytes in size.

Availability of the XMM fast hypercall interface is indicated via the “Hypervisor Feature Identification” CPUID Leaf (0x40000003):

- Bit 4: support for passing hypercall input via XMM registers is available.

Note that there is a separate flag to indicate support for XMM fast output. Any attempt to use this interface when the hypervisor does not indicate availability will result in a #UD fault.

#### Register Mapping (Input Only)

| x64     | x86     | Information Provided                                        |
|---------|---------|-------------------------------------------------------------|
| RCX     | EDX:EAX | Hypercall Input Value                                       |
| RDX     | EBX:ECX | Input Parameter Block                                       |
| R8      | EDI:ESI | Input Parameter Block                                       |
| XMM0    | XMM0    | Input Parameter Block                                       |
| XMM1    | XMM1    | Input Parameter Block                                       |
| XMM2    | XMM2    | Input Parameter Block                                       |
| XMM3    | XMM3    | Input Parameter Block                                       |
| XMM4    | XMM4    | Input Parameter Block                                       |
| XMM5    | XMM5    | Input Parameter Block                                       |

The hypercall input value is passed in registers along with the input parameters. The register mappings depend on whether the caller is running in 32-bit (x86) or 64-bit (x64) mode. The hypervisor determines the caller’s mode based on the value of EFER.LMA and CS.L. If both of these flags are set, the caller is assumed to be a 64-bit caller. If the input parameter block is smaller than 112 bytes, any extra bytes in the registers are ignored.

## Hypercall Outputs

All hypercalls return a 64-bit value called a hypercall result value. It is formatted as follows:

| Field           | Bits  | Comment                                                                               |
|-----------------|-------|---------------------------------------------------------------------------------------|
| Result          | 15-0  | `HV_STATUS` code indicating success or failure                                        |
| Rsvd            | 31-16 | Callers should ignore the value in these bits                                         |
| Reps completed  | 43-32 | Number of reps successfully completed                                                 |
| RsvdZ           | 63-40 | Callers should ignore the value in these bits                                         |

For rep hypercalls, the reps complete field is the total number of reps complete and not relative to the rep start index. For example, if the caller specified a rep start index of 5, and a rep count of 10, the reps complete field would indicate 10 upon successful completion.

The hypercall result value is passed back in registers. The register mapping depends on whether the caller is running in 32-bit (x86) or 64-bit (x64) mode (see above). The register mapping for hypercall outputs is as follows:

| x64     | x86     | Information Provided                                        |
|---------|---------|-------------------------------------------------------------|
| RAX     | EDX:EAX | Hypercall Result Value                                      |

### XMM Fast Hypercall Output

Similar to how the hypervisor supports XMM fast hypercall inputs, the same registers can be shared to return output. This is only supported on x64 platforms.

The ability to return output via XMM registers is indicated via the “Hypervisor Feature Identification” CPUID Leaf (0x40000003):

- Bit 15: support for returning hypercall output via XMM registers is available.

Note that there is a separate flag to indicate support for XMM fast input. Any attempt to use this interface when the hypervisor does not indicate availability will result in a #UD fault.

#### Register Mapping (Input and Output)

Registers that are not being used to pass input parameters can be used to return output. In other words, if the input parameter block is smaller than 112 bytes (rounded up to the nearest 16 byte aligned chunk), the remaining registers will return hypercall output.

| x64     | Information Provided                                        |
|---------|-------------------------------------------------------------|
| RDX     | Input or Output Block                                       |
| R8      | Input or Output Block                                       |
| XMM0    | Input or Output Block                                       |
| XMM1    | Input or Output Block                                       |
| XMM2    | Input or Output Block                                       |
| XMM3    | Input or Output Block                                       |
| XMM4    | Input or Output Block                                       |
| XMM5    | Input or Output Block                                       |

For example, if the input parameter block is 20 bytes in size, the hypervisor would ignore the following 12 bytes. The remaining 80 bytes would contain hypercall output (if applicable).

## Volatile Registers

Hypercalls will only modify the specified register values under the following conditions:

1. RAX (x64) and EDX:EAX (x86) are always overwritten with the hypercall result value and output parameters, if any.
1. Rep hypercalls will modify RCX (x64) and EDX:EAX (x86) with the new rep start index.
1. [HvCallSetVpRegisters](./hypercalls/HvCallSetVpRegisters.md) can modify any registers that are supported with that hypercall.
1. RDX, R8, and XMM0 through XMM5, when used for fast hypercall input, remain unmodified. However, registers used for fast hypercall output can be modified, including RDX, R8, and XMM0 through XMM5. Hyper-V will only modify these registers for fast hypercall output, which is limited to x64.

## Hypercall Restrictions

Hypercalls may have restrictions associated with them for them to perform their intended function. If all restrictions are not met, the hypercall will terminate with an appropriate error. The following restrictions will be listed, if any apply:

- The calling partition must possess a particular privilege
- The partition being acted upon must be in a particular state (e.g. “Active”)

## Hypercall Status Codes

Each hypercall is documented as returning an output value that contains several fields. A status value field (of type `HV_STATUS`) is used to indicate whether the call succeeded or failed.

### Output Parameter Validity on Failed Hypercalls

Unless explicitly stated otherwise, when a hypercall fails (that is, the result field of the hypercall result value contains a value other than `HV_STATUS_SUCCESS`), the content of all output parameters are indeterminate and should not be examined by the caller. Only when the hypercall succeeds, will all appropriate output parameters contain valid, expected results.

### Ordering of Error Conditions

The order in which error conditions are detected and reported by the hypervisor is undefined. In other words, if multiple errors exist, the hypervisor must choose which error condition to report. Priority should be given to those error codes offering greater security, the intent being to prevent the hypervisor from revealing information to callers lacking sufficient privilege. For example, the status code `HV_STATUS_ACCESS_DENIED` is the preferred status code over one that would reveal some context or state information purely based upon privilege.

### Common Hypercall Status Codes

Several result codes are common to all hypercalls and are therefore not documented for each hypercall individually. These include the following:

| Status code                        | Error condition                                                                       |
|------------------------------------|---------------------------------------------------------------------------------------|
| `HV_STATUS_SUCCESS`                | The call succeeded.                                                                   |
| `HV_STATUS_INVALID_HYPERCALL_CODE` | The hypercall code is not recognized.                                                 |
| `HV_STATUS_INVALID_HYPERCALL_INPUT`| The rep count is incorrect (for example, a non-zero rep count is passed to a non-rep call or a zero rep count is passed to a rep call).
|                                    | The rep start index is not less than the rep count.                                   |
|                                    | A reserved bit in the specified hypercall input value is non-zero.                    |
| `HV_STATUS_INVALID_ALIGNMENT`      | The specified input or output GPA pointer is not aligned to 8 bytes.                  |
|                                    | The specified input or output parameter lists spans pages.                            |
|                                    | The input or output GPA pointer is not within the bounds of the GPA space.            |

The return code `HV_STATUS_SUCCESS` indicates that no error condition was detected.

## Reporting the Guest OS Identity

The guest OS running within the partition must identify itself to the hypervisor by writing its signature and version to an MSR (`HV_X64_MSR_GUEST_OS_ID`) before it can invoke hypercalls. This MSR is partition-wide and is shared among all virtual processors.

This register’s value is initially zero. A non-zero value must be written to the Guest OS ID MSR before the hypercall code page can be enabled (see [Establishing the Hypercall Interface](#establishing-the-hypercall-interface)). If this register is subsequently zeroed, the hypercall code page will be disabled.

 ```c
#define HV_X64_MSR_GUEST_OS_ID 0x40000000
 ```

### Guest OS Identity for proprietary Operating Systems

The following is the recommended encoding for this MSR. Some fields may not apply for some guest OSs.

| Bits      | Field           | Description                                                                 |
|-----------|-----------------|-----------------------------------------------------------------------------|
| 15:0      | Build Number    | Indicates the build number of the OS                                        |
| 23:16     | Service Version | Indicates the service version (for example, "service pack" number)          |
| 31:24     | Minor Version   | Indicates the minor version of the OS                                       |
| 39:32     | Major Version   | Indicates the major version of the OS                                       |
| 47:40     | OS ID           | Indicates the OS variant. Encoding is unique to the vendor. Microsoft operating systems are encoded as follows: 0=Undefined, 1=MS-DOS®, 2=Windows® 3.x, 3=Windows® 9x, 4=Windows® NT (and derivatives), 5=Windows® CE
| 62:48     | Vendor ID       | Indicates the guest OS vendor. A value of 0 is reserved. See list of vendors below.
| 63        | OS Type         | Indicates the OS types. A value of 0 indicates a proprietary, closed source OS. A value of 1 indicates an open source OS.

Vendor values are allocated by Microsoft. To request a new vendor, please file an issue on the GitHub virtualization documentation repository (<https://aka.ms/VirtualizationDocumentationIssuesTLFS>).

| Vendor    | Value                                                                                |
|-----------|--------------------------------------------------------------------------------------|
| Microsoft | 0x0001                                                                               |
| HPE       | 0x0002                                                                               |
| LANCOM    | 0x0200                                                                               |

### Guest OS Identity MSR for Open Source Operating Systems

The following encoding is offered as guidance for open source operating system vendors intending to conform to this specification. It is suggested that open source operating systems adapt the following convention.

| Bits      | Field           | Description                                                                 |
|-----------|-----------------|-----------------------------------------------------------------------------|
| 15:0      | Build Number    | Additional Information                                                      |
| 47:16     | Version         | Upstream kernel version information.                                        |
| 55:48     | OS ID           | Additional vendor information                                               |
| 62:56     | OS Type         | OS type (e.g., Linux, FreeBSD, etc.). See list of known OS types below      |
| 63        | Open Source     | A value of 1 indicates an open source OS.                                   |

OS Type values are allocated by Microsoft. To request a new OS Type, please file an issue on the GitHub virtualization documentation repository (<https://aka.ms/VirtualizationDocumentationIssuesTLFS>).

| OS Type   | Value                                                                                |
|-----------|--------------------------------------------------------------------------------------|
| Linux     | 0x1                                                                                  |
| FreeBSD   | 0x2                                                                                  |
| Xen       | 0x3                                                                                  |
| Illumos   | 0x4                                                                                  |

## Establishing the Hypercall Interface

Hypercalls are invoked by using a special opcode. Because this opcode differs among virtualization implementations, it is necessary for the hypervisor to abstract this difference. This is done through a special hypercall page. This page is provided by the hypervisor and appears within the guest’s GPA space. The guest is required to specify the location of the page by programming the Guest Hypercall MSR.

 ```c
#define HV_X64_MSR_HYPERCALL 0x40000001
 ```

| Bits    | Description                                                                        | Attributes      |
|---------|------------------------------------------------------------------------------------|-----------------|
| 63:12   | Hypercall GPFN - Indicates the Guest Physical Page Number of the hypercall page    | Read/write    |
| 11:2    | RsvdP. Bits should be ignored on reads and preserved on writes.                    | Reserved        |
| 1       | Locked. Indicates if the MSR is immutable. If set, this MSR is locked thereby preventing the relocation of the hypercall page. Once set, only a system reset can clear the bit.                                                    | Read/write    |
| 0       | Enable hypercall page                                                              | Read/write    |

The hypercall page can be placed anywhere within the guest’s GPA space, but must be page-aligned. If the guest attempts to move the hypercall page beyond the bounds of the GPA space, a #GP fault will result when the MSR is written.

This MSR is a partition-wide MSR. In other words, it is shared by all virtual processors in the partition. If one virtual processor successfully writes to the MSR, another virtual processor will read the same value.

Before the hypercall page is enabled, the guest OS must report its identity by writing its version signature to a separate MSR (HV_X64_MSR_GUEST_OS_ID). If no guest OS identity has been specified, attempts to enable the hypercall will fail. The enable bit will remain zero even if a one is written to it. Furthermore, if the guest OS identity is cleared to zero after the hypercall page has been enabled, it will become disabled.

The hypercall page appears as an “overlay” to the GPA space; that is, it covers whatever else is mapped to the GPA range. Its contents are readable and executable by the guest. Attempts to write to the hypercall page will result in a protection (#GP) exception. After the hypercall page has been enabled, invoking a hypercall simply involves a call to the start of the page.

The following is a detailed list of the steps involved in establishing the hypercall page:

1. The guest reads CPUID leaf 1 and determines whether a hypervisor is present by checking bit 31 of register ECX.
2. The guest reads CPUID leaf 0x40000000 to determine the maximum hypervisor CPUID leaf (returned in register EAX) and CPUID leaf 0x40000001 to determine the interface signature (returned in register EAX). It verifies that the maximum leaf value is at least 0x40000005 and that the interface signature is equal to “Hv#1”. This signature implies that `HV_X64_MSR_GUEST_OS_ID`, `HV_X64_MSR_HYPERCALL` and `HV_X64_MSR_VP_INDEX` are implemented.
3. The guest writes its OS identity into the MSR `HV_X64_MSR_GUEST_OS_ID` if that register is zero.
4. The guest reads the Hypercall MSR (`HV_X64_MSR_HYPERCALL`).
5. The guest checks the Enable Hypercall Page bit. If it is set, the interface is already active, and steps 6 and 7 should be omitted.
6. The guest finds a page within its GPA space, preferably one that is not occupied by RAM, MMIO, and so on. If the page is occupied, the guest should avoid using the underlying page for other purposes.
7. The guest writes a new value to the Hypercall MSR (`HV_X64_MSR_HYPERCALL`) that includes the GPA from step 6 and sets the Enable Hypercall Page bit to enable the interface.
8. The guest creates an executable VA mapping to the hypercall page GPA.
9. The guest consults CPUID leaf 0x40000003 to determine which hypervisor facilities are available to it.
After the interface has been established, the guest can initiate a hypercall. To do so, it populates the registers per the hypercall protocol and issues a CALL to the beginning of the hypercall page. The guest should assume the hypercall page performs the equivalent of a near return (0xC3) to return to the caller. As such, the hypercall must be invoked with a valid stack.

## Extended Hypercall Interface

Hypercalls with call codes above 0x8000 are known as extended hypercalls. Extended hypercalls use the same calling convention as normal hypercalls and appear identical from a guest VM’s perspective. Extended hypercalls are internally handled differently within the Hyper-V hypervisor.

Extended hypercall capabilities can be queried with [HvExtCallQueryCapabilities](hypercalls/HvExtCallQueryCapabilities.md).