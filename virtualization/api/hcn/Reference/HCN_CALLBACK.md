/////////////////////////////////////////////////////////////////////////
/// Notifications

/// Notifications indicated to callbacks
typedef enum HCN_NOTIFICATIONS
{
       HcnNotificationInvalid                                  = 0x00000000,

       /// Notifications for HCN_SERVICE handles
       HcnNotificationNetworkPreCreate                         = 0x00000001,
       HcnNotificationNetworkCreate                            = 0x00000002,
       HcnNotificationNetworkPreDelete                         = 0x00000003,
       HcnNotificationNetworkDelete                            = 0x00000004,

       /// Namespace Notifications
       HcnNotificationNamespaceCreate                          = 0x00000005,
       HcnNotificationNamespaceDelete                          = 0x00000006,

       /// Notifications for HCN_SERVICE handles
       HcnNotificationGuestNetworkServiceCreate                = 0x00000007,
       HcnNotificationGuestNetworkServiceDelete                = 0x00000008,

       /// Notifications for HCN_NETWORK handles
       HcnNotificationNetworkEndpointAttached                  = 0x00000009,
       HcnNotificationNetworkEndpointDetached                  = 0x00000010,

       /// Notifications for HCN_GUESTNETWORKSERVICE handles
       HcnNotificationGuestNetworkServiceStateChanged          = 0x00000011,
       HcnNotificationGuestNetworkServiceInterfaceStateChanged = 0x00000012,

       /// Common notifications
       HcnNotificationServiceDisconnect                        = 0x01000000,

       /// The upper 4 bits are reserved for flags
       HcnNotificationFlagsReserved                            = 0xF0000000
} HCN_NOTIFICATIONS;

/// Handle to a callback registered on a hns object
typedef void* HCN_CALLBACK;

/// Function type for HNS notification callbacks
typedef void (CALLBACK *HCN_NOTIFICATION_CALLBACK)(
    _In_            DWORD  NotificationType,
    _In_opt_        void*  Context,
    _In_            HRESULT NotificationStatus,
    _In_opt_        PCWSTR NotificationData
    );
