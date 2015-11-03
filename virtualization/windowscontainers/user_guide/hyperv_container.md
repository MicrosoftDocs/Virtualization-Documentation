The Windows Container technology includes two distinct types of container technology, Windows Server Containers and Hyper-V Containers. Both types of containers are created, managed and function identically. What differs between them is the level of isolation created between the container, the host operating system, and all of the other container running on that host.

**Windows Server Containers** – multiple containers run on a host with isolation provided through namespace and process isolation technologies.

**Hyper-V Containers** – multiple containers run on a host with each Hyper-V container hosted inside of a utility virtual machine. This provides kernel level isolation between a Hyper-V container, the container host, and any other containers running on the container host.

## Creating a Hyper-V Container

A Hyper-V container is created identically to a Widows Server Container with the only difference being a parameter indicating that that it will be a Hyper-V container.

Example Creating a Hyper-V Container with PowerShell

```powershell
$con = New-Container -Name HYPVCON -ContainerImageName NanoServer -SwitchName "Virtual Switch" -RuntimeType HyperV
```
Example Creating a Hyper-V Container with Docker

```powershell
docker run -it --isolation=hyperv 646d6317b02f cmd
```

In addition to creating a container as a Hyper-V container at build time, containers that have been created with PowerShell can also be converted from a Windows Server Container to a Hyper-V container. 

```powershell
<insert script>
```

## Hyper-V Container Demonstration:

```powershell
PS C:\> get-process | where {$_.ProcessName -eq 'csrss'}
Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
    255      12     1820       4000 ...98     0.53    532   0 csrss
    116      11     1284       3700 ...94     0.25    608   1 csrss
    246      13     1844       5504 ...17     3.45   3484   2 csrss
```
Create New Windows Server Container:

```powershell
$con = New-Container -Name WINCONT -ContainerImageName WindowsServerCore -SwitchName "Virtual Switch"
```

Start the Container:

```powershell
PS C:\> Start-Container $con
```

Create Remote PS Session with the container.

```powershell
PS C:\> Enter-PSSession -ContainerId $con.ContainerId –RunAsAdministrator
```

From the remote container session return all processes with a process name of csrss. Take note of the process id for the running csrss process.

```powershell
[WINCONT]: PS C:\> get-process | where {$_.ProcessName -eq 'csrss'}

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
    167       9     1276       3720 ...97     0.20   1228   3 csrss
```

Now return the list of csrss process form the container host. Notice that the same csrss process is also returned from the container host. This demonstrates the shared etc. etc. etc.

```powershell
PS C:\> get-process | where {$_.ProcessName -eq 'csrss'}

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
    252      11     1712       3968 ...98     0.53    532   0 csrss
    113      11     1176       3676 ...93     0.25    608   1 csrss
    175       9     1260       3708 ...97     0.20   1228   3 csrss
    243      13     1736       5512 ...17     3.77   3484   2 csrss
```
## Same Demonstration with a Hyper-V Container

Return a list of csrss process form the container host.

```powershell
PS C:\> get-process | where {$_.ProcessName -eq 'csrss'}

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
    261      12     1820       4004 ...98     0.53    532   0 csrss
    116      11     1284       3704 ...94     0.25    608   1 csrss
    246      13     1844       5536 ...17     3.83   3484   2 csrss
```

Now, create a Hyper-V container.

```powershell
PS C:\> $con = New-Container -Name HYPVCON -ContainerImageName NanoServer -SwitchName "Virtual Switch" -RuntimeType HyperV
```

Start the Hyper-V Container

```powershell
PS C:\> Start-Container $con
```

Create a remote PS session with the Hyper-V container.

```powershell
PS C:\> Enter-PSSession -ContainerId $con.ContainerId –RunAsAdministrator
```

Return a list of csrss process running inside the Hyper-V container. Take note of the process id for the csrss process (956 in the below example).

```powershell
[HYPVCON]: PS C:\> get-process | where {$_.ProcessName -eq 'csrss'}

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
              4      452       1520 ...63     0.06    956   1 csrss
```

Now return a list of csrss process on the container host. Notice, unlike with the Windows Server Container, where the csrss process was visible both from within the container and also from the container host, the Hyper-V container process is only visible from within the container itself. This is because a Hyper-V Container is encapsulated in a utility virtual machine and the process is isolated to only that utility virtual mahchine.

```powershell
PS C:\> get-process | where {$_.ProcessName -eq 'csrss'}

Handles  NPM(K)    PM(K)      WS(K) VM(M)   CPU(s)     Id  SI ProcessName
-------  ------    -----      ----- -----   ------     --  -- -----------
    255      12     1716       3972 ...98     0.56    532   0 csrss
    113      11     1176       3676 ...93     0.25    608   1 csrss
    243      13     1732       5512 ...18     4.23   3484   2 csrss
```

 
