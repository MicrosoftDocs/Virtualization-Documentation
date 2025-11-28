---
title: Overview of Windows Container Base Images
description: Learn about Windows container base images, their differences, and how to choose the right one for your application. Explore Nano Server, Server Core, and more.
#customer intent: As a system administrator, I want to know how to pull Windows container base images from the Microsoft Container Registry so that I can set up my containerized environment.
author: robinharwood
ms.author: roharwoo
ms.date: 11/28/2025
ms.topic: overview
---

# Overview of Windows Container base images

> Applies to: Windows Server 2025, Windows Server 2022, Windows Server 2019, Windows Server 2016

Windows offers four container base images that you can build from. Each base image is a different type of the Windows or Windows Server operating system. Each base image has a different on-disk footprint and a different set of the Windows API set.

<ul class="columns is-multiline has-margin-left-none has-margin-bottom-none has-padding-top-medium">
    <li class="column is-one-quarter has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="https://hub.docker.com/_/microsoft-windows-servercore" data-linktype="external">
            <article class="card has-outline-hover is-relative is-full-height has-padding-none">
                    <div class="cardImageOuter bgdAccent1 has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                        <div class="cardImage centered has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                            <img src="media/Microsoft_logo.svg" alt="Microsoft logo" data-linktype="relative-path">
                        </div>
                    </div>
                <div class="card-content has-text-overflow-ellipsis has-padding-top-small">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Windows Server Core</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Supports traditional .NET framework applications.</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
    <li class="column is-one-quarter has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="https://hub.docker.com/_/microsoft-windows-nanoserver" data-linktype="external">
            <article class="card has-outline-hover is-relative is-full-height has-padding-none">
                    <div class="cardImageOuter bgdAccent1 has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                        <div class="cardImage centered has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                            <img src="media/Microsoft_logo.svg" alt="Microsoft logo." data-linktype="relative-path">
                        </div>
                    </div>
                <div class="card-content has-text-overflow-ellipsis has-padding-top-small">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Nano Server</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Built for .NET Core applications.</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
    <li class="column is-one-quarter has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="https://hub.docker.com/_/microsoft-windows" data-linktype="external">
            <article class="card has-outline-hover is-relative is-full-height has-padding-none">
                    <div class="cardImageOuter bgdAccent1 has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                        <div class="cardImage centered has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                            <img src="media/Microsoft_logo.svg" alt="Microsoft logo." data-linktype="relative-path">
                        </div>
                    </div>
                <div class="card-content has-text-overflow-ellipsis has-padding-top-small">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Windows</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Provides the full Windows API set.</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
    <li class="column is-one-quarter has-padding-top-small-mobile has-padding-bottom-small">
        <a class="is-undecorated is-full-height is-block"
            href="https://hub.docker.com/r/microsoft/windows-server/" data-linktype="external">
            <article class="card has-outline-hover is-relative is-full-height has-padding-none">
                    <div class="cardImageOuter bgdAccent1 has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                        <div class="cardImage centered has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                            <img src="media/Microsoft_logo.svg" alt="Microsoft logo." data-linktype="relative-path">
                        </div>
                    </div>
                <div class="card-content has-text-overflow-ellipsis has-padding-top-small">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Windows Server</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Provides the full Windows API set.</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
</ul>

## Image discovery

You can discover all Windows container base images through [Docker Hub](https://hub.docker.com/r/microsoft/windows). The Windows container base images themselves come from [mcr.microsoft.com](https://azure.microsoft.com/services/container-registry/), the Microsoft Container Registry (MCR). This registry is why the pull commands for the Windows container base images look like the following command:

```code
docker pull mcr.microsoft.com/windows/servercore:ltsc2025
```

The MCR doesn't have its own catalog experience. Instead, it supports existing catalogs, such as Docker Hub. With Azure's global footprint and Azure Content Delivery Network, the MCR delivers an image pull experience that's consistent and fast. Azure customers benefit from faster in-network speeds and close ties with the MCR, Azure Marketplace, and other Azure services. Many Azure services now use containers as their deployment format.

## Choosing a base image

How do you choose the right base image to build upon? For most users, `Windows Server Core` and `Nanoserver` are the most appropriate images to use. Each base image is briefly described in the following list:

- `Nano Server` is an ultralight Windows offering for new application development.
- `Server Core` is medium in size and a good option for "lifting and shifting" Windows Server apps.
- `Windows` is the largest image and has full Windows API support for workloads.
- `Windows Server` is slightly smaller than the Windows image, has full Windows API support, and allows you to use more server features.

### Guidelines

 While you're free to target whichever image you want to use, consider the following guidelines:

- **Does your application require the full .NET framework?** If yes, target `Windows Server Core`.
- **Are you building a Windows app based upon .NET Core?** If yes, target `Nanoserver`.
- **Is the Windows Server Core container image missing a dependency your app needs?** If yes, try to target `Windows`. This image is larger than the other base images, but it carries many of the core Windows libraries (such as the graphics device interface library).
- **Are you a Windows Insider?** If yes, consider using the insider version of the images. For more information, see "Base images for Windows insiders" in the following section.
- **Do you need GPU acceleration support for your container workloads?** If yes, consider using the `Windows Server` image to include hardware acceleration for your Windows containers workloads.

> [!TIP]
> Many Windows users want to containerize applications that have a dependency on .NET. In addition to the four base images described here, Microsoft publishes several Windows container images that come preconfigured with popular Microsoft frameworks, such as the [.NET framework](https://hub.docker.com/r/microsoft/dotnet-framework) image and the [ASP.NET](https://hub.docker.com/r/microsoft/dotnet-framework-aspnet) image.

## Windows vs Windows Server

The `Windows Server` image (3.1 GB) is slightly smaller than the `Windows` image (3.4 GB). The Windows Server image also inherits the performance and reliability improvements from the Server Core image, has GPU support, and has no limits for IIS connections. To use the latest Windows Server image, you need a Windows Server 2025 installation. The Windows image isn't available for Windows Server 2025.

## Base images for Windows Insiders

Microsoft provides "insider" versions of each container base image. These insider container images include the latest feature development in our container images. When you run a host that is an insider version of Windows (either Windows Insider or Windows Server Insider), use these images. The following insider images are available on Docker Hub:

- [mcr.microsoft.com/windows/servercore/insider](https://hub.docker.com/r/microsoft/windows-servercore-insider)
- [mcr.microsoft.com/windows/nanoserver/insider](https://hub.docker.com/r/microsoft/windows-nanoserver-insider)
- [mcr.microsoft.com/windows/server/insider:10.0.20344.1](https://hub.docker.com/r/microsoft/windows-server-insider/)
- [mcr.microsoft.com/windows/insider](https://hub.docker.com/r/microsoft/windows-insider)

To learn more, see [Use Containers with the Windows Insider Program](../deploy-containers/insider-overview.md).

## Windows Server Core vs Nano Server

Windows Server Core and Nano Server are the most common base images to target. The key difference between these images is that Nano Server has a smaller API surface. PowerShell, WMI, and the Windows servicing stack are absent from the Nano Server image.

Nano Server provides just enough API surface to run apps that depend on .NET core or other modern open source frameworks. As a tradeoff to the smaller API surface, the Nano Server image has a smaller on-disk footprint than the rest of the Windows base images. You can always add layers on top of Nano Server as you see fit. For an example of this check out the [.NET Core Nano Server Dockerfile](https://github.com/dotnet/dotnet-docker).
