---
title: Known Issues
description: Known Issues for Windows Server containers
keywords: metadata, containers, version,
author: weijuans
ms. author: weijuans
manager: taylob
ms.date: 05/26/2020
---
# Known Issues

## Know Issues of Windows Server, version 2004

### 1. Performance Issue on Server Core container
In prepping for Windows Server, version 2004 release, we identified a performance issue with .NET Team on the current Server Core container image in this release, comparing to the performance improvements we blogged in Dec 2019 [here](https://techcommunity.microsoft.com/t5/containers/making-windows-server-core-containers-40-smaller/ba-p/1058874) and on .NET Team blog [here](https://devblogs.microsoft.com/dotnet/we-made-windows-server-core-container-images-40-smaller/) which was done on a Windows Server, version 2004 (also referred as "20H1") Insider Release Server Core container image. 

The symptons that we observed are like this:

If you use the Server Core container image to build your own image and upload to a remote container registry such as Azure Container Registry, and then you or someone else pulls that image from the registry and runs it, you will see a slower performance of the container.
However, if you build the image and run the image locally, you will not see any performance difference.

We have idenfied some possible root causes and are actively looking at how to fix this. Please stay tuned.

## Know Issues of Windows Server, version 1909

## Know Issues of Windows Server, version 1903

## Know Issues of Windows Server 2019/Windows Server, version 1809

## Know Issues of Windows Server 2016
