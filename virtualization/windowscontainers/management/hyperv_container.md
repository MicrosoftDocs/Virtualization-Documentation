---
author: neilpeterson
---

# Hyper-V Containers

**This is preliminary content and subject to change.** 

The Windows Container technology includes two distinct types of containers, Windows Server Containers and Hyper-V Containers. Both types of containers are created, managed, and function identically. They also produce and consume the same container images. What differs between them is the level of isolation created between the container, the host operating system, and all of the other container running on that host.

**Windows Server Containers** – multiple container instances can run concurrently on a host, with isolation provided through namespace, resource control, and process isolation technologies.  Windows Server Containers share the same kernel with the host, as well as each other.

**Hyper-V Containers** – multiple container instances can run concurrently on a host; however, each container runs inside of a special virtual machine. This provides kernel level isolation between each Hyper-V container and the container host.

## Hyper-V container

### Create container

Managing Hyper-V Containers with Docker is almost identical to managing Windows Server Containers. When creating a Hyper-V Container with Docker, the `--isolation=hyperv` parameter is used.

```powershell
docker run -it --isolation=hyperv windowsservercore cmd
```

### Isolation explanation

This example will differentiate the isolation capabilities between Windows Server and Hyper-V containers. 

Here a Windows Server containers is being run and is also hosting a long running ping process.

```none
docker run -d windowsservercore ping localhost -t
```

Running the `docker top` command, the ping process is returned as seen inside the container.

```none
docker top 1f8bf89026c8f66921a55e773bac1c60174bb6bab52ef427c6c8dbc8698f9d7a
```

The process in this example has an ID of 3964.

```none
3964 ping
```

On the container host, the `get-process` command can be used to return any ping process as seen from the host.

```powershell
get-process -Name ping
```

In this example, one process is returned, and the ID can be seen to match the is as seen from the container.  

```none
Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
     67       5      820       3836 ...71     0.03   3964   3 PING
```

To contrast, this example starts a Hyper-V container with a ping process as well. 

```none
docker run -d --isolation=hyperv nanoserver ping -t localhost
```

Likewise, `docker top` command can be used to return the running processes from the container. 

```none
docker top 5d5611e38b31a41879d37a94468a1e11dc1086dcd009e2640d36023aa1663e62
```

Which in this example has an id of 1732.

```none
1732 ping
```

However, when searching for the process on the container host, the process is not found. 

```powershell
get-process -Name ping
```

PowerShell produces an error based on the lack of a visible process.

```none
get-process : Cannot find a process with the name "ping". Verify the process name and call the cmdlet again.
At line:1 char:1
+ get-process -Name ping
+ ~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : ObjectNotFound: (ping:String) [Get-Process], ProcessCommandException
    + FullyQualifiedErrorId : NoProcessFoundForGivenName,Microsoft.PowerShell.Commands.GetProcessCommand
```

Finally, on the host, the `vmwp` process is visible, which is the running virtual machine that is encapsulating the running container and protecting the running processes form the host operating system.

```powershell
get-process -Name vmwp
```

Here is the output of the `vmwp` process.

```
Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
   1737      15    39452      19620 ...61     5.55   2376   0 vmwp
```

## Video Walkthrough

<iframe src="https://channel9.msdn.com/Blogs/containers/Container-Fundamentals--Part-5-Hyper-V-Containers/player" width="800" height="450"  allowFullScreen="true" frameBorder="0" scrolling="no"></iframe>
