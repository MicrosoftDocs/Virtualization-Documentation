HRESULT
WINAPI
HcnRegisterServiceCallback(
    _In_ HCN_NOTIFICATION_CALLBACK Callback,
    _In_ void* Context,
    _Outptr_ HCN_CALLBACK* CallbackHandle
    );