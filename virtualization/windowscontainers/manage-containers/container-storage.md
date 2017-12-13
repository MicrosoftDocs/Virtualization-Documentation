---
title: Windows Server Container Storage
description: How Windows Server Containers can use host & other storage types
keywords: containers, volume, storage, mount, bindmount
author: patricklang
---



# Overview

<!-- Great diagram would be great! -->


## Layer Storage

This is all the files that are built into the container. Every time you `docker pull` then `docker run` that container - they are the same.


### Where layers are stored and how to change it

The layers are stored in `c:\programdata\docker` and split across the image and windowsfilter folders. Don't modify what's in these folders - they're carefully managed using commands such as:

- [docker images](https://docs.docker.com/engine/reference/commandline/images/)
- [docker rmi](https://docs.docker.com/engine/reference/commandline/rmi/)
- [docker pull](https://docs.docker.com/engine/reference/commandline/pull/)
- [docker load](https://docs.docker.com/engine/reference/commandline/load/)
- [docker save](https://docs.docker.com/engine/reference/commandline/save/)

If you want to use a path other than `c:\programdata\docker`, then you can change the `docker-root` configuration. Search for it on the [Docker Engine on Windows](docker/configure_docker_daemon.md) for an example of how to use it.


### What works and doesn't

Running containers can use most NTFS operations with the exception of transactions. This includes setting ACLs, and all ACLs are checked inside the container. If you want to run processes as multiple users inside a container, you can create users in your `Dockerfile` with `RUN net user /create ...`, set file ACLs, then configure later processes to run with that user with the [Dockerfile USER directive](https://docs.docker.com/engine/reference/builder/#user).


## Persistent Volumes

Persistent storage can be given to containers in a few ways:

- Bind mounts
- Named volumes

Docker has a great overview of how to [use volumes](https://docs.docker.com/engine/admin/volumes/volumes/) so its best to read that first. The rest of this page focused on differences between Linux & Windows and provides examples on Windows.




### Bind Mounts

[Bind mounts](https://docs.docker.com/engine/admin/volumes/bind-mounts/) allow a container to share a directory with the host. This is useful if you want a place to store files on the local machine that are available if you restart a container, or want to share it with multiple containers. If you want the container to run on multiple machines with access to the same files, then a named volume or SMB mount should be used instead.

#### Permissions

A simple read-only or read-write permission model is used for bind mounts. Because the container has users that don't exist on the host, file ACLs cannot be checked normally. Instead, the file is accessed on the host using the `LocalService` account. If you get access denied in the container, make sure `LocalSystem` has access to that directory on the host.

> Warning: Do not bind-mount sensitive directories such as `c:\` into an untrusted container. This would allow it to change files on the host that it would not normally have access to and could create a security breach.

Example usage: 

- `docker run -v c:\ContainerData:c:\data:RO` for read-only access
- `docker run -v c:\ContainerData:c:\data:RW` for read-write access

#### Symlinks

Symlinks are resolved in the container. If you bind-mount a host path to a container that is a symlink, or contains symlinks - the container will not be able to access them.

#### SMB Mounts

On Windows Server version 1709, a new feature called "SMB Global Mapping" makes it possible to mount a SMB share on the host, then pass folders on that share into a container. The container doesn't need to be configured with a specific server, share, username or password - that's all handled on the host instead. The container will work the same as if it had local storage.

##### Configuration Steps

1. On the container host, globally map the remote SMB share:
    $creds = Get-Credentials
    New-SmbGlobalMapping -RemotePath \\contosofileserver\share1 -Credential $creds -LocalPath G:
This command will use the credentials to authenticate with the remote SMB server. Then, map the remote share path to G: drive letter (can be any other available drive letter). Containers created on this container host can now have their data volumes mapped to a path on the G: drive.

> Note: When using SMB global mapping for containers, all users on the container host can access the remote share. Any application running on the container host will also have access to the mapped remote share.

2. Create containers with data volumes mapped to globally mounted SMB share
    docker run -it --name demo -v g:\ContainerData:G:\AppData1 microsoft/windowsservercore:1709 cmd.exe

Inside the container, G:\AppData1 will then be mapped to the remote share’s "ContainerData" folder. Any data stored on globally mapped remote share will be available to applications inside the container. Multiple containers can get read/write access to this shared data with the same command.

This SMB global mapping support is SMB client-side feature which can work on top of any compatible SMB server including:

- Scaleout File Server on top of S2D or Traditional SAN
- Azure Files (SMB share)
- Traditional File Server
- 3rd party implementation of SMB protocol (ex: NAS appliances)

> Note: SMB global mapping does not support DFS, DFSN, DFSR shares in Windows Server version 1709.

### Named Volumes

Named volumes allow you to create a volume by name, assign it to a container, and reuse it later by the same name. You don't need to keep track of the actual path of where it was created, just the name. The Docker engine on Windows has a built-in named volume plugin that can create volumes on the local machine. If you want to use them on multiple machines, then an additional volume plugin is needed instead.

Example steps:

1. `docker volume create unwound` - Create a volume named 'unwound'
2. `docker run -v unwound:c:\data microsoft/windowsservercore` - Start a container with the volume mapped to c:\data
3. Write some files to c:\data in the container, then stop the container
4. `docker run -v unwound:c:\data microsoft/windowsservercore` - Start a new container
5. Run `dir c:\data` in the new container - the files are still there