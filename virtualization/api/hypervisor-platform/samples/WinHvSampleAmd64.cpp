/*++

Copyright (c) Microsoft Corporation.  All rights reserved.

Module Name:

    WinHvSampleAmd64.cpp

Abstract:

    This module contains samples for the Windows Hypervisor User-Mode APIs on Amd64.

--*/

#include <windows.h>
#include <winhvplatform.h>
#include <exception>
#include <stdio.h>
#include <stdlib.h>
#include <mutex>
#include <string>
#include <vector>
#include <wil/result.h>
#include <wil/resource.h>

// Sample code
namespace WHvSample {

#define ROUND_UP_TO_POWER2(Value, Alignment) \
    (((Value) + (Alignment) - 1) & ~((Alignment) - 1))

using unique_whv_partition =
    wil::unique_any<WHV_PARTITION_HANDLE, decltype(&WHvDeletePartition), WHvDeletePartition>;

const SIZE_T PageSize = 0x1000;

/// Sample demonstrating detection of WHP support.
void Initialize(void)
{
    WHV_CAPABILITY capability;
    THROW_IF_FAILED(WHvGetCapability(WHvCapabilityCodeHypervisorPresent, &capability, sizeof(capability), nullptr));
    THROW_HR_IF(HRESULT_FROM_WIN32(ERROR_HV_NOT_PRESENT), !capability.HypervisorPresent);
}

// Allocating a region from VirtualAlloc will implicitly reserve a region of the allocation
// granularity. This class demonstrates how to reserve and map an entire region up front and then
// commit as needed to reduce wasted virtual address space.
class GuestAddressSpace
{
public:
    GuestAddressSpace(WHV_PARTITION_HANDLE Partition, SIZE_T SizeInBytes) :
        m_Partition(Partition)
    {
        std::call_once(m_MemoryRegionOnce, [&]()
        {
            SYSTEM_INFO systemInfo;
            GetSystemInfo(&systemInfo);

            // N.B. The page size can be included from the DDK headers.
            THROW_HR_IF(E_UNEXPECTED, systemInfo.dwPageSize != PageSize);
            FAIL_FAST_IF(PageSize > systemInfo.dwAllocationGranularity);
            FAIL_FAST_IF((systemInfo.dwAllocationGranularity % PageSize) != 0);
            m_AllocationGranularity = systemInfo.dwAllocationGranularity;
        });

        SIZE_T reserveSizeInBytes = ROUND_UP_TO_POWER2(SizeInBytes, m_AllocationGranularity);
        wil::unique_virtualalloc_ptr<void> regionStart { VirtualAlloc(nullptr, reserveSizeInBytes, MEM_RESERVE, PAGE_NOACCESS) };
        THROW_LAST_ERROR_IF_NULL(regionStart);
        const WHV_MAP_GPA_RANGE_FLAGS GpaRangeFlags = WHvMapGpaRangeFlagRead | WHvMapGpaRangeFlagWrite | WHvMapGpaRangeFlagExecute;
        THROW_IF_FAILED(WHvMapGpaRange(m_Partition, regionStart.get(), 0, reserveSizeInBytes, GpaRangeFlags));

        // Initialize remaining member variables.
        m_RegionCurrent = regionStart.get();
        m_RegionCurrentPageCount = reserveSizeInBytes / PageSize;
        m_RegionStart = std::move(regionStart);
    }

