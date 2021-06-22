---
title: Quick Start
description: Quick Start
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# Quick Start

Here provides a simple example to use HCS API to manage the virtual machine, which includes HcsCreateComputeSystem, HcsStartComputeSystem, HcsGetComputeSystemProperties, HcsModifyComputeSystem and HcsTerminateComputeSystem.

This sample code uses the [Windows Implementation Libraries (WIL)](https://github.com/microsoft/wil) for more ergonomic and modern C++ usage of win32 APIs.

```cpp

#include <windows.h>
#include <winerror.h>
#include <wil\resource.h>

// HCS API header file
#include <computecore.h>
#include <computedefs.h>
#include <computenetwork.h>
#include <computestorage.h>

#pragma comment(lib, "computecore.lib")


//
// Helper RAII objects around HCS system handle and HCS operation handle
// HCS_OPERATION handle closed by HcsCloseOperation
// HCS_SYSTEM handle closed by HcsCloseComputeSystem
//
using unique_hcs_operation = wil::unique_any<HCS_OPERATION, decltype(&HcsCloseOperation), HcsCloseOperation>;
using unique_hcs_system = wil::unique_any<HCS_SYSTEM, decltype(&HcsCloseComputeSystem), HcsCloseComputeSystem>;

//
// Create a virtual machine
//
    static constexpr wchar_t c_VmConfiguration[] = LR"(
    {
        "SchemaVersion": {
            "Major": 2,
            "Minor": 1
        },
        "Owner": "Sample",
        "ShouldTerminateOnLastHandleClosed": true,
        "VirtualMachine": {
            "Chipset": {
                "Uefi": {
                    "BootThis": {
                        "DevicePath": "Primary disk",
                        "DiskNumber": 0,
                        "DeviceType": "ScsiDrive"
                    }
                }
            },
            "ComputeTopology": {
                "Memory": {
                    "Backing": "Virtual",
                    "SizeInMB": 2048
                },
                "Processor": {
                    "Count": 2
                }
            },
            "Devices": {
                "Scsi": {
                    "Primary disk": {
                        "Attachments": {
                            "0": {
                                "Type": "VirtualDisk",
                                "Path": c:\\HCS_Test\\utilityvm.vhdx"
                            }
                        }
                    }
                }
            }
        }
    })";

    // After setting up the JSON document, we need to call into the HCS to create
    // the compute system, in this case, an HCS VM.
    // This operation doesn't need callback
    unique_hcs_operation operation(HcsCreateOperation(nullptr, nullptr));
    unique_hcs_system system;
    THROW_IF_FAILED(HcsCreateComputeSystem(
        L"Sample", // Unique Id
        c_VmConfiguration,
        operation.get(),
        nullptr, // This parameter is not supported yet, always pass NULL
        &system));

    // We need to wait on the operation explicitly because no callback was setup
    // Result document from waiting on the operation would usually contain
    // a JSON blob with either error attribution or operation specific result data
    // (for example, compute system properties if the operation was used to call
    // ::HcsGetComputeSystemProperties).
    // Result document isn't necessarily set all the time, so make sure to check for that!
    wil::unique_hlocal_string resultDoc;
    THROW_IF_FAILED_MSG(HcsWaitForOperationResult(operation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());
    // For a successful HcsCreateComputeSystem, result document doesn't have anything.

//
// Now that the HCS VM is created, we need to start it!
//
    THROW_IF_FAILED(HcsStartComputeSystem(
        system.get(),
        operation.get(),
        nullptr)); // This parameter is not currently supported, pass NULL.
    THROW_IF_FAILED_MSG(HcsWaitForOperationResult(operation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());

//
// Get the VM memory property and print the result out
//
    static constexpr wchar_t c_VmQuery[] = LR"(
    {
        "PropertyTypes":[
            "Memory"
        ]
    })";

    THROW_IF_FAILED(HcsGetComputeSystemProperties(
        system.get(),
        operation.get(),
        c_VmQuery));
    THROW_IF_FAILED_MSG(HcsWaitForOperationResult(operation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());

    // It's a failure if the result document doesn't have anything for
    // ::HcsGetComputeSystemProperties!
    THROW_HR_IF(E_UNEXPECTED, !resultDoc);
    wprintf(L"HCS VM properties:\n%s\n", resultDoc.get());

//
// Let's modify the virtual machine setting
// The operation of HcsModifyComputeSystem will success only when virtual machine booted up completed
// So here gives 5 times retry and each would wait for 5s.
//
    static constexpr wchar_t c_modifySetting[] = LR"(
    {
        "ResourcePath": "VirtualMachine/ComputeTopology/Memory/SizeInMB",
        "RequestType": "Update",
        "Settings": 4096
    })";

    int retry = 0;
    do
    {
        Sleep(5000);
        unique_hcs_operation modifyOperation(HcsCreateOperation(nullptr, nullptr));
        THROW_IF_FAILED(HcsModifyComputeSystem(system.get(), modifyOperation.get(), c_modifySetting, nullptr));

        result = HcsWaitForOperationResult(modifyOperation.get(), INFINITE, &resultDoc);
    } while (result != S_OK && retry++ < 5);
    THROW_IF_FAILED(result);

//
// Finally, shut down the virtual machine. Because the sample virtual machine is not created with guest
// compute service, HcsShutDownComputeSystem is not able to use here. Let's use HcsTerminateComputeSystem
//
    THROW_IF_FAILED(HcsTerminateComputeSystem(system.get(), operation.get(), nullptr));
    THROW_IF_FAILED_MSG(HcsWaitForOperationResult(operation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());

```