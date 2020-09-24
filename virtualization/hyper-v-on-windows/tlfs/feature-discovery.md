# Feature and Interface Discovery

Guest software interacts with the hypervisor through a variety of mechanisms. Many of these mirror the traditional mechanisms used by software to interact with the underlying processor. As such, these mechanisms are architecture-specific. On the x64 architecture, the following mechanisms are used:

- CPUID instruction – Used for static feature and version information.
- MSRs (model-specific registers) – Used for status and control values.
- Memory-mapped registers – Used for status and control values.
- Processor interrupts – Used for asynchronous events, notifications and messages.

In addition to these architecture-specific interfaces, the hypervisor provides a simple procedural interface implemented with [hypercalls](#hypercalls).

## Hypervisor Discovery
Before using any hypervisor interfaces, software should first determine whether it’s running within a virtualized environment. On x64 platforms that conform to this specification, this is done by executing the CPUID instruction with an input (EAX) value of 1. Upon execution, code should check bit 31 of register ECX (the “hypervisor present bit”). If this bit is set, a hypervisor is present. In a non-virtualized environment, the bit will be clear.

 ```c
CPUID.01h.ECX:31 // if set, virtualization present
 ```

If the “hypervisor present bit” is set, additional CPUID leafs can be queried for more information about the conformant hypervisor and its capabilities. Two such leaves are guaranteed to be available: `0x40000000` and `0x40000001`. Subsequently-numbered leaves may also be available.

## Standard Hypervisor CPUID Leaves

When the leaf at `0x40000000` is queried, the hypervisor will return information that provides the maximum hypervisor CPUID leaf number and a vendor ID signature.

| Register  | Information Provided                                        |
|-----------|-------------------------------------------------------------|
| EAX       | The maximum input value for hypervisor CPUID information    |
| EBX       | Hypervisor Vendor ID Signature                              |
| ECX       | Hypervisor Vendor ID Signature                              |
| EDX       | Hypervisor Vendor ID Signature                              |

If the leaf at `0x40000001` is queried, it will return a value representing a vendor-neutral hypervisor interface identification. This determines the semantics of the leaves from `0x4000002` through `0x400000FF`.

| Register  | Information Provided                                        |
|-----------|-------------------------------------------------------------|
| EAX       | Hypervisor Interface Signature.                             |
| EBX       | Reserved                                                    |
| ECX       | Reserved                                                    |
| EDX       | Reserved                                                    |

These two leaves allow the guest to query the hypervisor vendor ID and interface independently. The vendor ID is provided only for informational and diagnostic purposes. It is recommended that software only base compatibility decisions on the interface signature reported through leaf `0x40000001`.

## Microsoft Hypervisor CPUID Leaves

On hypervisors conforming to the Microsoft hypervisor CPUID interface, the `0x40000000` and `0x40000001` leaf registers will have the following values.

### Hypervisor CPUID Leaf Range - 0x40000000

EAX determines the maximum hypervisor CPUID leaf. EBX-EDX contain the hypervisor vendor ID signature. The vendor ID signature should be used only for reporting and diagnostic purposes.

| Register  | Information Provided                                        |
|-----------|-------------------------------------------------------------|
| EAX       | The maximum input value for hypervisor CPUID information. On Microsoft hypervisors, this will be at least `0x40000005`.  |
| EBX       | 0x7263694D—“Micr”                                           |
| ECX       | 0x666F736F—“osof”                                           |
| EDX       | 0x76482074—“t Hv”                                           |

### Hypervisor Vendor-Neutral Interface Identification - 0x40000001

EAX contains the hypervisor interface identification signature. This determines the semantics of the leaves from `0x40000002` through `0x400000FF`.

| Register  | Information Provided                                        |
|-----------|-------------------------------------------------------------|
| EAX       | 0x31237648—“Hv#1”                                           |
| EBX       | Reserved                                                    |
| ECX       | Reserved                                                    |
| EDX       | Reserved                                                    |

Hypervisors conforming to the “Hv#1” interface also provide at least the following leaves.

### Hypervisor System Identity - 0x40000002

<!---
+-----------+-------+------------------------+
| Register  | Bits  | Information Provided   |
+===========+=======+========================+
| EAX       |       | Build Number           |
+-----------+-------+------------------------+
| EBX       | 31-16 | Major Version          |
+           +-------+------------------------+
|           | 15-0  | Minor Version          |
+-----------+-------+------------------------+
| ECX       |       | Service Pack           |
+-----------+-------+------------------------+
| EDX       | 31-24 | Service Branch         |
+           +-------+------------------------+
|           | 23-0  | Service Number         |
+-----------+-------+------------------------+
-->

<table>
    <thead>
        <tr>
            <th>Register</th>
            <th>Bits</th>
            <th>Information Provided</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>EAX</td>
            <td></td>
            <td>Build Number</td>
        </tr>
        <tr>
            <td rowspan="2">EBX</td>
            <td>31-16</td>
            <td>Major Version</td>
        </tr>
         <tr>
            <td>15-0</td>
            <td>Minor Version</td>
        </tr>
    </tbody>
</table>

### Hypervisor Feature Identification - 0x40000003

EAX and EBX indicate which features are available to the partition based upon the current partition privileges.

<!---
+-----------+-------+---------------------------------------------------------------------------------------+
| Register  | Bits  | Information Provided                                                                  |
+===========+=======+=======================================================================================+
| EAX       |       | Corresponds to bits 31-0 of HV_PARTITION_PRIVILEGE_MASK                               |
+-----------+-------+---------------------------------------------------------------------------------------+
| EBX       |       | Corresponds to bits 63-32 of HV_PARTITION_PRIVILEGE_MASK                              |
+-----------+-------+---------------------------------------------------------------------------------------+
| ECX       |       |                                                                                       |
+-----------+-------+---------------------------------------------------------------------------------------+
| EDX       | 0     | Deprecated (previously indicated availability of the MWAIT command).                  |
+           +-------+---------------------------------------------------------------------------------------+
|           | 1     | Guest debugging support is available                                                  |
+           +-------+---------------------------------------------------------------------------------------+
|           | 2     | Performance Monitor support is available                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 3     | Support for physical CPU dynamic partitioning events is available                     |
+           +-------+---------------------------------------------------------------------------------------+
|           | 4     | Support for passing hypercall input parameter block via XMM registers is available    |
+           +-------+---------------------------------------------------------------------------------------+
|           | 5     | Support for a virtual guest idle state is available                                   |
+           +-------+---------------------------------------------------------------------------------------+
|           | 6     | Support for hypervisor sleep state is available                                       |
+           +-------+---------------------------------------------------------------------------------------+
|           | 7     | Support for querying NUMA distances is available                                      |
+           +-------+---------------------------------------------------------------------------------------+
|           | 8     | Support for determining timer frequencies is available                                |
+           +-------+---------------------------------------------------------------------------------------+
|           | 9     | Support for injecting synthetic machine checks is available                           |
+           +-------+---------------------------------------------------------------------------------------+
|           | 10    | Support for guest crash MSRs is available                                             |
+           +-------+---------------------------------------------------------------------------------------+
|           | 11    | Support for debug MSRs is available                                                   |
+           +-------+---------------------------------------------------------------------------------------+
|           | 12    | Support for NPIEP is available                                                        |
+           +-------+---------------------------------------------------------------------------------------+
|           | 13    | DisableHypervisorAvailable                                                            |
+           +-------+---------------------------------------------------------------------------------------+
|           | 14    | ExtendedGvaRangesForFlushVirtualAddressListAvailable                                  |
+           +-------+---------------------------------------------------------------------------------------+
|           | 15    | Support for returning hypercall output via XMM registers is available                 |
+           +-------+---------------------------------------------------------------------------------------+
|           | 16    | Reserved                                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 17    | SintPollingModeAvailable                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 18    | HypercallMsrLockAvailable                                                             |
+           +-------+---------------------------------------------------------------------------------------+
|           | 19    | Use direct synthetic timers                                                           |
+           +-------+---------------------------------------------------------------------------------------+
|           | 31-20 | Reserved                                                                              |
-->

<table>
    <thead>
        <tr>
            <th>Register</th>
            <th>Bits</th>
            <th>Information Provided</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>EAX</td>
            <td></td>
            <td>Corresponds to bits 31-0 of HV_PARTITION_PRIVILEGE_MASK</td>
        </tr>
        <tr>
            <td>EBX</td>
            <td></td>
            <td>Corresponds to bits 63-32 of HV_PARTITION_PRIVILEGE_MASK</td>
        </tr>
        <tr>
            <td>ECX</td>
            <td></td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td rowspan="27">EDX</td>
            <td>0</td>
            <td>Deprecated (previously indicated availability of the MWAIT instruction)</td>
        </tr>
        <tr>
            <td>1</td>
            <td>Guest debugging support is available</td>
        </tr>
        <tr>
            <td>2</td>
            <td>Performance Monitor support is available</td>
        </tr>
        <tr>
            <td>3</td>
            <td>Support for physical CPU dynamic partitioning events is available</td>
        </tr>
        <tr>
            <td>4</td>
            <td>Support for passing hypercall input parameter block via XMM registers is available</td>
        </tr>
        <tr>
            <td>5</td>
            <td>Support for a virtual guest idle state is available</td>
        </tr>
        <tr>
            <td>6</td>
            <td>Support for hypervisor sleep state is available</td>
        </tr>
        <tr>
            <td>7</td>
            <td>Support for querying NUMA distances is available</td>
        </tr>
        <tr>
            <td>8</td>
            <td>Support for determining timer frequencies is available</td>
        </tr>
        <tr>
            <td>9</td>
            <td>Support for injecting synthetic machine checks is available</td>
        </tr>
        <tr>
            <td>10</td>
            <td>Support for guest crash MSRs is available</td>
        </tr>
        <tr>
            <td>11</td>
            <td>Support for debug MSRs is available</td>
        </tr>
        <tr>
            <td>12</td>
            <td>Support for NPIEP is available</td>
        </tr>
        <tr>
            <td>13</td>
            <td>DisableHypervisorAvailable</td>
        </tr>
        <tr>
            <td>14</td>
            <td>ExtendedGvaRangesForFlushVirtualAddressListAvailable</td>
        </tr>
        <tr>
            <td>15</td>
            <td>Support for returning hypercall output via XMM registers is available</td>
        </tr>
        <tr>
            <td>16</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>17</td>
            <td>SintPollingModeAvailable</td>
        </tr>
        <tr>
            <td>18</td>
            <td>HypercallMsrLockAvailable</td>
        </tr>
        <tr>
            <td>19</td>
            <td>Use direct synthetic timers</td>
        </tr>
        <tr>
            <td>20</td>
            <td>Support for PAT register available for VSM</td>
        </tr>
        <tr>
            <td>21</td>
            <td>Support for bndcfgs register available for VSM</td>
        </tr>
        <tr>
            <td>22</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>23</td>
            <td>Support for synthetic time unhalted timer available</td>
        </tr>
        <tr>
            <td>25-24</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>26</td>
            <td>Intel’s Last Branch Record (LBR) feature supported</td>
        </tr>
        <tr>
            <td>31-27</td>
            <td>Reserved</td>
        </tr>
    </tbody>
</table>

### Implementation Recommendations - 0x40000004

Indicates which behaviors the hypervisor recommends the OS implement for optimal performance.

<!---
+-----------+-------+---------------------------------------------------------------------------------------+
| Register  | Bits  | Information Provided                                                                  |
+===========+=======+=======================================================================================+
| EAX       | 0     | Recommend using hypercall for address space switches rather than MOV to CR3 instruction
+           +-------+---------------------------------------------------------------------------------------+
|           | 1     | Recommend using hypercall for local TLB flushes rather than INVLPG or MOV to CR3 instructions
+           +-------+---------------------------------------------------------------------------------------+
|           | 2     | Recommend using hypercall for remote TLB flushes rather than inter-processor interrupts
+           +-------+---------------------------------------------------------------------------------------+
|           | 3     | Recommend using MSRs for accessing APIC registers EOI, ICR and TPR rather than their memory-mapped counterparts
+           +-------+---------------------------------------------------------------------------------------+
|           | 4     | Recommend using the hypervisor-provided MSR to initiate a system RESET                |
+           +-------+---------------------------------------------------------------------------------------+
|           | 5     | Recommend using relaxed timing for this partition. If used, the VM should disable any watchdog timeouts that rely on the timely delivery of external interrupts.
+           +-------+---------------------------------------------------------------------------------------+
|           | 6     | Recommend using DMA remapping                                                         |
+           +-------+---------------------------------------------------------------------------------------+
|           | 7     | Recommend using interrupt remapping                                                   |
+           +-------+---------------------------------------------------------------------------------------+
|           | 8     | Recommend using x2APIC MSRs                                                           |
+           +-------+---------------------------------------------------------------------------------------+
|           | 9     | Recommend deprecating AutoEOI                                                         |
+           +-------+---------------------------------------------------------------------------------------+
|           | 10    | Recommend using SyntheticClusterIpi hypercall                                         |
+           +-------+---------------------------------------------------------------------------------------+
|           | 11    | Recommend using the newer ExProcessorMasks interface                                  |
+           +-------+---------------------------------------------------------------------------------------+
|           | 12    |  Indicates that the hypervisor is nested within a Hyper-V partition.                  |
+           +-------+---------------------------------------------------------------------------------------+
|           | 13    | Recommend using INT for MBEC system calls                                             |
+           +-------+---------------------------------------------------------------------------------------+
|           | 14    | Recommend a nested hypervisor using the enlightened VMCS interface. Also indicates that additional nested enlightenments may be available (see leaf `0x4000000A`)
+           +-------+---------------------------------------------------------------------------------------+
|           | 15    | UseSyncedTimeline – Indicates the partition should consume the QueryPerformanceCounter bias provided by the root partition.
+           +-------+---------------------------------------------------------------------------------------+
|           | 16    | Reserved                                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 17    | UseDirectLocalFlushEntire – Indicates the guest should toggle CR4.PGE to flush the entire TLB, as this is more performant than making a hypercall.
+           +-------+---------------------------------------------------------------------------------------+
|           | 18    | NoNonArchitecturalCoreSharing - Indicates that a virtual processor will never share a physical core with another virtual processor, except for virtual processors that are reported as sibling SMT threads. This can be used as an optimization to avoid the performance overhead of STIBP.
+           +-------+---------------------------------------------------------------------------------------+
|           | 31-19 | Reserved                                                                              |
+-----------+-------+---------------------------------------------------------------------------------------+
| EBX       |       | Recommended number of attempts to retry a spinlock failure before notifying the hypervisor about the failures. 0xFFFFFFFF indicates never to retry.
+-----------+-------+---------------------------------------------------------------------------------------+
| ECX       | 6-0   | ImplementedPhysicalAddressBits – Reports the physical address width (MAXPHYADDR) reported by the system’s physical processors. If all bits contain 0, the feature is not supported. Note that the value reported is the actual number of physical address bits, and not the bit position used to represent that number.
+           +-------+---------------------------------------------------------------------------------------+
|           | 31-7  | Reserved                                                                              |
+-----------+-------+---------------------------------------------------------------------------------------+
| EDX       |       |   Reserved                                                                            |
-->

<table>
    <thead>
        <tr>
            <th>Register</th>
            <th>Bits</th>
            <th>Information Provided</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="20">EAX</td>
            <td>0</td>
            <td>Recommend using hypercall for address space switches rather than MOV to CR3 instruction.</td>
        </tr>
        <tr>
            <td>1</td>
            <td>Recommend using hypercall for local TLB flushes rather than INVLPG or MOV to CR3 instructions.</td>
        </tr>
        <tr>
            <td>2</td>
            <td>Recommend using hypercall for remote TLB flushes rather than inter-processor interrupts.</td>
        </tr>
        <tr>
            <td>3</td>
            <td>Recommend using MSRs for accessing APIC registers EOI, ICR and TPR rather than their memory-mapped counterparts.</td>
        </tr>
        <tr>
            <td>4</td>
            <td>Recommend using the hypervisor-provided MSR to initiate a system RESET.</td>
        </tr>
        <tr>
            <td>5</td>
            <td>Recommend using relaxed timing for this partition. If used, the VM should disable any watchdog timeouts that rely on the timely delivery of external interrupts.</td>
        </tr>
        <tr>
            <td>6</td>
            <td>Recommend using DMA remapping.</td>
        </tr>
        <tr>
            <td>7</td>
            <td>Recommend using interrupt remapping.</td>
        </tr>
        <tr>
            <td>8</td>
            <td>Reserved.</td>
        </tr>
        <tr>
            <td>9</td>
            <td>Recommend deprecating AutoEOI.</td>
        </tr>
        <tr>
            <td>10</td>
            <td>Recommend using SyntheticClusterIpi hypercall.</td>
        </tr>
        <tr>
            <td>11</td>
            <td>Recommend using the newer ExProcessorMasks interface.</td>
        </tr>
        <tr>
            <td>12</td>
            <td>Indicates that the hypervisor is nested within a Hyper-V partition.</td>
        </tr>
        <tr>
            <td>13</td>
            <td>Recommend using INT for MBEC system calls.</td>
        </tr>
        <tr>
            <td>14</td>
            <td>Recommend a nested hypervisor using the enlightened VMCS interface. Also indicates that additional nested enlightenments may be available (see leaf 0x4000000A).</td>
        </tr>
        <tr>
            <td>15</td>
            <td>UseSyncedTimeline – Indicates the partition should consume the QueryPerformanceCounter bias provided by the root partition.</td>
        </tr>
        <tr>
            <td>16</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>17</td>
            <td>UseDirectLocalFlushEntire – Indicates the guest should toggle CR4.PGE to flush the entire TLB, as this is more performant than making a hypercall.</td>
        </tr>
        <tr>
            <td>18</td>
            <td>NoNonArchitecturalCoreSharing - indicates that core sharing is not possible. This can be used as an optimization to avoid the performance overhead of STIBP.</td>
        </tr>
       <tr>
            <td>31-19</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>EBX</td>
            <td></td>
            <td>Recommended number of attempts to retry a spinlock failure before notifying the hypervisor about the failures. 0xFFFFFFFF indicates never notify.</td>
        </tr>
        <tr>
            <td rowspan="2">ECX</td>
            <td>6-0</td>
            <td>ImplementedPhysicalAddressBits – Reports the physical address width (MAXPHYADDR) reported by the system’s physical processors. If all bits contain 0, the feature is not supported. Note that the value reported is the actual number of physical address bits, and not the bit position used to represent that number.</td>
        </tr>
        <tr>
            <td>31-7</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>EDX</td>
            <td></td>
            <td>Reserved</td>
        </tr>
    </tbody>
</table>

### Hypervisor Implementation Limits - 0x40000005

Describes the scale limits supported in the current hypervisor implementation. If any value is zero, the hypervisor does not expose the corresponding information; otherwise, they have these meanings.

| Register  | Information Provided                                                                 |
|-----------|--------------------------------------------------------------------------------------|
| EAX       | The maximum number of virtual processors supported                                   |
| EBX       | The maximum number of logical processors supported                                   |
| ECX       | The maximum number of physical interrupt vectors available for interrupt remapping.  |
| EDX       | Reserved                                                                             |

### Implementation Hardware Features - 0x40000006

Indicates which hardware-specific features have been detected and are currently in use by the hypervisor.

<!---
+-----------+-------+---------------------------------------------------------------------------------------+
| Register  | Bits  | Information Provided                                                                  |
+===========+=======+=======================================================================================+
| EAX       | 0     | Support for APIC overlay assist is detected and in use                                |
+           +-------+---------------------------------------------------------------------------------------+
|           | 1     | Support for MSR bitmaps is detected and in use                                        |
+           +-------+---------------------------------------------------------------------------------------+
|           | 2     | Support for architectural performance counters is detected and in use                 |
+           +-------+---------------------------------------------------------------------------------------+
|           | 3     | Support for second level address translation is detected and in use                   |
+           +-------+---------------------------------------------------------------------------------------+
|           | 4     | Support for DMA remapping is detected and in use                                      |
+           +-------+---------------------------------------------------------------------------------------+
|           | 5     | Support for interrupt remapping is detected and in use                                |
+           +-------+---------------------------------------------------------------------------------------+
|           | 6     | Indicates that a memory patrol scrubber is present in the hardware                    |
+           +-------+---------------------------------------------------------------------------------------+
|           | 7     | DMA protection is in use                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 8     | HPET is requested                                                                     |
+           +-------+---------------------------------------------------------------------------------------+
|           | 9     | Synthetic timers are volatile                                                         |
+           +-------+---------------------------------------------------------------------------------------+
|           | 31-10 | Reserved                                                                              |
+-----------+-------+---------------------------------------------------------------------------------------+
| EBX       | Reserved                                                                                      |
+-----------+-----------------------------------------------------------------------------------------------+
| ECX       | Reserved                                                                                      |
+-----------+-----------------------------------------------------------------------------------------------+
| EDX       | Reserved                                                                                      |
-->

<table>
    <thead>
        <tr>
            <th>Register</th>
            <th>Bits</th>
            <th>Information Provided</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="11">EAX</td>
            <td>0</td>
            <td>Support for APIC overlay assist is detected and in use.</td>
        </tr>
        <tr>
            <td>1</td>
            <td>Support for MSR bitmaps is detected and in use.</td>
        </tr>
        <tr>
            <td>2</td>
            <td>Support for architectural performance counters is detected and in use.</td>
        </tr>
        <tr>
            <td>3</td>
            <td>Support for second level address translation is detected and in use.</td>
        </tr>
        <tr>
            <td>4</td>
            <td>Support for DMA remapping is detected and in use.</td>
        </tr>
        <tr>
            <td>5</td>
            <td>Support for interrupt remapping is detected and in use.</td>
        </tr>
        <tr>
            <td>6</td>
            <td>Indicates that a memory patrol scrubber is present in the hardware.</td>
        </tr>
        <tr>
            <td>7</td>
            <td>DMA protection is in use.</td>
        </tr>
        <tr>
            <td>8</td>
            <td>HPET is requested.</td>
        </tr>
        <tr>
            <td>9</td>
            <td>Synthetic timers are volatile.</td>
        </tr>
        <tr>
            <td>31-10</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>EBX</td>
            <td></td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>ECX</td>
            <td></td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>EDX</td>
            <td></td>
            <td>Reserved</td>
        </tr>
    </tbody>
</table>

### Nested Hypervisor Feature Identification - 0x40000009

Describes the features exposed to the partition by the hypervisor when running nested. EAX describes access to virtual MSRs. EDX describes access to hypercalls.

<!---
+-----------+-------+---------------------------------------------------------------------------------------+
| Register  | Bits  | Information Provided                                                                  |
+===========+=======+=======================================================================================+
| EAX       | 1-0   | Reserved                                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 2     | AccessSynicRegs                                                                       |
+           +-------+---------------------------------------------------------------------------------------+
|           | 3     | Reserved                                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 4     | AccessIntrCtrlRegs                                                                    |
+           +-------+---------------------------------------------------------------------------------------+
|           | 5     | AccessHypercallMsrs                                                                   |
+           +-------+---------------------------------------------------------------------------------------+
|           | 6     | AccessVpIndex                                                                         |
+           +-------+---------------------------------------------------------------------------------------+
|           | 11-7  | Reserved                                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 12    | AccessReenlightenmentControls                                                         |
+           +-------+---------------------------------------------------------------------------------------+
|           | 31-13 | Reserved                                                                              |
+-----------+-------+---------------------------------------------------------------------------------------+
| EBX       | Reserved                                                                                      |
+-----------+-----------------------------------------------------------------------------------------------+
| ECX       | Reserved                                                                                      |
+-----------+-----------------------------------------------------------------------------------------------+
| EDX       | 3-0   | Reserved                                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 4     | XmmRegistersForFastHypercallAvailable                                                 |
+           +-------+---------------------------------------------------------------------------------------+
|           | 14-5  | Reserved                                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 15    | FastHypercallOutputAvailable                                                          |
+           +-------+---------------------------------------------------------------------------------------+
|           | 16    | Reserved                                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 17    | SintPollingModeAvailable                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 31-18 | Reserved                                                                              |
-->

<table>
    <thead>
        <tr>
            <th>Register</th>
            <th>Bits</th>
            <th>Information Provided</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="9">EAX</td>
            <td>1-0</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>2</td>
            <td>AccessSynicRegs</td>
        </tr>
        <tr>
            <td>3</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>4</td>
            <td>AccessIntrCtrlRegs</td>
        </tr>
        <tr>
            <td>5</td>
            <td>AccessHypercallMsrs</td>
        </tr>
        <tr>
            <td>6</td>
            <td>AccessVpIndex</td>
        </tr>
        <tr>
            <td>11-7</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>12</td>
            <td>AccessReenlightenmentControls</td>
        </tr>
        <tr>
            <td>31-13</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>EBX</td>
            <td></td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>ECX</td>
            <td></td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td rowspan="7">EDX</td>
            <td>3-0</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>4</td>
            <td>XmmRegistersForFastHypercallAvailable</td>
        </tr>
        <tr>
            <td>14-5</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>15</td>
            <td>FastHypercallOutputAvailable</td>
        </tr>
        <tr>
            <td>16</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>17</td>
            <td>SintPollingModeAvailable</td>
        </tr>
        <tr>
            <td>31-18</td>
            <td>Reserved</td>
        </tr>
    </tbody>
</table>

### Hypervisor Nested Virtualization Features - 0x4000000A

Indicates which nested virtualization optimizations are available to a nested hypervisor.

<!---
+-----------+-------+---------------------------------------------------------------------------------------+
| Register  | Bits  | Information Provided                                                                  |
+===========+=======+=======================================================================================+
| EAX       | 7-0   | Enlightened VMCS version (low)                                                        |
+           +-------+---------------------------------------------------------------------------------------+
|           | 15-8  | Enlightened VMCS version (high)                                                       |
+           +-------+---------------------------------------------------------------------------------------+
|           | 16    | Reserved                                                                              |
+           +-------+---------------------------------------------------------------------------------------+
|           | 17    | Indicates support for direct virtual flush hypercalls                                 |
+           +-------+---------------------------------------------------------------------------------------+
|           | 18    | Indicates support for the HvFlushGuestPhysicalAddressSpace and HvFlushGuestPhysicalAddressList hypercalls
+           +-------+---------------------------------------------------------------------------------------+
|           | 19    | Indicates support for using an enlightened MSR bitmap.                                |
+           +-------+---------------------------------------------------------------------------------------+
|           | 31-20 | Reserved                                                                              |
+-----------+-------+---------------------------------------------------------------------------------------+
| EBX       | Reserved                                                                                      |
+-----------+-----------------------------------------------------------------------------------------------+
| ECX       | Reserved                                                                                      |
+-----------+-----------------------------------------------------------------------------------------------+
| EDX       | Reserved                                                                                      |
-->

<table>
    <thead>
        <tr>
            <th>Register</th>
            <th>Bits</th>
            <th>Information Provided</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td rowspan="8">EAX</td>
            <td>7-0</td>
            <td>Enlightened VMCS version (low)</td>
        </tr>
        <tr>
            <td>15-8</td>
            <td>Enlightened VMCS version (high)</td>
        </tr>
        <tr>
            <td>16</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>17</td>
            <td>Indicates support for direct virtual flush hypercalls.</td>
        </tr>
        <tr>
            <td>18</td>
            <td>Indicates support for the HvFlushGuestPhysicalAddressSpace and HvFlushGuestPhysicalAddressList hypercalls.</td>
        </tr>
        <tr>
            <td>19</td>
            <td>Indicates support for using an enlightened MSR bitmap.</td>
        </tr>
        <tr>
            <td>20</td>
            <td>Indicates support for combining virtualization exceptions in the page fault exception class.</td>
        </tr>
        <tr>
            <td>31-21</td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>EBX</td>
            <td></td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>ECX</td>
            <td></td>
            <td>Reserved</td>
        </tr>
        <tr>
            <td>EDX</td>
            <td></td>
            <td>Reserved</td>
        </tr>
    </tbody>
</table>

## Versioning

The hypervisor version information is encoded in leaf `0x40000002`. Two version numbers are provided: the main version and the service version.

The main version includes a major and minor version number and a build number. These correspond to Microsoft Windows release numbers. The service version describes changes made to the main version.

Clients are strongly encouraged to check for hypervisor features by using CPUID leaves `0x40000003` through `0x40000005` rather than by comparing against version ranges.

## Reporting the Guest OS Identity

The guest OS running within the partition must identify itself to the hypervisor by writing its signature and version to an MSR (`HV_X64_MSR_GUEST_OS_ID`). This MSR is partition-wide and is shared among all virtual processors.

This register’s value is initially zero. A non-zero value must be written to the Guest OS ID MSR before the hypercall code page can be enabled (see Establishing the Hypercall Interface). If this register is subsequently zeroed, the hypercall code page will be disabled.

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
