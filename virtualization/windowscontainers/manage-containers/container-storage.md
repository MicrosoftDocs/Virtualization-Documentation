---
title: Container storage overview
description: How Windows Server containers can use host and other storage types.
author: cwilhit
ms.author: mosagie
ms.date: 01/23/2025
ms.topic: overview
---

# Container Storage Overview

This topic provides an overview of the different ways containers use storage on Windows. Containers behave differently than virtual machines when it comes to storage. By nature, containers are built to prevent an app running within them from writing state all over the host's filesystem. Containers use a "scratch" space by default, but Windows also provides a means to persist storage.

## Scratch Space

Windows containers by default use ephemeral storage. All container I/O happens in a "scratch space" and each container gets their own scratch. File creation and file writes are captured in the scratch space and do not escape to the host. When a container instance is stopped, all changes that occurred in the scratch space are thrown away. When a new container instance is started, a new scratch space is provided for the instance.

## Layer Storage

As described in the [Containers Overview](../about/index.md), container images are a bundle of files expressed as a series of layers. Layer storage is all the files that are built into the container. Every time you `docker pull` then `docker run` that container - they are the same.

### Where layers are stored and how to change it

In a default installation, layers are stored in `C:\ProgramData\docker` and split across the "image" and "windowsfilter" directories. You can change where the layers are stored using the `docker-root` configuration, as demonstrated in the [Docker Engine on Windows](../manage-docker/configure-docker-daemon.md) documentation.

> [!NOTE]
> Only NTFS is supported for layer storage. ReFS and cluster shared volumes (CSV) are not supported.

You should not modify any files in the layer directories - they're carefully managed using commands such as:

- [docker images](https://docs.docker.com/reference/cli/docker/image/ls/)
- [docker rmi](https://docs.docker.com/reference/cli/docker/image/rm/)
- [docker pull](https://docs.docker.com/reference/cli/docker/image/pull/)
- [docker load](https://docs.docker.com/reference/cli/docker/image/load/)
- [docker save](https://docs.docker.com/reference/cli/docker/image/save/)

### Supported operations in layer storage

Running containers can use most NTFS operations with the exception of transactions. This includes setting ACLs, and all ACLs are checked inside the container. If you want to run processes as multiple users inside a container, you can create users in your `Dockerfile` with `RUN net user /create ...`, set file ACLs, then configure processes to run with that user using the [Dockerfile USER directive](https://docs.docker.com/reference/dockerfile/#user).

## Persistent Storage

Windows containers support mechanisms for providing persistent storage via bind mounts and volumes. To learn more, see [Persistent Storage in Containers](./persistent-storage.md).

## Storage Limits

A common pattern for Windows applications is to query the amount of free disk space before installing or creating new files or as a trigger for cleaning up temporary files.  With the goal of maximizing application compatibility, the C: drive in a Windows container represents a virtual free size of 20GB.

Some users may want to override this default and configure the free space to a smaller or larger value. this can be accomplished though the “size” option within the “storage-opt” configuration.

### Example

Command line: `docker run --storage-opt "size=50GB" mcr.microsoft.com/windows/servercore:ltsc2019 cmd`

Or you can change the docker configuration file directly:

```Docker Configuration File
"storage-opts": [
    "size=50GB"
  ]
```

> [!TIP]
> This method works for docker build, too. See the [configure docker](../manage-docker/configure-docker-daemon.md#configure-docker-with-a-configuration-file) document for more details on modifying the docker configuration file.
