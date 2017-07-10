# Using Insider Container Images

This exercise will walk you through the deployment and use of the Windows container feature on the latest insider build of Windows Server from the Windows Insider Preview program. During this exercise, you will install the container role and deploy a preview edition of the base OS images. Before starting this quick start, familiarize yourself with basic container concepts and terminology. You can find this information in the [Quick Start Introduction](./index.md).

This quick start is specific to Windows Server containers on the Windows Server Insider Preview program. Please familiarize yourself with the program before continuing this quick start.

**Prerequisites:**

- Become a part of the [Windows Insider Program](https://insider.windows.com/GettingStarted) and review the Terms of Use. 
- One computer system (physical or virtual) running the latest build of Windows Server from the Windows Insider program and/or the latest build of Windows 10 from the Windows Insider program.

>It is required that you use a build of Windows Server from the Windows Server Insider Preview program, or a build of Windows 10 from the Windows Insider Preview program, to use the base image described below. If you are not using one of these builds, the use of these base images will result in failure to start a container.

## Install Docker
Docker is required in order to work with Windows containers. Docker consists of the Docker Engine, and the Docker client. You will also need a version of Docker that supports multi-stage builds for the best experience using the Container-optimized Nano Server image.

To install Docker, we'll use the OneGet provider PowerShell module. The provider will enable the containers feature on your machine and install Docker - this will require a reboot. Note that there are multiple channels with different version of docker to use in different cases. For this exercise, we will be using the latest Community Edition version of Docker from the Stable channel. There is also an Edge channel available if you would like to test the latest developments in Docker. 

Open an elevated PowerShell session and run the following commands.

>Note: Installing Docker in the insider builds requires a different provider than the one normally used as of today. Please note the difference below.

Install the OneGet PowerShell module.
```powershell
Install-Module -Name DockerMsftProviderInsider -Repository PSGallery -Force
```
Use OneGet to install the latest version of Docker.
```powershell
Install-Package -Name docker -ProviderName DockerMsftProviderInsider -RequiredVersion 17.05.0-ce
```
When the installation is complete, reboot the computer.
```none
Restart-Computer -Force
```

## Install Base Container Image

Before working with Windows containers, a base image needs to be installed. By being part of the Windows Insider program, you can also test our latest builds for the base images. With the Insider base images, there are now 4 available base images based on Windows Server. Refer to the table below to check for what purposes each should be used:

| Base OS Image                       | Usage                      |
|-------------------------------------|----------------------------|
| microsoft/windowsservercore         | Production and Development |
| microsoft/nanoserver                | Production and Development |
| microsoft/windowsservercore-insider | Development only           |
| microsoft/nanoserver-insider        | Development only           |

To pull the Nano Server Insider base image run the following:

```none
docker pull microsoft/nanoserver-insider
```

To pull the Windows Server Core insider base image run the following:

```none
docker pull microsoft/windowsservercore-insider
```

Please read the Windows Containers OS Image EULA which can be found here – [EULA](../EULA.md ), and the Windows Insider program Terms of Use which can be found here – [Terms of Use](https://www.microsoft.com/en-us/software-download/windowsinsiderpreviewserver). 

## Next Steps

[Build and run an application with or without .NET Core 2.0 or PowerShell Core 6](./Nano-RS3-.NET-Core-and-PS.md)
