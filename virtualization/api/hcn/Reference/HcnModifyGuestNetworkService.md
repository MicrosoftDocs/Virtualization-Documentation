HRESULT
WINAPI
HcnModifyGuestNetworkService(
    _In_ HCN_GUESTNETWORKSERVICE GuestNetworkService,
    _In_ PCWSTR Settings,
    _Outptr_opt_ PWSTR* ErrorRecord
    );