---
title: Base image servicing lifecycles
description: Information about the Windows container base image lifecycle.
author: sethmanheim
ms.author: mosagie
ms.date: 01/23/2025
ms.topic: reference
---
# Base image servicing lifecycles

> Applies to: Windows Server 2025, Windows Server 2022, Windows Server 2019, Windows Server 2016

> [!Note]
> Microsoft has delayed the scheduled end of support and servicing dates for a number of products to help people and organizations focus their attention on retaining business continuity. See [Lifecycle changes to end of support and servicing dates](/lifecycle/announcements/lifecycle-changes-eos-servicing-dates) for more information.

Windows container base images are based on either Long-Term Servicing Channel releases or Semi-Annual Channel releases of Windows Server. This article explains how long support will last for different versions of base images from both channels.

The Semi-Annual Channel is a twice-per-year feature update release with eighteen-month servicing timelines for each release. This lets customers take advantage of new operating system capabilities at a faster pace, both in applications (particularly those built on containers and microservices) and in the software-defined hybrid data center. For more information, see the [Windows Server Semi-Annual Channel overview](/windows-server/get-started/semi-annual-channel-overview).

For Server Core images, customers can also use the Long-Term Servicing Channel that releases a new major version of Windows Server every two to three years. Long-Term Servicing Channel releases receive five years of mainstream support and five years of extended support. This channel works with systems that require a longer servicing option and functional stability.

The following table lists each type of base image, its servicing channel, and how long its support will last.

|Base image                       |Servicing channel|Version|OS build|Availability|Mainstream support end date|Extended support date|
|---------------------------------|-----------------|-------|--------|------------|---------------------------|---------------------|
|Server Core, Nano Server, Datacenter Container |Long-Term      |2025   | 26100   |11/01/2024  |10/09/2029                 |10/10/2034                  |
|Server Core, Nano Server, Datacenter Container |Long-Term      |2022   | 20348   |08/18/2021  |10/13/2026                 |10/14/2031                  |
|Server Core, Nano Server, Windows|Semi-Annual      |20H2   |19042   |10/20/2020  |08/09/2022                 |N/A                  |
|Server Core, Nano Server, Windows|Semi-Annual      |2004   |19041   |05/27/2020  |12/14/2021                 |N/A                  |
|Server Core, Nano Server, Windows|Semi-Annual      |1909   |18363   |11/12/2019  |05/11/2021                |N/A                  |
|Server Core, Nano Server, Windows|Semi-Annual      |1903   |18362   |05/21/2019  |12/08/2020                 |N/A                  |
|Server Core                      |Long-Term, Semi-Annual        |2019, 1809   |17763   |11/13/2018  |01/09/2024                 |01/09/2029           |
|Nano Server                      |Semi-Annual      |1809   |17763   |11/13/2018  |01/09/2024                 |01/09/2029                 |
|Windows             |Semi-Annual      |1809   |17763   |11/13/2018  |01/09/2024    |01/09/2029         |
|Server Core, Nano Server         |Semi-Annual      |1803   |17134   |04/30/2018  |11/12/2019                 |N/A                  |
|Server Core, Nano Server         |Semi-Annual      |1709   |16299   |10/17/2017  |04/09/2019                 |N/A                  |
|Server Core                      |Long-Term        |2016   |14393   |10/15/2016  |01/11/2022                 |01/11/2027           |
|Nano Server                      |Semi-Annual      |1607   |14393   |10/15/2016  |10/09/2018                 |N/A                  |

For servicing requirements and other additional information, see the [Windows Lifecycle FAQ](/lifecycle/faq/windows), [Windows Server release information](/windows-server/get-started/windows-server-release-info), and the following Windows Server base OS images on the Docker Hub repo:

- [Windows Server](https://hub.docker.com/r/microsoft/windows-server)
- [Windows Server Core](https://hub.docker.com/r/microsoft/windows-servercore)
- [Nano Server](https://hub.docker.com/r/microsoft/windows-nanoserver)
