# Container Resource Management

When you create a container, you can now manage how much CPU, IO, network, and memory resources that the container can utilize, in order to provide the appropriate resources for the workload you plan to run in the container. 

## Managing Container Resources with PowerShell

If you choose to manage your containers via PowerShell cmdlets, you have the following options for setting container resource controls on the CPU, Network, Memory, and IO on both local container storage and shared folders. 

All of the `Set-Container` commands take the `ContainerName` flag to specify which container to set the resource usage on. 

### Memory

You can set the memory limit of a container at container creation time using the New-Container cmdlet and the MaximumMemoryBytes flag.
 
```powershell
New-Container –Name TestContainer –MaximumMemoryBytes 256MB -ContainerimageName WindowsServerCore
```

You can also set the memory limit of an existing container via the Set-ContainerMemory cmdlet.

```powershell
Set-ContainerMemory -ContainerName TestContainer -MaximumBytes 500mb
```

### Network Bandwidth

You can set the network bandwidth limit of an already created container. First ensure you have set up a Container Network Adapter by running the Get-ContainerNetworkAdapter cmdlet. If none appears, use the Add-ContainerNetworkAdapter cmdlet to add a network adapter to your container. You can then either use Get-ContainerNetworkAdapter to use the Network Adapter’s name, or just place the Network Adapter Object in a variable. 
Once a network adapter is setup, running the Set-ContainerNetworkAdapter cmdlet like below can be used to limit the maximum egress network bandwidth of a container to 100Mbps.
PS C:\>Set-ContainerNetworkAdapter –ContainerName TestContainer –MaximumBandwidth 100000000

### CPU 

You can limit the amount of compute a container can use by either setting a Maximum percentage of CPU it can use, or setting a relative weight of the container. While mixing these two CPU management schemes is not blocked, it is not recommended. By default, all containers have full use of the processor (a maximum of 100%), and a relative weight of 100. 
The below sets the relative weight of the container to 1000. The default weight of a container is 100, so this container while have 10 times the priority of a container set to the default. The max value is 10000.
PS C:\ > Set-ContainerProcessor -ContainerName Container1 –RelativeWeight 10000. 
You can also set a hard limit on the amount of CPU a container can use in terms of percentage of CPU time. By default, a container can use 100% of the CPU. The below sets the max percent of a CPU a container can use to 30%. Using the –Maximum flag automatically sets the RelativeWeight to 100. 
PS C:\ > Set-ContainerProcessor -ContainerName Container1 -Maximum 30

### Storage IO

You can limit how much IO a container can use in terms of Bandwidth (bytes per second) or 8k Normalized IOPS. These two parameters can be set in conjunction. Throttling occurs when the first limit is reached. 
PS C:\ > Set-ContainerStorage -ContainerName Container1 -MaximumBandwidth 1000000
PS C:\ > Set-ContainerStorage -ContainerName Container1 -MaximumIOPS 32

## Managing Container Resources through Docker 

We offer the ability to manage a subset of container resources through Docker. Specifically, we allow users to specify how the cpu is shared amongst containers. 

### CPU

CPU shares amongst containers can be managed at runtime via the --cpu-shares flag. By default, all containers enjoy an equal proportion of CPU time. To change the relative share of CPU that containers use run the --cpu-shares flag with a value from 1-10000. By default, all containers receive a weight of 5000. 
C:\> docker run –it --cpu-shares 2 --name dockerdemo windowsservercore cmd

## Known Issues

•	CPU and IO Resource Controls are not currently supported with Hyper-V Containers.
•	IO Resource Controls are not currently supported with Container Shared Folders.

