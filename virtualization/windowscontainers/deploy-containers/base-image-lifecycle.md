---
title: Windows container base image release information
description: Information about the Windows container base image lifecycle.
keywords: windows containers, containers, lifecycle, release information, base image, container base image
author: helohr
ms.date: 11/19/2018
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
---
# Windows container base image release information

The Semi-Annual Channel is a twice-per-year feature update release with eighteen-month servicing timelines for each release. This page is designed to help you determine the end of support date for a Windows container base image that's tied to the Semi-Annual Channel releases.

The Semi-Annual Channel provides opportunity for customers who are innovating quickly to take advantage of new operating system capabilities at a faster pace, both in applications (particularly those built on containers and microservices) and in the software-defined hybrid datacenter. For more information, see the [Windows Server Semi-Annual Channel overview](https://docs.microsoft.com/windows-server/get-started/semi-annual-channel-overview). Customers also have the option to continue using the Long-Term Servicing Channel releases, which continue to be released every two to three years. Each Long-Term Servicing Channel release is supported for five years of mainstream support and five years of extended support.

|Windows container base image|Version|OS build|Availability|Mainstream support end date|Extended support date|
|---|---|---|---|---|---|
|Server Core (LTSC)|1809|17763|11/13/2018|01/09/2024|01/09/2029|
|Server Core, Nano Server, Windows|1809|17763|11/13/2018|5/11/2020|N/A|
|Server Core, Nano Server|1803|17134|4/30/2018|11/12/2019|N/A|
|Server Core, Nano Server|1709|16299|10/17/2017|04/09/2019|N/A|
|Server Core (LTSC)|1607|14393|10/15/2016|01/11/2022|01/11/2027|
|Nano Server |1607|14393|10/15/2016|10/09/2018|N/A|

>[!NOTE]
>Windows Server, version 1803, and Windows Server, version 1809, are governed by the [Modern Lifecycle Policy](https://support.microsoft.com/help/30881). See the [Windows Lifecycle FAQ](https://support.microsoft.com/help/18581/lifecycle-faq-windows-products) and [Windows Server Semi-Annual Channel overview](https://docs.microsoft.com/en-us/windows-server/get-started/semi-annual-channel-overview) for details regarding servicing requirements and other important information.

For additional information, see [Windows base OS images](https://hub.docker.com/_/microsoft-windows-base-os-images) on Docker.