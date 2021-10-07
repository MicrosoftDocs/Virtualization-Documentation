HRESULT
WINAPI
HcnReserveGuestNetworkServicePortRange(
    _In_ HCN_GUESTNETWORKSERVICE GuestNetworkService,
    _In_ USHORT PortCount,
    _Out_ HCN_PORT_RANGE_RESERVATION* PortRangeReservation,
    _Out_ HANDLE* PortReservationHandle
    );