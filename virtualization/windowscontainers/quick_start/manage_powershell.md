ms.ContentId: d0a07897-5fd2-41a5-856d-dc8b499c6783
title: Manage Windows Server Containers with PowerShell

#Manage Windows Server Containers with PowerShell

You can create, run, and interact with Windows Server Containers using PowerShell cmdlets. Everything you need to get going is available in-box.!--In what box? "with Windows Containers" or "Windows PowerShell"? Be specific. Definitely don't use "in-box"--!

##Working with PowerShell Commands !--I'd suggest deleting this heading. I don't think it's adding any value. Generally you don't need a heading for intro.--!

If you’ve used Hyper-V PowerShell, the design of the cmdlets for Windows Server Containers should be pretty familiar to you. A lot of the workflow is similar to how you’d manage a virtual machine using the Hyper-V module. Instead of `New-VM`, `Get-VM`, `Start-VM`, `Stop-VM`, you have `New-Container`, `Get-Container`, `Start-Container`, `Stop-Container`.  There are quite a few container-specific cmdlets and parameters, but the general lifecycle and management of a Windows container looks roughly like that of a Hyper-V VM.
!--Hyper-V PowerShell? PowerShell cmdlets for Hyper-V? Is Hyper-V PowerShell a thing? Also "module" you might put in PowerShell module to be more specific. Also the formating of the cmdlets in the paragraph. Not sure if that's right. My experience is that you bold cmdlet names as you're talking about them and you put them in code format when they're part of a example script. We should check to see how Azure content is doing it. Not a major problem to fix right now though.--!
The following walkthrough will demonstrate the basics of creating and managing Windows Server Containers and Container Images with PowerShell.

> Note - Windows Containers created with Docker need to be managed with Docker. For more information, see [Managing Windows Containers with Docker](./manage_docker.md).

##Step 1 - Create a Container

Before running PowerShell commands, make sure that you have started a PowerShell session. To do this, type `powershell` at the command prompt. You will know that you are in a PowerShell session when the prompt changes from `C:\directory>` to `PS C:\directory>` .
!--I'm trying not to edit...much. But work on using less words and more active verbs/present tense. Just tell them what to do. For example, this is more direct as "Start a PowerShell session from the command prompt by typing "PowerShell"..." It's less words for people to process and easier for non-native english speakers.--!
To return a list of all Windows Server Container Images loaded on the host run `Get-ContainerImage`. You can see in this example that one image was returned with a name of WindowsServerCore. This is the image that will be used when creating a container.
```powershell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
WindowsServerCore CN=Microsoft 10.0.10254.0 True
```
!--Why is this the first step if you haven't created a container yet? I find this confusing. Shouldn't this be after you've created it? If this is a default one, where did it come from? Where is the step to get that? --!
When creating a container the name of a Network Switch will also need to be specified. Run the `Get-VMSwitch` command to return a list of available switches. Take note of the switch that you want to use with your container.
```powershell
Get-VMSwitch

Name           SwitchType NetAdapterInterfaceDescription
----           ---------- ------------------------------
Virtual Switch External   Microsoft Hyper-V Network Adapter
```

Create a new container from the container image using the `New-Container` command. Notice in this example that the output of `New-Container` is stored in the variable `$container`. This variable will be helpful later on in this exercise.

```powershell
$container = New-Container -Name "MyContainer" -ContainerImageName WindowsServerCore -SwitchName "Virtual Switch"
```

To see a list of containers on the host and verify that the container was created, run the `Get-Container` command. You should see the new container that isn't running. 
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
When a container has been created you can interact with it using PowerShell remoting commands such as `Invoke-Command`, or `Enter-PSSession`. The example below creates an interactive session into the container using the `Enter-PSSession` command. When the `Enter-PSSession` command completes, the prompt will change to include the first 11 characters of the container id `[2446380e-629]` indicating that the session is now working against the container.

```powershell
Enter-PSSession -ContainerId $container.ContainerId -RunAsAdministrator

[2446380e-629]: PS C:\Windows\system32>
```

When in the container it can be managed very much like a physical or virtual machine. Command such as `ipconfig` to return the IP address of the container, `mkdir` to create a directory in the container and PowerShell commands like `Get-ChildItem` all work. Go ahead and make a change to the container such as creating a file or folder. For example, the following command will create a file which contains network configuration data about the container. 
!--Huh? "When you're in a container, you can manage it very much like..."--!
```
ipconfig > c:\ipconfig.txt
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
Now that the container has been modified, exit the remote PSSession by typing `exit` and stop the container using the `Stop-Container` command. When these commands have completed, you will be back in control of the container host.

```powershell
exit

Stop-Container -Container $container
```

##Step 2 - Create a Container Image

An image can now be made from this container that will include all changes made to the container. This image will behave like a snapshot of the container and can be re-deployed many times. Each time you deploy the image, it will create a new container.

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

## Step 3 - Create Container From Image

Create a new container from the new container image.
```powershell
$newcontainer = New-Container -Name "newcontainer" -ContainerImageName newimage -SwitchName "Virtual Switch"
```
Start the new container and create a PSSession into the new container.
```powershell
#Start Container
Start-Container $newcontainer

