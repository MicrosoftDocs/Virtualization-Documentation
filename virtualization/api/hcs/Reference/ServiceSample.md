# Hose Service Sample Code

<a name = "GetServiceProperties"></a>
## Get the properties of host service

Return type is ServiceProperties, its properties `Any` can be ???

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

|PropertyType|Setting Type|
|---|---|
|`"ContainerCredentialGuard"`|ContainerCredentialGuard|

```cpp
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

// Recorder for HCS_EVENTs on a given HCS_SYSTEM.
// class HcsEventRecorder

    static constexpr wchar_t c_Settings[] = LR"(
    {
        "WindowsCrashInfo": 
    })";

    wil::unique_hlocal_string resultDoc;
    THROW_IF_FAILED(HcsSubmitWerReport(c_Settings));
```

