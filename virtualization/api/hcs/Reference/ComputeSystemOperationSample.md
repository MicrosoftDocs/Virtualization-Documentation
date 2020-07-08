# Compute System Operation Sample Code

This sample shows how to use Host Compute System API to create a virtual machine and start it.

```cpp
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
                                "Path": "e:\\schema-test\\image\\utilityvm.vhdx"
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

    unique_hcs_operation operation(::HcsCreateOperation(nullptr, nullptr)); // This operation doesn't need callback
    unique_hcs_system system;
    THROW_IF_FAILED(::HcsCreateComputeSystem(
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
    THROW_IF_FAILED_MSG(::HcsWaitForOperationResult(operation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());

    // For a successful HcsCreateComputeSystem, result document doesn't have anything.

    //
    // Now that the HCS VM is created, we need to start it!
    //
    THROW_IF_FAILED(::HcsStartComputeSystem(
        system.get(),
        operation.get(),
        nullptr)); // This parameter is not currently supported, pass NULL.
    THROW_IF_FAILED_MSG(::HcsWaitForOperationResult(operation.get(), INFINITE, &resultDoc),
        "ResultDoc: %ws", resultDoc.get());

```