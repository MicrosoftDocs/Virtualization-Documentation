ms.ContentId: 4e33f990-eaa8-4a57-a83c-632fb13b4b38
title: Manage Windows Container Images

# Container Images

Container Images provide the deployment foundation for containers as well drive container system efficiency through image layer capabilities. A container images includes applications and application dependencies and is used to deployed to new containers. Container images can be transferred between container environments, stored in a public registry for public use, and stored in a private registry for organizational use. Container images are created in a layered structure such that multiple containers use a single instance of a common container image. Container images can be created, removed and stored in a container registry for later use.

# Container Image Architecture

![](./media/image1.png)

# Installing Base Images

Container OS Images for Windows Containers have been prepared and can be downloaded using PowerShell or manually from the <insert download location>.

Once the Container OS Images have been downloaded, they will need to be installed on the container host. This can be completed using the **Install-ContainerOSImage** command.

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
# Finding and Downloading New Container Images

<Insert OneGet Deatils - meeting on 10/30 for details.>

# Creating New Images

```powershell
New-ContainerImage -Container $container -Publisher Demo -Name DemoImage -Version 1.0
```

# Storing Images in a Container Registry

<Can we do this with PowerShell at TP4>

# Removing Images from the Container Host

```powershell
Get-ContainerImage -Name newimage | Remove-ContainerImage -Force
```