#Create PowerShell connection into container.
Enter-PSSession -ContainerId $newcontainer.ContainerId -RunAsAdministrator
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

Type `exit` to exit the PowerShell session on the container.

```powershell
exit
```

##Step 4 - Remove Containers and Images

To stop all running containers run the command below. If any containers are in a stopped state when you run this command, you receive a warning, which is ok.
```powershell
Get-Container | Stop-Container
```
To remove all containers:

```powershell
Get-Container | Remove-Container -Force
```
Finally to remove a particular container image run the following: 

```powershell
Get-ContainerImage -Name newimage | Remove-ContainerImage -Force
```
!--Is this really what people would be doing everytime they're creating images? This article seems like more of a walkthrough. For user guide - and maybe for future after we see how this article does, I'd suggest breaking making step 4 a seperate section and not one of the steps. And first 3 steps plus "remove" section would be seperate article from the rest of this content. --!
##Host a Web Server in a Container

This next example will walk through a more practical use case for a Windows Server Container. The steps included in this exercise will complete the following:  
- Create a container from the Windows Server Core base image.  
- Deploy web server software into the container.  
- Create an new image from the modified container.  
- Deploy a web server ready container and host a simple website in the container.
    
##Step 1 – Prepare Source Container

To prepare for the creation of a web server container image, deploy and start a container from the Windows Server Core base image.
```powershell
#Create container.
$container = New-Container -Name webbase -ContainerImageName WindowsServerCore -SwitchName "Virtual Switch"

#Start Container
Start-Container $container
```

##Step 2 - Prepare Web Server Software

The next step in preparing the container to host the web server is to install the web server software. This example will use nginx for Windows. Download and extract the nginx software to c:\nginx-1.9.3 on the container. The software can be downloaded from the following site – [nginx for Windows](http://nginx.org/en/download.html). Alternatively use the following commands in the contianer to download and extract the nginx software to C:\nginx-1.9.3.

```powershell
#Establish PowerShell session with the container.
Enter-PSSession -ContainerId $container.ContainerId -RunAsAdministrator

#Download nginx software.
Invoke-WebRequest 'http://nginx.org/download/nginx-1.9.3.zip' -OutFile "c:\nginx-1.9.3.zip"

#Extract nginx software.    
PowerShell.exe Expand-Archive -Path C:\nginx-1.9.3.zip -DestinationPath c:\ -Force
```
Exit the PSSession and Stop the container using the following commands. 
```powershell
exit

Stop-Container $container
``` 
##Step 3 - Create Web Server Image

With the container modified to include the nginx web server software you can now create an image from this container. To do so run the following command:
```powershell
$webserverimage = New-ContainerImage -Container $container -Publisher Demo -Name nginxwindows -Version 1.0
```
When completed run `Get-ContainerImage` to validate that the image was created. 

```powershell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
nginxwindows      CN=Demo      1.0.0.0      False
WindowsServerCore CN=Microsoft 10.0.10254.0 True
```

##Step 3 - Deploy Web Server Container

You can now deploy multiple containers based off of this web server image all of which will be prepared to host web content. To deploy a Windows Server Container based off of the nginxwindows image use the `New-Container` PowerShell command.

```powershell
$webservercontainer = New-Container -Name webserver1 -ContainerImageName nginxwindows -SwitchName "Virtual Switch"
```
Start the new container and create a PSSesson into the container.

```powershell
#Start Container.
Start-Container $webservercontainer

#Create PowerShell connection into container.
Enter-PSSession -ContainerId $webservercontainer.ContainerId -RunAsAdministrator
```

From inside the container the nginx web server can be started and web content staged. To start the nginx web server move to the installation folder and run `start nginx`:
```
cd c:\nginx-1.9.3\

start nginx
```

When the nginx software is running, get the IP address of the container using `ipconfig` and on a different machine open up a web browser and browse to `http//<ip address>`. If everything has been correctly configured you will see the nginx welcome page.

![](media/nginx.png)

At this point feel free to update the website, copy in your own sample website or run the following command to replace the nginx welcome page with a ‘Hello World’ web page.

```powershell
Invoke-WebRequest 'https://raw.githubusercontent.com/neilpeterson/index/master/index.html' -OutFile "C:\nginx-1.9.3\html\index.html"
```
After the website has been updated navigate back to `http://<ip address>`.

![](media/hello.png)

####Wrap Up

This walkthrough has demonstrated basic use of PowerShell with Windows Server Containers, basic image and container management and finally has demonstrated a simple yet practical use for Windows Server Containers. The lessons learned from this walkthrough should enable you to begin exploring deployment and management of Windows Server Containers using PowerShell.

####Resources
[Back to Container Home](../containers_welcome.md)  
[Managing Windows Containers with Docker](./manage_docker.md)
