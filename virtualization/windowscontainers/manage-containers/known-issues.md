---
title: Known issues
description: Known issues for Windows Server containers.
author: taylob
ms.author: mabrigg
ms.topic: reference
ms.date: 07/21/2021
---
# Known Issues

## Known issues with Windows Server, version 2004

### Performance Issue on Server Core container
In prepping for general availability of Windows Server, version 2004 release, we identified a potential performance issue with .NET Team on the current Server Core container image in the May 27, 2020 release when compared to the performance improvements as discussed in this December 2019 [blog post](https://techcommunity.microsoft.com/t5/containers/making-windows-server-core-containers-40-smaller/ba-p/1058874) and on the [.NET Team blog](https://devblogs.microsoft.com/dotnet/we-made-windows-server-core-container-images-40-smaller/). At that time, the performance analysis was performed on a Windows Server, version 2004, Insider Preview release Server Core container image.

The performance issues that we observed are:

When using the Server Core container image to build your own image and then uploading it to a remote container registry, such as Azure Container Registry, when you pull that image from the registry and run it, you'll see a slower performance of the container. However, if you build the image and run the image locally, you will not observe that performance difference.

This issue is now root caused, and we are working on the fix. You can find the following links that track the issue:
[microsoft/hcsshim#830](https://github.com/microsoft/hcsshim/issues/830);

[moby/moby#41066](https://github.com/moby/moby/issues/41066);

[containerd/containerd#4301](https://github.com/containerd/containerd/issues/4301).


