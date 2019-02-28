
# Container types and isolation

Windows Containers include two different container types, or runtimes.

## Windows Container Types

**Windows Server Containers** – provide application isolation through process and namespace isolation technology. A Windows Server Container shares a kernel with the container host and all containers running on the host. These containers do not provide a hostile security boundary and should not be used to isolate untrusted code. Because of the shared kernel space, these containers require the same kernel version and configuration.

**Hyper-V Isolation** – expands on the isolation provided by Windows Server Containers by running each container in a highly optimized virtual machine. In this configuration, the kernel of the container host is not shared with other containers on the same host. These containers are designed for hostile multitenant hosting with the same security assurances of a virtual machine. Since these containers do not share the kernel with the host or other containers on the host, they can run kernels with different versions and configurations (with in supported versions) - for example all Windows containers on Windows 10 use Hyper-V isolation to utilize the Windows Server kernel version and configuration.

## Choosing between Windows Server Containers and Hyper-V Isolation

Running a container on Windows with or without Hyper-V Isolation is a runtime decision. You may elect to create the container with Hyper-V isolation initially and later at runtime choose to run it instead as a Windows Server container. From a development perspective, there are no differences between packaging a Windows Container or a container with Hyper-V Isolation.

## Hyper-V isolation examples

### Create container

Managing Hyper-V isolated containers with Docker is nearly identical to managing Windows Server containers. To create a container with Hyper-V isolation thorough Docker, use the `--isolation` parameter to set `--isolation=hyperv`.

``` cmd
docker run -it --isolation=hyperv mcr.microsoft.com/windows/nanoserver:1809 cmd
```

### Isolation explanation

This example demonstrates the differences in isolation capabilities between Windows Server and Hyper-V containers. 

Here, a process isolated container is being deployed, and will be hosting a long running ping process.

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
