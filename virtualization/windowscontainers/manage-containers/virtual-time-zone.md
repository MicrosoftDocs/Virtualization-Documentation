---
title: Virtualized container time zone
description: Learn how to configure the time zone in a container.
keywords: containers, timezone, virtualization
author: brasmith-ms
ms.author: brasmith
ms.topic: conceptual
ms.date: 06/15/2021
---

# Virtualized time zone

Windows containers support the ability to maintain a virtualized time zone configuration separate from the host. All of the configurations traditionally used for the host time zone have been virtualized and are instanced for each container. With this feature, Windows containers offer the following behaviors:

- When starting the container, the time zone of the host is inherited and stays within the container. If the time zone of the host changes while the container is running, then the time zone stored within the container does not change. To re-inherit the host's time zone, the container must be restarted.
- The container keeps the host's time zone configuration that's observed when starting the container only **until the user explicitly configures the time zone from within the container**. Once you set the time zone from within the container, the configuration is virtualized and the container no longer refers to the host.
- If you configure the container's time zone and subsequently save the state of the container, the time zone configuration persists across reboots.

All kernel mode and user mode APIs relating to configuration of the system time zone are now container-aware. When a thread running in the context of a container calls a system API to query the local time, it retrieves the container's time zone configuration instead of the host's. Time zone data written from within a container now persists in container-specific storage and the container in question no longer inherits the host’s current time zone data during startup. This means that once you set the time zone, the container continues to use the configured time zone across reboots. Any containers built on top of an image inherit the time zone configuration as long as it was explicitly set within one of the layers.

The following table shows the supported build for each SKU:

| SKU | Supported build |
|---|---|
| Windows Server 2019 | 10.0.17763.1935 or higher |
| 20H2 SAC | 10.0.19042.985 or higher |
| Windows Server 2022 | All versions |

## How do I configure the container's time zone?

First, you need **both host and guest** versions containing this feature, which means running on a 2105B servicing patch or higher. Running earlier versions simply revert the behavior of the container to mirroring the host's time zone with the configuration having no impact on the host or guest.

> [!NOTE]
> Configuring the time zone requires administrative privileges, specifically SeTimeZonePrivilege. The ContainerAdministrator account has this privilege. Therefore, the recommendation is to run with the least privileges necessary for your workload and reserve the ContainerAdministrator account for administrative tasks, such as setting the time zone.

**The recommended way to configure the container time zone is through the TZUtil.exe utility or PowerShell's Set-TimeZone cmdlet**. These utilities are well maintained and offer convenience to easily set the time zone. Any other method needs to directly interact with the system APIs. Base image versions with TZUtil.exe or PowerShell included will work right out of the box. The `Nanoserver` base image is an exception as this image does not support TZUtil.exe or PowerShell by default, so it requires a custom utility to interact with the system APIs. In any case, **newly written applications should NOT take a dependency on the operating system time zone** unless absolutely necessary and should instead account for it within the application data and logic.

## Example using Windows Server 2019

Using the latest Windows Server 2019 [Server Core](https://hub.docker.com/_/microsoft-windows-servercore) base image, the following is an example for setting a virtualized time zone.

1. After starting the container, set the time zone to the host's time zone (in this example, it's Pacific Standard Time) as shown below:

     ```powershell
    PS C:\> tzutil /g
    Pacific Standard Time

2. Set the time zone of the **host** to Central Asian Standard Time (UTC+6:00) and notice that the Pacific Standard Time still appears in the container:

    ```powershell
    PS C:\> Get-TimeZone
    ```
            
    ```output    
    Id                         : Pacific Standard Time
    DisplayName                : (UTC-08:00) Pacific Time (US & Canada)
    StandardName               : Pacific Standard Time
    DaylightName               : Pacific Daylight Time
    BaseUtcOffset              : -08:00:00
    SupportsDaylightSavingTime : True
    ```

   Note that when starting the container for the first time, the configuration is set to whatever was configured when creating the base image **until you configure it yourself**. In most cases for Windows base images, the default will be Pacific Standard Time.

3. Next, set the time zone of the container to "Samoa Standard Time":

    ```powershell
    PS C:\> tzutil /s "Samoa Standard Time"
    PS C:\> tzutil /g
    Samoa Standard Time
    PS C:\> Get-TimeZone
    ```
            
    ```output 
    Id                         : Samoa Standard Time
    DisplayName                : (UTC+13:00) Samoa
    StandardName               : Samoa Standard Time
    DaylightName               : Samoa Daylight Time
    BaseUtcOffset              : 13:00:00
    SupportsDaylightSavingTime : True
    ```

    Now the container's time zone has been updated to Samoa Standard Time, but the host remains on Central Asia Standard time. This configuration persists when saving the container's state.

4. If you restart the container without previously saving its state, the time zone is set to the time zone of the host as shown below:

    ```powershell
    PS C:\>tzutil /g
    Central Asia Standard Time
    PS C:\> Get-TimeZone
    ```
                
    ```output
    Id                         : Central Asia Standard Time
    DisplayName                : (UTC+06:00) Astana
    StandardName               : Central Asia Standard Time
    DaylightName               : Central Asia Daylight Time
    BaseUtcOffset              : 06:00:00
    SupportsDaylightSavingTime : False
    ```
