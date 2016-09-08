---
title: Container Data Volumes
description: Create and manage data volumes with Windows containers.
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: f5998534-917b-453c-b873-2953e58535b1
---

# Container Data Volumes

**This is preliminary content and subject to change.** 

When creating containers, you may need to create a new data directory, or add an existing directory to the container. This can be accomplished through adding data volumes. Data volumes are visible to both container and container host, and data can be shared between them. Data volumes can also be shared between multiple containers on the same container host. 
This document will detail creating, inspecting, and removing data volumes.

## Data volumes

### Create new data volume

Create a new data volume using `-v` parameter of the `docker run` command. By default, new data volumes are stored on the host under 'c:\ProgramData\Docker\volumes'.

This example creates a data volume named 'new-data-volume'. This data volume will be accessible in the running container at 'c:\new-data-volume'.

```none
docker run -it -v c:\new-data-volume windowsservercore cmd
```

For more information on creating volumes, see [Manage data in containers on docker.com](https://docs.docker.com/engine/userguide/containers/dockervolumes/#data-volumes).

### Mounting existing directory

In addition to creating a new data volume, you may want to pass an existing directory from the host, through to the container. This can also be accomplished with the `-v` parameter of the `docker run` command. All files inside host directory will also be available in the container. Any files created by the container in the mounted volume, will be available on the host. The same directory can be mounted to many containers. In this configuration, data can be shared between containers.

In this example, the source directory, 'c:\source', is mounted into a container as 'c:\destination'.

```none
docker run -it -v c:\source:c:\destination windowsservercore cmd
```

For more information on mounting host directories, see [Manage data in containers on docker.com](https://docs.docker.com/engine/userguide/containers/dockervolumes/#mount-a-host-directory-as-a-data-volume).

### Mount single files

A single file cannot be mounted into a Windows container. Running the following command will not fail, however the resulting container will not contain the file. 

```none
docker run -it -v c:\config\config.ini microsoft/windowsservercore cmd
```

As a workaround, any files to me mounted into a container will need to be mounted from a directory.

```none
docker run -it -v c:\config:c:\config microsoft/windowsservercore cmd
```

### Mount full drive

A complete drive can be mounted using a command similar to this.

```none
docker run -it -v d:\:d: windowsservercore cmd
```

At this time, mounting a portion of the second drive does not work. For instance, the following is not possible.

```none
docker run -it -v d:\source:d:\destination windowsservercore cmd
```

### Data volume containers

Data volumes can be inherited from other running containers using the `--volumes-from` parameter of the `docker run` command. Using this inheritance, a container can be created with the explicit purpose of hosting data volumes for containerized applications. 

This example mounts the data volumes from the container ‘cocky_bell` into a new container. Once the new container has been started, the data found in this volume will be available for applications running in the container.  

```none
docker run -it --volumes-from cocky_bell windowsservercore cmd
```

For more information on data containers see [Manage data in containers on docker.com](https://docs.docker.com/engine/userguide/containers/dockervolumes/#mount-a-host-file-as-a-data-volume).

### Inspect shared data volume

Mounted volumes can be viewed using the `docker inspect` command.

```none
docker inspect backstabbing_kowalevski
```

This will return information about the container, including a section named ‘Mounts’, which contains data about the mounted volumes such as the source and destination directory.

```none
"Mounts": [
    {
        "Source": "c:\\container-share",
        "Destination": "c:\\data",
        "Mode": "",
        "RW": true,
        "Propagation": ""
}
```

For more information on inspecting volumes, see [Manage data in containers on docker.com](https://docs.docker.com/engine/userguide/containers/dockervolumes/#locating-a-volume).

