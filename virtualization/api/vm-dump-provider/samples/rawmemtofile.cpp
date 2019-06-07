#include "stdafx.h" 
#include "VmSavedStateDump.h" 
#include <iostream> 
#include <fstream> 
#include <memory> 
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
// Main 
// 
int wmain(int ArgC, wchar_t *ArgV[]) 
{ 
    if (ArgC != 3) 
    { 
        wprintf(L"Usage: VmSavedStateDumpProvider_ExampleProject.exe " 
            L"<VMRS file path> <Binary Output file path>"); 
        return -1; 
    } 
 
    VM_SAVED_STATE_DUMP_HANDLE vmssdHandle; 
     
    if (::LoadSavedStateFile(ArgV[1], &vmssdHandle) != S_OK) 
    { 
        wprintf(L"Failed to load saved state file :("); 
        return E_FAIL; 
    } 
    wprintf(L"Successfully loaded saved state file :)"); 
    wprintf(L"\n\n"); 
 
    UINT64 guestRawSavedMemorySize; 
    constexpr UINT32 memoryBufferSize = 2048 * 1024; 
    RETURN_IF_FAILED_VMSAVEDSTATEDUMP_API(::GetGuestRawSavedMemorySize, vmssdHandle, &guestRawSavedMemorySize); 
    wprintf(L"Dumping raw memory (reading %I64u bytes in chunks of %u) ", 
        guestRawSavedMemorySize, memoryBufferSize); 
 
    std::vector<BYTE> rawMemoryBuffer(memoryBufferSize); 
    std::ofstream file; 
    file.open(ArgV[2]); 
 
    UINT64 bytesReadSoFar = 0; 
    bool finished = false; 
    while (!finished) 
    { 
        UINT32 bytesRead; 
        if(FAILED(::ReadGuestRawSavedMemory(vmssdHandle, bytesReadSoFar, rawMemoryBuffer.data(), memoryBufferSize, &bytesRead))) 
        { 
            file.close(); 
            return ::ReleaseSavedStateFiles(vmssdHandle); 
        } 
 
        bytesReadSoFar += bytesRead; 
        finished = (bytesRead != memoryBufferSize) || (bytesReadSoFar >= guestRawSavedMemorySize); 
 
        // Write read buffer to binary file 
        file << rawMemoryBuffer.data(); 
        wprintf(L"."); 
    } 
 
    file.close(); 
    return ::ReleaseSavedStateFiles(vmssdHandle); 
} 