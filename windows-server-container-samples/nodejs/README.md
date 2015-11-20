# Sample to create a Windows Server Container Image with node.js v5 installed

These samples were created for Windows Server 2016 Technical Preview 3 with Containers. They assume that the WindowsServerCore Container base image is present.

## Using PowerShell-managed Windows Server Containers to create a node.js Container Image

In order to create a node.js Container image when you are running PowerShell-managed Windows Server Containers, you only need to copy the HybridInstaller.ps1 to your local Container host.

To do this with PowerShell run:
``` PowerShell
wget https://raw.githubusercontent.com/Microsoft/Virtualization-Documentation/master/windows-server-container-samples/nodejs/HybridInstaller.ps1
```

In the same directory as the script on the Container host, run:
```
.\HybridInstaller.ps1 -CreateContainerImageUsingPowerShell -InternetVirtualSwitchName "Virtual Switch"
```

It is important to note that the Container host and the Virtual Switch need Internet access, since the HybridInstaller.ps1 will download the sources for node.js v5.0.0 x64.

The following steps are run in the script:

1. Create a new container
2. Running several steps inside the container
  1. Create a temp directory
  2. Wait for an IP address
  3. Download node.js MSI installer
  4. Run MSI installer quietly and wait for it to finish
  5. Removing the temp directory
3. Stopping the container
4. Create a new Container Image based on this Container
5. Remove the Container

## Using Docker-managed Windows Server Containers to create a node.js Container Image 

In order to create a node.js Container image when you are running Docker-managed Windows Server Containers, please copy both, the HybridInstaller.ps1 and the Dockerfile to a new folder (e.g. `C:\build\node`) your local Container host.

On the Container host, please run
```
docker build -t node:0.12.7-x64 C:\build\node
docker tag node:0.12.7-x64 node:latest
```

It is important to note that the Container host and Containers created by Docker need Internet access, since the HybridInstaller.ps1 will download the sources for node.js v5.0.0 x64.

The following steps will be run when building the dockerfile:

1. Copying the HybridInstaller.ps1 script to the TEMP directory in the Container
2. Running `HybridInstaller.ps1 -RunNative` inside of the Container
  1. Create a temp directory
  2. Wait for an IP address
  3. Download node.js MSI installer
  4. Run MSI installer quietly and wait for it to finish
  5. Removing the temp directory
