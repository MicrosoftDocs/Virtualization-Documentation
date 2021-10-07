/// Modify the settings of a Namespace
@[rs5, DLoadRet(E_NOTIMPL)]
HRESULT
WINAPI
HcnModifyNamespace(
    _In_ HCN_NAMESPACE Namespace,
    _In_ PCWSTR Settings,
    _Outptr_opt_ PWSTR* ErrorRecord
    );