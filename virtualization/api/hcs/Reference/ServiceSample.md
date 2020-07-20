# Host Service Sample Code

<a name = "GetServiceProperties"></a>
## Get the properties of host service

Here takes the memory property of service as example.

```cpp
    static constexpr wchar_t c_ServicePropertyQuery[] = LR"(
    {
        "PropertyTypes":[
            "Memory"
        ]
    })";

    wil::unique_hlocal_string resultDoc;
    THROW_IF_FAILED(HcsGetServiceProperties(c_ServicePropertyQuery, &resultDoc));
    std::wcout << L"Service property is " << resultDoc.get() << std::endl;
```

<a name = "ModifyServiceSettings"></a>
## Modify the service settings

```cpp
// Not finished yet, only available type `ContainerCredentialGuard` is used for container
    static constexpr wchar_t c_ServiceSettings[] = LR"(
    {
        "PropertyType": "ContainerCredentialGuard",
        "Settings":
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
