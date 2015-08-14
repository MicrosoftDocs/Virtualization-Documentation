ms.ContentId: d0a07897-5fd2-41a5-856d-dc8b499c6783
title: Manage Windows Server Containers with PowerShell

#Quick Start: Windows Server Containers and PowerShell

This article will walk through the fundamentals of managing Windows Server Container with PowerShell. Items covered will include creating Windows Server Containers and Windows Server Container Images, removing Windows Server Container and Container Images and finally deploying an application into a Windows Server Container. The lessons learned in this walkthrough should enable you to begin exploring deployment and management of Windows Server Containers using PowerShell.

Have questions? Ask them on the [Windows Containers forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

> Note: Windows Containers created with PowerShell can not be managed with Docker right now and visa versa. To create containers with Docker instead, see [Quick Start: Windows Server Containers and Docker](./manage_docker.md).

As you start this guide, you should be looking at a screen that looks like this:
![](./media/ContainerHost_ready.png)
If you don't have this set up, see the [Container setup in a local VM](./container_setup.md) or [container setup in Azure](./azure_setup.md) articles.

The window in the forground (highlighted in red) is a cmd prompt from which you will start working with containers.

##Basic Container Management with PowerShell:

This first example will walk through the basics of creating and removing Windows Server Containers and Windows Server Container Images with PowerShell.

##Step 1 - Create a New Container

Before creating a Windows Server Container you will need the name of a Container Image and the name of a virtual switch that will be attached to the new container.

First start a PowerShell session from the command prompt by typing `PowerShell`. You will know that you are in a PowerShell session when the prompt changes from ``C:\directory>`` to ``PS C:\directory>``.

```
C:\>powershell
Windows PowerShell
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\>
```

Use the `Get-ContainerImage` command to return a list of images loaded on the host. Take note of the image name that you will use to create the container.
```powershell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
WindowsServerCore CN=Microsoft 10.0.10254.0 True
```

Use the `Get-VMSwitch` command to return a list of switches available on the host. Take note of the switch name that will be used with the container.

```powershell
Get-VMSwitch

Name           SwitchType NetAdapterInterfaceDescription
----           ---------- ------------------------------
Virtual Switch External   Microsoft Hyper-V Network Adapter
```

Run the following command to create a container. When running `New-Containewr` you will name the container, specify the container image, and select the network switch to use with the container. Notice in this example that the output is placed in a variable $container. This will be helpful later in this exercise. 

```powershell
$container = New-Container -Name "MyContainer" -ContainerImageName WindowsServerCore -SwitchName "Virtual Switch"
```

To see a list of containers on the host and verify that the container was created, use the `Get-Container` command. Notice that a container has been created with the name of MyContainer, however it has not been started.

```powershell
Get-Container

Name        State Uptime   ParentImageName
----        ----- ------   ---------------
MyContainer Off   00:00:00 WindowsServerCore
```

To start the container, use `Start-Container` proivding the name of the container.

```
Start-Container -Name "MyContainer"
```
You can interact with containers using PowerShell remoting commands such as `Invoke-Command`, or `Enter-PSSession`. The example below creates a remote PowerShell session into the container using the `Enter-PSSession` command. This command needs the container id in order to create the remote session. The contianer id was stored in the `$container` variable when the container was created. 

Notice that once the remote session has been created the command prompt will change to include the first 11 characters of the container id `[2446380e-629]`.

```powershell
Enter-PSSession -ContainerId $container.ContainerId -RunAsAdministrator

[2446380e-629]: PS C:\Windows\system32>
```

A container can be managed very much like a physical or virtual machine. Command such as `ipconfig` to return the IP address of the container, `mkdir` to create a directory in the container and PowerShell commands like `Get-ChildItem` all work. Go ahead and make a change to the container such as creating a file or folder. For example, the following command will create a file which contains network configuration data about the container.

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
Now that the container has been modified, exit the remote PowerShell session by typing `exit`.
```
exit
```

Stop the container by providing the container name to the `Stop-Container` command. When this command has completed, you will be back in control of the container host.

```
Stop-Container -Name "MyContainer"
```

##Step 2 - Create a New Container Image

An image can now be made from this container. This image will behave like a snapshot of the container and can be re-deployed many times.

To create a new image named 'newimage' use the `New-ContainerImage` command. When using this command you will specify the container to capture, a name for the new image, and some additional metadata as seen below.

```powershell
$newimage = New-ContainerImage -ContainerName MyContainer -Publisher Demo -Name newimage -Version 1.0
```

Use `Get-ContainerImage` to return a list of Container Images. Notice that a new image with the name 'newimage' has been created.

```powershell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
newimage          CN=Demo      1.0.0.0      False
WindowsServerCore CN=Microsoft 10.0.10254.0 True
```

## Step 3 - Create New Container From Image

Now that you have created a customized container image, go ahead and deploy a new container from this image.

Create a container named 'newcontainer' from the container image named 'newimage', output the result to a variable named '$newcontainer'.

```powershell
$newcontainer = New-Container -Name "newcontainer" -ContainerImageName newimage -SwitchName "Virtual Switch"
```
Start the new container.

```powershell
Start-Container $newcontainer
```

Create a remote PowerShell session with the container.
```
Enter-PSSession -ContainerId $newcontainer.ContainerId -RunAsAdministrator
```

Finally notice that this new container contains the ipconfig.txt file created earlier in this exercise.

```
type c:\ipconfig.txt

Ethernet adapter vEthernet (Container-2446380E-6296-4BF2-8146-18DAAFD85FCA-0):

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::85b:7834:454c:375b%20
   IPv4 Address. . . . . . . . . . . : 192.168.1.55
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . :
```

 Once you are done working with this container, exit the remote PowerShell session.

```
exit
```

This exercise has shown that an image taken from a modified container will include all modifications. While the example here was a simple file modification, the same would apply if you were to install software into the container such as a web server. Using these methods, custom images can be created that will deploy application ready containers.

##Step 4 - Remove Containers and Container Images

To stop all running containers run the command below. If any containers are in a stopped state when you run this command, you receive a warning, which is ok.

```powershell
Get-Container | Stop-Container
```
Run the following to remove all containers.

```powershell
Get-Container | Remove-Container -Force
```
To remove the container image named 'newimage', run the following.

```powershell
Get-ContainerImage -Name newimage | Remove-ContainerImage -Force
```

##Host a Web Server in a Container

This next example will demonstrate a more practical use case for Windows Server Containers. The steps included in this exercise will guide you through creating a web server container image that can be used for deploying web applications hosted inside of a Windows Server Container.

##Step 1 – Create Container from the Windows Server Core OS Image

To create a web server container image, you first need to deploy and start a container from the Windows Server Core OS image.
```powershell
$container = New-Container -Name webbase -ContainerImageName WindowsServerCore -SwitchName "Virtual Switch"
 ```

Start the container.
```powershell
Start-Container $container
```

When the container is up, create a remote PowerShell session with the container.
```powershell
Enter-PSSession -ContainerId $container.ContainerId -RunAsAdministrator
```

##Step 2 - Install Web Server Software

The next step is to install the web server software. This example will use nginx for Windows. Use the following commands to automatically download and extract the nginx software to c:\nginx-1.9.3.

Download the nginx software.
```
Invoke-WebRequest 'http://nginx.org/download/nginx-1.9.3.zip' -OutFile "c:\nginx-1.9.3.zip"
```

Extract the nginx software.
```
Expand-Archive -Path C:\nginx-1.9.3.zip -DestinationPath c:\ -Force
```
This is all that needs to be completed for the nginx software installation.

Exit the remote PowerShell session.
```powershell
exit
```

Stop the container using the following command. 
```
Stop-Container $container
```
##Step 3 - Create Image from Web Server Container

With the container modified to include the nginx web server software, you can now create an image from this container. To do so, run the following command:
```powershell
$webserverimage = New-ContainerImage -Container $container -Publisher Demo -Name nginxwindows -Version 1.0
```
When completed, use the `Get-ContainerImage` command to validate that the image has been created.

```powershell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
nginxwindows      CN=Demo      1.0.0.0      False
WindowsServerCore CN=Microsoft 10.0.10254.0 True
```

##Step 4 - Deploy Web Server Ready Container

To deploy a Windows Server Container based off of the 'nginxwindows' image, use the `New-Container` PowerShell command.

```powershell
$webservercontainer = New-Container -Name webserver1 -ContainerImageName nginxwindows -SwitchName "Virtual Switch"
```
Start the container.
```
Start-Container $webservercontainer
```

Create a remote PowerShell session with the new container.
```
Enter-PSSession -ContainerId $webservercontainer.ContainerId -RunAsAdministrator
```

Once working inside the container, the nginx web server can be started and web content staged. To start the nginx web server, change to the nginx installation directory.
```
cd c:\nginx-1.9.3\
```
Start the nginx web server.
```
start nginx```

##Step 5 - Configure Container Networking:
Depending on the configuration of the container host and network, a container will either receive an IP address from a DHCP server or the container host itself through network address translation (NAT). This guided walk through is configured to use NAT. In this configuration a port from the container is mapped to a port on the container host. The application hosted in the container is then accessed through the IP address / name of the container host. For instance if port 80 from the container was mapped to port 55534 or the container host, a typical http request to the application would look like this http://contianerhost:55534. This allows a container host to run many containers and allow for the application in these containers to respond to requests on the same port number. 

For this lab we need to create this port mapping. In order to do so we will need to know the IP address of the container and the internal (application) and external (container host) port that will be configured. For this example let’s keep it simple and map port 80 from the container to port 80 of the host. In order to create this mapping run the following where `ipaddress` is the IP address of the container.

```powershell
Add-NetNatStaticMapping -NatName "containerNAT" -Protocol TCP -ExternalIPAddress 0.0.0.0 -ExternalPort 80 -InternalIPAddress <ipaddress> -InternalPort 80
```
When the port mapping has been created you will also need to configure an inbound firewall rule for the configured port. To do so for port 80 run the following command.

```
netsh advfirewall firewall add rule name="Port80" dir=in action=allow protocol=TCP localport=80
```
Finally if you are working from Azure an external endpoint will need to be created that will expose this port to the internet. For more information on Azure VM Endpoints see this article: [Set up Azure VM Endpoints]( https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-set-up-endpoints/).

##Step 6 – Access the Container Hosted Website
With the web server container created and all networking configured, you can now checkout the application hosted in the container. To do so, get the ip address of the container host using `ipconfig`, open up a browser on different machine and enter `http://ipaddress`. If everything has been correctly configured, you will see the nginx welcome page.

![](media/nginx.png)

At this point, feel free to update the website. Copy in your own sample website, or run the following command to replace the nginx welcome page with a ‘Hello World’ web page.

```powershell
Invoke-WebRequest 'https://raw.githubusercontent.com/neilpeterson/index/master/index.html' -OutFile "C:\nginx-1.9.3\html\index.html"
```
After the website has been updated, navigate back to `http://ipaddress`.

![](media/hello.png)

-----------------------------------


## Next Steps

### Experiment with PowerShell
Andy -- use https://int.msdn.microsoft.com/virtualization/hyperv_on_windows/quick_start/walkthrough_powershell as a template



[Back to Container Home](../containers_welcome.md)  

