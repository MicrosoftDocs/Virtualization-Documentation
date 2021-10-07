HRESULT
WINAPI
HcnCreateGuestNetworkService(
    _In_ REFGUID Id,
    _In_ PCWSTR Settings,
    _Out_ PHCN_GUESTNETWORKSERVICE GuestNetworkService,
    _Outptr_opt_ PWSTR* ErrorRecord
    );