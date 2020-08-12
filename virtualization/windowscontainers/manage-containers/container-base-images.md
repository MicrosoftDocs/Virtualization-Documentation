---
title: Windows Container Base Images
description: An overview of the Windows container base images and when to use them.
keywords: docker, containers, hashes
author: patricklang
ms.date: 09/25/2019
ms.topic: conceptual
ms.assetid: 88e6e080-cf8f-41d8-a301-035959dc5ce0
---

# Container Base Images

Windows offers four container base images that users can build from. Each base image is a different flavor of the Windows OS, has a different on-disk footprint, and carries a different amount of the Windows API set.

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
            href="https://hub.docker.com/_/microsoft-windows-iotcore" data-linktype="external">
            <article class="card has-outline-hover is-relative is-full-height has-padding-none">
                    <div class="cardImageOuter bgdAccent1 has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                        <div class="cardImage centered has-padding-top-large has-padding-bottom-large has-padding-left-large has-padding-right-large">
                            <img src="media/Microsoft_logo.svg" alt="Microsoft logo." data-linktype="relative-path">
                        </div>
                    </div>
                <div class="card-content has-text-overflow-ellipsis has-padding-top-small">
                    <div class="has-padding-bottom-none">
                        <h3 class="is-size-4 has-margin-top-none has-margin-bottom-none has-text-primary">Windows IoT Core</h3>
                    </div>
                    <div class="is-size-7 has-margin-top-small has-line-height-reset">
                        <p>Purpose-built for IoT applications.</p>
                    </div>
                </div>
            </article>
        </a>
    </li>
</ul>

## Image discovery

All Windows container base images are discoverable through [Docker Hub](https://hub.docker.com/_/microsoft-windows-base-os-images). The Windows container base images themselves are served from [mcr.microsoft.com](https://azure.microsoft.com/services/container-registry/), the Microsoft Container Registry (MCR). This is why the pull commands for the Windows container base images look like the following:

```code
docker pull mcr.microsoft.com/windows/servercore:ltsc2019
```

The MCR does not have its own catalog experience and is meant to support existing catalogs such as Docker Hub. Thanks to Azure’s global footprint and coupled with Azure CDN, the MCR delivers an image pull experience that is consistent and fast. Azure customers, running their workloads in Azure, benefit from in-network performance enhancements as well as tight integration with the MCR (the source for Microsoft container images), Azure Marketplace, and the expanding number of services in Azure that offer containers as the deployment package format.

## Choosing a base image

How do you choose the right base image to build upon? For most users, `Windows Server Core` and `Nanoserver` will be the most appropriate image to use.

### Guidelines

 While you're free to target whichever image you wish, here are some guidelines to help steer your choice:

- **Does your application require the full .NET framework?** If the answer to this question is yes, you should target `Windows Server Core`.
- **Are you building a Windows app based upon .NET Core?** If the answer to this question is yes, you should target `Nanoserver`.
- **Are you building an IoT application?** If the answer to this question is yes, you should target `IoT Core`.
- **Is the Windows Server Core container image missing a dependency your app needs?** If the answer to this question is yes, you should attempt to target `Windows`. This image is much larger than the other base images, but it carries many of the core Windows libraries (such as the GDI library).
- **Are you a Windows Insider?** If yes, you should consider using the insider version of the images. See "Base images for Windows insiders" below.

> [!TIP]
> Many Windows users want to containerize applications that have a dependency on .NET. In addition to the four base images described here, Microsoft publishes several Windows container images that come pre-configured with popular Microsoft frameworks, such as a the [.NET framework](https://hub.docker.com/_/microsoft-dotnet-framework) image and the [ASP .NET](https://hub.docker.com/_/microsoft-dotnet-framework-aspnet/) image.

### Base images for Windows Insiders

Microsoft provides "insider" versions of each container base image. These insider container images carry the latest and greatest feature development in our container images. When you're running a host that is an insider version of Windows (either Windows Insider or Windows Server Insider), it is preferable to use these images. The insider images are available on Docker Hub:

- [mcr.microsoft.com/windows/servercore/insider](https://hub.docker.com/_/microsoft-windows-servercore-insider)
- [mcr.microsoft.com/windows/nanoserver/insider](https://hub.docker.com/_/microsoft-windows-nanoserver-insider)
- [mcr.microsoft.com/windows/iotcore/insider](https://hub.docker.com/_/microsoft-windows-iotcore-insider)
- [mcr.microsoft.com/windows/insider](https://hub.docker.com/_/microsoft-windows-insider)

Read [Use Containers with the Windows Insider Program](../deploy-containers/insider-overview.md) to learn more.

### Windows Server Core vs Nanoserver

`Windows Server Core` and `Nanoserver` are the most common base images to target. The key difference between these images is that Nanoserver has a significantly smaller API surface. PowerShell, WMI, and the Windows servicing stack are absent from the Nanoserver image.

Nanoserver was built to provide just enough API surface to run apps that have a dependency on .NET core or other modern open source frameworks. As a tradeoff to the smaller API surface, the Nanoserver image has a significantly smaller on-disk footprint than the rest of the Windows base images. Keep in mind that you can always add layers on top of Nano Server as you see fit. For an example of this check out the [.NET Core Nano Server Dockerfile](https://github.com/dotnet/dotnet-docker/blob/master/src/sdk/2.1/nanoserver-1909/amd64/Dockerfile).
