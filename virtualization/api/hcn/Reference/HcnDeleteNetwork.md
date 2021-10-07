/// Delete a Network
@[rs5, DLoadRet(E_NOTIMPL)]
HRESULT
WINAPI
HcnDeleteNetwork(
    _In_ REFGUID Id,
    _Outptr_opt_ PWSTR* ErrorRecord
    );