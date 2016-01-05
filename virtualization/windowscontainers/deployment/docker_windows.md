# Docker and Windows

**This is preliminary content and subject to change.** 

Docker is a container deployment and management platform, that works with both Linux and Windows containers. Docker is used to create, manage, and delete containers and container images. Docker enables storing container images in a public registry (Docker Hub) and private registries (Docker Trusted Registries). Docker additionally provides container host clustering capabilities with Docker Swarm and deployment automaton with Docker Compose. For more information on Docker and the Docker toolset visit [Docker.com](https://www.docker.com/).

> The Windows Container feature must be enabled before Docker can be used to create and manage Windows Server and Hyper-V Container. For instructions on enabling this feature, see the [Container Host Deployment Guide](./docker_windows.md).

## Windows Server

### Install Docker <!--1-->

The Docker Daemon and CLI are not shipped with Windows Server or Windows Server Core, and not installed with the Windows Container feature. Docker will need to be installed separately. This document will walk through manually installing the Docker daemon and Docker client. Automated methods for competing these task will also be provided. 

The Docker Daemon and Docker command line interface have been developed in the Go language. At this time, docker.exe does not install as a Windows Service. There are several methods that can be used to create a Windows service, one example shown here uses `nssm.exe`. 

Download docker.exe from `https://aka.ms/ContainerTools` and place it in the System32 directory on the Container Host.

```powershell
PS C:\> wget https://aka.ms/ContainerTools -OutFile $env:SystemRoot\system32\docker.exe
```

Create a directory named `c:\programdata\docker`. In this directory, create a file named `runDockerDaemon.cmd`.

```powershell
PS C:\> New-Item -ItemType File -Path C:\ProgramData\Docker\runDockerDaemon.cmd -Force
```

Copy the following text into the `runDockerDaemon.cmd` file. This batch file starts the Docker daemon with the command `docker daemon –D –b “Virtual Switch”`. Note: the name of the virtual switch in this file, will need to match the name of the virtual that containers will be using for network connectivity.

```powershell
@echo off
set certs=%ProgramData%\docker\certs.d

if exist %ProgramData%\docker (goto :run)
mkdir %ProgramData%\docker

:run
if exist %certs%\server-cert.pem (goto :secure)

docker daemon -D -b "Virtual Switch"
goto :eof

:secure
docker daemon -D -b "Virtual Switch" -H 0.0.0.0:2376 --tlsverify --tlscacert=%certs%\ca.pem --tlscert=%certs%\server-cert.pem --tlskey=%certs%\server-key.pem
```
Download nssm.exe from [https://nssm.cc/release/nssm-2.24.zip](https://nssm.cc/release/nssm-2.24.zip).

```powershell
PS C:\> wget https://nssm.cc/release/nssm-2.24.zip -OutFile $env:ALLUSERSPROFILE\nssm.zip
```

Extract the files, and copy `nssm-2.24\win64\nssm.exe` into the `c:\windows\system32` directory.

```powershell
PS C:\> Expand-Archive -Path $env:ALLUSERSPROFILE\nssm.zip $env:ALLUSERSPROFILE
PS C:\> Copy-Item $env:ALLUSERSPROFILE\nssm-2.24\win64\nssm.exe $env:SystemRoot\system32
```
Run `nssm install` to configure the Docker service.

```powershell
PS C:\> start-process nssm install
```

Enter the following data into the corresponding fields in the NSSM service installer.

Application Tab:

- **Path:** C:\Windows\System32\cmd.exe

- **Startup Directory:** C:\Windows\System32

- **Arguments:** /s /c C:\ProgramData\docker\runDockerDaemon.cmd

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

If following this guide for creating a Windows service from docke.exe, the following command will remove the service.

```powershell
PS C:\> sc.exe delete Docker

[SC] DeleteService SUCESS
```

## Nano Server

### Install Docker <!--2-->

Download docker.exe from `https://aka.ms/ContainerTools` and copy it to the `windows\system32` folder of the Nano Server Container host.

Run the below command to start the docker daemon. This will need to be run each time the container host is started. This command starts the Docker daemon, specifies a virtual switch for container connectivity, and set’s the daemon to listen on port 2375 for incoming Docker requests. In this configuration Docker can be managed from a remote computer.

```powershell
PS C:\> start-process cmd "/k docker daemon -D -b <Switch Name> -H 0.0.0.0:2375”
```

### Interactive Nano Sessions 

You may receive this error when creating an interactive session with a Container created with Docker on a Nano Serve Host.

```powershell
docker : cannot enable tty mode on non tty input
    + CategoryInfo          : NotSpecified: (cannot enable tty mode on non tty input:String) [], RemoteException
    + FullyQualifiedErrorId : NativeCommandError 
```
In order to create an interactive session with a Docker created container on a Nano Server host, the Docker daemon must be managed remotely. To do so download the docker.exe from [this location]() and copy it to a remote system. 

Open a PowerShell or CMD session and enter run Docker commands like this:

```powershell
.\docker.exe -H tcp://<ip address of Nano Server>:2375
```

For example, if you would like to see the available images: 

```powershell
.\docker.exe -H tcp://<ip address of Nano Server>:2375 images
```

### Removing Docker <!--2-->

To remove the docker daemon and cli from Nano Server, delete `docker.exe` from the Windows\system32 directory.

```powershell
PS C:\> Remove-Item $env:SystemRoot\system32\docker.exe
``` 


