/////////////////////////////////////////////////////////////////////////
/// Hcn Port Reservation

typedef enum tagHCN_PORT_PROTOCOL
{
    HCN_PORT_PROTOCOL_TCP = 0x01,
    HCN_PORT_PROTOCOL_UDP = 0x02,
    HCN_PORT_PROTOCOL_BOTH = 0x03
} HCN_PORT_PROTOCOL;

typedef enum tagHCN_PORT_ACCESS
{
    HCN_PORT_ACCESS_EXCLUSIVE = 0x01,
    HCN_PORT_ACCESS_SHARED = 0x02
} HCN_PORT_ACCESS;

typedef struct tagHCN_PORT_RANGE_RESERVATION
{
    // start and end are inclusive
    USHORT startingPort;
    USHORT endingPort;
} HCN_PORT_RANGE_RESERVATION;

typedef struct tagHCN_PORT_RANGE_ENTRY {
    GUID OwningPartitionId;
    GUID TargetPartitionId;
    HCN_PORT_PROTOCOL Protocol;
    UINT64 Priority;
    UINT32 ReservationType;
    UINT32 SharingFlags;
    UINT32 DeliveryMode;
    UINT16 StartingPort;
    UINT16 EndingPort;
} HCN_PORT_RANGE_ENTRY, *PHCN_PORT_RANGE_ENTRY;
