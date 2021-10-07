HRESULT
WINAPI
HcnEnumerateGuestNetworkPortReservations(
    _Out_ ULONG* ReturnCount,
    _Out_writes_bytes_all_(*ReturnCount) HCN_PORT_RANGE_ENTRY** PortEntries
    );