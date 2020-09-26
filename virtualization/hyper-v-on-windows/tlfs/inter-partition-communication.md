# Inter-Partition Communication

The hypervisor provides two simple mechanisms for one partition to communicate with another: messages and events. In both cases, notification is signaled by using the SynIC (synthetic interrupt controller).

## SynIC Messages

The hypervisor provides a simple inter-partition communication facility that allows one partition to send a parameterized message to another partition. (Because the message is sent asynchronously, it is said to be posted.) The destination partition may be notified of the arrival of this message through an interrupt.

### Message Buffers

A message buffer is used internally to the hypervisor to store a message until it is delivered to the recipient. The hypervisor maintains several sets of message buffers.

#### Guest Message Buffers

The hypervisor maintains a set of guest message buffers for each port. These buffers are used for messages sent explicitly from one partition to another by a guest. When a port is created, the hypervisor will allocate sixteen (16) message buffers from the port owner’s memory pool. These message buffers are returned to the memory pool when the port is deleted.

#### Message Buffer Queues

For each partition and each virtual processor in the partition, the hypervisor maintains one queue of message buffers for each SINTx (synthetic interrupt source) in the virtual processor’s SynIC. All message queues of a virtual processor are empty upon creation or reset of the virtual processor.

#### Reliability and Sequencing of Guest Message Buffers

Messages successfully posted by a guest have been queued for delivery by the hypervisor. Actual delivery and reception by the target partition is dependent upon its correct operation. Partitions may disable delivery of messages to particular virtual processors by either disabling its SynIC or disabling the SIMP.

Breaking a connection will not affect undelivered (queued) messages. Deletion of the target port will always free all of the port’s message buffers, whether they are available or contain undelivered (queued) messages.

Messages arrive in the order in which they have been successfully posted. If the receiving port is associated with a specific virtual processor, then messages will arrive in the same order in which they were posted. If the receiving port is associated with HV_ANY_VP, then messages are not guaranteed to arrive in any particular order.

### Messages

When a message is sent, the hypervisor selects a free message buffer. The set of available message buffers depends on the event that triggered the sending of the message.

The hypervisor marks the message buffer “in use” and fills in the message header with the message type, payload size, and information about the sender. Finally, it fills in the message payload. The contents of the payload depend on the event that triggered the message.

The hypervisor then appends the message buffer to a receiving message queue. The receiving message queue depends on the event that triggered the sending of the message. For all message types, SINTx is either implicit (in the case of intercept messages), explicit (in the case of timer messages) or specified by a port ID (in the case of guest messages). The target virtual processor is either explicitly specified or chosen by the hypervisor when the message is enqueued. Virtual processors whose SynIC or SIM page is disabled will not be considered as potential targets. If no targets are available, the hypervisor terminates the operation and returns an error to the caller.

The hypervisor then determines whether the specified SINTx message slot within the SIM page for the target virtual processor is empty. If the message type in the message slot is equal to HvMessageTypeNone (that is, zero), the message slot is assumed to be empty. In this case, the hypervisor dequeues the message buffer and copies its contents to the message slot within the SIM page. The hypervisor may copy only the number of payload bytes associated with the message. The hypervisor also attempts to generate an edge-triggered interrupt for the specified SINTx. If the APIC is software disabled or the SINTx is masked, the interrupt is lost. The arrival of this interrupt notifies the guest that a new message has arrived. If the SIM page is disabled or the message slot within the SIM page is not empty, the message remains queued, and no interrupt is generated.

As with any fixed-priority interrupt, the interrupt is not acknowledged by the virtual processor until the PPR (process priority register) is less than the vector specified in the SINTx register and interrupts are not masked by the virtual processor (rFLAGS[IF] is set to 1).

Multiple message buffers with the same SINTx can be queued to a virtual processor. In this case, the hypervisor will deliver the first message (that is, write it to the SIM page) and leave the others queued until one of three events occur:

- Another message buffer is queued.
- The guest indicates the “end of interrupt” by writing to the APIC’s EOI register.
- The guest indicates the “end of message” by writing to the SynIC’s EOM register.

In all three cases, the hypervisor will scan one or more message buffer queues and attempt to deliver additional messages. The hypervisor also attempts to generate an edge-triggered interrupt, indicating that a new message has arrived.

#### Recommended Message Handling

The SynIC message delivery mechanism is designed to accommodate efficient delivery and receipt of messages within a target partition. It is recommended that the message handling ISR (interrupt service routine) within the target partition perform the following steps:

- Examine the message that was deposited into the SIM message slot.
- Copy the contents of the message to another location and set the message type within the message slot to HvMessageTypeNone.
- Indicate the end of interrupt for the vector by writing to the APIC’s EOI register.
- Perform any actions implied by the message.

#### Message Sources

The classes of events that can trigger the sending of a message are as follows:

