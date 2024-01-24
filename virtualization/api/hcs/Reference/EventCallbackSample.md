---
title: Event Callback Samples
description: Event Callback Samples
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- Event Callback Samples
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# Event Callback Samples

This section shows example code on how to configure event callback function in the HCS APIs.

## Use event callback for non operation notifications

The following snippet creates a Virtual Machine with no virtual disk, for simplicity. Compute system event callback is used for a wide range of scenarios, and the snippet adds appropriate comments on each event type with more details.

```cpp
constexpr auto c_EmptyVM = LR"(
{
    "SchemaVersion": {
        "Major": 2,
        "Minor": 1
    },
    "Owner": "Sample",
    "VirtualMachine": {
        "Chipset": {
            "Uefi": {}
        },
        "ComputeTopology": {
            "Memory": {
                "Backing": "Physical",
                "SizeInMB": 1024
            },
            "Processor": {
                "Count": 2
            }
        }
    },
    "ShouldTerminateOnLastHandleClosed": true
})";

//
// Start by creating a compute system.
//
unique_hcs_operation operation{ HcsCreateOperation(nullptr, nullptr) };
unique_hcs_system system;
THROW_IF_FAILED(HcsCreateComputeSystem(L"Test", c_EmptyVM, operation.get(), nullptr, &system));
wil::unique_hlocal_string resultDoc;
THROW_IF_FAILED_MSG(HcsWaitForOperationResult(operation.get(), INFINITE, &resultDoc), "%ws", resultDoc.get());

//
// Set the compute system's event callback function.
// This callback is used to act on events that occur on compute systems
// outside of an HCS operation. These vary on different contexts, and the
// HCS_EVENT parameter determines what happened.
//
THROW_IF_FAILED(HcsSetComputeSystemCallback(
    system.get(),
    HcsEventOptionNone,
    nullptr,
    [](HCS_EVENT* event, void*)
    {
        switch(event->Type)
        {
        case HcsEventSystemExited:
            //
            // The compute system has exited. This usually means that it has been terminated
            // via HcsTerminateComputeSystem or shutdown via HcsShutdownComputeSystem.
            // It could also be a result of an internal error in the Host Compute Service;
            // or the compute system's guest operating system turning off the system.
            //
            // Normally cleanup logic in the client side would happen here
            // because we can deterministically know when the compute system
            // is not going to be around anymore.
            //
            // EventData is a JSON document that contains the system exit status.
            //
            WI_ASSERT(event->EventData != nullptr);
            break;

        case HcsEventSystemCrashInitiated:
            //
            // The compute system's guest operating system has initiated a crash (bugcheck).
            // This event is used to notify client code about the crash to give it a chance
            // to do something before the crash completes.
            //
            // EventData is a JSON document with a guest report.
            //
            WI_ASSERT(event->EventData != nullptr);
            break;

        case HcsEventSystemCrashReport:
            //
            // The compute system's guest operating system has reported a crash (bugcheck).
            // This event is used to notify client code about the crash completed.
            //
            // EventData is a JSON document with a guest report.
            // This can be used as input to HcsSubmitWerReport.
            //
            WI_ASSERT(event->EventData != nullptr);
            break;

        case HcsEventSystemRdpEnhancedModeStateChanged:
            //
            // The compute system's RDP enhanced mode state has changed.
            //
            break;

        case HcsEventSystemSiloJobCreated:
            //
            // Reserved for future use.
            //
            break;

        case HcsEventSystemGuestConnectionClosed:
            //
            // The compute system's guest connection has been closed.
            // This notification is called regardless of the disconnection being expected or not.
            //
            break;

        case HcsEventProcessExited:
            //
            // Event notification for when an HCS_PROCESS completes.
            // The EventData of the event is a JSON document describing
            // the resulting process status.
            //
            // This event notification is only valid for when HcsSetProcessCallback
            // is used. This will never fire for a compute system's event callback
            // set via HcsSetComputeSystemCallback.
            //

            WI_ASSERT(false); // Not valid for compute systems!
            break;

        case HcsEventOperationCallback:
            // This event type is only valid if HcsEventOptionEnableOperationCallbacks

            WI_ASSERT(false); // Not valid because we've used HcsEventOptionNone!
            break;

        case HcsEventServiceDisconnect:
            //
            // Event notification to indicate when the client code
            // has lost connection to the Host Compute Service.
            // This would usually mean the service crashed or has been forcefully stopped.
            //
            break;

        case HcsEventInvalid:
        default:
            WI_ASSERT(false); // This shouldn't happen!
        }
    }));
```
