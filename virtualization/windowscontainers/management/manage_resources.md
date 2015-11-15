# Container Resource Management

Windows Containers include the ability to manage how much CPU, disk IO, network and memory resources containers can consume. Constraining container resource consumptions allows host resources to be used efficiently, and prevents over consumption. This document will detail managing container resources with both PowerShell and Docker.

## PowerShell

### Memory

Container memory limits can be set when a container is created using the `-MaximumMemoryBytes` parameter of the `New-Container` command. This example sets maximum memory to 256mb.
 
```powershell
New-Container –Name TestContainer –MaximumMemoryBytes 256MB -ContainerimageName WindowsServerCore
```
You can also set the memory limit of an existing container using the `Set-ContainerMemory` cmdlet.

```powershell
Set-ContainerMemory -ContainerName TestContainer -MaximumBytes 500mb
```

### Network Bandwidth

Network bandwidth limits can be set on an exsisting container. To do so, ensure the container has a network adapter using the `Get-ContainerNetworkAdapter` command. If a network adapter does nto exist, use the `Add-ContainerNetworkAdapter` command to create one. Finally, use the `Set-ContainerNetworkAdapter` command to limit the maximum egress network bandwidth of the container.

The below sample the maximum bandwitch to 100Mbps.

PS C:\>Set-ContainerNetworkAdapter –ContainerName TestContainer –MaximumBandwidth 100000000

### CPU 

You can limit the amount of compute a container can use by either setting a Maximum percentage of CPU, or by setting a relative weight for the container. While mixing these two CPU management schemes is not blocked, it is not recommended. By default, all containers have full use of the processor (a maximum of 100%), and a relative weight of 100. 

The below sets the relative weight of the container to 1000. The default weight of a container is 100, so this container while have 10 times the priority of a container set to the default. The max value is 10000.

```powershell
Set-ContainerProcessor -ContainerName Container1 –RelativeWeight 10000.
```
 
You can also set a hard limit on the amount of CPU a container can use in terms of percentage of CPU time. By default, a container can use 100% of the CPU. The below sets the max percent of a CPU a container can use to 30%. Using the –Maximum flag automatically sets the RelativeWeight to 100. 

```powershell
Set-ContainerProcessor -ContainerName Container1 -Maximum 30
```

### Storage IO

You can limit how much IO a container can use in terms of Bandwidth (bytes per second) or 8k Normalized IOPS. These two parameters can be set in conjunction. Throttling occurs when the first limit is reached. 

```powershell
Set-ContainerStorage -ContainerName Container1 -MaximumBandwidth 1000000
```
```powershell
Set-ContainerStorage -ContainerName Container1 -MaximumIOPS 32
```

## Managing Resources - Docker 

We offer the ability to manage a subset of container resources through Docker. Specifically, we allow users to specify how the cpu is shared amongst containers. 

### CPU

CPU shares amongst containers can be managed at runtime via the --cpu-shares flag. By default, all containers enjoy an equal proportion of CPU time. To change the relative share of CPU that containers use run the --cpu-shares flag with a value from 1-10000. By default, all containers receive a weight of 5000. 

```powershell 
docker run –it --cpu-shares 2 --name dockerdemo windowsservercore cmd
```

## Known Issues

- CPU and IO Resource Controls are not currently supported with Hyper-V Containers.
- IO Resource Controls are not currently supported with Container Shared Folders.

