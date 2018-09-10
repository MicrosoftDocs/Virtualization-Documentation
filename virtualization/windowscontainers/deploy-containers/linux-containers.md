# Linux containers

This feature uses [Hyper-V Isolation](../manage-containers/hyperv-container.md) to run a Linux kernel with just enough OS to support containers. The changes to Windows and Hyper-V to build this started in the _Windows 10 Fall Creators Update_ and _Windows Server, version 1709_, but bringing this together also required work with the open source [Moby project](https://www.github.com/moby/moby) on which Docker technology is built, as well as the Linux kernel. 

[!VIDEO https://sec.ch9.ms/ch9/1e5a/08ff93f2-987e-4f8d-8036-2570dcac1e5a/LinuxContainer.mp4]

To try this out, you’ll need:

- Windows 10 or Windows Server Insider Preview build 16267 or later
- A build of the Docker daemon based off the Moby master branch, running with the `--experimental` flag
- Your choice of compatible Linux image

There are getting started guides available for this preview:

- [Docker Enterprise Edition Preview](https://blog.docker.com/2017/09/docker-windows-server-1709/) includes a LinuxKit system and preview of Docker EE that can run Linux containers. For more background, also check [Preview Linux Containers on Windows using LinuxKit](https://go.microsoft.com/fwlink/?linkid=857061)
- [Running Ubuntu Containers with Hyper-V Isolation on Windows 10 and Windows Server](https://go.microsoft.com/fwlink/?linkid=857067)


## Work in progress

Ongoing progress in the Moby project can be tracked on [GitHub](https://github.com/moby/moby/issues/33850)


### Known app issues

These applications all require volume mapping, which has some limitations covered under [Bind mounts](#Bind-mounts). They will not start or run correctly.

- MySQL
- PostgreSQL
- WordPress
- Jenkins
- MariaDB
- RabbitMQ


### Bind mounts

Bind mounting volumes with `docker run -v ...` stores the files on the Windows NTFS filesystem, so some translation is needed for POSIX operations. Some filesystem operations are currently partially or not implemented, which may cause incompatibilities for some apps.

These operations are not currently working for bind-mounted volumes:

- MkNod
- XAttrWalk
- XAttrCreate
- Lock
- Getlock
- Auth
- Flush
- INotify

There are also a few that are not fully implemented:

- GetAttr – The Nlink count is always reported as 2
- Open – Only ReadWrite, WriteOnly, and ReadOnly flags are implemented
