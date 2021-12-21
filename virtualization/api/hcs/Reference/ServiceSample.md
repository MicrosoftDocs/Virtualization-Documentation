---
title: Host Service Samples
description: Host Service Samples
author: faymeng
ms.author: qiumeng
ms.topic: reference
ms.prod: virtualization
ms.technology: virtualization
ms.date: 06/09/2021
api_name:
- Host Service Samples
api_location:
- computecore.dll
api_type:
- DllExport
topic_type: 
- apiref
---
# Host Service Samples

<a name = "GetServiceProperties"></a>
## Get the properties of host service

Here takes the memory property in the service as the example.

```cpp
    static constexpr wchar_t c_ServicePropertyQuery[] = LR"(
    {
        "PropertyTypes": [
            "Memory"
        ]
    })";

    wil::unique_hlocal_string resultDoc;
    THROW_IF_FAILED(HcsGetServiceProperties(c_ServicePropertyQuery, &resultDoc));
    std::wcout << L"Service property is " << resultDoc.get() << std::endl;
```

<a name = "ModifyServiceSettings"></a>
## Modify the service settings

Here takes the CPUGroup property in the service as the example.

```cpp
    static constexpr wchar_t c_ServiceSettings[] = LR"(
    {
        "PropertyType": "CpuGroup",
        "Settings": {
            "Operation": "CreateGroup",
            "OperationDetails": {
                "GroupId": "GUID",
                "LogicalProcessorCount": 2,
                "LogicalProcessors": [0, 1]
            }
        }
    })";

    wil::unique_hlocal_string resultDoc;
    HRESULT hr = HcsModifyServiceSettings(c_ServiceSettings, &resultDoc);
    if (FAILED(hr))
    {
        std::wcout << resultDoc.get() << std::endl;
    }
    THROW_IF_FAILED(hr);
```

<a name = "SubmitReport"></a>
## Submit Crash Report

```cpp
    // Assume you have a valid unique_hcs_system object
    // to a newly created compute system.
    // We set compute system callbacks to wait specifically
    // for a crash system report.
    THROW_IF_FAILED(HcsSetComputeSystemCallback(
        system.get(), // system handle
        nullptr, // context
        [](HCS_EVENT* Event, void*)
        {
            if (Event->Type == HcsEventSystemCrashReport)
            {
                THROW_IF_FAILED(HcsSubmitWerReport(Event->EventData));
            }
        }));
```
