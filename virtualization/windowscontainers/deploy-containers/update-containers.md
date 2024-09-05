---
title: Update Windows Server containers
description: Learn how Windows can run build and run containers across multiple versions.
author: heidilohr
ms.author: helohr
manager: lizross
ms.topic: conceptual
ms.date: 10/20/2021
---
# Update Windows Server containers

> Applies to: Windows Server 2022, Windows Server 2019, Windows Server 2016

As part of servicing Windows Server each month, we publish updated Windows Server Base OS container images on a regular basis. With these updates, you can automate building updated container images or manually update them by pulling the latest version. Windows Server containers don't have a servicing stack like Windows Server. You can't get updates within a container like you do with Windows Server. Therefore, every month we rebuild the Windows Server Base OS container images with the updates and publish the updated container images.

Other container images, such as .NET or IIS, will be rebuilt based on the updated Base OS container images and published monthly.

## How to get Windows Server container updates

We update Windows Server Base OS container images in alignment with the Windows servicing cadence. Updated container images are published the second Tuesday of each month, which we sometimes refer to as our "B" release, with a prefix number based on the release month. For example, we call our February update "2B" and our March update "3B." This monthly update event is the only regular release that include new security fixes.

The server hosting these containers, called the container host or just the "host", can be serviced during additional update events other than "B" releases. To learn more about the Windows update servicing cadence, see our [Windows update servicing cadence](https://techcommunity.microsoft.com/t5/windows-it-pro-blog/windows-10-update-servicing-cadence/ba-p/222376) blog post.

New Windows Server Base OS container images go live shortly after 10:00am PST on the second Tuesday of each month in the Microsoft Container Registry (MCR), and the featured tags target the most recent B release. Some examples include:

- ltsc2019 [(LTSC)](/windows-server/get-started-19/servicing-channels-19#long-term-servicing-channel-ltsc):  docker pull mcr.microsoft.com/windows/servercore:ltsc2019
- 1909 [(SAC)](/windows-server/get-started-19/servicing-channels-19#semi-annual-channel): docker pull mcr.microsoft.com/windows/servercore:1909

If you're more familiar with Docker Hub than MCR, [this blog post](https://azure.microsoft.com/blog/microsoft-syndicates-container-catalog/) will give you a more detailed explanation.

For each release, the respective container image also gets published with two additional tags for the revision number and the KB article number for targeting specific container image revisions. For example:

- docker pull mcr.microsoft.com/windows/servercore:10.0.17763.1040
- docker pull mcr.microsoft.com/windows/servercore:1809-KB4546852

These examples both pull the Windows Server 2019 Server Core container image with the February 18 security release update.

For a complete list of Windows Server Base OS container images, versions, and their respective tags, see the following resources on Docker Hub:

- [Windows Server](https://hub.docker.com/r/microsoft/windows-server)
- [Windows Server Core](https://hub.docker.com/r/microsoft/windows-servercore)
- [Nano Server](https://hub.docker.com/r/microsoft/windows-nanoserver)

Monthly serviced Windows Server images released on Azure Marketplace by Microsoft also come with preinstalled Base OS container images. Find our more at our [Windows Server Azure Marketplace pricing page](https://azuremarketplace.microsoft.com/marketplace/apps/microsoftwindowsserver.windowsserver?tab=PlansAndPrice). We usually update these images about five working days after the "B" release.

For a complete list of Windows Server images and versions, see [Windows Server release on Azure Marketplace update history](https://support.microsoft.com/help/4497947/windows-server-release-on-azure-marketplace-update-history).

## Host and container version compatibility

There are two types of isolation modes for Windows containers: Process isolation and Hyper-V isolation. Hyper-V isolation is more flexible when it comes to host and container version compatibility. To learn more, see [Version compatibility](version-compatibility.md) and [Isolation Modes](../manage-containers/hyperv-container.md). This section will focus on process-isolated containers unless stated otherwise.

When you update your container host or container image with the monthly updates, as long as the host and container image are both supported (Windows Server version 1809 or higher), the host and container image revisions don't need to match for the container to start and run normally.

However, you might encounter issues when using Windows Server containers with the February 11, 2020 security update release (also called "2B") or later monthly security update releases. See [this Microsoft Support article](https://support.microsoft.com/help/4542617/you-might-encounter-issues-when-using-windows-server-containers-with-t) for more details. These issues resulted from a security change that required an interface between user mode and kernel mode to change to ensure the security of your applications. These issues only happen on process isolated containers because process isolated containers share the kernel mode with the container host. This means container images without the updated user mode component were unsecured and incompatible with the new secured kernel interface.

We've released a fix as of February 18, 2020. This new release has established a "new baseline." This new baseline follows these rules:

- Any combination of hosts and containers that are both before 2B will work.
- Any combination of hosts and containers that are both after 2B will work.
- Any combination of hosts and containers on different sides of the new baseline won't work. For example, a 3B host and a 1B container won't work.

Let's use the March 2020 monthly security update release as an example to show you how these new compatibility rules work. In the following table, the March 2020 security update release is called "3B," the February 2020 update is "2B," and the January 2020 update is "1B."

| Host | Container | Compatibility |
|---|---|---|
| 3B | 3B | Yes |
| 3B | 2B | Yes |
| 3B | 1B or earlier | No |
| 2B | 3B | Yes |
| 2B | 2B | Yes |
| 2B | 1B or earlier | No |
| 1B or earlier | 3B | No |
| 1B or earlier | 2B | No |
| 1B or earlier | 1B or earlier | Yes |

For reference, the following table lists the version numbers for Base OS container images with 1B, 2B, and 3B monthly security update releases across different major OS releases from Windows Server 2016 to the latest Windows Server, version 1909 release.

| Windows Server version (floating tag) | Update version for 1/14/20 release (1B)| Update version for 2/18/20 release (2B) | Update version for 3/10/20 release (3B) |
|---|---|---|---|
| Windows Server 2016 (ltsc2016) | 10.0.14393.3443 (KB4534271) | 10.0.14393.3506 (KB4546850) | 10.0.14393.3568 (KB4551573) |
| Windows Server, version 1803 (1803) | 10.0.17134.1246 (KB4534293) | 10.0.17134.1305 (KB4546851)  | This version has reached end of support. For more information, see [Base image servicing lifecycles](base-image-lifecycle.md).|
| Windows Server, version 1809 (1809)| 10.0.17763.973 (KB4534273) | 10.0.17763.1040 (KB4546852) | 10.0.17763.1098 (KB4538461) |
| Windows Server 2019 (ltsc2019) | 10.0.17763.973 (KB4534273) | 10.0.17763.1040 (KB4546852) | 10.0.17763.1098 (KB4538461) |
| Windows Server, version 1903 (1903) |10.0.18362.592 (KB4528760) | 10.0.18362.658 (KB4546853) | 10.0.18362.719 (KB4540673) |
| Windows Server, version 1909 (1909) | 10.0.18363.592 (KB4528760) | 10.0.18363.658 (KB4546853) | 10.0.18363.719 (KB4540673) |

## Troubleshoot host and container image mismatches

Before you start, make sure sure to get familiar with the information in [Version compatibility](version-compatibility.md). This information will help you figure out whether your issue was caused by mismatching patches. When you've established mismatching patches as the cause, you can follow the instructions in this section to troubleshoot the issue.

### Query the version of your container host

If you can access your container host, you can run the `ver` command to get its OS version. For example, if you run `ver` on a system that runs Windows Server 2019 with the latest Feb 2020 security update release, you'll see this:

```batch
Microsoft Windows [Version 10.0.17763.1039]
(c) 2018 Microsoft Corporation. All rights reserved.

C:\>ver

Microsoft Windows [Version 10.0.17763.1039]
```

>[!NOTE]
>The revision number in this example displays as 1039, not 1040, because the Feb 2020 security update release didn't have an out-of-band 2B release for Windows Server. There was only an out-of-band 2B release for containers, which had a revision number of 1040.

If you don't have direct access to your container host, check with your IT admin. If you're running on the cloud, check the cloud provider's website to find out what container host OS version they're running. For example, If you are using Azure Kubernetes Service (AKS), you can find the host OS version in the [AKS release notes](https://github.com/Azure/AKS/releases).

### Query the version of your container image

Follow these instructions to find out which version your container is running:

1. Run the following cmdlet in PowerShell:

    ```powershell
    docker images
    ```

    The output should look something like this:

     ```powershell
     REPOSITORY                             TAG                 IMAGE ID            CREATED             SIZE
     mcr.microsoft.com/windows/servercore   ltsc2019            b456290f487c        4 weeks ago         4.84GB
     mcr.microsoft.com/windows              1809                58229ca44fa7        4 weeks ago         12GB
     mcr.microsoft.com/windows/nanoserver   1809                f519d4f3a868        4 weeks ago         251M

2. Run the `docker inspect` command for the Image ID of the container image that isn't working. This will tell you which version the container image is targeting.

   For example, let's say we `run docker inspect` for an ltsc 2019 container image:

   ```powershell
   docker inspect b456290f487c

       "Architecture": "amd64",

        "Os": "windows",

        "OsVersion": "10.0.17763.1039",

        "Size": 4841309825,

        "VirtualSize": 4841309825,
    ```

    In this example, the container OS version shows as `10.0.17763.1039`.

    If you're already running a container, you can also run the `ver` command within the container itself to get the version. For example, running `ver` in a Server Core container image of Windows Server 2019 with the latest Feb 2020 security update release will show you this:

    ```batch
    Microsoft Windows [Version 10.0.17763.1040]
    (c) 2020 Microsoft Corporation. All rights reserved.

    C:\>ver

    Microsoft Windows [Version 10.0.17763.1040]
    ```
