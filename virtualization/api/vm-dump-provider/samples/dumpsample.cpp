#include "stdafx.h" 
#include "VmSavedStateDump.h" 
#include <vector> 
 
// 
// Helper macros 
// 
 
#define PASTE(x, y) x##y 
#define MAKEWIDE(x) PASTE(L,x) 
 
#define RETURN_IF_FAILED_VMSAVEDSTATEDUMP_API(_API_, _Handle_, ...) \ 
    do                                                              \ 
    {                                                               \ 
        HRESULT hr = _API_(_Handle_, __VA_ARGS__);                  \ 
        if (hr != S_OK)                                             \ 
        {                                                           \ 
            wprintf(L"Failed to call %ws!", MAKEWIDE(#_API_));      \ 
            return ::ReleaseSavedStateFiles(_Handle_);              \ 
        }                                                           \ 
    } while(false)                                                  \ 
 
// 
// Enumerations defined in VmSavedStateDumpDefs.h to wide string 
// 
 
constexpr PCWSTR PagingModeToWString[] = 
{ 
    L"Invalid", 
    L"NonPaged", 
    L"32Bit", 
    L"PhysicalAddressExtension", 
    L"Long", 
}; 
 
constexpr PCWSTR x86GuestRegisterToWString[] = 
{ 
    L"Eax", 
    L"Ecx", 
    L"Edx", 
    L"Ebx", 
    L"Esp", 
    L"Ebp", 
    L"Esi", 
    L"Edi", 
    L"Eip", 
    L"EFlags", 
    L"LowXmm0", 
    L"HighXmm0", 
    L"LowXmm1", 
    L"HighXmm1", 
    L"LowXmm2", 
    L"HighXmm2", 
    L"LowXmm3", 
    L"HighXmm3", 
    L"LowXmm4", 
    L"HighXmm4", 
    L"LowXmm5", 
    L"HighXmm5", 
    L"LowXmm6", 
    L"HighXmm6", 
    L"LowXmm7", 
    L"HighXmm7", 
    L"LowXmm8", 
    L"HighXmm8", 
    L"LowXmm9", 
    L"HighXmm9", 
    L"LowXmm10", 
    L"HighXmm10", 
    L"LowXmm11", 
    L"HighXmm11", 
    L"LowXmm12", 
    L"HighXmm12", 
    L"LowXmm13", 
    L"HighXmm13", 
    L"LowXmm14", 
    L"HighXmm14", 
    L"LowXmm15", 
    L"HighXmm15", 
    L"LowXmmControlStatus", 
    L"HighXmmControlStatus", 
    L"LowXmmFpControlStatus", 
    L"HighXmmFpControlStatus", 
    L"Cr0", 
    L"Cr2", 
    L"Cr3", 
    L"Cr4", 
    L"Cr8", 
    L"Efer", 
    L"Dr0", 
    L"Dr1", 
    L"Dr2", 
    L"Dr3", 
    L"Dr6", 
    L"Dr7", 
    L"BaseGs", 
    L"BaseFs", 
    L"SegCs", 
    L"SegDs", 
    L"SegEs", 
    L"SegFs", 
    L"SegGs", 
    L"SegSs", 
    L"Tr", 
    L"Ldtr", 
    L"BaseIdtr", 
    L"LimitIdtr", 
    L"BaseGdtr", 
    L"LimitGdtr", 
}; 
 
constexpr PCWSTR x64GuestRegisterToWString[] = 
{ 
    L"Rax", 
    L"Rcx", 
    L"Rdx", 
    L"Rbx", 
    L"Rsp", 
    L"Rbp", 
    L"Rsi", 
    L"Rdi", 
    L"R8", 
    L"R9", 
    L"R10", 
    L"R11", 
    L"R12", 
    L"R13", 
    L"R14", 
    L"R15", 
    L"Rip", 
    L"RFlags", 
    L"LowXmm0", 
    L"HighXmm0", 
    L"LowXmm1", 
    L"HighXmm1", 
    L"LowXmm2", 
    L"HighXmm2", 
    L"LowXmm3", 
    L"HighXmm3", 
    L"LowXmm4", 
    L"HighXmm4", 
    L"LowXmm5", 
    L"HighXmm5", 
    L"LowXmm6", 
    L"HighXmm6", 
    L"LowXmm7", 
    L"HighXmm7", 
    L"LowXmm8", 
    L"HighXmm8", 
    L"LowXmm9", 
    L"HighXmm9", 
    L"LowXmm10", 
    L"HighXmm10", 
    L"LowXmm11", 
    L"HighXmm11", 
    L"LowXmm12", 
    L"HighXmm12", 
    L"LowXmm13", 
    L"HighXmm13", 
    L"LowXmm14", 
    L"HighXmm14", 
    L"LowXmm15", 
    L"HighXmm15", 
    L"LowXmmControlStatus", 
    L"HighXmmControlStatus", 
    L"LowXmmFpControlStatus", 
    L"HighXmmFpControlStatus", 
    L"Cr0", 
    L"Cr2", 
    L"Cr3", 
    L"Cr4", 
    L"Cr8", 
    L"Efer", 
    L"Dr0", 
    L"Dr1", 
    L"Dr2", 
    L"Dr3", 
    L"Dr6", 
    L"Dr7", 
    L"BaseGs", 
    L"BaseFs", 
    L"SegCs", 
    L"SegDs", 
    L"SegEs", 
    L"SegFs", 
    L"SegGs", 
    L"SegSs", 
    L"Tr", 
    L"Ldtr", 
    L"BaseIdtr", 
    L"LimitIdtr", 
    L"BaseGdtr", 
    L"LimitGdtr", 
}; 
 
 
// 
// Main 
// 
int wmain(int ArgC, wchar_t *ArgV[]) 
{ 
    if (ArgC != 2) 
    { 
        wprintf(L"Usage: VmSavedStateDumpProvider_ExampleProject.exe " 
            L"<VMRS file path>"); 
        return -1; 
    } 
 
    VM_SAVED_STATE_DUMP_HANDLE vmssdHandle; 
    if (::LoadSavedStateFile(ArgV[1], &vmssdHandle) != S_OK) 
    { 
        wprintf(L"Failed to load saved state file."); 
        return E_FAIL; 
    } 
    wprintf(L"Successfully loaded saved state file."); 
    wprintf(L"\n\n"); 
 
    UINT64 rawSavedMemorySize; 
    RETURN_IF_FAILED_VMSAVEDSTATEDUMP_API(::GetGuestRawSavedMemorySize, vmssdHandle, &rawSavedMemorySize); 
    wprintf(L"Raw Saved Memory Size: %I64u bytes", rawSavedMemorySize); 
    wprintf(L"\n\n"); 
 
    std::vector<GPA_MEMORY_CHUNK> memoryChunks; 
    UINT64 pageSize; 
    UINT64 memoryChunkCount; 
    if (::GetGuestPhysicalMemoryChunks(vmssdHandle, &pageSize, memoryChunks.data(), &memoryChunkCount) != S_OK) 
    { 
        memoryChunks.resize(memoryChunkCount); 
    } 
    RETURN_IF_FAILED_VMSAVEDSTATEDUMP_API(::GetGuestPhysicalMemoryChunks, vmssdHandle, &pageSize, memoryChunks.data(), &memoryChunkCount); 
 
    UINT64 i = 0; 
    for (const auto& memoryChunk : memoryChunks) 
    { 
        wprintf(L"Memory Chunk %I64u:\nGuestPhysicalStartPageIndex: %I64u\nPageCount: %I64u\n", 
            ++i, memoryChunk.GuestPhysicalStartPageIndex, memoryChunk.PageCount); 
    } 
    wprintf(L"\n"); 
 
    UINT32 vpCount; 
    RETURN_IF_FAILED_VMSAVEDSTATEDUMP_API(::GetVpCount, vmssdHandle, &vpCount); 
    wprintf(L"Virtual Processor Count: %u", vpCount); 
    wprintf(L"\n\n"); 
 
    for (UINT32 vpId = 0; vpId < vpCount; ++vpId) 
    { 
        wprintf(L"Virtual processor %u information", vpId); 
        wprintf(L"\n\n"); 
 
        PAGING_MODE pagingMode; 
        RETURN_IF_FAILED_VMSAVEDSTATEDUMP_API(::GetPagingMode, vmssdHandle, vpId, &pagingMode); 
        wprintf(L"VP Paging Mode: %ws", PagingModeToWString[pagingMode]); 
        wprintf(L"\n\n"); 
 
        VIRTUAL_PROCESSOR_ARCH architecture; 
        RETURN_IF_FAILED_VMSAVEDSTATEDUMP_API(::GetArchitecture, vmssdHandle, vpId, &architecture); 
        wprintf(L"VP Architecture %ws", architecture == Arch_x64 ? L"x64" : L"x86"); 
        wprintf(L"\n\n"); 
 
        VIRTUAL_PROCESSOR_REGISTER reg; 
        reg.Architecture = architecture; 
        DWORD registerCount = architecture == Arch_x64 ? X64_RegisterCount : X86_RegisterCount; 
 
        for (DWORD currentRegister = 0; currentRegister < registerCount; ++currentRegister) 
        { 
            RETURN_IF_FAILED_VMSAVEDSTATEDUMP_API(::GetRegisterValue, 
                vmssdHandle, vpId, &reg); 
            wprintf(L"Register %ws: %I64u\n", architecture == Arch_x64 ?  
                x64GuestRegisterToWString[currentRegister] : x86GuestRegisterToWString[currentRegister], reg.RegisterValue); 
        } 
    } 
    wprintf(L"\n"); 
 
    return ReleaseSavedStateFiles(vmssdHandle); 
} 