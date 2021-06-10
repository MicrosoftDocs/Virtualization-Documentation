---
title: Compute System Samples
description: Compute System Samples
author: faymeng
ms.author: qiumeng
ms.topic: article
ms.prod: virtualization
ms.service: virtualization
ms.date: 06/09/2021
---
# Compute System Samples

<a name = "OpenVM"></a>
## Open a virtual machine

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
