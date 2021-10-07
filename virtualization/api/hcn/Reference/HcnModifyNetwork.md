/// Modify the settings of a Network
@[rs5, DLoadRet(E_NOTIMPL)]
HRESULT
WINAPI
HcnModifyNetwork(
    _In_ HCN_NETWORK Network,
    _In_ PCWSTR Settings,
    _Outptr_opt_ PWSTR* ErrorRecord
    );