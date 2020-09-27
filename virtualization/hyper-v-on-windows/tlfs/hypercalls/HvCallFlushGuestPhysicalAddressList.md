# HvCallFlushGuestPhysicalAddressList

The HvCallFlushGuestPhysicalAddressList hypercall invalidates cached GVA / L2 GPA to GPA mappings within a portion of a second level address space.

## Interface

 ```c
HV_STATUS
HvCallFlushGuestPhysicalAddressList(
    _In_ HV_SPA AddressSpace,
    _In_ UINT64 Flags,
    _In_reads_(RangeCount) PHV_GPA_PAGE_RANGE GpaRangeList
    );
 ```

This hypercall can only be used with nested virtualization is active. The virtual TLB invalidation operation acts on all processors.

On Intel platforms, the HvFlushGuestPhysicalAddressSpace hypercall is like the execution of an INVEPT instruction with type “single-context” on all processors.

This call guarantees that by the time control returns to the caller, the observable effects of all flushes have occurred.
If the TLB is currently “locked”, the caller’s virtual processor is suspended.

This call takes a list of L2 GPA ranges to flush. Each range has a base L2 GPA. Because flushes are performed with page granularity, the bottom 12 bits of the L2 GPA can be used to define a range length. These bits encode the number of additional pages (beyond the initial page) within the range. This allows each entry to encode a range of 1 to 4096 pages.

## Call Code

`0x00B0` (Rep)

## Input Parameters

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `AddressSpace`          | 0          | 8        | Specifies an address space ID (EPT PML4 table pointer). |
| `Flags`                 | 8          | 8        | RsvdZ                                     |

## Input List Element

| Name                    | Offset     | Size     | Information Provided                      |
|-------------------------|------------|----------|-------------------------------------------|
| `GpaRange`              | 0          | 8        | GPA range                                 |