ms.ContentId: 8c12cf06-1dcb-43d6-b973-6d9f9def2400
title: Manage Windows Containers

The container life cycle may include actions such as, starting the container, stopping the container, and removing the container. While performing these actions you will also need retrieve a list of container images, manage container networking as container resources. This document will detail basic container management tasks using PowerShell.
Create a Container
When creating a new container, you will need the name of the container image that will serve as the container base. This can be found using the **Get-ContainerImageName** command.
```powershell
PS C:\> Get-ContainerImage
Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServer        CN=Microsoft 10.0.10584.1000 True
WindowsServerCore CN=Microsoft 10.0.10584.1000 True
```
Use the **New-Container** command to create a new container.
```powershell
PS C:\> New-Container -Name TST -ContainerImageName WindowsServerCore
Name State Uptime   ParentImageName
---- ----- ------   ---------------
TST  Off   00:00:00 WindowsServerCore
```
Once the container has been created, add a network adapter to the container.
```powershell
PS C:\> Add-ContainerNetworkAdapter -ContainerName TST
```
Connet the containers network adapter to a virtuial switch. To get the name of the virtual switch use the **Get-VMSwitch** command.
```powershell
PS C:\> Get-VMSwitch
Name SwitchType NetAdapterInterfaceDescription
---- ---------- ------------------------------
DHCP External   Microsoft Hyper-V Network Adapter
NAT  NAT
```
Connect the network adapter the virtual switch using **Connect-ContainerNetowkrAdapter**.
```powershell
PS C:\> Connect-ContainerNetworkAdapter -ContainerName TST -SwitchName NAT
```
