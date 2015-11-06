# Container Images

Container Images provide the deployment foundation for containers as well drive container system efficiency through image layer capabilities. A container images includes applications and application dependencies and is used to deployed to new containers. Container images can be transferred between container environments, stored in a public registry for public use, and stored in a private registry for organizational use. Container images are created in a layered structure such that multiple containers use a single instance of a common container image. Container images can be created, removed and stored in a container registry for later use.

# Container Image Architecture

# Installing Base Images

Container OS Images for Windows Containers have been prepared by Microsoft and can be downloaded and installed using PowerShell OneGet.

Return a list of images from PowerShell OneGet package manager:
```powershell
Find-ContainerImage
```

Download and install an OS image from the PowerShell OneGet package manager.

```powershell
Install-ContainerImage -Name ImageName
```

Alternatively, a container image can be downloaded using one get and stored for later user.
```powershell
Save-ContainerImage -Name ImageName -Destination C:\temp\ImageName.wim
``` 

Once the Container OS Images have been downloaded, they can be installed on the container host using the `Install-ContainerOSImage` command.

```powerhsell
PS C:\> Install-ContainerOSImage –WimPath 'C:\CBaseOsPkg_NanoServer\NanoServer_en-us.wim' -Force
```
# Listing images on the Container Host

```powerhsell
PS C:\> Get-ContainerImage

Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
WindowsServerCore CN=Microsoft 10.0.10584.1000 True
```
# Creating New Images

```powershell
New-ContainerImage -Container $container -Publisher Demo -Name DemoImage -Version 1.0
```

# Storing Images in a Container Registry

<!-- Can we do this with PowerShell at TP4 -->

# Removing Images from the Container Host

```powershell
Get-ContainerImage -Name newimage | Remove-ContainerImage -Force
```
