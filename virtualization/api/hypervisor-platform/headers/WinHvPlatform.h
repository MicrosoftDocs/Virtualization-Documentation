// Copyright 2025 Microsoft

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#ifndef _WINHVAPI_H_
#define _WINHVAPI_H_

#if defined(_MSC_VER) && (_MSC_VER >= 1200)
#pragma once
#endif

#include <apiset.h>
#include <apisetcconv.h>
#include <minwindef.h>
#include <winapifamily.h>

#pragma region Desktop Family or OneCore Family
#if WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)

#include <WinHvPlatformDefs.h>

#ifdef __cplusplus
extern "C" {
#endif

//
// Platform capabilities
//

HRESULT
WINAPI
WHvGetCapability(
    _In_ WHV_CAPABILITY_CODE CapabilityCode,
    _Out_writes_bytes_to_(CapabilityBufferSizeInBytes,*WrittenSizeInBytes) VOID* CapabilityBuffer,
    _In_ UINT32 CapabilityBufferSizeInBytes,
    _Out_opt_ UINT32* WrittenSizeInBytes
    );


HRESULT
WINAPI
WHvCreatePartition(
    _Out_ WHV_PARTITION_HANDLE* Partition
    );


HRESULT
WINAPI
WHvSetupPartition(
    _In_ WHV_PARTITION_HANDLE Partition
    );


HRESULT
WINAPI
WHvDeletePartition(
    _In_ WHV_PARTITION_HANDLE Partition
    );


HRESULT
WINAPI
WHvGetPartitionProperty(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ WHV_PARTITION_PROPERTY_CODE PropertyCode,
    _Out_writes_bytes_to_(PropertyBufferSizeInBytes,*WrittenSizeInBytes) VOID* PropertyBuffer,
    _In_ UINT32 PropertyBufferSizeInBytes,
    _Out_opt_ UINT32* WrittenSizeInBytes
    );


HRESULT
WINAPI
WHvSetPartitionProperty(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ WHV_PARTITION_PROPERTY_CODE PropertyCode,
    _In_reads_bytes_(PropertyBufferSizeInBytes) const VOID* PropertyBuffer,
    _In_ UINT32 PropertyBufferSizeInBytes
    );


HRESULT
WINAPI
WHvSuspendPartitionTime(
    _In_ WHV_PARTITION_HANDLE Partition
    );


HRESULT
WINAPI
WHvResumePartitionTime(
    _In_ WHV_PARTITION_HANDLE Partition
    );


//
// Memory Management
//

HRESULT
WINAPI
WHvMapGpaRange(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ VOID* SourceAddress,
    _In_ WHV_GUEST_PHYSICAL_ADDRESS GuestAddress,
    _In_ UINT64 SizeInBytes,
    _In_ WHV_MAP_GPA_RANGE_FLAGS Flags
    );


HRESULT
WINAPI
WHvUnmapGpaRange(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ WHV_GUEST_PHYSICAL_ADDRESS GuestAddress,
    _In_ UINT64 SizeInBytes
    );


HRESULT
WINAPI
WHvTranslateGva(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_ WHV_GUEST_VIRTUAL_ADDRESS Gva,
    _In_ WHV_TRANSLATE_GVA_FLAGS TranslateFlags,
    _Out_ WHV_TRANSLATE_GVA_RESULT* TranslationResult,
    _Out_ WHV_GUEST_PHYSICAL_ADDRESS* Gpa
    );


//
// Virtual Processors
//

HRESULT
WINAPI
WHvCreateVirtualProcessor(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_ UINT32 Flags
    );


HRESULT
WINAPI
WHvDeleteVirtualProcessor(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex
    );


HRESULT
WINAPI
WHvRunVirtualProcessor(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _Out_writes_bytes_(ExitContextSizeInBytes) VOID* ExitContext,
    _In_ UINT32 ExitContextSizeInBytes
    );


HRESULT
WINAPI
WHvCancelRunVirtualProcessor(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_ UINT32 Flags
    );


HRESULT
WINAPI
WHvGetVirtualProcessorRegisters(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_reads_(RegisterCount) const WHV_REGISTER_NAME* RegisterNames,
    _In_ UINT32 RegisterCount,
    _Out_writes_(RegisterCount) WHV_REGISTER_VALUE* RegisterValues
    );


HRESULT
WINAPI
WHvSetVirtualProcessorRegisters(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_reads_(RegisterCount) const WHV_REGISTER_NAME* RegisterNames,
    _In_ UINT32 RegisterCount,
    _In_reads_(RegisterCount) const WHV_REGISTER_VALUE* RegisterValues
    );


#if defined(NTDDI_VERSION) && (NTDDI_VERSION >= NTDDI_WIN10_VB)
#pragma deprecated("WHvGetVirtualProcessorInterruptControllerState is deprecated; use WHvGetVirtualProcessorInterruptControllerState2")
#endif
HRESULT
WINAPI
WHvGetVirtualProcessorInterruptControllerState(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _Out_writes_bytes_to_(StateSize,*WrittenSize) VOID* State,
    _In_ UINT32 StateSize,
    _Out_opt_ UINT32* WrittenSize
    );


#if defined(NTDDI_VERSION) && (NTDDI_VERSION >= NTDDI_WIN10_VB)
#pragma deprecated("WHvSetVirtualProcessorInterruptControllerState is deprecated; use WHvSetVirtualProcessorInterruptControllerState2")
#endif
HRESULT
WINAPI
WHvSetVirtualProcessorInterruptControllerState(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_reads_bytes_(StateSize) const VOID* State,
    _In_ UINT32 StateSize
    );


HRESULT
WINAPI
WHvRequestInterrupt(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ const WHV_INTERRUPT_CONTROL* Interrupt,
    _In_ UINT32 InterruptControlSize
    );


HRESULT
WINAPI
WHvGetVirtualProcessorXsaveState(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _Out_writes_bytes_to_(BufferSizeInBytes,*BytesWritten) VOID* Buffer,
    _In_ UINT32 BufferSizeInBytes,
    _Out_ UINT32* BytesWritten
    );


HRESULT
WINAPI
WHvSetVirtualProcessorXsaveState(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_reads_bytes_(BufferSizeInBytes) const VOID* Buffer,
    _In_ UINT32 BufferSizeInBytes
    );


HRESULT
WINAPI
WHvQueryGpaRangeDirtyBitmap(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ WHV_GUEST_PHYSICAL_ADDRESS GuestAddress,
    _In_ UINT64 RangeSizeInBytes,
    _Out_writes_bytes_to_opt_(BitmapSizeInBytes,RangeSizeInBytes / 4096 / 64) UINT64* Bitmap,
    _In_ UINT32 BitmapSizeInBytes
    );


HRESULT
WINAPI
WHvGetPartitionCounters(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ WHV_PARTITION_COUNTER_SET CounterSet,
    _Out_writes_bytes_to_(BufferSizeInBytes,*BytesWritten) VOID* Buffer,
    _In_ UINT32 BufferSizeInBytes,
    _Out_opt_ UINT32* BytesWritten
    );


HRESULT
WINAPI
WHvGetVirtualProcessorCounters(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_ WHV_PROCESSOR_COUNTER_SET CounterSet,
    _Out_writes_bytes_to_(BufferSizeInBytes,*BytesWritten) VOID* Buffer,
    _In_ UINT32 BufferSizeInBytes,
    _Out_opt_ UINT32* BytesWritten
    );


HRESULT
WINAPI
WHvGetVirtualProcessorInterruptControllerState2(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _Out_writes_bytes_to_(StateSize,*WrittenSize) VOID* State,
    _In_ UINT32 StateSize,
    _Out_opt_ UINT32* WrittenSize
    );


HRESULT
WINAPI
WHvSetVirtualProcessorInterruptControllerState2(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ UINT32 VpIndex,
    _In_reads_bytes_(StateSize) const VOID* State,
    _In_ UINT32 StateSize
    );


HRESULT
WINAPI
WHvRegisterPartitionDoorbellEvent(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ const WHV_DOORBELL_MATCH_DATA* MatchData,
    _In_ HANDLE EventHandle
    );


HRESULT
WINAPI
WHvUnregisterPartitionDoorbellEvent(
    _In_ WHV_PARTITION_HANDLE Partition,
    _In_ const WHV_DOORBELL_MATCH_DATA* MatchData
    );


#ifdef __cplusplus
}
#endif

