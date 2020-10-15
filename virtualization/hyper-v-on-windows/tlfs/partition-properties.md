# Partitions

The hypervisor supports isolation in terms of a partition. A partition is a logical unit of isolation, supported by the hypervisor, in which operating systems execute.

## Partition Privilege Flags

Each partition has a set of privileges assigned by the hypervisor. Privileges control access to synthetic MSRs or hypercalls.

A partition can query its privileges through the “Hypervisor Feature Identification” CPUID Leaf (0x40000003). See [HV_PARTITION_PRIVILEGE_MASK](datatypes/HV_PARTITION_PRIVILEGE_MASK.md) for a description of all privileges.

## Partition Crash Enlightenment

The hypervisor provides guest partitions with a crash enlightenment facility. This interface allows the operating system running in a guest partition the option of providing forensic information about fatal OS conditions to the hypervisor as part of its crash dump procedure. Options include preserving the contents of the guest crash parameter MSRs and specifying a crash message. The hypervisor then makes this information available to the root partition for logging. This mechanism allows the virtualization host administrator to gather information about the guest OS crash event without needing to inspect persistent storage attached to the guest partition for crash dump or core dump information that may be stored there by the crashing guest OS.

The availability of this mechanism is indicated via `CPUID.0x400003.EDX:10`, the GuestCrashMsrsAvailable flag; refer to [feature discovery](feature-discovery.md).

### Guest Crash Enlightenment Interface

The guest crash enlightenment interface is provided through six synthetic MSRs, as defined below.

 ```c
#define HV_X64_MSR_CRASH_P0 0x40000100
#define HV_X64_MSR_CRASH_P1 0x40000101
#define HV_X64_MSR_CRASH_P2 0x40000102
#define HV_X64_MSR_CRASH_P3 0x40000103
#define HV_X64_MSR_CRASH_P4 0x40000104
#define HV_X64_MSR_CRASH_CTL 0x40000105
 ```

#### Guest Crash Control MSR

The guest crash control MSR HV_X64_MSR_CRASH_CTL may be used by guest partitions to determine the hypervisor’s guest crash capabilities, and to invoke the specified action to take. The [HV_CRASH_CTL_REG_CONTENTS](datatypes/HV_CRASH_CTL_REG_CONTENTS.md) data structure defines the contents of the MSR.

##### Determining Guest Crash Capabilities

To determine the guest crash capabilities, guest partitions may read the HV_X64_MSR_CRASH_CTL register. The supported set of actions and capabilities supported by the hypervisor is reported.

##### Invoking Guest Crash Capabilities

To invoke a supported hypervisor guest crash action, a guest partition writes to the HV_X64_MSR_CRASH_CTL register, specifying the desired action. Two variations are supported: CrashNotify by itself, and CrashMessage in combination with CrashNotify. For each occurrence of a guest crash, at most a single write to MSR HV_X64_MSR_CRASH_CTL should be performed, specifying one of the two variations.

| Guest Crash Action  | Description                                                 |
|---------------------|-------------------------------------------------------------|
| CrashMessage        | This action is used in combination with CrashNotify to specify a crash message to the hypervisor. When selected, the values of P3 and P4 are treated as the location and size of the message. HV_X64_MSR_CRASH_P3 is the guest physical address of the message, and HV_X64_MSR_CRASH_P4 is the length in bytes of the message (maximum of 4096 bytes). |
| CrashNotify         | This action indicates to the hypervisor that the guest partition has completed writing the desired data into the guest crash parameter MSRs (i.e., P0 thru P4), and the hypervisor should proceed with logging the contents of these MSRs. |