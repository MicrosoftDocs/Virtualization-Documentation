# Compute System Operation Sample Code

<a name = "CreateStartVM"></a>
## Create and start a virtual machine

This sample shows how to use Host Compute System API to create a virtual machine and start it.

```cpp

//
// Helper RAII objects around HCS system handle and HCS operation handle
// HCS_OPERATION handle closed by HcsCloseOperation
// HCS_SYSTEM handle closed by HcsCloseComputeSystem
//
using unique_hcs_operation = wil::unique_any<HCS_OPERATION, decltype(&HcsCloseOperation), HcsCloseOperation>;
using unique_hcs_system = wil::unique_any<HCS_SYSTEM, decltype(&HcsCloseComputeSystem), HcsCloseComputeSystem>;

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

    //
    // After setting up the JSON document, we need to call into the HCS to create
    // the compute system, in this case, an HCS VM.
    //

    unique_hcs_operation operation(HcsCreateOperation(nullptr, nullptr)); // This operation doesn't need callback
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

```

<a name = "OpenGetPropVM"></a>
## Open a virtual machine and get its memory configuration

On scope exit, the operation will be properly cleaned up, and the system handle (HCS_SYSTEM handle) will be close using HcsCloseComputeSystem.
Because the HCS VM has already been created, it will still be running even after closing the handle and even after the current process exits.
If you still want to access/modify/query the compute system after this function/process exists, you can always get a new handle to the system
via ::HcsOpenComputeSystem (assuming the system is still running/created and hasn't been removed)

```cpp
    static constexpr wchar_t c_VmQuery[] = LR"(
    {
        "PropertyTypes":[
            "Memory"
        ]
    })";

    unique_hcs_operation operation(HcsCreateOperation(nullptr, nullptr));
    unique_hcs_system system;
    THROW_IF_FAILED(HcsOpenComputeSystem(L"Sample", GENERIC_ALL, &system));

    THROW_IF_FAILED(HcsGetComputeSystemProperties(
        system.get(),
        operation.get(),
        c_VmQuery));

    wil::unique_hlocal_string resultDoc;
    THROW_IF_FAILED_MSG(HcsWaitForOperationResult(operation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());

    // It's a failure if the result document doesn't have anything for
    // ::HcsGetComputeSystemProperties!
    THROW_HR_IF(E_UNEXPECTED, !resultDoc);
    wprintf(L"HCS VM properties:\n%s\n", resultDoc.get());

```

<a name = "ShutDownCS"></a>
## Terminate compute system

```cpp
    // Assume same "system" as previous sample code
    unique_hcs_operation terminateOperation(HcsCreateOperation(nullptr, nullptr));
    THROW_IF_FAILED(HcsTerminateComputeSystem(system.get(), terminateOperation.get(), nullptr));

    THROW_IF_FAILED_MSG(HcsWaitForOperationResult(terminateOperation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());
```

<a name = "EnumCS"></a>
## Enumerate all compute systems

```cpp
    unique_hcs_operation enumOperation(HcsCreateOperation(nullptr, nullptr));
    THROW_IF_FAILED(HcsEnumerateComputeSystems(nullptr, enumOperation.get()));

    // print out all the compute system in JSON string
    wil::unique_hlocal_string Enumresult;
    THROW_IF_FAILED(HcsWaitForOperationResult(enumOperation.get(), INFINITE, &Enumresult));
    std::wcout << Enumresult.get() << std::endl;
```

<a name = "PauseResumeCS"></a>
## Pause and Resume compute system

```cpp
    static constexpr wchar_t c_pauseOption[] = LR"(
    {
        "SuspensionLevel": "Suspend",
        "HostedNotification": {
            "Reason": "Save"
        }
    })";

    // Assume same "system" as previous sample code
    unique_hcs_operation pauseOperation(HcsCreateOperation(nullptr, nullptr));
    THROW_IF_FAILED(HcsPauseComputeSystem(system.get(), pauseOperation.get(), c_pauseOption));

    wil::unique_hlocal_string resultDoc;
    THROW_IF_FAILED_MSG(HcsWaitForOperationResult(pauseOperation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());

    // After some while, resume the compute system
    unique_hcs_operation resumeOperation(HcsCreateOperation(nullptr, nullptr));
    THROW_IF_FAILED(HcsResumeComputeSystem(system.get(), resumeOperation.get(), nullptr));

    THROW_IF_FAILED_MSG(HcsWaitForOperationResult(resumeOperation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());
```

<a name = "SaveCloseCS"></a>
## Save and close compute system

```cpp
    static constexpr wchar_t c_saveOption[] = LR"(
    {
        "SaveType": "ToFile",
        "SaveStateFilePath": "c:\\HCS_Test\\save.vmrs"
    })";

    // Assume same "system" as previous sample code
    unique_hcs_operation saveOperation(HcsCreateOperation(nullptr, nullptr));
    THROW_IF_FAILED(HcsSaveComputeSystem(system.get(), saveOperation.get(), c_saveOption));

    wil::unique_hlocal_string resultDoc;
    THROW_IF_FAILED_MSG(HcsWaitForOperationResult(saveOperation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());

    // after some while, close the compute system
    // No need to close manually if using wil::unique_any for HCS_SYSTEM handle
    HcsCloseComputeSystem(system.get());
```

<a name = "ModifyVM"></a>
## Pause and Resume compute system

The example shows to add virtual SMB layer

```cpp
    static constexpr wchar_t c_modifySetting[] = LR"(
    {
        "ResourcePath": "c:\\HCS_Test\\VirtualSMB",
        "RequestType": "Add",
        "Settings": {
            "Name": "BaseImageLayer",
            "Path": "c:\\HCS_Test\\",
            "Options": {
                "ReadOnly": true
            },
            "AllowedFiles": [
                "BaseImage.vhdx"
            ]
        }
    })";

    unique_hcs_operation modifyOperation(HcsCreateOperation(nullptr, nullptr));
    THROW_IF_FAILED(HcsModifyComputeSystem(system.get(), modifyOperation.get(), c_modifySetting, nullptr));

    wil::unique_hlocal_string resultDoc;
    THROW_IF_FAILED_MSG(HcsWaitForOperationResult(modifyOperation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());
```
