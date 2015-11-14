# Windows Server Container Management

The container life cycle includes actions such as, starting, stopping, and removing containers. When performing these actions you may also need retrieve a list of container images, manage container networking, and limit container resources. This document will detail basic container management tasks using PowerShell.

For documentation on managing Windows Containers with Docker see the Docker document [Working with Containers]( https://docs.docker.com/userguide/usingdocker/).

## PowerShell

### Create a Container

When creating a new container, you need the name of a container image that will serve as the container base. This can be found using the `Get-ContainerImageName` command.

```powershell
PS C:\>Get-ContainerImage
Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServer        CN=Microsoft 10.0.10584.1000 True
WindowsServerCore CN=Microsoft 10.0.10584.1000 True
```

Use the `New-Container` command to create a new container.

```powershell
PS C:\>New-Container -Name TST -ContainerImageName WindowsServerCore

Name State Uptime   ParentImageName
---- ----- ------   ---------------
TST  Off   00:00:00 WindowsServerCore
```

Once the container has been created, add a network adapter to the container.

```powershell
PS C:\>Add-ContainerNetworkAdapter -ContainerName TST
```

In order to connected the containers network adapter to a virtual switch, the switch name is needed. Use `Get-VMSwitch` to return a list of virtual switches. 

```powershell
PS C:\>Get-VMSwitch

Name SwitchType NetAdapterInterfaceDescription
---- ---------- ------------------------------
DHCP External   Microsoft Hyper-V Network Adapter
NAT  NAT
```

Connect the network adapter the virtual switch using `Connect-ContainerNetowkrAdapter`. NOTE – this can also be completed when the container is crated using the –SwitchName parameter.

```powershell
PS C:\>Connect-ContainerNetworkAdapter -ContainerName TST -SwitchName NAT
```

### Start a Container
In order to start the container, a PowerShell object representing that container that will be enumerated. This can be done by placing the output of `Get-Container` into a PowerShell variable.

```powershell
PS C:\>$container = Get-Container -Name TST
```

This data can then be used with the `Start-Container` command to start the container.

```powershell
PS C:\>Start-Container $container
```

The following script will start all containers on the host.

```powershell
PS C:\>Get-Container | Start-Container
```

### Connect with Container

PowerShell direct can be used to connect to a container. This may be helpful if you need to manually perform a task such as installing software, starting a processes or troubleshooting a container. Because PowerShell direct is being used, a PowerShell session can be created with the container regardless of network configuration. For more infotmation on PowerShell Direct see the [PowerShell Direct Blog](http://blogs.technet.com/b/virtualization/archive/2015/05/14/powershell-direct-running-powershell-inside-a-virtual-machine-from-the-hyper-v-host.aspx)

To create an interactive session with the container, use the `Enter-PSSession` command.

 ```powershell
PS C:\>Enter-PSSession -ContainerName TST –RunAsAdministrator
```

Notice that once the remote PowerShell session has been created, the shell prompt changes to reflect the container name.

```powershell
[TST]: PS C:\>
```

Commands can also be run against a container without creating a persistent PowerShell session. To do so use `Invoke-Command`.

The following sample creates a folder named ‘Application’ in the container.

```powershell

PS C:\>Invoke-Command -ContainerName TST -ScriptBlock {New-Item -ItemType Directory -Path c:\application }

Directory: C:\
Mode                LastWriteTime         Length Name                                                 PSComputerName
----                -------------         ------ ----                                                 --------------
d-----       10/28/2015   3:31 PM                application                                          TST
```

### Stop a Container

In order to stop the container, a PowerShell object representing that container will be needed. This can be done by placing the output of `Get-Container` into a PowerShell variable.

```powershell
PS C:\>$container = Get-Container -Name TST
```

This can then be used with the `Stop-Container` command to stop the container.

```powershell
PS C:\>Stop-Container $container
```

The following will stop all containers on the host.

```powershell
PS C:\>Get-Container | Stop-Container
```

To stop a container with Docker.

```powershell

```

### Remove a Container

When a container is no longer needed it can be removed. In order to remove a container, it needs to be in a stopped state, and a PowerShell object needs to be created that represents the container.

```powershell
PS C:\>$container = Get-Container -Name TST
```

To remove the container, use the `Remove-Container` command.

```powershell
PS C:\>Remove-Container $container -Force
```

The following will remove all containers on the host.

```powershell
PS C:\>Get-Container | Remove-Container -Force
```

## Docker

### Create a Container <!--docker-->

```powershell
docker run -p 80:80 windowsservercoreiis
```

For more information on the Docker run command, see the [Docker run reference}( https://docs.docker.com/engine/reference/run/).

### Stop a Container <!--docker-->

## Remove Container <!--docker-->

To remove a container with Docker.

```powershell
PS C:\>docker rm prickly_pike

prickly_pike
``` 

To remove all containers with Docker.

```powershell
PS C:\>docker rm $(docker ps -a -q)

dc3e282c064d
2230b0433370
```

For more information on the Docker rm command, see the [Docker rm reference}(https://docs.docker.com/engine/reference/commandline/rm/).

## Container Process

### Container Processes

When a Windows Server Container has been started, the processes visible inside of the running container, are also visible on the container host. The `csrss.exe` process represents the container runtime. The host will show a copy of certain services such as winintt.exe and services.exe for every running Windows Server Container.
 
It may be helpful when troubleshooting container performance or other issues to be able to identify processes associated with a particular container. To return a list of processes visible to the container, run the below command. The ID of each processes visible inside of the container, will matches a process on the container host (Windows Server Containers Only).

```powershell
Invoke-Command -ContainerId $con.ContainerId {Get-Process}

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName                  PSComputerName
-------  ------    -----      ----- -----   ------     --  -- -----------                  --------------
     81       5      928       4492 ...72            5336   3 CExecSvc                     NONIC
    176       9     1284       3872 ...01            6108   3 csrss                        NONIC
      0       0        0          4     0               0   0 Idle                         NONIC
    538      18     2752       9344 ...96             628   3 lsass                        NONIC
    195      12     2208       8580 ...98            5472   3 msdtc                        NONIC
    450      24    52332      65580 ...46     1.50   2968   3 powershell                   NONIC
    204      10     2400       5740 ...78            5220   3 services                     NONIC
     46       3      368       1136 ...59            3928   0 smss                         NONIC
    130       8     1492       7076 ...14            6124   3 SppExtComObj                 NONIC
    205      10     6992      18320 ...10            5028   3 sppsvc                       NONIC
    252      13     6556      10592 ...96            1564   3 svchost                      NONIC
    351      28     4228      14112 ...07            2648   3 svchost                      NONIC
    255      13     1992       6468 ...88            3556   3 svchost                      NONIC
    284      12     2484       8420 ...97            4160   3 svchost                      NONIC
    194      14     2948       9136 ...98            4324   3 svchost                      NONIC
     93       7     1296       5432 ...91            5500   3 svchost                      NONIC
     81       6     1008       4808 ...92            5724   3 svchost                      NONIC
    282      13     2752       9948 ...36            5952   3 svchost                      NONIC
    907      33    12452      27856 ...06            6048   3 svchost                      NONIC
   2541       0      116        128     3               4   0 System                       NONIC
    107       9     1096       4732 ...77            3248   3 wininit                      NONIC
    128       8     5672      10840 ...04            5360   3 WmiPrvSE                     NONIC
```

## Additional Resources

For a complete reference of Container PowerShell commands see the [Container PowerShell Reference](https://technet.microsoft.com/en-us/library/mt433069.aspx).

For documentation on managing Windows Containers with Docker see the Docker document [Working with Containers]( https://docs.docker.com/userguide/usingdocker/).
