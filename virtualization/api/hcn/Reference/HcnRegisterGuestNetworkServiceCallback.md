HRESULT
WINAPI
HcnRegisterGuestNetworkServiceCallback(
    _In_ HCN_GUESTNETWORKSERVICE GuestNetworkService,
    _In_ HCN_NOTIFICATION_CALLBACK Callback,
    _In_ void* Context,
    _Outptr_ HCN_