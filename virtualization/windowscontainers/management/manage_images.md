---
title: Windows Container Images
description: Create and manage container images with Windows containers.
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 08/22/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: d8163185-9860-4ee4-9e96-17b40fb508bc
redirect_url: https://docs.docker.com/v1.8/userguide/dockerimages/
---

# Windows Container Images

**This is preliminary content and subject to change.** 

>Windows Containers are managed with Docker. The Windows Container documentation is supplemental to documentation found on [docs.docker.com](https://docs.docker.com/).

Container images are used to deploy containers. These images can include applications and all application dependencies. For instance, you may develop a container image that has been pre-configured with Nano Server, IIS, and an application running in IIS. This container image can then be stored in a container registry for later use, deployed on any Windows container host (on-prem, cloud, or even to a container service), and also used as the base for a new container image.

### Install image

Before working with Windows Containers a base image needs to be installed. Base images are available with either Windows Server Core or Nano Server as the underlying operating system. For information on supported configurations, see [Windows Container System Requirements](../deployment/system_requirements.md).

To install the Windows Server Core base image run the following:

```none
docker pull microsoft/windowsservercore
```

To install the Nano Server base image run the following:

```none
docker pull microsoft/nanoserver
```

### List Images

```none
docker images

REPOSITORY                    TAG                 IMAGE ID            CREATED             SIZE
microsoft/windowsservercore   latest              02cb7f65d61b        9 weeks ago         7.764 GB
microsoft/nanoserver          latest              3a703c6e97a2        9 weeks ago         969.8 MB
```

### Create new image

A new container image can be created from any existing container. To do so, use the `docker commit` command. The following example creates a new container image with the name ‘windowsservercoreiis’.

```none
docker commit 475059caef8f windowsservercoreiis
```

### Remove image

Container images cannot be removed if any container, even in a stopped state, has a dependency on the image.

When removing an image with docker, the images can be referenced by image name or id.

```none
docker rmi windowsservercoreiis
```

### Image dependency

To see image dependencies with Docker, the `docker history` command can be used.

```none
docker history windowsservercoreiis

IMAGE               CREATED             CREATED BY          SIZE                COMMENT
2236b49aaaef        3 minutes ago       cmd                 171.2 MB
6801d964fda5        2 weeks ago                             0 B
```

### Docker Hub

The Docker Hub registry contains pre-built images which can be downloaded onto a container host. Once these images have been downloaded, they can be used as the base for Windows container Applications.

To see a list of images available from Docker Hub use the `docker search` command. Note – the Windows Server Core or Nano Server base OS images will need to be installed before pulling these dependent container images from Docker Hub.

Most of these images have a Windows Server Core and a Nano Server version. To get a specific version just add the tag ":windowsservercore" or ":nanoserver". The "latest" tag will return the Windows Server Core version by default, unless there is only a Nano Server version available.


```none
docker search *

NAME                     DESCRIPTION                                     STARS     OFFICIAL   AUTOMATED
microsoft/sample-django  Django installed in a Windows Server Core ...   1                    [OK]
microsoft/dotnet35       .NET 3.5 Runtime installed in a Windows Se...   1         [OK]       [OK]
microsoft/sample-golang  Go Programming Language installed in a Win...   1                    [OK]
microsoft/sample-httpd   Apache httpd installed in a Windows Server...   1                    [OK]
microsoft/iis            Internet Information Services (IIS) instal...   1         [OK]       [OK]
microsoft/sample-mongodb MongoDB installed in a Windows Server Core...   1                    [OK]
microsoft/sample-mysql   MySQL installed in a Windows Server Core b...   1                    [OK]
microsoft/sample-nginx   Nginx installed in a Windows Server Core b...   1                    [OK]
microsoft/sample-node    Node installed in a Windows Server Core ba...   1                    [OK]
microsoft/sample-python  Python installed in a Windows Server Core ...   1                    [OK]
microsoft/sample-rails   Ruby on Rails installed in a Windows Serve...   1                    [OK]
microsoft/sample-redis   Redis installed in a Windows Server Core b...   1                    [OK]
microsoft/sample-ruby    Ruby installed in a Windows Server Core ba...   1                    [OK]
microsoft/sample-sqlite  SQLite installed in a Windows Server Core ...   1                    [OK]
```

### Docker Pull

To download an image from Docker Hub, use `docker pull`. For more information, see [Docker Pull on Docker.com](https://docs.docker.com/engine/reference/commandline/pull/).

```none
docker pull microsoft/aspnet

Using default tag: latest
latest: Pulling from microsoft/aspnet
f9e8a4cc8f6c: Pull complete

b71a5b8be5a2: Download complete
```

The image will now be visible when running `docker images`.

```none
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
microsoft/aspnet    latest              b3842ee505e5        5 hours ago         101.7 MB
windowsservercore   10.0.14300.1000     6801d964fda5        2 weeks ago         0 B
windowsservercore   latest              6801d964fda5        2 weeks ago         0 B
```

> If Docker Pull fails, ensure that the latest cumulative updates have been applied to the container host. The TP5 update can be found at [KB3157663]( https://support.microsoft.com/en-us/kb/3157663).

### Docker Push

Container images can also be uploaded to Docker Hub or a Docker Trusted Registry. Once uploaded these images can be downloaded and re-used across different Windows container environments.

To upload a container image to Docker Hub, first log into the registry. For more information, see [Docker Login on Docker.com]( https://docs.docker.com/engine/reference/commandline/login/) .

```none
docker login

Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: username
Password:

Login Succeeded
```

Once logged into Docker hub or your Docker Trusted registry, use `docker push` to upload a container image. The container image can be referenced by name or ID. For more information, see [Docker Push on Docker.com]( https://docs.docker.com/engine/reference/commandline/push/).

```none
docker push username/containername

The push refers to a repository [docker.io/username/containername]
b567cea5d325: Pushed
00f57025c723: Pushed
2e05e94480e9: Pushed
63f3aa135163: Pushed
469f4bf35316: Pushed
2946c9dcfc7d: Pushed
7bfd967a5e43: Pushed
f64ea92aaebc: Pushed
4341be770beb: Pushed
fed398573696: Pushed
latest: digest: sha256:ae3a2971628c04d5df32c3bbbfc87c477bb814d5e73e2787900da13228676c4f size: 2410
```

At this point the container image is now available and can be accessed with `docker pull`.



