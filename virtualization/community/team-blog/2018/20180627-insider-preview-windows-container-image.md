---
layout:     post
title:      "Insider preview&#58; Windows container image"
date:       2018-06-27 10:00:23
categories: containers
---
Earlier this year at Microsoft Build 2018, we announced a third container base image for applications that have additional API dependencies beyond _nano server_ and _Windows Server Core_. Now the time has finally come and the _Windows_ container image is available for Windows Insiders. [![](https://msdnshared.blob.core.windows.net/media/2018/06/windowscontainerbuild2018-500x281.png)](https://msdnshared.blob.core.windows.net/media/2018/06/windowscontainerbuild2018.png)

## Why another container image?

In conversations with IT Pros and developers there were some themes coming up which went beyond the `nanoserver` and `windowsservercore` container images: Quite a few customers were interested in moving their legacy applications into containers to benefit from container orchestration and management technologies like Kubernetes. However, not all applications could be easily containerized, in some cases due to missing components like proofing support which is not included in Windows Server Core. Others wanted to leverage containers to run automated UI tests as part of their CI/CD processes or use other graphics capabilities like DirectX which are not available within the other container images. With the new `windows` container image, we're now offering a third option to choose from based on the requirements of the workload. We're looking forward to see what you will build! 

## How can you get it?

If you are running a container host on Windows Insider build, you can get the matching container image using the following commands:  To simply get the latest available version of the container image, you can use the following command: `docker pull mcr.microsoft.com/windows-insider:latest` Please note that for compatibility reasons we recommend running the same build version for the container host and the container itself. Since this image is currently part of the Windows Insider preview, we're looking forward to your feedback, bug reports, and comments. We will be publishing newer builds of this container image along with the insider builds. Alles Gute, Lars (update: Added PowerShell gist to download the matching container instead of a static docker pull command) 
