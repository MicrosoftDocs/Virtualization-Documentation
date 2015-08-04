ms.ContentId: d0a07897-5fd2-41a5-856d-dc8b499c6783
title: Manage Windows Server Containers with PowerShell

##Manage Windows Server Containers with PowerShell

You can create, run, and interact with Windows Server Containers using PowerShell cmdlets. Everything you need to get going is available in-box.

If you’ve used Hyper-V PowerShell, the design of the cmdlets for Windows Server Containers should be pretty familiar to you. A lot of the workflow is similar to how you’d manage a virtual machine using the Hyper-V module. Instead of `New-VM`, `Get-VM`, `Start-VM`, `Stop-VM`, you have `New-Container`, `Get-Container`, `Start-Container`, `Stop-Container`.  There are quite a few container-specific cmdlets and parameters, but the general lifecycle and management of a Windows container looks roughly like that of a Hyper-V VM.

The following walkthrough will demonstrate the basics of creating and managing Windows Server Containers and Container Images with PowerShell.

> Please Note - Windows Containers created with Docker need to be managed with Docker – [Managing Windows Containers with Docker](./manage_docker.md)

##Step 1 - Create a Container

Before running PowerShell commands make sure that you have started a PowerShell session. In Windows Sever 2016 Core this can be completed by typing `powershell`. You will know that you are in a PowerShell session then the prompt changes from `C:\directory>` to `PS C:\directory>` .

To return a list of all Windows Server Container Images loaded on the host run `Get-ContainerImage`. You can see in this example that one image was returned with a name of WindowsServerCore. This is the image that will be used when creating a container.
```powershell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
WindowsServerCore CN=Microsoft 10.0.10254.0 True
```

When creating a container the name of a Network Switch will also need to be specified. The `Get-VMSwitch` command can be run to return a list of available switches, take note of the switch that will be used with your container.
```powershell
get-VMSwitch

Name           SwitchType NetAdapterInterfaceDescription
----           ---------- ------------------------------
Virtual Switch External   Microsoft Hyper-V Network Adapter
```

You can now create a new container from the container image using the `New-Container` command.

```powershell
New-Container -Name "MyContainer" -ContainerImageName WindowsServerCore -SwitchName "Virtual Switch"

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

To start the container use the `Start-Container` command.
```
Start-Container -Name "MyContainer"
```
When the container has been created you can interact with the container using many standard PowerShell remoting commands such as `Invoke-Command`, and `Enter-PSSession`. The example below creates an interactive session into the container using the Enter-PSSession command. Notice that when the command completes the prompt changes to include the container id ` [2446380e-629]` indicating that the session is now working against the container.

```powershell
PS C:\> Enter-PSSession -ContainerId $container.ContainerId -RunAsAdministrator
[2446380e-629]: PS C:\Windows\system32>
```

When in the container it can be managed very much like a physical or virtual machine. Command such as `ipconfig` to return the IP address of the container, `mkdir` to create a directory in the container and PowerShell commands like `Get-ChildItem` all work. Go ahead and make a modification to the container such as creating a file or folder. For instance the following command will created a file which contains network configuration data about the container. 

```
ipconfig > c:\ipconfig
```

You can read the contents of the file to ensure the command completed successfully. Notice that the IP address contained in the text file matches that of the container.
```
type c:\ipconfig.txt

Ethernet adapter vEthernet (Virtual Switch-b34f32fcdc63b8632eaeb114c6eb901f8982bc91f38a8b64e6da0de40ec47a07-0):

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::85b:7834:454c:375b%20
   IPv4 Address. . . . . . . . . . . : 192.168.1.55
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . :

```
Now that the container has been modified, exit the remote PSSession by typing `Exit` and stop the container using the `Stop-Container` command. When these commands have completed you will be back in control of the container host.

```powershell
exit

Stop-Container -Container $container
```

##Step 2 - Create a Container Image

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

## Step 3 - Create New Container From Image

Create a new container from the new container image.
```powershell
$container2 = New-Container -Name "MyContainer2" -ContainerImage $newimage -SwitchName $vmswitch.Name
```
Start the new container and create a PSSession into the new container.
```powershell
Start-Container $container2
Enter-PSSession -ContainerId $container2.ContainerId -RunAsAdministrator
```

Finally from the container session notice that the ipconfig.txt file is present.
```
type c:\ipconfig.txt

