ms.ContentId: d0a07897-5fd2-41a5-856d-dc8b499c6783
title: Manage Windows Server Containers with PowerShell

#Quick Start: Windows Server Containers and PowerShell

This article will walk through the fundamentals of managing Windows Server Container with PowerShell. Items covered will include creating Windows Server Containers and Windows Server Container Images, removing Windows Server Containers and Container Images and finally deploying an application into a Windows Server Container. The lessons learned in this walkthrough should enable you to begin exploring deployment and management of Windows Server Containers using PowerShell.

Have questions? Ask them on the [Windows Containers forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

> **Note:** Windows Server Containers created with PowerShell can not currently be managed with Docker and visa versa. To create containers with Docker instead, see [Quick Start: Windows Server Containers and Docker](./manage_docker.md).

## Prerequisites
In order to complete this walkthrough the following items need to be in place.
- Windows Server 2016 Container host.
- Container host must be connected to a network and able to access the internet.
- The Windows Server 2016 Container host should be ready at the command prompt.

If you need to configure a container host, see the following guides: [Container Setup in Azure](./azure_setup.md) or [Container Setup in Hyper-V](./container_setup.md). 

<!--
As you start this guide, you should be looking at a screen that looks like this:
![](./media/ContainerHost_ready.png)

If you don't have this set up, see the [Container setup in a local VM](./container_setup.md) or [container setup in Azure](./azure_setup.md) articles.

The window in the forground (highlighted in red) is a cmd prompt from which you will start working with containers.

-->

## Basic Container Management with PowerShell

This first example will walk through the basics of creating and removing Windows Server Containers and Windows Server Container Images with PowerShell. You can find the available container cmdlets using `Get-Command -Module Containers`.

### Step 1 - Create a New Container

Before creating a Windows Server Container you will need the name of a Container Image and the name of a virtual switch that will be attached to the new container.

First start a PowerShell session from the command prompt by typing `PowerShell`. You will know that you are in a PowerShell session when the prompt changes from ``C:\directory>`` to ``PS C:\directory>``.

```
C:\> powershell
Windows PowerShell
Copyright (C) 2015 Microsoft Corporation. All rights reserved.

PS C:\>
```

Use the `Get-ContainerImage` command to return a list of container images loaded on the host. Take note of the image name that you will use to create the container.
``` PowerShell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
WindowsServerCore CN=Microsoft 10.0.10514.0 True
```

Use the `Get-VMSwitch` command to return a list of switches available on the host. Take note of the switch name that will be used with the container.

``` PowerShell
Get-VMSwitch

Name           SwitchType NetAdapterInterfaceDescription
----           ---------- ------------------------------
Virtual Switch NAT
```

Run the following command to create a container. When running `New-Container` you will name the container, specify the container image, and select the network switch to use with the container. Notice in this example that the output is placed in a variable $container. This will be helpful later in this exercise. 

``` PowerShell
$container = New-Container -Name "MyContainer" -ContainerImageName WindowsServerCore -SwitchName "Virtual Switch"
```

To see a list of containers on the host and verify that the container was created, use the `Get-Container` command. Notice that a container has been created with the name of MyContainer, however it has not been started.

``` PowerShell
Get-Container

Name        State Uptime   ParentImageName
----        ----- ------   ---------------
MyContainer Off   00:00:00 WindowsServerCore
```

To start the container, use `Start-Container` proivding the name of the container.

``` PowerShell
Start-Container -Name "MyContainer"
```

You can interact with containers using PowerShell remoting commands such as `Invoke-Command`, or `Enter-PSSession`. The example below creates a remote PowerShell session into the container using the `Enter-PSSession` command. This command needs the container id in order to create the remote session. The contianer id was stored in the `$container` variable when the container was created. 

Notice that once the remote session has been created the command prompt will change to include the first 11 characters of the container id `[2446380e-629]`.

``` PowerShell
Enter-PSSession -ContainerId $container.ContainerId -RunAsAdministrator

[2446380e-629]: PS C:\Windows\system32>
```

A container can be managed very much like a physical or virtual machine. Command such as `ipconfig` to return the IP address of the container, `mkdir` to create a directory in the container and PowerShell commands like `Get-ChildItem` all work. Go ahead and make a change to the container such as creating a file or folder. For example, the following command will create a file which contains network configuration data about the container.

``` PowerShell
ipconfig > c:\ipconfig.txt
```

You can read the contents of the file to ensure the command completed successfully. Notice that the IP address contained in the text file matches that of the container.

``` PowerShell
type c:\ipconfig.txt

Ethernet adapter vEthernet (Virtual Switch-E0D87408-325B-4818-ADB2-2EC7A2005739-0):

   Connection-specific DNS Suffix  . : corp.microsoft.com
   Link-local IPv6 Address . . . . . : fe80::400e:1e0e:591c:beef%18
   IPv4 Address. . . . . . . . . . . : 172.16.0.2
   Subnet Mask . . . . . . . . . . . : 255.240.0.0
   Default Gateway . . . . . . . . . : 172.16.0.1
```

Now that the container has been modified, exit the remote PowerShell session.

``` PowerShell
exit
```

Stop the container by providing the container name to the `Stop-Container` command. When this command has completed, you will be back in control of the container host.

``` PowerShell
Stop-Container -Name "MyContainer"
```

### Step 2 - Create a New Container Image

An image can now be made from this container. This image will behave like a snapshot of the container and can be re-deployed many times.

To create a new image named 'newimage' use the `New-ContainerImage` command. When using this command you will specify the container to capture, a name for the new image, and additional metadata as seen below.

``` PowerShell
$newimage = New-ContainerImage -ContainerName MyContainer -Publisher Demo -Name newimage -Version 1.0
```

Use `Get-ContainerImage` to return a list of Container Images. Notice that a new image with the name 'newimage' has been created.

``` PowerShell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
newimage          CN=Demo      1.0.0.0      False
WindowsServerCore CN=Microsoft 10.0.10254.0 True
```

### Step 3 - Create New Container From Image

Now that you have created a customized container image, go ahead and deploy a new container from this image.

Create a container named 'newcontainer' from the container image named 'newimage', output the result to a variable named '$newcontainer'.

``` PowerShell
$newcontainer = New-Container -Name "newcontainer" -ContainerImageName newimage -SwitchName "Virtual Switch"
```

Start the new container.
``` PowerShell
Start-Container $newcontainer
```

Create a remote PowerShell session with the container.
``` PowerShell
Enter-PSSession -ContainerId $newcontainer.ContainerId -RunAsAdministrator
```

Finally notice that this new container contains the ipconfig.txt file created earlier in this exercise.

``` PowerShell
type c:\ipconfig.txt

Ethernet adapter vEthernet (Virtual Switch-E0D87408-325B-4818-ADB2-2EC7A2005739-0):

   Connection-specific DNS Suffix  . : corp.microsoft.com
   Link-local IPv6 Address . . . . . : fe80::400e:1e0e:591c:beef%18
   IPv4 Address. . . . . . . . . . . : 172.16.0.2
   Subnet Mask . . . . . . . . . . . : 255.240.0.0
   Default Gateway . . . . . . . . . : 172.16.0.1
```

 Once you are done working with this container, exit the remote PowerShell session.

``` PowerShell
exit
```

This exercise has shown that an image taken from a modified container will include all modifications. While the example here was a simple file modification, the same would apply if you were to install software into the container such as a web server. Using these methods, custom images can be created that will deploy application ready containers.

### Step 4 - Remove Containers and Container Images

To stop all running containers run the command below. If any containers are in a stopped state when you run this command, you receive a warning, which is ok.

``` PowerShell
Get-Container | Stop-Container
```
Run the following to remove all containers.

``` PowerShell
Get-Container | Remove-Container -Force
```
To remove the container image named 'newimage', run the following.

``` PowerShell
Get-ContainerImage -Name newimage | Remove-ContainerImage -Force
```

## Host a Web Server in a Container

This next example will demonstrate a more practical use case for Windows Server Containers. The steps included in this exercise will guide you through creating a web server container image that can be used for deploying web applications hosted inside of a Windows Server Container.

### Step 1 – Create Container from the Windows Server Core OS Image

To create a web server container image, you first need to deploy and start a container from the Windows Server Core OS image.
``` PowerShell
$container = New-Container -Name webbase -ContainerImageName WindowsServerCore -SwitchName "Virtual Switch"
 ```

Start the container.
``` PowerShell
Start-Container $container
```

When the container is up, create a remote PowerShell session with the container.
``` PowerShell
Enter-PSSession -ContainerId $container.ContainerId -RunAsAdministrator
```

### Step 2 - Install Web Server Software

The next step is to install the web server software. This example will use nginx for Windows. Use the following commands to automatically download and extract the nginx software to c:\nginx-1.9.3. **Note** that this step will require the container host to be connected to the internet. If this step produces a connectivity or name resolution error check the network configuration of the container host.

Download the nginx software.
``` PowerShell
wget -uri 'http://nginx.org/download/nginx-1.9.3.zip' -OutFile "c:\nginx-1.9.3.zip"
```

Extract the nginx software.
``` PowerShell
Expand-Archive -Path C:\nginx-1.9.3.zip -DestinationPath c:\ -Force
```
This is all that needs to be completed for the nginx software installation.

Exit the remote PowerShell session.
``` PowerShell
exit
```

Stop the container using the following command. 
``` PowerShell
Stop-Container $container
```
### Step 3 - Create Image from Web Server Container

With the container modified to include the nginx web server software, you can now create an image from this container. To do so, run the following command:
``` PowerShell
$webserverimage = New-ContainerImage -Container $container -Publisher Demo -Name nginxwindows -Version 1.0
```
When completed, use the `Get-ContainerImage` command to validate that the image has been created.

``` PowerShell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
nginxwindows      CN=Demo      1.0.0.0      False
WindowsServerCore CN=Microsoft 10.0.10254.0 True
```

### Step 4 - Deploy Web Server Ready Container

To deploy a Windows Server Container based off of the 'nginxwindows' image, use the `New-Container` PowerShell command.

``` PowerShell
$webservercontainer = New-Container -Name webserver1 -ContainerImageName nginxwindows -SwitchName "Virtual Switch"
```

Start the container.
``` PowerShell
Start-Container $webservercontainer
```

Create a remote PowerShell session with the new container.
``` PowerShell
Enter-PSSession -ContainerId $webservercontainer.ContainerId -RunAsAdministrator
```

Once working inside the container, the nginx web server can be started and web content staged. To start the nginx web server, change to the nginx installation directory.
``` PowerShell
cd c:\nginx-1.9.3\
```

Start the nginx web server.
``` PowerShell
start nginx
```

And exit this PS-Session.  The web server will keep running.
``` PowerShell
exit
```

### Step 5 - Configure Container Networking
Depending on the configuration of the container host and network, a container will either receive an IP address from a DHCP server or the container host itself using network address translation (NAT). This guided walk through is configured to use NAT. In this configuration a port from the container is mapped to a port on the container host. The application hosted in the container is then accessed through the IP address / name of the container host. For example if port 80 from the container was mapped to port 55534 on the container host, a typical http request to the application would look like this http://contianerhost:55534. This allows a container host to run many containers and allow for the applications in these containers to respond to requests using the same port. 

For this lab we need to create this port mapping. In order to do so we will need to know the IP address of the container and the internal (application) and external (container host) ports that will be configured. For this example let’s keep it simple and map port 80 from the container to port 80 of the host. Using the `Add-NetNatStaticMapping` command, the `–InternalIPAddress` will be the IP address of the container which for this walkthrough should be ‘172.16.0.2’’.

``` PowerShell
Add-NetNatStaticMapping -NatName "ContainerNat" -Protocol TCP -ExternalIPAddress 0.0.0.0 -InternalIPAddress 172.16.0.2 -InternalPort 80 -ExternalPort 80
```
When the port mapping has been created you will also need to configure an inbound firewall rule for the configured port. To do so for port 80 run the following command.

``` PowerShell
if (!(Get-NetFirewallRule | where {$_.Name -eq "httpTCP80"})) {
    New-NetFirewallRule -Name "httpTCP80" -DisplayName "HTTP on TCP/80" -Protocol tcp -LocalPort 80 -Action Allow -Enabled True
}
```

Finally if you are working from Azure an external endpoint will need to be created that will expose this port to the internet. For more information on Azure VM Endpoints see this article: [Set up Azure VM Endpoints]( https://azure.microsoft.com/en-us/documentation/articles/virtual-machines-set-up-endpoints/).

### Step 6 – Access the Container Hosted Website
With the web server container created and all networking configured, you can now checkout the application hosted in the container. To do so, get the ip address of the container host using `ipconfig`, open up a browser on different machine and enter `http://containerhost-ipaddress`. If everything has been correctly configured, you will see the nginx welcome page.

![](media/nginx.png)

At this point, feel free to update the website. Copy in your own sample website, or use a simple ‘Hello World’ sample site that has been created for this demo. To use the sample you will first need to re-establish a remote PS session with the container.

You will first need to re-create the remote PS session with the container.
``` PowerShell
Enter-PSSession -ContainerId $webservercontainer.ContainerId -RunAsAdministrator
```
Then run the following command to download and replace the index.html file.

``` powershell
wget -uri 'https://raw.githubusercontent.com/neilpeterson/index/master/index.html' -OutFile "C:\nginx-1.9.3\html\index.html"
```
   
After the website has been updated, navigate back to `http://containerhost-ipaddress`.

![](media/hello.png)

-----------------------------------
[Back to Container Home](../containers_welcome.md)   
[Known Issues for Current Release](../about/work_in_progress.md)