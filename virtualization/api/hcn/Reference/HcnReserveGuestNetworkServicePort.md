HRESULT
WINAPI
HcnReserveGuestNetworkServicePort(
    _In_ HCN_GUESTNETWORKSERVICE GuestNetworkService,
    _In_ HCN_PORT_PROTOCOL Protocol,
    _In_ HCN_PORT_ACCESS Access,
    _In_ USHORT Port,
    _Out_ HANDLE* PortReservationHandle
    );