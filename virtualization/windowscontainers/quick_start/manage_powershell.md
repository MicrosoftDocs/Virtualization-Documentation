ms.ContentId: d0a07897-5fd2-41a5-856d-dc8b499c6783
title: Manage Windows Containers with PowerShell

##Manage Windows Containers with PowerShell

You can create, run, and interact with Windows Server Containers using PowerShell cmdlets. Everything you need to get going is available in-box.

Please Note - Windows Containers created with Docker need to be managed with Docker – [Managing Windows Containers with Docker](./manage_docker.md)

If you’ve used Hyper-V PowerShell, the design of the cmdlets should be pretty familiar to you. A lot of the workflow is similar to how you’d manage a virtual machine using the Hyper-V module. Instead of `New-VM`, `Get-VM`, `Start-VM`, `Stop-VM`, you have `New-Container`, `Get-Container`, `Start-Container`, `Stop-Container`.  There are quite a few container-specific cmdlets and parameters, but the general lifecycle and management of a Windows container looks roughly like that of a Hyper-V VM.

#### Working with PowerShell Commands for Windows Containers
The following walkthrough will demonstrate the basics of creating and managing Windows Server Containers and Container Images with PowerShell.

Before running PowerShell commands make sure that you have started a PowerShell session. In Windows Sever 2016 Core this can be completed by typing `powershell`. You will know that you are in a PowerShell session then the prompt changes from `C:\>` to `PS C:\>` .

To return a list of all Windows Server Container Images loaded on the host run `Get-ContainerImages`. You can see in this example that one image was returned with a name of WindowsServerCore. This is the image that we will use to create a container from.
```powershell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
WindowsServerCore CN=Microsoft 10.0.10254.0 True
```

In order to use this image during the container creation process run `Get-ContainerImage` again however this time place the results into a PowerShell variable as seen below. Also notice that in this example the `–Name` parameter is being used to select a specific container image. This would be important if more than one image was present on the host.

```powershell
$baseImage = Get-ContainerImage –Name WindowsServerCore
```

When creating a container the name of a Network Switch will also need to be specified. The `Get-VMSwitch` command can be run to return a list of available switches. If desired the switch details can be stored in a PowerShell variable.
```powershell
$vmswitch = get-VMSwitch –Name ‘Virtual Switch’
```

At this point the container image object is stored in the `$baseimage` variable and the VM Switch object is stored in the `$VMSwitch` variable. You can now create a new container from the container image using the `New-Container` command.

```powershell
New-Container -Name "MyContainer" -ContainerImage $baseImage -SwitchName $vmswitch.Name

Name        State Uptime   ParentImageName
----        ----- ------   ---------------
MyContainer Off   00:00:00 WindowsServerCore
```

To see a list on container on the system and verify that the container was created run the `Get-Container` command. You will see from the output that a new container has been created however is not running. 
```powershell
Get-Container

Name        State Uptime   ParentImageName
----        ----- ------   ---------------
MyContainer Off   00:00:00 WindowsServerCore
```
Before starting the container run get-container once again however this time place the results into a PowerShell variable. This will come in handy as we begin to work with the container. 
```powershell
$container1 = Get-Container -Name "MyContainer"
```
To start the container use the `Start-Container` command.
```
Start-Container -Name "MyContainer"
```
Once the container has been created you can interact with the container using many standard PowerShell remoting commands such as `Invoke-Command`, and `Enter-PSSession`. This example will create a PSSession into the container.

```powershell
Enter-PSSession -ContainerId $container1.Id
```

```
cd \
mkdir Test
cd Test
echo "hello world" > hello.txt
exit
```

```
$container1
```

```powershell
Stop-Container -Container $container1
```

```powershell
$image1 = New-ContainerImage -Container $container1 -Publisher Test -Name Image1 -Version 1.0
```

```powershell
Get-ContainerImage
```

```powershell
$container2 = New-Container -Name "MySecondContainer" -ContainerImage $image1 -SwitchName "Virtual Switch"
```

```powershell
Remove-Container -Container $container1
```

```powershell
Get-Container
```

```powershell
Export-ContainerImage -Image $image1 -Path "C:\exports"
```

```powershell
Remove-ContainerImage -Image $image1
```

```powershell
Import-ContainerImage -Path C:\exports\CN=Test_Image1_1.0.0.0.appx
```

```powershell
Start-Container -Container $container2 
```
##Prepare Web Server Image
##Deploy Web Server Contianer

##Navigation:
[Back to Container Home](../containers_welcome.md)
