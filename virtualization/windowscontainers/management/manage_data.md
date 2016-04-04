---
author: neilpeterson
---

# Container Shared Folders

**This is preliminary content and subject to change.** 

Shared folders allow data to be shared between a container host and container. When the shared folder has been created, the shared folder will be available inside of the container. Any data that is placed in the shared folder from the host, will be available inside of the container. Any data placed in the shared folder from within the container will be available on the host. A single folder on the host can be shared with many containers, in this configuration data can be shared between running containers.

## Manage Data - Docker

### Mounting Volumes

When managing Windows Containers with Docker, volumes can be mounted using the `-v` option.

In the below example the source folder is c:\source and destination folder c:\destination.

```powershell
PS C:\> docker run -it -v c:\source:c:\destination 1f62aaf73140 cmd
```

For more information on managing data in containers with Docker see [Docker Volumes on Docker.com](https://docs.docker.com/userguide/dockervolumes/).

## Video Walkthrough

<iframe src="https://channel9.msdn.com/Blogs/containers/Container-Fundamentals--Part-3-Shared-Folders/player" width="800" height="450"  allowFullScreen="true" frameBorder="0" scrolling="no"></iframe>