    void *CommitRange(SIZE_T SizeInBytes, DWORD Protection)
    {
        SIZE_T commitSizeInBytes = ROUND_UP_TO_POWER2(SizeInBytes, PageSize);
        SIZE_T commitSizeInPages = commitSizeInBytes / PageSize;
        THROW_HR_IF(E_NOT_SUFFICIENT_BUFFER, commitSizeInPages > m_RegionCurrentPageCount);
        unsigned char *regionCurrent =
            static_cast<unsigned char *>(VirtualAlloc(m_RegionCurrent, commitSizeInBytes, MEM_COMMIT, Protection));

        THROW_LAST_ERROR_IF_NULL(regionCurrent);

        FAIL_FAST_IF(regionCurrent != m_RegionCurrent);
        m_RegionCurrent = regionCurrent + commitSizeInBytes;
        m_RegionCurrentPageCount -= commitSizeInPages;
        return regionCurrent;
    }

private:
    static SIZE_T m_AllocationGranularity;
    static std::once_flag m_MemoryRegionOnce;
    WHV_PARTITION_HANDLE m_Partition = nullptr;
    wil::unique_virtualalloc_ptr<void> m_RegionStart;
    void *m_RegionCurrent = nullptr;
    SIZE_T m_RegionCurrentPageCount = 0;
};

// Statics for GuestAddressSpace
SIZE_T GuestAddressSpace::m_AllocationGranularity = {};
std::once_flag GuestAddressSpace::m_MemoryRegionOnce = {};

/// Sample demonstrating executing code on a virtual processor in long mode (64 bit). A partition
/// with a single virtual processor is created and configured to execute a code sequence that loads
/// registers rax, rcx, rdx, rbx, r8, and r9 with the byte values of 'W', 'H', 'v', '6', '4' '!'
/// followed by a breakpoint trap. For the processor to execute directly in long mode, the
/// following state is configured which should be adjusted as needed outside of this sample:
///     Page tables - identity mapping for first 2MB of partition address space.
///     Gdt - NULL entry followed by Cs entry.
///     Code region - x64 opcodes mapped into the partition address space.
///     Rip - start of the code region.
///     Cs - references the Cs entry in the Gdt with long mode access.
///     Gdtr - describes the Gdt.
///     Cr0 - bits required for long mode.
///     Cr3 - references the start of the page tables
///     Cr4 - bites required for long mode
///     Efer - bits required for long mode
///     Pat - bits required for long mode
///
/// N.B. The state above reflects a processor already running in long mode. Entering long mode from
///     protected mode through code execution does not set the state above explicitly as some
///     settings are controlled by the processor.
///
/// During execution, the virtual processor will exit for the breakpoint trap and the register
/// state of rcx, rdx, rbx, r8, and r9 will be printed to the screen.
void LongMode(void)
{
    // Create a partition that supports a single processor and apic emulation.
    unique_whv_partition partition;
    THROW_IF_FAILED(WHvCreatePartition(&partition));
    const UINT32 processorCount = 1;
    const UINT32 processorIndex = 0;
    WHV_PARTITION_PROPERTY property{};
    property.ProcessorCount = processorCount;
    THROW_IF_FAILED(WHvSetPartitionProperty(partition.get(), WHvPartitionPropertyCodeProcessorCount, &property, sizeof(property)));
    property = {};
    property.LocalApicEmulationMode = WHvX64LocalApicEmulationModeXApic;
    THROW_IF_FAILED(WHvSetPartitionProperty(partition.get(), WHvPartitionPropertyCodeLocalApicEmulationMode, &property, sizeof(property)));

    // Enable exits on the breakpoint trap (int 3 instruction) for the purposes of this sample.
    property = {};
    property.ExtendedVmExits.ExceptionExit = 1;
    THROW_IF_FAILED(WHvSetPartitionProperty(partition.get(), WHvPartitionPropertyCodeExtendedVmExits, &property, sizeof(property)));
    property = {};
    property.ExceptionExitBitmap = 1ui64 << WHvX64ExceptionTypeBreakpointTrap;
    THROW_IF_FAILED(WHvSetPartitionProperty(partition.get(), WHvPartitionPropertyCodeExceptionExitBitmap, &property, sizeof(property)));

    // Setup the partition and create the virtual processor.
    THROW_IF_FAILED(WHvSetupPartition(partition.get()));
    THROW_IF_FAILED(WHvCreateVirtualProcessor(partition.get(), processorIndex, 0));

    // Allocate and map the address space of the partition with a single allocation. When possible,
    // multiple allocations and mappings should be coalesced as they require additional tracking
    // structures. The permissions of the individual pages are enforced by the allocation, the
    // mapping, and the guest's page table. In this sample the mapping is done with full
    // permissions so the permissions are determined by the allocation (host's page table) and the
    // guest's page table.
    const SIZE_T zeroPageSize = PageSize;
    const SIZE_T pageTableCount = 4;
    const SIZE_T pageTableSize = (pageTableCount * PageSize);
    const SIZE_T gdtSize = PageSize;
    const SIZE_T codeSize = PageSize;
    const SIZE_T addressSpaceSize = zeroPageSize + pageTableSize + gdtSize + codeSize;
    GuestAddressSpace addressSpace(partition.get(), addressSpaceSize);

    // Commit the zero page which is unused in this sample.
    addressSpace.CommitRange(zeroPageSize, PAGE_NOACCESS);

    // Setup the page tables for long mode. For the purposes of this sample, a simple identity
    // mapping is created for the first 2MB of the address space.
    const SIZE_T pageTableStart = zeroPageSize;
    // Page bits - present, read\write
    const uint64_t pageTableFlagsDefault = 0x3;
    uint64_t *pageTables = static_cast<uint64_t *>(addressSpace.CommitRange(pageTableSize, PAGE_READWRITE));

    // Initialize the first 3 levels of the page table - PML4, PDP, and PD.
    uint64_t *currentPageTableLevel = pageTables;
    uint64_t pageTableData = (pageTableStart + PageSize) | pageTableFlagsDefault;
    for (int pageTableIndex = 0; pageTableIndex < pageTableCount - 1; ++pageTableIndex) {
        *currentPageTableLevel = pageTableData;
        currentPageTableLevel += PageSize / sizeof(*currentPageTableLevel);
        pageTableData += PageSize;
    }

    // Initialize the last level of the page table - PT.
    const uint64_t pageTableFlagNx = 0x8000000000000000;
    pageTableData = pageTableFlagsDefault | pageTableFlagNx;
    uint64_t *pageTable = currentPageTableLevel;
    for (int pageIndex = 0; pageIndex < PageSize / sizeof(*pageTable); ++pageIndex) {
        pageTable[pageIndex] = pageTableData;
        pageTableData += PageSize;
    }

    // Setup the GDT for long mode. For the purposes of this sample, a simple GDT is created with
    // a NULL entry followed by a CS entry.
    const SIZE_T gdtStart = pageTableStart + pageTableSize;
    const SIZE_T gdtCount = 2;
    // GDT NULL entry
    const UINT64 gdtNullEntryValue = 0;
    const UINT64 gdtNullEntryIndex = 0;
    // GDT CS entry - page granularity, long, present, type code, execute\read\accessed
    const UINT16 csAttributes = 0xa09b;
    const UINT64 gdtCsEntryValue = ((UINT64)csAttributes << 20);
    const UINT64 gdtCsEntryIndex = 1;

    uint64_t *gdtPage = static_cast<uint64_t *>(addressSpace.CommitRange(gdtSize, PAGE_READWRITE));
    gdtPage[gdtNullEntryIndex] = gdtNullEntryValue;
    gdtPage[gdtCsEntryIndex] = gdtCsEntryValue;

    // Setup the code region and clear the Nx bit from the page table.
    const SIZE_T codeStart = gdtStart + gdtSize;
    const unsigned char code[] = {
        0x48, 0xc7, 0xc0, 'W', 0x00, 0x00, 0x00, // movq rax, 'W'
        0x48, 0xc7, 0xc1, 'H', 0x00, 0x00, 0x00, // movq rcx, 'H'
        0x48, 0xc7, 0xc2, 'v', 0x00, 0x00, 0x00, // movq rdx, 'v'
        0x48, 0xc7, 0xc3, '6', 0x00, 0x00, 0x00, // movq rbx, '6'
        0x49, 0xc7, 0xc0, '4', 0x00, 0x00, 0x00, // movq r8, '4'
        0x49, 0xc7, 0xc1, '!', 0x00, 0x00, 0x00, // movq r9, '!'
        0xcc,      // int 3
        0xf4       // hlt
    };

    uint64_t *codePage = static_cast<uint64_t *>(addressSpace.CommitRange(codeSize, PAGE_READWRITE));
    static_assert(sizeof(code) <= codeSize, "Code size does not overflow the code region.");
    memcpy(codePage, code, sizeof(code));
    static_assert(codeSize == PageSize, "Code size is a single page.");
    pageTable[codeStart / PageSize] &= ~pageTableFlagNx;

    // Set the initial virtual processor state.
    // Cs limit (base is forced to 0 for long mode)
    const UINT32 csLimit = 0xFFFFFFFF;
    // CR0 bits - PG and PE
    const UINT32 cr0 = 0x80000001;
    // CR4 bits - PAE
    const UINT32 cr4 = 0x20;
    // EFER bits - NXE, LMA, LME
    const UINT32 efer = 0xD00;
    // PAT bits - after reset (default) value.
    const uint64_t pat = 0x0007040600070406UI64;

    WHV_REGISTER_NAME initialNames[] = {WHvX64RegisterRip,
                                        WHvX64RegisterCs,
                                        WHvX64RegisterGdtr,
                                        WHvX64RegisterCr0,
                                        WHvX64RegisterCr3,
                                        WHvX64RegisterCr4,
                                        WHvX64RegisterEfer,
                                        WHvX64RegisterPat};

    WHV_REGISTER_VALUE initialValues[_countof(initialNames)] = {};
    initialValues[0].Reg64 = codeStart;
    initialValues[1].Segment.Base = 0;
    initialValues[1].Segment.Limit = csLimit;
    initialValues[1].Segment.Selector = gdtCsEntryIndex * sizeof(*gdtPage);
    initialValues[1].Segment.Attributes = csAttributes;
    initialValues[2].Table.Base = gdtStart;
    initialValues[2].Table.Limit = (gdtCount * sizeof(*gdtPage)) - 1;
    initialValues[3].Reg64 = cr0;
    initialValues[4].Reg64 = pageTableStart;
    initialValues[5].Reg64 = cr4;
    initialValues[6].Reg64 = efer;
    initialValues[7].Reg64 = pat;

    THROW_IF_FAILED(WHvSetVirtualProcessorRegisters(partition.get(), processorIndex, initialNames, _countof(initialNames), initialValues));

    // Run the virtual processor until the int 3 instruction is hit in the long mode code segment
    // region.
    for (;;) {
        WHV_RUN_VP_EXIT_CONTEXT exitContext = {};
        THROW_IF_FAILED(WHvRunVirtualProcessor(partition.get(), 0, &exitContext, sizeof(exitContext)));
        printf("Exit reason %d\n", exitContext.ExitReason);
        if (exitContext.ExitReason == WHvRunVpExitReasonException &&
            exitContext.VpException.ExceptionType == WHvX64ExceptionTypeBreakpointTrap) {

            printf("Breakpoint trap (int 3) detected\n");

            // Display the contents of the registers set by the code sequence.
            WHV_REGISTER_NAME names[] = {WHvX64RegisterRax,
                                         WHvX64RegisterRcx,
                                         WHvX64RegisterRdx,
                                         WHvX64RegisterRbx,
                                         WHvX64RegisterR8,
                                         WHvX64RegisterR9};

            WHV_REGISTER_VALUE values[_countof(names)] = {};
            THROW_IF_FAILED(WHvGetVirtualProcessorRegisters(partition.get(), processorIndex, names, _countof(names), values));
            std::string message;
            for (auto& value : values)
            {
                message.push_back(value.Reg8);
            }

            printf("Message from virtual processor %s\n", message.c_str());
            break;
        }
    }

    return;
}

/// Sample demonstrating executing code on a virtual processor in real mode (16 bit). A partition
/// with a single virtual processor is created and configured to execute a code sequence that loads
/// registers al, cl, dl, and bl wit the byte values of 'W', 'H', 'v', '!' followed by a breakpoint
/// trap. During execution, the virtual processor will exit for the breakpoint trap and the
/// register state of al, cl, dl, and bl will be printed to the screen.
void RealMode(void)
{
    // Create a partition that supports a single processor and apic emulation.
    unique_whv_partition partition;
    THROW_IF_FAILED(WHvCreatePartition(&partition));
    const UINT32 processorCount = 1;
    const UINT32 processorIndex = 0;
    WHV_PARTITION_PROPERTY property{};
    property.ProcessorCount = processorCount;
    THROW_IF_FAILED(WHvSetPartitionProperty(partition.get(), WHvPartitionPropertyCodeProcessorCount, &property, sizeof(property)));
    property = {};
    property.LocalApicEmulationMode = WHvX64LocalApicEmulationModeXApic;
    THROW_IF_FAILED(WHvSetPartitionProperty(partition.get(), WHvPartitionPropertyCodeLocalApicEmulationMode, &property, sizeof(property)));

    // Enable exits on the breakpoint trap (int 3 instruction) for the purposes of this sample.
    property = {};
    property.ExtendedVmExits.ExceptionExit = 1;
    THROW_IF_FAILED(WHvSetPartitionProperty(partition.get(), WHvPartitionPropertyCodeExtendedVmExits, &property, sizeof(property)));
    property = {};
    property.ExceptionExitBitmap = 1ull << WHvX64ExceptionTypeBreakpointTrap;
    THROW_IF_FAILED(WHvSetPartitionProperty(partition.get(), WHvPartitionPropertyCodeExceptionExitBitmap, &property, sizeof(property)));

    // Setup the partition and create the virtual processor.
    THROW_IF_FAILED(WHvSetupPartition(partition.get()));
    THROW_IF_FAILED(WHvCreateVirtualProcessor(partition.get(), processorIndex, 0));

    // Create and map the real mode code region.
    // N.B. The real mode sample only requires a single committed page from the region. Additional
    // pages can be committed if needed.
    const WHV_GUEST_PHYSICAL_ADDRESS codeSize = PageSize;
    const WHV_GUEST_PHYSICAL_ADDRESS codeStart = 4096;
    const unsigned char code[] = {
        0xb0, 'W', // mov al, 'W'
        0xb1, 'H', // mov cl, 'H'
        0xb2, 'v', // mov dl, 'v'
        0xb3, '!', // mov bl, '!'
        0xcc,      // int 3
        0xf4       // hlt
    };

    wil::unique_virtualalloc_ptr<void> codeRegion{ VirtualAlloc(nullptr, codeSize , MEM_COMMIT, PAGE_READWRITE) };
    THROW_LAST_ERROR_IF(!codeRegion);
    static_assert(sizeof(code) <= codeSize, "Code size does not overflow the code region.");
    memcpy(codeRegion.get(), code, sizeof(code));
    // N.B. Page protections are specified in the allocation, the guest mapping, and the guest CS segment.
    const WHV_MAP_GPA_RANGE_FLAGS GpaRangeFlags = WHvMapGpaRangeFlagRead | WHvMapGpaRangeFlagExecute;
    THROW_IF_FAILED(WHvMapGpaRange(partition.get(), codeRegion.get(), codeStart, codeSize, GpaRangeFlags));

    // Set the virtual processor register state to execute in the real mode code region.
    WHV_REGISTER_NAME initialNames[] = {WHvX64RegisterCs, WHvX64RegisterRip};
    WHV_REGISTER_VALUE initialValues[_countof(initialNames)] = {};

    // CS attribute bits - present, type code, execute\read\accessed
    const UINT16 csAttributes = 0x9b;
    initialValues[0].Segment.Base = codeStart;
    initialValues[0].Segment.Limit = codeSize;
    initialValues[0].Segment.Attributes = csAttributes;
    // Rip is offset from CS base.
    initialValues[1].Reg64 = 0;

    THROW_IF_FAILED(WHvSetVirtualProcessorRegisters(partition.get(), processorIndex, initialNames, _countof(initialNames), initialValues));

    // Run the virtual processor until the int 3 instruction is hit in the real mode code segment region.
    for (;;) {
        WHV_RUN_VP_EXIT_CONTEXT exitContext = {};
        THROW_IF_FAILED(WHvRunVirtualProcessor(partition.get(), 0, &exitContext, sizeof(exitContext)));
        printf("Exit reason %d\n", exitContext.ExitReason);
        if (exitContext.ExitReason == WHvRunVpExitReasonException &&
            exitContext.VpException.ExceptionType == WHvX64ExceptionTypeBreakpointTrap) {

            printf("Breakpoint trap (int 3) detected\n");

            // Display the contents of the registers set by the code sequence.
            WHV_REGISTER_NAME names[] = {WHvX64RegisterRax, WHvX64RegisterRcx, WHvX64RegisterRdx, WHvX64RegisterRbx};
            WHV_REGISTER_VALUE values[_countof(names)] = {};
            THROW_IF_FAILED(WHvGetVirtualProcessorRegisters(partition.get(), processorIndex, names, _countof(names), values));
            std::string message;
            for (auto& value : values)
            {
                message.push_back(value.Reg8);
            }

            printf("Message from virtual processor %s\n", message.c_str());
            break;
        }
    }

    return;
}

} // namespace WHvSample

// Entry point for sample
int __cdecl wmain(int argc, wchar_t **argv)
try
{
    UNREFERENCED_PARAMETER(argc);
    UNREFERENCED_PARAMETER(argv);

    printf("Initializing...:\n");
    WHvSample::Initialize();

    // Execute the real mode sample
    printf("Real mode:\n");
    WHvSample::RealMode();

    // Execute the long mode sample
    printf("Long mode:\n");
    WHvSample::LongMode();

    return 0;
}
catch (std::exception& e)
{
    fprintf(stderr, "ERROR: %s\n", e.what());
    return 1;
}

