---
title: Virtualized Container Time Zone
description: How to configure the time zone in a container.
keywords: containers, timezone, virtualization
author: brasmith-ms
ms. author: brasmith
ms.topic: conceptual
ms.date: 06/15/2021
---
# Virtualized Time Zone

| SKU | Supported Build |
|---|---|
| Windows Server 2019 | 10.0.17763.1935 or higher |
| 20H2 SAC | 10.0.19042.985 or higher |
| Windows Server 2022 | All versions |

Windows containers support the ability to maintain a virtualized time zone configuration separate from the host. All of the configurations traditionally used for the host time zone have been virtualized and are instanced for each and every container. With this feature, Windows containers offer the following behaviors:

- When starting the container the time zone of the host is inherited and stays within the container. If the time zone of the host changes while the container is running then the time zone stored within the container will not change. To re-inherit the host's time zone the container must be restarted.
- The container will keep the host's time zone configuration observed upon starting the container only **until the user explicitly configures the time zone from within the container**. Once the user sets the time zone from within the container, the configuration is virtualized and the container no longer refers to the host.
- If the user configures the container's time zone and subsequently saves the state of the container, the time zone configuration will persist across boots.

All kernel-mode and user-mode APIs revolving around time zone data and the retrieval of the current time zone bias have been enhanced to handle the distinction between host and container, and redirect to the appropriate data. When a thread running in the context of a container calls a system API to query the local time it will retrieve the container's time zone configuration instead of the host's. When writing new time zone data from within a container, the data is persisted in container-specific storage and the container in question no longer inherits the host’s current time zone data on startup - meaning that once set by the user the container will continue to use the configured time zone across reboots going forward. Any containers built on top of an image will inherit the time zone configuration as long as it was explicitly set within one of the layers.

## How do I Configure the Container's Time Zone?

First, you need **both host and guest** versions containing this feature, which means running on a 2105B build or higher. Running with versions prior to this will simply revert the behavior of the container to mirroring the host's time zone with configuration having no impact on the host or guest.

>[!NOTE]
>Configuration of the time zone requires administrative privileges - specifically the SeTimeZonePrivilege. The ContainerAdministrator account has this privilege. Therefore the recommendation is to run with the least privileges necessary for your workload and reserve the ContainerAdministrator account for administrative tasks such as setting the time zone.

**The recommended way to configure the container time zone is through the TZUtil.exe utility or Powershell's Set-TimeZone cmdlet**. These utilities are well maintained and offer convenience in easily setting the time zone. Any other scenario will need to interact with the system APIs directly. Any base image version with TZUtil.exe or Powershell will support these methods. The nanoserver base image is an exception to this as it does not support Powershell or TZUtil out of the box, which will require a custom utility to interact with the system APIs. In any case, **newly written applications should NOT take a dependency on the OS time zone** unless absolutely necessary and should instead account for it within the application data & logic.

### Example

Using the latest Windows Server 2019 [Server Core](https://hub.docker.com/_/microsoft-windows-servercore) base image:

1. Upon booting the container we will see the time zone is set to the host's time zone (for this example it's PST)

     ```powershell
    PS C:\> tzutil /g
    Pacific Standard Time

2. If we set the time zone of the **host** to Central Asian Standard Time (UTC+6:00), we still see PST in the container

    ```powershell
    PS C:\> Get-TimeZone
            
        
    Id                         : Pacific Standard Time
    DisplayName                : (UTC-08:00) Pacific Time (US & Canada)
    StandardName               : Pacific Standard Time
    DaylightName               : Pacific Daylight Time
    BaseUtcOffset              : -08:00:00
    SupportsDaylightSavingTime : True
    ```

    Some important things to note here. When starting the container for the first time the configuration will be set to whatever was configured when creating the base image **until the user configures it themselves**. In most cases with Windows base images the default will be PST.

3. Now lets set the time zone of the container to "Samoa Standard Time"

    ```powershell
    PS C:\> tzutil /s "Samoa Standard Time"
    PS C:\> tzutil /g
    Samoa Standard Time
    PS C:\> Get-TimeZone
            
        
    Id                         : Samoa Standard Time
    DisplayName                : (UTC+13:00) Samoa
    StandardName               : Samoa Standard Time
    DaylightName               : Samoa Daylight Time
    BaseUtcOffset              : 13:00:00
    SupportsDaylightSavingTime : True
    ```

    Now the container's time zone has been updated to Samoa Standard Time but the host remains on Central Asia Standard time. This configuration will persist when saving the container's state.

4. Now if we restart the container without having previously saved its state, the time zone will be set to that of the host.

    ```powershell
    PS C:\>tzutil /g
    Central Asia Standard Time
    PS C:\> Get-TimeZone
                
        
    Id                         : Central Asia Standard Time
    DisplayName                : (UTC+06:00) Astana
    StandardName               : Central Asia Standard Time
    DaylightName               : Central Asia Daylight Time
    BaseUtcOffset              : 06:00:00
    SupportsDaylightSavingTime : False
    ```
