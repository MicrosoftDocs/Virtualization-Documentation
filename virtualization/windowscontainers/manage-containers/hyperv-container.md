---
title: Hyper-V Containers
description: Explaination of how Hyper-V containers differ from process containers.
keywords: docker, containers
author: scooley
ms.date: 09/13/2018
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 42154683-163b-47a1-add4-c7e7317f1c04
---

# Hyper-V Isolated Containers

**This is preliminary content and subject to change.** 

The Windows container technology includes two distinct types of containers, Windows Server containers (process containers) and Hyper-V isolated containers. Both types of containers are created, managed, and function identically. They also produce and consume the same container images. What differs between them is the level of isolation created between the container, the host operating system, and all of the other containers running on that host.

**Windows Server containers** – multiple container instances can run concurrently on a host, with isolation provided through namespace, resource control, and process isolation technologies.  Windows Server containers share the same kernel with the host, as well as each other.  This is approximately the same as how containers run on Linux.

**Hyper-V isolated containers** – multiple container instances can run concurrently on a host, however, each container runs inside of a special virtual machine. This provides kernel level isolation between each Hyper-V isolated container and the container host.

## Hyper-V isolated container examples

### Create container

Managing Hyper-V isolated containers with Docker is nearly identical to managing Windows Server containers. To create a Hyper-V isolated container with Docker, use the `--isolation` parameter to set `--isolation=hyperv`.

``` cmd
docker run -it --isolation=hyperv mcr.microsoft.com/windows/nanoserver:1809 cmd
```

### Isolation explanation

This example demonstrates the differences in isolation capabilities between Windows Server and Hyper-V isolated containers. 

Here, a Windows Server containers is being deployed, and will be hosting a long running ping process.

``` cmd
docker run -d mcr.microsoft.com/windows/servercore:1809 ping localhost -t
```

Using the `docker top` command, the ping process is returned as seen inside the container. The process in this example has an ID of 3964.

``` cmd
docker top 1f8bf89026c8f66921a55e773bac1c60174bb6bab52ef427c6c8dbc8698f9d7a

3964 ping
```

On the container host, the `get-process` command can be used to return any running ping processes from the host. In this example there is one, and the process id matches that from the container. It is the same process visible from both container and host.

```
get-process -Name ping

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
     67       5      820       3836 ...71     0.03   3964   3 PING
```

To contrast, this example starts a Hyper-V isolated container with a ping process as well. 

```
docker run -d --isolation=hyperv mcr.microsoft.com/windows/nanoserver:1809 ping -t localhost
```

Likewise, `docker top` can be used to return the running processes from the container.

```
docker top 5d5611e38b31a41879d37a94468a1e11dc1086dcd009e2640d36023aa1663e62

1732 ping
```

However, when searching for the process on the container host, a ping process is not found, and an error is thrown.

```
get-process -Name ping

get-process : Cannot find a process with the name "ping". Verify the process name and call the cmdlet again.
At line:1 char:1
+ get-process -Name ping
+ ~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (ping:String) [Get-Process], ProcessCommandException
    + FullyQualifiedErrorId : NoProcessFoundForGivenName,Microsoft.PowerShell.Commands.GetProcessCommand
```

Finally, on the host, the `vmwp` process is visible, which is the running virtual machine that is encapsulating the running container and protecting the running processes from the host operating system.

```
get-process -Name vmwp

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
   1737      15    39452      19620 ...61     5.55   2376   0 vmwp
```
