---
title: Persistent Storage in Containers
description: How Windows containers can persistent storage
keywords: containers, volume, storage, mount, bindmount
author: cwilhit
ms.topic: conceptual
---

# Persistent Storage in Containers

<!-- Great diagram would be great! -->

You may have cases where it's important that an app be able to persist data in a container, or you want to show files into a container that were not included at container build-time. Persistent storage can be given to containers in a couple ways:

- Bind mounts
- Named volumes

Docker has a great overview of how to [use volumes](https://docs.docker.com/engine/admin/volumes/volumes/) so it's best to read that first. The rest of this page focuses on differences between Linux & Windows and provides examples on Windows.

## Bind Mounts

[Bind mounts](https://docs.docker.com/engine/admin/volumes/bind-mounts/) allow a container to share a directory with the host. This is useful if you want a place to store files on the local machine that are available if you restart a container, or want to share it with multiple containers. If you want the container to run on multiple machines with access to the same files, then a named volume or SMB mount should be used instead.

> [!NOTE]
> Bind mounting directly on cluster shared volumes (CSV) is not supported, virtual machines acting as a container host can run on a CSV volume.

### Permissions

The permission model used for bind mounts varies based on the isolation level for your container.

Containers using **Hyper-V isolation** use a simple read-only or read-write permission model. Files are accessed on the host using the `LocalSystem` account. If you get access denied in the container, make sure `LocalSystem` has access to that directory on the host. When the read only flag is used, changes made to the volume inside the container will not be visible or persisted to the directory on the host.

Windows containers using **process isolation** are slightly different because they use the process identity within the container to access data, meaning that file ACLs are honored. The identity of the process running in the container ("ContainerAdministrator" on Windows Server Core and "ContainerUser" on Nano Server containers, by default) will be used to access to the files and directories in the mounted volume instead of `LocalSystem`, and will need to be granted access to use the data.

Since these identities only exist within the context of the container--not on the host where the files are stored--you should use a well-known security group such as `Authenticated Users` when configuring the ACLs to grant access to the containers.

> [!WARNING]
> Do not bind-mount sensitive directories such as `C:\` into an untrusted container. This would allow it to change files on the host that it would not normally have access to and could create a security breach.

Example usage:

- `docker run -v c:\ContainerData:c:\data:RO` for read-only access
- `docker run -v c:\ContainerData:c:\data:RW` for read-write access
- `docker run -v c:\ContainerData:c:\data` for read-write access (default)

### Symlinks

Symlinks are resolved in the container. If you bind-mount a host path to a container that is a symlink, or contains symlinks - the container will not be able to access them.

### SMB Mounts

On Windows Server version 1709 and later, feature called "SMB Global Mapping" makes it possible to mount a SMB share on the host, then pass directories on that share into a container. The container doesn't need to be configured with a specific server, share, username or password - that's all handled on the host instead. The container will work the same as if it had local storage.

#### Configuration Steps

1. On the container host, globally map the remote SMB share:
    ```
    $creds = Get-Credential
    New-SmbGlobalMapping -RemotePath \\contosofileserver\share1 -Credential $creds -LocalPath G:
    ```
    This command will use the credentials to authenticate with the remote SMB server. Then, map the remote share path to G: drive letter (can be any other available drive letter). Containers created on this container host can now have their data volumes mapped to a path on the G: drive.

    > [!NOTE]
    > When using SMB global mapping for containers, all users on the container host can access the remote share. Any application running on the container host will also have access to the mapped remote share.

2. Create containers with data volumes mapped to globally mounted SMB share
    docker run -it --name demo -v g:\ContainerData:c:\AppData1 mcr.microsoft.com/windows/servercore:ltsc2019 cmd.exe

    Inside the container, c:\AppData1 will then be mapped to the remote share’s "ContainerData" directory. Any data stored on globally mapped remote share will be available to applications inside the container. Multiple containers can get read/write access to this shared data with the same command.

This SMB global mapping support is SMB client-side feature which can work on top of any compatible SMB server including:

- Scaleout File Server on top of Storage Spaces Direct (S2D) or a traditional SAN
- Azure Files (SMB share)
- Traditional File Server
- 3rd party implementation of SMB protocol (ex: NAS appliances)

> [!NOTE]
> SMB global mapping does not support DFS, DFSN, DFSR shares in Windows Server version 1709.

## Named Volumes

Named volumes allow you to create a volume by name, assign it to a container, and reuse it later by the same name. You don't need to keep track of the actual path of where it was created, just the name. The Docker engine on Windows has a built-in named volume plugin that can create volumes on the local machine. An additional plugin is required if you want to use named volumes on multiple machines.

Example steps:

1. `docker volume create unwound` - Create a volume named 'unwound'
2. `docker run -v unwound:c:\data microsoft/windowsservercore` - Start a container with the volume mapped to c:\data
3. Write some files to c:\data in the container, then stop the container
4. `docker run -v unwound:c:\data microsoft/windowsservercore` - Start a new container
5. Run `dir c:\data` in the new container - the files are still there

> [!NOTE]
> Windows Server will convert target pathnames (the path inside of the container) to lower-case; i. e. `-v unwound:c:\MyData`, or `-v unwound:/app/MyData` in Linux containers, will result in a directory inside the container of `c:\mydata`, or `/app/mydata` in Linux containers, being mapped (and created, if not existent).