#endif // WINAPI_FAMILY_PARTITION(WINAPI_PARTITION_DESKTOP | WINAPI_PARTITION_SYSTEM)
#pragma endregion

#endif // _WINHVAPI_H_





#ifndef ext_ms_win_hyperv_hvplatform_l1_1_3_query_routines
#define ext_ms_win_hyperv_hvplatform_l1_1_3_query_routines



//
//Private Extension API Query Routines
//

#ifdef __cplusplus
extern "C" {
#endif

BOOLEAN
__stdcall
IsWHvGetCapabilityPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvCreatePartitionPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvSetupPartitionPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvDeletePartitionPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvGetPartitionPropertyPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvSetPartitionPropertyPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvSuspendPartitionTimePresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvResumePartitionTimePresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvMapGpaRangePresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvUnmapGpaRangePresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvTranslateGvaPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvCreateVirtualProcessorPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvDeleteVirtualProcessorPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvRunVirtualProcessorPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvCancelRunVirtualProcessorPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvGetVirtualProcessorRegistersPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvSetVirtualProcessorRegistersPresent(
    VOID
    );

#if defined(NTDDI_VERSION) && (NTDDI_VERSION >= NTDDI_WIN10_VB)


#endif


BOOLEAN
__stdcall
IsWHvGetVirtualProcessorInterruptControllerStatePresent(
    VOID
    );

#if defined(NTDDI_VERSION) && (NTDDI_VERSION >= NTDDI_WIN10_VB)


#endif


BOOLEAN
__stdcall
IsWHvSetVirtualProcessorInterruptControllerStatePresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvRequestInterruptPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvGetVirtualProcessorXsaveStatePresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvSetVirtualProcessorXsaveStatePresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvQueryGpaRangeDirtyBitmapPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvGetPartitionCountersPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvGetVirtualProcessorCountersPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvGetVirtualProcessorInterruptControllerState2Present(
    VOID
    );

BOOLEAN
__stdcall
IsWHvSetVirtualProcessorInterruptControllerState2Present(
    VOID
    );

BOOLEAN
__stdcall
IsWHvRegisterPartitionDoorbellEventPresent(
    VOID
    );

BOOLEAN
__stdcall
IsWHvUnregisterPartitionDoorbellEventPresent(
    VOID
    );

#ifdef __cplusplus
}
#endif

#endif // endof guard

