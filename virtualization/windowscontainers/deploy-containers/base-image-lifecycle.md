---
title: Base image servicing lifecycles
description: Information about the Windows container base image lifecycle.
author: sethmanheim
ms.author: mosagie
ms.date: 06/12/2025
ms.topic: reference
---
# Base image servicing lifecycles

> Applies to: Windows Server 2025, Windows Server 2022, Windows Server 2019, Windows Server 2016

> [!NOTE]
> Microsoft has delayed the scheduled end of support and servicing dates for a number of products to help people and organizations focus their attention on retaining business continuity. See [Lifecycle changes to end of support and servicing dates](/lifecycle/announcements/lifecycle-changes-eos-servicing-dates) for more information.

Windows container base images are based on either Long-Term Servicing Channel releases or Annual Channel releases of Windows Server. This article explains how long support will last for different versions of base images from both channels.

Beginning September 2023 Windows Server has two primary release channels available, the Long-Term Servicing Channel and the Annual Channel. The Long-Term Servicing Channel (LTSC) provides a longer term option focuses on providing a traditional lifecycle of quality and security updates, whereas the Annual Channel (AC) provides more frequent releases. For more a more detailed comparison, see [Windows Server servicing channels](/windows-server/get-started/servicing-channels-comparison).

Windows Server Annual Channel for Containers is an operating system to specifically host Windows Server containers. Windows Server Annual Channel for Containers introduces container image portability, meaning you can move to the latest Annual Channel release without having to rebuild your container images. To learn more about portability, see [Portability with Windows Server Annual Channel for Containers](https://techcommunity.microsoft.com/t5/containers/portability-with-windows-server-annual-channel-for-containers/ba-p/3885911).

For Server Core images, customers can also use the Long-Term Servicing Channel that typically releases a new major version of Windows Server every two to three years. Long-Term Servicing Channel releases receive five years of mainstream support and five years of extended support. This channel works with systems that require a longer servicing option and functional stability.

The following table lists each type of base image, its servicing channel, and how long its support will last.

| Base image                                     | Servicing channel      | Version    | OS build | Availability | Mainstream support end date | Extended support date |
|------------------------------------------------|------------------------|------------|----------|--------------|-----------------------------|-----------------------|
| Server Core, Nano Server, Datacenter Container | Long-Term              | 2025       | 26100    | 11/01/2024   | 10/09/2029                  | 10/10/2034            |
| Server Core, Nano Server, Datacenter Container | Long-Term              | 2022       | 20348    | 08/18/2021   | 10/13/2026                  | 10/14/2031            |
| Server Core                                    | Long-Term, Semi-Annual | 2019, 1809 | 17763    | 11/13/2018   | 01/09/2024                  | 01/09/2029            |
| Nano Server                                    | Semi-Annual            | 1809       | 17763    | 11/13/2018   | 01/09/2024                  | 01/09/2029            |
| Windows                                        | Semi-Annual            | 1809       | 17763    | 11/13/2018   | 01/09/2024                  | 01/09/2029            |
| Server Core                                    | Long-Term              | 2016       | 14393    | 10/15/2016   | 01/11/2022                  | 01/11/2027            |

For servicing requirements and other additional information, see the [Windows Lifecycle FAQ](/lifecycle/faq/windows), [Windows Server release information](/windows-server/get-started/windows-server-release-info), and the following Windows Server base OS images on the Docker Hub repo:

- [Windows Server](https://hub.docker.com/r/microsoft/windows-server)
- [Windows Server Core](https://hub.docker.com/r/microsoft/windows-servercore)
- [Nano Server](https://hub.docker.com/r/microsoft/windows-nanoserver)