Ethernet adapter vEthernet (Container-2446380E-6296-4BF2-8146-18DAAFD85FCA-0):

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::85b:7834:454c:375b%20
   IPv4 Address. . . . . . . . . . . : 192.168.1.55
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . :
```
##Step 4 - Remove Containers and Container Images

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
##Host a Web Server in a Windows Server Container

This next example will walk through a more practical use case for a Windows Server Container. The steps included in this exercise will complete the following:  
- Create a container from the Windows Server Core base image.  
- Deploy web server software into the container.  
- Create an new image from the modified container.  
- Deploy a web server ready container and host a simple website in the container.<br />   
    
##Step 1 – Prepare Source Container

To prepare for the creation of a web server container image, deploy and start a container from the Windows Server Core base image.
```powershell
$img = Get-ContainerImage -Name WindowsServerCore
$net = Get-VMSwitch -Name “Virtual Switch”
$container = New-Container -Name webbase -ContainerImage $img -SwitchName $net.Name
Start-Container $container
```

##Step 2 - Download and Extract the nginx Software

The next step in preparing the container to host the web server is to install the web server software. This example will use nginx for Windows. Download and extract the nginx software to <b>c:\build\nginx\source</b>. The software can be downloaded from the following site – [nging for Windows](http://nginx.org/en/download.html). Alternatively use the following commands on the container host to download and extract the nginx software to <b>c:\build\nginx\source</b>.

```powershell
PowerShell.exe Invoke-WebRequest 'http://nginx.org/download/nginx-1.9.3.zip' -OutFile "c:\nginx-1.9.3.zip"
PowerShell.exe Expand-Archive -Path C:\nginx-1.9.3.zip -DestinationPath c:\ -Force
```
Exit the PSSession and Stop the container using the following commands. 
```powershell
exit
Stop-Container $container
``` 
##Step 3 - Create Web Server Container Image

With the container modified to include the nginx web server software you can now create an image from this container.  To do so run the following command:
```powershell
$webserverimage = New-ContainerImage -Container $container -Publisher Demo -Name nginxwindows -Version 1.0
```
When completed run Get-ContainerImage to validate that the image was created. 

```
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
nginxwindows      CN=Demo      1.0.0.0      False
WindowsServerCore CN=Microsoft 10.0.10254.0 True
```

##Deploy Web Server Contianer

You can now deploy multiple containers based off of this web server image all of which will be prepared to host web content. To deploy a Windows Server Container based off of the nginxwindows image use the `New-Container` PowerShell command.

```powershell
$img = Get-ContainerImage -Name nginxwindows
PS C:\Users\Administrator> $net = Get-VMSwitch -Name Container
PS C:\Users\Administrator> $webservercontainer = New-Container -Name webserver1 -ContainerImage $img -SwitchName $net.Name

Name       State Uptime   ParentImageName
----       ----- ------   ---------------
webserver1 Off   00:00:00 nginxwindows
```
Start the new container and create a PSSesson into the container.

```powershell
Start-Container $webservercontainer
Enter-PSSession -ContainerId $webservercontainer.ContainerId -RunAsAdministrator

```

From inside the container the nginx web server can be started and web content staged for consumption. To start the nginx web server move to the installation folder and run `start nginx`:
```
cd c:\nginx-1.9.2\
start nginx
```

When the nginx software is running, get the IP address of the container using `ipconfig`, open up a web browser and browse to `http//<ip address>`. If everything has been correctly configured you will see the nginx welcome page.

![](media/nginx.png)

At this point feel free to update the website, copy in your own sample website or run the following command to replace the nginx welcome page with a ‘Hello World’ web page.

```powershell
Powershell Invoke-WebRequest 'https://raw.githubusercontent.com/neilpeterson/index/master/index.html' -OutFile "C:\nginx-1.9.3\html\index.html"
```
After the website has been updated navigate back to `http://<IP address>`.

![](media/hello.png)

####Wrap Up

This walkthrough has demonstrated basic use of PowerShell with Windows Server Containers, basic image and container management and finally has demonstrated a simple yet practical use for Windows Server Containers. The lessons learned from this walkthrough should enable you to begin exploring deployment and management of Windows Server Containers using PowerShell.

##Navigation
[Back to Container Home](../containers_welcome.md)
