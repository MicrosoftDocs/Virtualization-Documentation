# Windows Server Container Management

**This is preliminary content and subject to change.** 

The container life cycle includes actions such as, starting, stopping, and removing containers. When performing these actions, you may also need retrieve a list of container images, manage container networking, and limit container resources. This document will detail basic container management tasks using PowerShell.

For documentation on managing Windows Containers with Docker see the Docker document [Working with Containers]( https://docs.docker.com/userguide/usingdocker/).

## PowerShell

### Create a Container

When creating a new container, you need the name of a container image that will serve as the container base. This can be found using the `Get-ContainerImageName` command.

```powershell
PS C:\> Get-ContainerImage

Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServer        CN=Microsoft 10.0.10584.1000 True
WindowsServerCore CN=Microsoft 10.0.10584.1000 True
```

Use the `New-Container` command to create a new container.

```powershell
PS C:\> New-Container -Name TST -ContainerImageName WindowsServerCore

Name State Uptime   ParentImageName
---- ----- ------   ---------------
TST  Off   00:00:00 WindowsServerCore
```

Once the container has been created, add a network adapter to the container.

```powershell
PS C:\> Add-ContainerNetworkAdapter -ContainerName TST
```

In order to connect the container's network adapter to a virtual switch, the switch name is needed. Use `Get-VMSwitch` to return a list of virtual switches. 

```powershell
PS C:\> Get-VMSwitch

Name SwitchType NetAdapterInterfaceDescription
---- ---------- ------------------------------
DHCP External   Microsoft Hyper-V Network Adapter
NAT  NAT
```

Connect the network adapter to the virtual switch using `Connect-ContainerNetowkrAdapter`. NOTE – this can also be completed when the container is created using the –SwitchName parameter.

```powershell
PS C:\> Connect-ContainerNetworkAdapter -ContainerName TST -SwitchName NAT
```

### Start a Container
In order to start the container, a PowerShell object representing that container that will be enumerated. This can be done by placing the output of `Get-Container` into a PowerShell variable.

```powershell
PS C:\> $container = Get-Container -Name TST
```

This data can then be used with the `Start-Container` command to start the container.

```powershell
PS C:\> Start-Container $container
```

The following script will start all containers on the host.

```powershell
PS C:\> Get-Container | Start-Container
```

### Connect with Container

PowerShell direct can be used to connect to a container. This may be helpful if you need to manually perform a task such as installing software, starting a processes or troubleshooting a container. Because PowerShell direct is being used, a PowerShell session can be created with the container regardless of network configuration. For more information on PowerShell Direct see the [PowerShell Direct Blog](http://blogs.technet.com/b/virtualization/archive/2015/05/14/powershell-direct-running-powershell-inside-a-virtual-machine-from-the-hyper-v-host.aspx)

To create an interactive session with the container, use the `Enter-PSSession` command.

 ```powershell
PS C:\> Enter-PSSession -ContainerName TST –RunAsAdministrator
```

Notice that once the remote PowerShell session has been created, the shell prompt changes to reflect the container name.

```powershell
[TST]: PS C:\>
```

Commands can also be run against a container without creating a persistent PowerShell session. To do so use `Invoke-Command`.

The following sample creates a folder named ‘Application’ in the container.

```powershell

PS C:\> Invoke-Command -ContainerName TST -ScriptBlock {New-Item -ItemType Directory -Path c:\application }

Directory: C:\
Mode                LastWriteTime         Length Name                                                 PSComputerName
----                -------------         ------ ----                                                 --------------
d-----       10/28/2015   3:31 PM                application                                          TST
```

### Stop a Container

In order to stop the container, a PowerShell object representing that container will be needed. This can be done by placing the output of `Get-Container` into a PowerShell variable.

```powershell
PS C:\> $container = Get-Container -Name TST
```

This can then be used with the `Stop-Container` command to stop the container.

```powershell
PS C:\> Stop-Container $container
```

The following will stop all containers on the host.

```powershell
PS C:\> Get-Container | Stop-Container
```

### Remove a Container

When a container is no longer needed it can be removed. In order to remove a container, it needs to be in a stopped state, and a PowerShell object needs to be created that represents the container.

```powershell
PS C:\> $container = Get-Container -Name TST
```

To remove the container, use the `Remove-Container` command.

```powershell
PS C:\> Remove-Container $container -Force
```

The following will remove all containers on the host.

```powershell
PS C:\> Get-Container | Remove-Container -Force
```

## Docker

### Create a Container <!--docker-->

Use `docker run` to create a container with Docker.

```powershell
PS C:\> docker run -p 80:80 windowsservercoreiis
```

For more information on the Docker run command, see the [Docker run reference}( https://docs.docker.com/engine/reference/run/).

### Stop a Container <!--docker-->

Use the `docker stop` command to stop a container with Docker.

```powershell
PS C:\> docker stop tender_panini
tender_panini
```

This example stops all running containers with Docker.

```powershell
PS C:\> docker stop $(docker ps -q)
fd9a978faac8
b51e4be8132e
```

### Remove Container <!--docker-->

To remove a container with Docker, use the `docker rm` command.

```powershell
PS C:\> docker rm prickly_pike

prickly_pike
``` 

To remove all containers with Docker.

```powershell
PS C:\> docker rm $(docker ps -a -q)

dc3e282c064d
2230b0433370
```

For more information on the Docker rm command, see the [Docker rm reference](https://docs.docker.com/engine/reference/commandline/rm/).