- Intercepts: Any intercept in a virtual processor will cause a message to be sent to either the parent partition or a higher VTL.
- Timers: The timer mechanisms will cause messages to be sent. Associated with each virtual processor are four dedicated timer message buffers, one for each timer. The receiving message queue belongs to SINTx of the virtual processor whose timer triggered the sending of the message.
- Guest messages: The hypervisor supports message passing as an inter-partition communication mechanism between guests. The interfaces defined in this section allow one guest to send messages to another guest. The message buffers used for messages of this class are taken from the receiver’s per-port pool of guest message buffers.

## SynIC Event Flags

In addition to messages, the SynIC supports a second type of cross-partition notification mechanism called event flags. Event flags may be set explicitly using the HvCallSignalEvent hypercall or implicitly by the hypervisor.

### Event Flags versus Messages

Event flags are lighter-weight than messages and are therefore lower overhead. Furthermore, event flags do not require any buffer allocation or queuing within the hypervisor, so HvCallSignalEvent will never fail due to insufficient resources.

### Event Flag Delivery

When a partition calls HvCallSignalEvent, it specifies an event flag number. The hypervisor responds by atomically setting a bit within the receiving virtual processor’s SIEF page. Virtual processors whose SynIC or SIEF page is disabled will not be considered as potential targets. If no targets are available, the hypervisor terminates the operation and returns an error to the caller.

If the event flag was previously cleared, the hypervisor attempts to notify the receiving partition that the flag is now set by generating an edge-triggered interrupt. The target virtual processor, along with the target SINTx, is specified as part of a port’s creation. If the SINTx is masked, HvSignalEvent returns HV_STATUS_INVALID_SYNIC_STATE.

As with any fixed-priority external interrupt, the interrupt is not acknowledged by the virtual processor until the process priority register (PPR) is less than the vector specified in the SINTx register and interrupts are not masked by the virtual processor (rFLAGS[IF] is set to 1).

### Recommended Event Flag Handling

It is recommended that the event flag interrupt service routine (ISR) within the target partition perform the following steps:

- Examine the event flags and determine which ones, if any, are set.
- Clear one or more event flags by using a locked (atomic) operation such as LOCK AND or LOCK CMPXCHG.
- Indicate the end of interrupt for the vector by writing to the APIC’s EOI register.
- Perform any actions implied by the event flags that were set.

## Ports and Connections

A message or event sent from one guest to another must be sent through a pre-allocated connection. A connection, in turn, must be associated with a destination port.

A port is allocated from the receiver’s memory pool and specifies which virtual processor and SINTx to target. Event ports have a “base flag number” and “flag count” that allow the caller to specify a range of valid event flags for that port.

Connections are allocated from the sender’s memory pool. When a connection is created, it must be associated with a valid port. This binding creates a simple, one-way communication channel. If a port is subsequently deleted, its connection, while it remains, becomes useless.

## SynIC MSRs

In addition to the memory-mapped registers defined for a local APIC, the following model-specific registers (MSRs) are defined in the SynIC. Each virtual processor has its own copy of these registers, so they can be programmed independently.

| MSR Address             | Register Name         | Function                             |
|-------------------------|-----------------------|--------------------------------------|
| 0x40000080              | SCONTROL              | SynIC Control                        |
| 0x40000081              | SVERSION              | SynIC Version                        |
| 0x40000082              | SIEFP                 | Interrupt Event Flags Page           |
| 0x40000083              | SIMP                  | Interrupt Message Page               |
| 0x40000084              | EOM                   | End of message                       |
| 0x40000090              | SINT0                 | Interrupt source 0 (hypervisor)      |
| 0x40000090              | SINT1                 | Interrupt source 1                   |
| 0x40000090              | SINT2                 | Interrupt source 2                   |
| 0x40000090              | SINT3                 | Interrupt source 3                   |
| 0x40000090              | SINT4                 | Interrupt source 4                   |
| 0x40000090              | SINT5                 | Interrupt source 5                   |
| 0x40000090              | SINT6                 | Interrupt source 6                   |
| 0x40000090              | SINT7                 | Interrupt source 7                   |
| 0x40000090              | SINT8                 | Interrupt source 8                   |
| 0x40000090              | SINT9                 | Interrupt source 9                   |
| 0x40000090              | SINT10                | Interrupt source 10                  |
| 0x40000090              | SINT11                | Interrupt source 11                  |
| 0x40000090              | SINT12                | Interrupt source 12                  |
| 0x40000090              | SINT13                | Interrupt source 13                  |
| 0x40000090              | SINT14                | Interrupt source 14                  |
| 0x40000090              | SINT15                | Interrupt source 15                  |

### SCONTROL Register

This register is used to control SynIC behavior of the virtual processor.

At virtual processor creation time and upon processor reset, the value of this SCONTROL (SynIC control register) is 0x0000000000000000. Thus, message queuing and event flag notifications will be disabled.

| Bits      | Field           | Description                                                                 | Attributes     |
|-----------|-----------------|-----------------------------------------------------------------------------|----------------|
| 63:1      | RsvdP           | Value must be preserved                                                     | Read / write   |
| 0         | Enable          | When set, this virtual processor will allow message queuing and event flag notifications to be posted to its SynIC. When clear, message queuing and event flag notifications cannot be directed to this virtual processor. | Read / write |

