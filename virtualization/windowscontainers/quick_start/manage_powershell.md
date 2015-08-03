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
Once the container has been created you can interact with the container using many standard PowerShell remoting commands such as `Invoke-Command`, and `Enter-PSSession`. The example below creates an interactive session into the container using the Enter-PSSession command. Notice that once the command completes the prompt changes to include the container id ` [2446380e-629]` indicating that the session is now working against the container.

```powershell
PS C:\> Enter-PSSession -ContainerId $container.ContainerId -RunAsAdministrator
[2446380e-629]: PS C:\Windows\system32>
```

Once in the container it can be managed very much like a physical or virtual machine. Command such as `ipconfig` to return the IP address of the container, `mkdir` to create a directory in the container and PowerShell commands like `Get-ChildItem` all work. Go ahead and make a modification to the container such as creating a file or folder. For instance the following command will created a file which contains network configuration data about the container. 

```
ipconfig > c:\ipconfig
```

You can read the contents of the file to ensure the command completed successfully. Notice that the IP address contained in the text file matches that of the container.
```
Type c:\ipconfig.txt

Ethernet adapter vEthernet (Virtual Switch-b34f32fcdc63b8632eaeb114c6eb901f8982bc91f38a8b64e6da0de40ec47a07-0):

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::85b:7834:454c:375b%20
   IPv4 Address. . . . . . . . . . . : 192.168.1.55
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . :

```
Now that the container has been modified, exit the remote PSSession by typing `Exit` and stop the container using the `Stop-Container` command. Once these commands have completed you will be back in control of the container host.

```powershell
Exit

Stop-Container -Container $container
```

Now that a container has been created and modified, an image can be made from this container that will include all changes made to the container. This image will behave like a snapshot of the container and can be re-deployed many times, each time creating a new container.

To create an image form the container run the following commands:

```powershell
$newimage = New-ContainerImage -Container $container -Publisher Demo -Name newimage -Version 1.0
```

Run `Get-ContainerImage` to return a list of Container Images. Notice that a new image has been created.

```powershell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
newimage          CN=Demo      1.0.0.0      False
WindowsServerCore CN=Microsoft 10.0.10254.0 True
```

Create a new container from the new container image.
```powershell
$container2 = New-Container -Name "MyContainer2" -ContainerImage $newimage -SwitchName $vmswitch.Name
```
Start the new container and create a PSSession into the new container.
```powershell
Start-Container $container2
Enter-PSSession -ContainerId $container2.ContainerId -RunAsAdministrator
```

Finally once in the container notice that because this new container is based off of an image taken from the previous container that the ipconfig.txt file is present.
```
type c:\ipconfig.txt

Ethernet adapter vEthernet (Container-2446380E-6296-4BF2-8146-18DAAFD85FCA-0):

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::85b:7834:454c:375b%20
   IPv4 Address. . . . . . . . . . . : 192.168.1.55
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . :
```
####Removing Containers and Container Images

To stop all running containers run the following:
```powershell
Get-Container | Stop-Contianer
```
To remove all contianers:

```powershell
Get-Container | Remove-Container -Force
```
Finally to remove a particular container image run the following: 

```powershell
Get-ContainerImage -Name newimage | Remove-ContainerImage
```
##Prepare Web Server Image
##Deploy Web Server Contianer

##Navigation
[Back to Container Home](../containers_welcome.md)
