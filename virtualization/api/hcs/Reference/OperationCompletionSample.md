---
title: Operation Completion Samples
description: Operation Completion Samples
author: faymeng
ms.author: mabrigg
ms.topic: reference
ms.service: virtualization
ms.date: 06/09/2021
api_name:
- Operation Completion Samples
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref

---

# Operation Completion Samples

This section shows example code on how to use operation completion callback function in the HCS APIs.


The examples in this page use [`HcsCreateComputeSystem`](./HcsCreateComputeSystem.md) as the HCS function to track, and the following global definitions:

```cpp
// JSON document that represents an "Empty" virtual machine.
// Essentially, just the bare minimum necessary to create a virtual machine
// that doesn't have any guest nor storage attached to it.
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

using unique_hcs_operation = wil::unique_any<HCS_OPERATION, decltype(&HcsCloseOperation), HcsCloseOperation>;
using unique_hcs_system = wil::unique_any<HCS_SYSTEM, decltype(&HcsCloseComputeSystem), HcsCloseComputeSystem>;
```

## Wait for operation synchronously

The first, most common, pattern is to wait for an operation explicitly to achieve a synchronous behavior without complex custom waitable objects.

```cpp
unique_hcs_operation operation{ HcsCreateOperation(nullptr, nullptr) };
unique_hcs_system system;
THROW_IF_FAILED(HcsCreateComputeSystem(L"Test", c_EmptyVM, operation.get(), nullptr, &system));
wil::unique_hlocal_string resultDoc;
THROW_IF_FAILED_MSG(HcsWaitForOperationResult(operation.get(), INFINITE, &resultDoc), "%ws", resultDoc.get());
```


## Use an HCS operation callback

This pattern relies on client code creating an operation with a callback, and use that as the synchronization mechanism to know when the operation has completed. Note in the example code that we don't store anywhere the returned `HCS_OPERATION` handle when creating it with [`HcsCreateOperation`](./HcsCreateOperation.md) since it can be closed from within the callback!

```cpp
// Use a windows event object as the context so that we can wait on it
wil::unique_event callbackWait;
callbackWait.create();
unique_hcs_system system;
THROW_IF_FAILED(HcsCreateComputeSystem(
    L"Test",
    c_EmptyVM,
    HcsCreateOperation(
        callbackWait.get(),
        [](HCS_OPERATION operation, void* context)
        {
            WI_ASSERT(HcsGetOperationType(operation) == HcsOperationTypeCreate);
            wil::unique_hlocal_string resultDoc;
            THROW_IF_FAILED_MSG(HcsGetOperationResult(operation, &resultDoc), "%ws", resultDoc.get());
            HcsCloseOperation(operation);
            SetEvent(context);
        }),
    nullptr,
    &system));
callbackWait.wait(INFINITE);
```


## Use event callback's operation completion

This pattern relies on the compute system or compute process event callback to get notified when the operation has been completed. This requires client code to use `HcsEventOptionEnableOperationCallbacks` as the [event option](./HCS_EVENT_OPTIONS.md) when calling [`HcsSetComputeSystemCallback`](./HcsSetComputeSystemCallback.md) or [`HcsSetProcessCallback`](./HcsSetProcessCallback.md). The following example uses event callback for compute system.

When this pattern is used, it's not allowed to use operation callbacks. Any attempt to do that will fail the function with `HCS_E_OPERATION_SYSTEM_CALLBACK_ALREADY_SET`.

```cpp
// Use a windows event object as the context so that we can wait on it
wil::unique_event callbackWait;
callbackWait.create();
unique_hcs_system system;
THROW_IF_FAILED(HcsCreateComputeSystem(L"Test", c_EmptyVM, HcsCreateOperation(nullptr, nullptr), nullptr, &system));
THROW_IF_FAILED(HcsSetComputeSystemCallback(
    system.get(),
    HcsEventOptionEnableOperationCallbacks,
    callbackWait.get(),
    [](HCS_EVENT* event, void* context)
    {
        WI_ASSERT(event->Type == HcsEventOperationCallback);
        wil::unique_hlocal_string resultDoc;
        THROW_IF_FAILED_MSG(HcsGetOperationResult(event->Operation, &resultDoc), "%ws", resultDoc.get());
        HcsCloseOperation(event->Operation);
        SetEvent(context);
    }));
callbackWait.wait(INFINITE);

// However, once the system callback has been set, using an operation with callback fails!
callbackWait.create();
HRESULT result = HcsStartComputeSystem(
    system.get(),
    HcsCreateOperation(nullptr, [](HCS_OPERATION operation, void* context){}),
    nullptr);
THROW_HR_IF(E_UNEXPECTED, result != HCS_E_OPERATION_SYSTEM_CALLBACK_ALREADY_SET);
```
