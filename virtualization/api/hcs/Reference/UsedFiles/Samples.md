# HCS Sample - mamezgeb-hcs branch

The following sample code demonstrates the usage of the Hyper-V Host Compute System API

```
#define NOMINMAX

#include <ComputeCore.h>
#include <rpc.h>
#include <sstream>

/// Formats a UNICODE string.
inline
void
FormatStringV(
    _Inout_ std::wstring &DestinationString,
    _Printf_format_string_ LPCWSTR FormatString,
    _In_ va_list Arguments
    )
{
    size_t length = ::_vscwprintf(FormatString, Arguments);
    DestinationString.resize(length);
    if (-1 == ::vswprintf_s(&DestinationString[0], length + 1, FormatString, Arguments))
    {
        throw E_INVALIDARG;
    }
}

/// Formats a UNICODE string.
inline
void
FormatString(
    _Inout_ std::wstring &DestinationString,
    _Printf_format_string_ LPCWSTR FormatString,
    ...
    )
{
    va_list vaList;
    va_start(vaList, FormatString);
    FormatStringV(DestinationString, FormatString, vaList);
    va_end(vaList);
}

/// Converts an ANSI string to UNICODE.
std::wstring
ConvertAnsiString(
    LPCSTR String
    )
{
    int charCount = ::MultiByteToWideChar(CP_ACP, 0, String, -1, nullptr, 0);
    if (charCount == 0)
    {
        throw HRESULT_FROM_WIN32(::GetLastError());
    }

    std::wstring result;
    result.resize(charCount);
    charCount = ::MultiByteToWideChar(CP_ACP, 0, String, -1, &result[0], charCount);
    if (charCount == 0)
    {
        throw HRESULT_FROM_WIN32(::GetLastError());
    }

    return result;
}

/// Adds escape characters to a file path for use in a JSON document.
std::wstring
EscapeFilePath(
    const std::wstring& FilePath
    )
{
    std::wostringstream out;
    for (auto& c : FilePath)
    {
        switch (c)
        {
            case L'\\':
                out << L"\\\\";
                break;
            default:
                out << c;
                break;
        }
    }
    return out.str();
}

/// Converts a GUID to a UNICODE string.
std::wstring
GuidToString(
    REFGUID Guid
    )
{
    RPC_WSTR guidString{};
    RPC_STATUS rpcStatus = ::UuidToString(&Guid, &guidString);
    if (rpcStatus != RPC_S_OK)
    {
        throw E_OUTOFMEMORY;
    }
    try
    {
        std::wstring result(reinterpret_cast<LPCWSTR>(guidString));
        RpcStringFree(&guidString);
        return result;
    }
    catch (...)
    {
        RpcStringFree(&guidString);
        throw;
    }
}

using unique_handle = std::unique_ptr<std::remove_pointer<HANDLE>::type, decltype(&::CloseHandle)>;
using unique_hcs_system = std::unique_ptr<std::remove_pointer<HCS_SYSTEM>::type, decltype(&::HcsCloseComputeSystem)>;
using unique_hcs_operation = std::unique_ptr<std::remove_pointer<HCS_OPERATION>::type, decltype(&::HcsCloseOperation)>;

/// Creates a compute system configuration including an external PCI device.
std::wstring
CreateSystemConfig(
    const std::wstring &VhdPath,
    const std::wstring &NetworkEndpointId
    )
{
    // NOTE: It's outside the scope of this sample to illustrate how to correctly generate
    // a JSON document. Any JSON library of choice can be used for this purpose.
    // This code uses simple string manipulation to insert a few configurable values
    // into a static template.
    static const std::wstring configTemplate = LR"(
        {
            "Owner": "test",
            "SchemaVersion": {
                "Major": 2,
                "Minor": 3
            },
            "VirtualMachine": {
                "Chipset": {
                    "Uefi": {
                        "BootThis": {
                            "DeviceType": "ScsiDrive",
                            "DevicePath": "Controller0",
                            "DiskNumber": 0
                        }
                    }
                },
                "ComputeTopology": {
                    "Memory": {
                        "SizeInMB": 2048,
                        "AllowOvercommit": true
                    },
                    "Processor": {
                        "Count": 2
                    }
                },
                "Devices": {
                    "Scsi": {
                        "Controller0": {
                            "Attachments": {
                                "0": {
                                    "Type": "VirtualDisk",
                                    "Path": "%ws"
                                }
                            }
                        }
                    },
                    "VideoMonitor": {},
                    "Keyboard": {},
                    "Mouse": {},
                    "NetworkAdapters": {
                        "Adapter0": {
                            "EndpointId" : "%ws"
                        }
                    }
                }
            },
            "ShouldTerminateOnLastHandleClosed": true
        }
    )";

    std::wstring config;
    FormatString(
        config,
        configTemplate.c_str(),
        VhdPath.c_str(),
        NetworkEndpointId.c_str());

    return config;
}

/// Displays usage information.
__declspec(noreturn)
void Usage()
{
    printf("hcssample.exe <VHD path> [<network endpoint ID>]\n");
    exit(1);
}

/// Program entry point.
int
main(
    int ArgC,
    _In_reads_opt_(ArgC) LPSTR ArgV[]
    )
try
{
    if (ArgC < 2 || ArgC > 3)
    {
        Usage();
    }

    std::wstring vhdPath = ConvertAnsiString(ArgV[1]);
    std::wstring networkEndpointId = GuidToString({});
    if (ArgC == 3)
    {
        networkEndpointId = ConvertAnsiString(ArgV[2]);
    }
    std::wstring systemId{ L"HCSSAMPLE" };

    // Create the JSON document describing the VM configuration.
    auto config = CreateSystemConfig(EscapeFilePath(vhdPath), networkEndpointId);
    printf("[INFO] Compute system configuration:\n%ws\n", config.c_str());

    HRESULT hr = ::HcsGrantVmAccess(systemId.c_str(), vhdPath.c_str());
    if (FAILED(hr))
    {
        throw hr;
    }

    printf("[INFO] Creating compute system\n");
    HCS_OPERATION operationHandle = ::HcsCreateOperation(nullptr, nullptr);
    if (operationHandle == nullptr)
    {
        throw E_OUTOFMEMORY;
    }
    unique_hcs_operation operation(operationHandle, &::HcsCloseOperation);
    HCS_SYSTEM systemHandle{};
    hr = ::HcsCreateComputeSystem(systemId.c_str(), config.c_str(), operation.get(), nullptr, &systemHandle);
    unique_hcs_system system(systemHandle, &::HcsCloseComputeSystem);
    if (FAILED(hr))
    {
        throw hr;
    }
    hr = ::HcsWaitForOperationResult(operation.get(), INFINITE, nullptr);
    if (FAILED(hr))
    {
        throw hr;
    }

    printf("[INFO] Starting compute system\n");
    hr = ::HcsStartComputeSystem(system.get(), operation.get(), nullptr);
    if (FAILED(hr))
    {
        throw hr;
    }
    hr = ::HcsWaitForOperationResult(operation.get(), INFINITE, nullptr);
    if (FAILED(hr))
    {
        throw hr;
    }

    // Wait for the system to exit.
    HANDLE systemExitHandle = CreateEventEx(nullptr, nullptr, 0, MAXIMUM_ALLOWED);
    if (systemExitHandle == nullptr)
    {
        throw HRESULT_FROM_WIN32(::GetLastError());
    }
    unique_handle systemExitEvent(systemExitHandle, &::CloseHandle);
    hr = ::HcsSetComputeSystemCallback(system.get(), HcsEventOptionNone, systemExitEvent.get(), [](HCS_EVENT* Event, void* Context)
    {
        if (Event->Type == HcsEventSystemExited || Event->Type == HcsEventServiceDisconnect)
        {
            SetEvent(reinterpret_cast<HANDLE>(Context));
        }
    });
    WaitForSingleObject(systemExitEvent.get(), INFINITE);
    printf("[INFO] Compute system exited\n");
    return 0;
}
catch (const HRESULT& hr)
{
    printf("[ERROR] HRESULT = 0x%08X\n", hr);
    return 1;
}
catch (const std::bad_alloc&)
{
    printf("[ERROR] Out of memory\n");
    return 1;
}

```