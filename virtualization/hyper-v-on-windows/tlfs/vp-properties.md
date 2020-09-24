# Virtual Processor Properties

Each partition may have zero or more virtual processors.

## Virtual Processor Indices

A virtual processor is identified by a tuple composed of its partition ID and its processor index. The processor index is assigned to the virtual processor when it is created, and it is unchanged through the lifetime of the virtual processor.

## Virtual Processor Idle Sleep State

Virtual processors may be placed in a virtual idle processor power state, or processor sleep state. This enhanced virtual idle state allows a virtual processor that is placed into a low power idle state to be woken with the arrival of an interrupt even when the interrupt is masked on the virtual processor. In other words, the virtual idle state allows the operating system in the guest partition to take advantage of processor power saving techniques in the OS that would otherwise be unavailable when running in a guest partition.

A partition which possesses the AccessGuestIdleMsr privilege may trigger entry into the virtual processor idle sleep state through a read to the hypervisor-defined MSR `HV_X64_MSR_GUEST_IDLE`. The virtual processor will be woken when an interrupt arrives, regardless of whether the interrupt is enabled on the virtual processor or not.

## Virtual Processor Assist Page

The hypervisor provides a page per virtual processor which is overlaid on the guest GPA space. This page can be used for bi-directional communication between a guest VP and the hypervisor. The guest OS has read/write access to this virtual VP assist page.

A guest specifies the location of the overlay page (in GPA space) by writing to the Virtual VP Assist MSR (0x40000073). The format of the Virtual VP Assist Page MSR is as follows:

| Bits      | Field           | Description                                                                 |
|-----------|-----------------|-----------------------------------------------------------------------------|
| 0         | Enable          | Enables the VP assist page                                                  |
| 11:1      | RsvdP           | Reserved                                                                    |
| 63:12     | Page PFN        | Virtual VP Assist PAGe PFN                                                  |
