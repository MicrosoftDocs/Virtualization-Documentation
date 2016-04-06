---
author: neilpeterson
---

# Docker and Windows

**This is preliminary content and subject to change.** 

Docker is a container deployment and management platform, that works with both Linux and Windows containers. Docker is used to create, manage, and delete containers and container images. Docker enables storing container images in a public registry (Docker Hub) and private registries (Docker Trusted Registries). Docker additionally provides container host clustering capabilities with Docker Swarm and deployment automaton with Docker Compose. For more information on Docker and the Docker toolset visit [Docker.com](https://www.docker.com/). The Docker Daemon and CLI are not shipped with Windows and will need to be installed separately. This document will walk through manually installing the Docker engine on Windows. 

> The Windows Container feature must be enabled before Docker can be used to create and manage Windows Server and Hyper-V Container. For instructions on enabling this feature, see the [Container Host Deployment Guide](./docker_windows.md).

## Windows Server

### Install Docker <!--1-->

TODO - update this text: Docker.exe does not natively install as a Windows Service. There are several methods that can be used to create a Windows service, one example shown here uses `nssm.exe`. 

Download docker.exe from `https://aka.ms/tp4/docker` and place it in the System32 directory on the Container Host.

```powershell
wget https://aka.ms/tp4/docker -OutFile $env:SystemRoot\system32\docker.exe
```

Create a directory named `c:\programdata\docker`. In this directory, create a file named `runDockerDaemon.cmd`.

```powershell
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
docker daemon -D -H 0.0.0.0:2376 --tlsverify --tlscacert=%certs%\ca.pem --tlscert=%certs%\server-cert.pem --tlskey=%certs%\server-key.pem
```
Download nssm.exe from [https://nssm.cc/release/nssm-2.24.zip](https://nssm.cc/release/nssm-2.24.zip).

```powershell
wget https://nssm.cc/release/nssm-2.24.zip -OutFile $env:ALLUSERSPROFILE\nssm.zip
```

Extract the the compressed package.

```powershell
Expand-Archive -Path $env:ALLUSERSPROFILE\nssm.zip $env:ALLUSERSPROFILE
```

Copy `nssm-2.24\win64\nssm.exe` into the `c:\windows\system32` directory.

```powershell
Copy-Item $env:ALLUSERSPROFILE\nssm-2.24\win64\nssm.exe $env:SystemRoot\system32
```
Run `nssm install` to configure the Docker service.

```powershell
start-process nssm install
```

Enter the following data into the corresponding fields in the NSSM service installer.

Application Tab:

- **Path:** C:\Windows\System32\cmd.exe

- **Startup Directory:** C:\Windows\System32

- **Arguments:** /s /c C:\ProgramData\docker\runDockerDaemon.cmd < nul

- **Service Name** - Docker

![](media/nssm1.png)

Details Tab:

- **Display name:** Docker

- **Description:** The Docker Daemon provides management capabilities of containers for docker clients.


![](media/nssm2.png)

IO Tab:

- **Output (stdout):** C:\ProgramData\docker\daemon.log

- **Error (stderr):** C:\ProgramData\docker\daemon.log


![](media/nssm3.png)

When finished, click the `Install Service` button.

With this completed, when Windows starts, the Docker daemon (service) will also start.

### Removing Docker <!--1-->

If following this guide for creating a Windows service from docker.exe, the following command will remove the service.

```powershell
sc.exe delete Docker
```

## Nano Server

### Install Docker <!--2-->

Download docker.exe from `https://aka.ms/tp4/docker` and copy it to the `windows\system32` folder of the Nano Server Container host.

Create a directory named `c:\programdata\docker`. In this directory, create a file named `runDockerDaemon.cmd`.

```powershell
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
docker daemon -D -H 0.0.0.0:2376 --tlsverify --tlscacert=%certs%\ca.pem --tlscert=%certs%\server-cert.pem --tlskey=%certs%\server-key.pem
```

The following script can be used to create a scheduled task to start the Docker daemon at system startup.

```powershell
# Creates a scheduled task to start docker.exe at computer start up.

$dockerData = "$($env:ProgramData)\docker"
$dockerDaemonScript = "$dockerData\runDockerDaemon.cmd"
$dockerLog = "$dockerData\daemon.log"
$action = New-ScheduledTaskAction -Execute "cmd.exe" -Argument "/c $dockerDaemonScript > $dockerLog 2>&1"
$trigger = New-ScheduledTaskTrigger -AtStartup
$settings = New-ScheduledTaskSettingsSet -Priority 5
Register-ScheduledTask -TaskName Docker -Action $action -Trigger $trigger -Settings $settings -User SYSTEM -RunLevel Highest | Out-Null
Start-ScheduledTask -TaskName Docker 
```

### Removing Docker <!--2-->

To remove the docker daemon and cli from Nano Server, delete `docker.exe` from the Windows\system32 directory.

```powershell
Remove-Item $env:SystemRoot\system32\docker.exe
``` 

Run the following to un-register the Docker scheduled task.

```powershell
Get-ScheduledTask -TaskName Docker | UnRegister-ScheduledTask
```

### Interactive Nano Session

> For information on remotely managing Nano Server, see [Getting Started with Nano Server](https://technet.microsoft.com/en-us/library/mt126167.aspx#bkmk_ManageRemote).

You may receive this error when interactively managing a container on a Nano Server Host.

```powershell
docker : cannot enable tty mode on non tty input
+ CategoryInfo          : NotSpecified: (cannot enable tty mode on non tty input:String) [], RemoteException
+ FullyQualifiedErrorId : NativeCommandError 
```

This can happen when trying to run a container with an interactive session, using -it:

```powershell
Docker run -it <image> <command>
```
Or trying to attach to a running container:

```powershell
Docker attach <container name>
```

In order to create an interactive session with a Docker created container on a Nano Server host, the Docker daemon must be managed remotely. To do so, download docker.exe from [this location](https://aka.ms/ContainerTools) and copy it to a remote system.

First, you will need to set up the Docker daemon in your Nano Server to listen to remote commands. You can do this by running this command in the Nano Server:

```powershell
docker daemon -D -H <ip address of Nano Server>:2375
```

Now, on your machine, open a PowerShell or CMD session, and run the Docker commands specifying the remote host with `-H`.

```powershell
.\docker.exe -H tcp://<ip address of Nano Server>:2375
```

For example, if you would like to see the available images: 

```powershell
.\docker.exe -H tcp://<ip address of Nano Server>:2375 images
```
