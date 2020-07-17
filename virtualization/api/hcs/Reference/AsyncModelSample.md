# Async Model Sample Code

There are three ways to use async model. Here takes `HcsCreateComputeSystem` as example.

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

    // Create an operation with no callback and wait explicitly on it.
    {
        unique_hcs_operation operation{ HcsCreateOperation(nullptr, nullptr) };
        unique_hcs_system system;
        THROW_IF_FAILED(HcsCreateComputeSystem(L"Test", c_EmptyVM, operation.get(), nullptr, &system));
        wil::unique_hlocal_string resultDoc;
        THROW_IF_FAILED_MSG(HcsWaitForOperationResult(operation.get(), INFINITE, &resultDoc), "%ws", resultDoc.get());
    }

    // Create an operation with a callback and wait for that.
    // Note that we don't store anywhere the returned HCS_OPERATION handle
    // when creating it since it can be closed from within the callback!
    {
        wil::unique_event callbackWait; // Using a windows event as the context so that we can wait on it
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
    }

    // Create an operation with no callback, but rely on compute system notification
    // callback to get the operation completion event
    {
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
    }
```