### SVERSION Register

This is a read-only register, and it returns the version number of the SynIC. Attempts to write to this register result in a #GP fault.

| Bits      | Field           | Description                                                                 | Attributes     |
|-----------|-----------------|-----------------------------------------------------------------------------|----------------|
| 63:32     | RsvdP           |                                                                             | Read           |
| 31:0      | SynIC Version   | Version number of the SynIc                                                 | Read           |

#### SIEFP Register

At virtual processor creation time and upon processor reset, the value of this SIEFP (synthetic interrupt event flags page) register is 0x0000000000000000. Thus, the SIEFP is disabled by default. The guest must enable it by setting bit 0. If the specified base address is beyond the end of the partition’s GPA space, the SIEFP page will not be accessible to the guest. When modifying the register, guests should preserve the value of the reserved bits (1 through 11) for future compatibility.

| Bits      | Field           | Description                                                                 | Attributes     |
|-----------|-----------------|-----------------------------------------------------------------------------|----------------|
| 63:12     | Base Address    | Base address (in GPA space) of SIEFP (low 12 bits assumed to be disabled)   | Read / Write   |
| 11:1      | RsvdP           | Reserved, value should be preserved                                         | Read / Write   |
| 0         | Enable          | SIEFP enable                                                                | Read / Write   |

#### SIMP Register

At virtual processor creation time and upon processor reset, the value of this SIMP (synthetic interrupt message page) register is 0x0000000000000000. Thus, the SIMP is disabled by default. The guest must enable it by setting bit 0. If the specified base address is beyond the end of the partition’s GPA space, the SIMP page will not be accessible to the guest. When modifying the register, guests should preserve the value of the reserved bits (1 through 11) for future compatibility.

| Bits      | Field           | Description                                                                 | Attributes     |
|-----------|-----------------|-----------------------------------------------------------------------------|----------------|
| 63:12     | Base Address    | Base address (in GPA space) of SIMP  (low 12 bits assumed to be disabled)   | Read / Write   |
| 11:1      | RsvdP           | Reserved, value should be preserved                                         | Read / Write   |
| 0         | Enable          | SIMP enable                                                                 | Read / Write   |

#### SINTx Registers

At virtual processor creation time, the default value of all SINTx (synthetic interrupt source) registers is 0x0000000000010000. Thus, all synthetic interrupt sources are masked by default. The guest must unmask them by programming an appropriate vector and clearing bit 16.

Setting the polling bit will have the effect of unmasking an interrupt source, except that an actual interrupt is not generated.

The AutoEOI flag indicates that an implicit EOI should be performed by the hypervisor when an interrupt is delivered to the virtual processor. In addition, the hypervisor will automatically clear the corresponding flag in the “in-service register” (ISR) of the virtual APIC. If the guest enables this behavior, then it must not perform an EOI in its interrupt service routine.
The AutoEOI flag can be turned on at any time, though the guest must perform an explicit EOI on an in-flight interrupt The timing consideration makes it difficult to know whether a particular interrupt needs EOI or not, so it is recommended that once SINT is unmasked, its settings are not changed. Likewise, the AutoEOI flag can be turned off at any time, though the same concerns about in-flight interrupts apply

Valid values for vector are 16-255 inclusive. Specifying an invalid vector number results in #GP.

| Bits      | Field           | Description                                                                 | Attributes     |
|-----------|-----------------|-----------------------------------------------------------------------------|----------------|
| 63:19     | RsvdP           | Reserved, value should be preserved                                         | Read / Write   |
| 18        | Polling         | Enables polling mode                                                        | Read / Write   |
| 17        | AutoEOI         | Set if an implicit EOI should be performed upon interrupt delivery          | Read / Write   |
| 16        | Masked          | Set if the SINT is masked                                                   | Read / Write   |
| 15:8      | RsvdP           | Reserved, value should be preserved                                         | Read / Write   |
| 7:0       | Vector          | Interrupt vector                                                            | Read / Write   |

#### EOM Register

A write to the end of message (EOM) register by the guest causes the hypervisor to scan the internal message buffer queue(s) associated with the virtual processor. If a message buffer queue contains a queued message buffer, the hypervisor attempts to deliver the message. Message delivery succeeds if the SIM page is enabled and the message slot corresponding to the SINTx is empty (that is, the message type in the header is set to HvMessageTypeNone). If a message is successfully delivered, its corresponding internal message buffer is dequeued and marked free. If the corresponding SINTx is not masked, an edge-triggered interrupt is delivered (that is, the corresponding bit in the IRR is set).

This register can be used by guests to “poll” for messages. It can also be used as a way to drain the message queue for a SINTx that has been disabled (that is, masked).

If the message queues are all empty, a write to the EOM register is a no-op.

Reads from the EOM register always returns zeros.

| Bits      | Field           | Description                                                                 | Attributes     |
|-----------|-----------------|-----------------------------------------------------------------------------|----------------|
| 63:0      | RsvdZ           | Write-only trigger                                                          | Write          |