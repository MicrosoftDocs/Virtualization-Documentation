# Sample to create a Windows Server Container Image with IIS 10.0 enabled

These samples were created for Windows Server 2016 Technical Preview 3 with Containers. They assume that the WindowsServerCore Container base image is present.

## Using PowerShell-managed Windows Server Containers to create an IIS Container Image

In order to create an IIS Container image when you are running PowerShell-managed Windows Server Containers, you only need to copy the HybridInstaller.ps1 to your local Container host.

On the Container host, run:
```
.\HybridInstaller.ps1 -CreateContainerImageUsingPowerShell -InternetVirtualSwitchName "Virtual Switch"
```

The following steps are run in the script:

1. Create a new container
2. Running `Add-WindowsFeature Web-Server` twice within the Container (to work around a bug)
3. Stopping the container
4. Create a new Container Image based on this Container
5. Remove the Container

## Using Docker-managed Windows Server Containers to create an IIS Container Image 

In order to create an IIS Container image when you are running Docker-managed Windows Server Containers, please copy both, the HybridInstaller.ps1 and the Dockerfile to a new folder (e.g. `C:\build\iis`) your local Container host.

On the Container host, please run
```
docker build -t iis:10.0.10514 C:\build\iis
docker tag iis:10.0.10514 iis:latest
```

The following steps will be run when building the dockerfile:

1. Copying the HybridInstaller.ps1 script to the TEMP directory in the Container
2. Running `HybridInstaller.ps1 -RunNative` inside of the Container
  1. Running `Add-WindowsFeature Web-Server` twice within the Container (to work around a bug)