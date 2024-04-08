/*++

Copyright (c) Microsoft Corporation.  All rights reserved.

Module Name:

    WinHvSampleArm64.cpp

Abstract:

    This module contains samples for the Windows Hypervisor User-Mode APIs on Arm64.

--*/

#include <windows.h>
#include <winhvplatform.h>
#include <exception>
#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <wil/result.h>
#include <wil/resource.h>

// Sample code
namespace WHvSample {

    using unique_whv_partition =
        wil::unique_any<WHV_PARTITION_HANDLE, decltype(&WHvDeletePartition), WHvDeletePartition>;

    const SIZE_T PageSize = 0x1000;

    /// Sample demonstrating executing code on a virtual processor. A partition
    /// with a single virtual processor is created and configured to execute a code sequence that loads
    /// registers x0, x1, x2, and x3 with the byte values of 'W', 'H', 'v', '!' followed by a branch to
    /// an invalid address. During execution, the virtual processor will exit for the invalid address and
    /// the register state of x0, x1, x2, and x3 will be printed to the screen.
    void Run(void)
    {
        // Create a partition that supports a single processor.
        unique_whv_partition partition;
        THROW_IF_FAILED(WHvCreatePartition(&partition));
        const UINT32 processorCount = 1;
        const UINT32 processorIndex = 0;
        WHV_PARTITION_PROPERTY property{};
        property.ProcessorCount = processorCount;
        THROW_IF_FAILED(WHvSetPartitionProperty(partition.get(), WHvPartitionPropertyCodeProcessorCount, &property, sizeof(property)));

        // Setup the partition and create the virtual processor.
        THROW_IF_FAILED(WHvSetupPartition(partition.get()));
        THROW_IF_FAILED(WHvCreateVirtualProcessor(partition.get(), processorIndex, 0));

        // Create and map the code region.
        // N.B. The sample only requires a single committed page from the region. Additional pages can be committed if needed.
        const WHV_GUEST_PHYSICAL_ADDRESS codeSize = PageSize;
        const WHV_GUEST_PHYSICAL_ADDRESS codeStart = 4096;
        const unsigned char code[] = {
            0xe0, 0x0a, 0x80, 0xd2, // mov x0, #'W'
            0x01, 0x09, 0x80, 0xd2, // mov x1, #'H'
            0xc2, 0x0e, 0x80, 0xd2, // mov x2, #'v'
            0x23, 0x04, 0x80, 0xd2, // mov x3, #'!'
            0x00, 0x00, 0x30, 0x14, // b #0x300000
        };

        wil::unique_virtualalloc_ptr<void> codeRegion{ VirtualAlloc(nullptr, codeSize , MEM_COMMIT, PAGE_READWRITE) };
        THROW_LAST_ERROR_IF(!codeRegion);
        static_assert(sizeof(code) <= codeSize, "Code size does not overflow the code region.");
        memcpy(codeRegion.get(), code, sizeof(code));
        // N.B. Page protections are specified in the allocation and the guest mapping.
        const WHV_MAP_GPA_RANGE_FLAGS GpaRangeFlags = WHvMapGpaRangeFlagRead | WHvMapGpaRangeFlagExecute;
        THROW_IF_FAILED(WHvMapGpaRange(partition.get(), codeRegion.get(), codeStart, codeSize, GpaRangeFlags));

        // Set the virtual processor register state to execute in the code region.
        WHV_REGISTER_NAME initialNames[] = { WHvArm64RegisterPc };
        WHV_REGISTER_VALUE initialValues[_countof(initialNames)] = { codeStart };

        THROW_IF_FAILED(WHvSetVirtualProcessorRegisters(partition.get(), processorIndex, initialNames, _countof(initialNames), initialValues));

        // Run the virtual processor until the code branches to an invalid address.
        for (;;) {
            WHV_RUN_VP_EXIT_CONTEXT exitContext = {};
            THROW_IF_FAILED(WHvRunVirtualProcessor(partition.get(), 0, &exitContext, sizeof(exitContext)));
            printf("Exit reason %d\n", exitContext.ExitReason);
            if (exitContext.ExitReason == WHvRunVpExitReasonUnmappedGpa) {
                printf("Memory access exit detected\n");

                // Display the contents of the registers set by the code sequence.
                WHV_REGISTER_NAME names[] = { WHvArm64RegisterX0, WHvArm64RegisterX1, WHvArm64RegisterX2, WHvArm64RegisterX3 };
                WHV_REGISTER_VALUE values[_countof(names)] = {};
                THROW_IF_FAILED(WHvGetVirtualProcessorRegisters(partition.get(), processorIndex, names, _countof(names), values));
                std::string message;
                for (auto& value : values)
                {
                    message.push_back(value.Reg8);
                }

                printf("Message from virtual processor: %s\n", message.c_str());
                break;
            }
        }

        return;
    }

} // namespace WHvSample

// Entry point for sample
int __cdecl wmain(int argc, wchar_t** argv)
try
{
    UNREFERENCED_PARAMETER(argc);
    UNREFERENCED_PARAMETER(argv);

    // Execute the sample
    printf("Running sample:\n");
    WHvSample::Run();

    return 0;
}
catch (const std::exception& e)
{
    fprintf(stderr, "ERROR: %s\n", e.what());
    return 1;
}
