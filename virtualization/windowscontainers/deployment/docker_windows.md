---
author: neilpeterson
---

# Docker and Windows

**This is preliminary content and subject to change.** 

The Docker engine is not included with Windows and will need to be installed and configured individually. The steps used to run the Docker Engine on Windows will vary from those used to run in on Linux. This document will step through installing and configuring the Docker engine on Windows Server 2016, Nano Server, and Windows Client.

For more information on Docker and the Docker toolset visit [Docker.com](https://www.docker.com/). 

> The Windows container feature must be enabled before Docker can be used to create and manage Windows Server and Hyper-V container. For instructions on enabling this feature, see the [Container host deployment guide](./docker_windows.md).

## Windows Server 2016

### Install Docker <!--1-->

There are several methods that can be used to create a Windows service, one example shown here uses `nssm.exe`. 

Download docker.exe from `https://aka.ms/tp5/docker` and place it in the System32 directory on the container Host.

```none
wget https://aka.ms/tp5/docker -OutFile $env:SystemRoot\system32\docker.exe
```

Create a directory named `c:\programdata\docker`. In this directory, create a file named `runDockerDaemon.cmd`.

```none
New-Item -ItemType File -Path C:\ProgramData\Docker\runDockerDaemon.cmd -Force
```

Copy the following text into the `runDockerDaemon.cmd` file.

```none
@echo off
set certs=%ProgramData%\docker\certs.d

if exist %ProgramData%\docker (goto :run)
mkdir %ProgramData%\docker

:run
if exist %certs%\server-cert.pem (goto :secure)

docker daemon -D
goto :eof

:secure
docker daemon -D -H npipe:// -H tcp://0.0.0.0:2376 --tlsverify --tlscacert=%certs%\ca.pem --tlscert=%certs%\server-cert.pem --tlskey=%certs%\server-key.pem
```
Download nssm.exe from [https://nssm.cc/release/nssm-2.24.zip](https://nssm.cc/release/nssm-2.24.zip).

```none
wget https://nssm.cc/release/nssm-2.24.zip -OutFile $env:ALLUSERSPROFILE\nssm.zip
```

Extract the the compressed package.

```none
Expand-Archive -Path $env:ALLUSERSPROFILE\nssm.zip $env:ALLUSERSPROFILE
```

Copy `nssm-2.24\win64\nssm.exe` into the `c:\windows\system32` directory.

```none
Copy-Item $env:ALLUSERSPROFILE\nssm-2.24\win64\nssm.exe $env:SystemRoot\system32
```
Run `nssm install` to configure the Docker service.

```none
start-process nssm install
```

Enter the following data into the corresponding fields in the NSSM service installer.

Application Tab:

**Path:** C:\Windows\System32\cmd.exe

**Startup Directory:** C:\Windows\System32

**Arguments:** /s /c C:\ProgramData\docker\runDockerDaemon.cmd < nul

**Service Name** - Docker

![](media/nssm1.png)

Details Tab:

**Display name:** Docker

**Description:** The Docker Daemon provides management capabilities of containers for docker clients.

![](media/nssm2.png)

IO Tab:

**Output (stdout):** C:\ProgramData\docker\daemon.log

**Error (stderr):** C:\ProgramData\docker\daemon.log

![](media/nssm3.png)

When finished, click the `Install Service` button.

With this completed, when Windows starts, the Docker daemon (service) will also start.

### Removing Docker <!--1-->

If following this guide for creating a Windows service from docker.exe, the following command will remove the service.

```none
sc.exe delete Docker
```

## Nano Server

### Install Docker <!--2-->

Download docker.exe from `https://aka.ms/tp5/docker` and copy it to the `windows\system32` folder of the Nano Server Container host.

Create a directory named `c:\programdata\docker`. In this directory, create a file named `runDockerDaemon.cmd`.

```none
New-Item -ItemType File -Path C:\ProgramData\Docker\runDockerDaemon.cmd -Force
```

Copy the following text into the `runDockerDaemon.cmd` file. This batch file starts the Docker daemon with the command `docker daemon -D -b “Virtual Switch”`. Note: the name of the virtual switch in this file, will need to match the name of the virtual switch that containers will be using for network connectivity.

```none
@echo off
set certs=%ProgramData%\docker\certs.d

if exist %ProgramData%\docker (goto :run)
mkdir %ProgramData%\docker

:run
if exist %certs%\server-cert.pem (goto :secure)

docker daemon -D
goto :eof

:secure
docker daemon -D -H npipe:// -H tcp://0.0.0.0:2376 --tlsverify --tlscacert=%certs%\ca.pem --tlscert=%certs%\server-cert.pem --tlskey=%certs%\server-key.pem
```

The following script can be used to create a scheduled task to start the Docker daemon. 

```none
# Creates a scheduled task to start docker.exe at computer start up.

$dockerData = "$($env:ProgramData)\docker"
$dockerDaemonScript = "$dockerData\runDockerDaemon.cmd"
$dockerLog = "$dockerData\daemon.log"
$action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c $dockerDaemonScript > $dockerLog 2>&1" -WorkingDirectory $dockerData
$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet -Priority 5
Register-ScheduledTask -TaskName Docker -Action $action -Trigger $trigger -Settings $settings -User SYSTEM -RunLevel Highest | Out-Null
Start-ScheduledTask -TaskName Docker 
```

If you wish to enable remote Docker management, you also need to open TCP port 2375.

```none
netsh advfirewall firewall add rule name="Docker daemon " dir=in action=allow protocol=TCP localport=2375
```

### Interactive Nano session

Nano server is managed through a remote powershell session. Not all docker operations, such as starting an interactive session with a container can be performed through this remote powershell session. To get around this, ensure docker.exe is available on a remote system, and manage the Docker host through a TCP connection. 

For more information on remotely managing Nano Server, see [Getting Started with Nano Server]( https://technet.microsoft.com/en-us/library/mt126167.aspx#bkmk_ManageRemote).

> As a best practice, Docker should be managed remotely through a secure TCP connection.

To remotely deploy a container and enter an interactive session, run the following command.

```none
docker –H tcp://<ipaddress of server>:2376 run –it nanoserver cmd
```

An environmental variable DOCKER_HOST can be created that will remove the –H parameter requirement. The following PowerShell command can be used for this.

```none
$env:DOCKER_HOST = "tcp://<ipaddress of server:2376"
```

With this variable set, the command would not look like this.

```none
docker run –it nanoserver cms
```

### Removing Docker <!--2-->

To remove the docker daemon and cli from Nano Server, delete `docker.exe` from the Windows\system32 directory.

```none
Remove-Item $env:SystemRoot\system32\docker.exe
``` 

Run the following to un-register the Docker scheduled task.

```none
Get-ScheduledTask -TaskName Docker | UnRegister-ScheduledTask
```