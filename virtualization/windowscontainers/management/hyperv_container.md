---
author: neilpeterson
---

# Hyper-V Containers

**This is preliminary content and subject to change.** 

The Windows Container technology includes two distinct types of containers, Windows Server Containers and Hyper-V Containers. Both types of containers are created, managed, and function identically. They also produce and consume the same container images. What differs between them is the level of isolation created between the container, the host operating system, and all of the other container running on that host.

**Windows Server Containers** – multiple container instances can run concurrently on a host with isolation provided through namespace, resource control, and process isolation technologies.  Windows Server Containers share the same kernel with the host as well as each other.

**Hyper-V Containers** – multiple container instances can run concurrently on a host; however, each container runs inside of a special virtual machine. This provides kernel level isolation between each Hyper-V container and the container host.

## Hyper-V Container Docker

### Create Container

Managing Hyper-V Containers with Docker is almost identical to managing Windows Server Containers. When creating a Hyper-V Container with Docker, the `--isolation=hyperv` parameter is used.

```powershell
docker run -it --isolation=hyperv 646d6317b02f cmd
```

For more information on the `Get-ComputeProcess` command, see [Management Interoperability](./hcs_powershell.md).

## Video Walkthrough

<iframe src="https://channel9.msdn.com/Blogs/containers/Container-Fundamentals--Part-5-Hyper-V-Containers/player" width="800" height="450"  allowFullScreen="true" frameBorder="0" scrolling="no"></iframe>
