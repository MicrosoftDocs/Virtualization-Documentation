## Docker and Windows

Docker is an open-source container deployment and management platform that works with both Linux and Windows containers. The Docker daemon and command line interface are used to create, manage, and delete containers. Docker enables storing container images in a public registry (Docker Hub) and private registries (Docker Trusted Registries). Docker additionally provides container host clustering capabilities with Docker Swarm and deployment automaton with Docker Compose.

For more information on Docker and the Docker toolset visit [Docker.com](https://www.docker.com/).

## Install Docker:

> This process will only work on Windows Server 2016 with Full UI and Windows Server 2016 Core.

The Docker Daemon and CLI are not shipped with Windows, and not installed with the Windows Container feature. Docker will need to be installed separately. This document will walk through manually installing the Docker daemon and Docker client. Automated methods for competing these task will also be provided. 

The Docker Daemon and CLI have been developed in the Go language. At this time, docker.exe does not install as a Windows Service. There are several methods that can be used to create a Windows service, one example here using nssm.exe. 

Download docker.exe from "https://aka.ms/ContainerTools".

Copy docker.exe into **c:\windows\system32** of your container host.

Create a folder **c:\programdata\docker**, and in this folder create a file named **runDockerDaemon.cmd**.

Copy the following text into the runDockerDaemon.cmd file.

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
Download nssm.exe from https://nssm.cc/release/nssm-2.24.zip.

Extract the files, and copy **nssm-2.24\win64\nssm.exe** into the **c:\windows\system32** directory.

Open a command prompt and type **nssm install**.

Enter the following data into the corresponding fields in the NSSM service installer.

Application Tab:

**Path:** C:\Windows\System32\cmd.exe

**Startup Directory:** C:\Windows\System32

**Arguments:** /s /c C:\ProgramData\docker\runDockerDaemon.cmd

**Service Name** - Docker

![](media/nssm1.png)

Details Tab:

- **Display name:** Docker
- **Description:** The Docker Daemon provides management capabilities of containers for docker clients


![](media/nssm2.png)

IO Tab:

- **Output (stdout):** C:\ProgramData\docker\daemon.log
- **Error (stderr):** C:\ProgramData\docker\daemon.log


![](media/nssm3.png)

When finished, click the install service button.

With this completed, when Windows starts, the Docker daemon (service) will also start.

## Automated Installation

Insert Script Instructions When Available

## Removing the Docker Service

If following this guide for creating a Windows service from docke.exe, the following command will remove the service.

```powershell
PS C:\ sc.exe delete Docker
[SC] DeleteService SUCESS
```