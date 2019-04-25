
# Using Insider Container Images

This exercise will walk you through the deployment and use of the Windows container feature on the latest insider build of Windows Server from the Windows Insider Preview program. During this exercise, you will install the container role and deploy a preview edition of the base OS images. If you need to familiarize yourself with containers, you can find this information in [About Containers](../about/index.md).

This quick start is specific to Windows Server containers on the Windows Server Insider Preview program. Please familiarize yourself with the program before continuing this quick start.

## Prerequisites:

- Become a part of the [Windows Insider Program](https://insider.windows.com/GettingStarted) and review the Terms of Use.
- One computer system (physical or virtual) running the latest build of Windows Server from the Windows Insider program and/or the latest build of Windows 10 from the Windows Insider program.

> [!IMPORTANT]
> You must use a build of Windows Server from the Windows Server Insider Preview program or a build of Windows 10 from the Windows Insider Preview program to use the base image described below. If you are not using one of these builds, the use of these base images will result in failure to start a container.

## Install Docker Enterprise Edition (EE)

Docker EE is required in order to work with Windows containers. Docker EE consists of the Docker engine and the Docker client.

To install Docker EE, we'll use the OneGet provider PowerShell module. The provider will enable the containers feature on your machine and install Docker EE - this will require a reboot. Open an elevated PowerShell session and run the following commands.

> [!NOTE]
> Installing Docker EE with Windows Server Insider builds requires a different OneGet provider than the one used for non-Insider builds. If Docker EE and the DockerMsftProvider OneGet provider are already installed remove them before continuing.

```powershell
Stop-Service docker
Uninstall-Package docker
Uninstall-Module DockerMsftProvider
```

Install the OneGet PowerShell module for use with Windows Insider builds.

```powershell
Install-Module -Name DockerProvider -Repository PSGallery -Force
```

Use OneGet to install the latest version of Docker EE Preview.

```powershell
Install-Package -Name docker -ProviderName DockerProvider -RequiredVersion Preview
```

When the installation is complete, reboot the computer.

```powershell
Restart-Computer -Force
```

## Install Base Container Image

Before working with Windows containers, a base image needs to be installed. By being part of the Windows Insider program, you can also test our latest builds for the base images. With the Insider base images, there are now 4 available base images based on Windows Server. Refer to the table below to check for what purposes each should be used:

| Base OS Image                       | Usage                      |
|-------------------------------------|----------------------------|
| mcr.microsoft.com/windows/servercore         | Production and Development |
| mcr.microsoft.com/windows/nanoserver              | Production and Development |
| mcr.microsoft.com/windows/servercore/insider | Development only           |
| mcr.microsoft.com/windows/nanoserver/insider        | Development only           |

To pull the Nano Server Insider base image run the following:

```console
docker pull mcr.microsoft.com/nanoserver/insider
```

To pull the Windows Server Core insider base image run the following:

```console
docker pull mcr.microsoft.com/windows/servercore/insider
```

> [!IMPORTANT]
> Please read the Windows containers OS image [EULA](../EULA.md ) and the Windows Insider program [Terms of Use](https://www.microsoft.com/en-us/software-download/windowsinsiderpreviewserver).

## Next Steps

> [!div class="nextstepaction"]
> [Build and run a sample application](./Nano-RS3-.NET-Core-and-PS.md)
