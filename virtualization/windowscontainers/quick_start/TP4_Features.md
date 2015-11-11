# Windows Containers Quick Start

This quick start will walk through basic creation and management of Windows Containers. This exercise will walk through a simple deployment of IIS in both a Windows Server and Hyper-V container. In addition to container management, this exercise will introduce networking, data, and resource control concepts. When complete you should have a basic understanding of simple container creation and management. 

The following items are needed in order to complete this quick start.

- A Windows Container Host running Windows 2016 (Full UI or Core) – Quick Start Host Deployment.
- The Widows Server 2016 Installation Media – Download Location.

This quick start will demonstrate both Windows Server and Hyper-V Containers. To try out Hyper-V containers these additional items will be required.

- Window Container Host with Nested Virtualization – Nest Virtualization. 

## Windows Server Container

Windows Server Containers provide an isolated, portable, and resource controlled operating environment for running applications and hosting processes. Windows Server Containers provide isolation between the container, host, and other containers running on the host, through process and namespace isolation. When running Windows Server Containers, the container hosts’ kernel is shared with all containers and processes from all containers are visible on the host.

### Create Container

At the time of TP4, Windows Server Containers running on a Windows Server 2016 with full UI or a Windows Server 2016 Core container host will require the Windows Server 2016 Core OS Image. This quick start demonstrates this configuration. 

To validate that the Windows Serve Core OS Image has been installed, use the `Get-ContainerImage` command. You may see multiple OS images, that is ok.

```powershell
Get-ContainerImage

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
NanoServer        CN=Microsoft 10.0.10586.0 True
WindowsServerCore CN=Microsoft 10.0.10586.0 True
```

To create a Windows Server Container, use the `New-Container` command. The below example creates a container named `TP4Demo`, from the `WindowsServerCore` OS Image, and connects the container to a VM Switch named `Virtual Switch`. Note also that the output, an object representing the container, is being stored in a variable `$con`.

```powershell
 $con = New-Container -Name TP4Demo -ContainerImageName WindowsServerCore -SwitchName "Virtual Switch"
```

Start the container using the `Start-Container` command.

```powershell
Start-Container $con
```

Connect to the container using the `Enter-PSSession` command. Notice that when the PowerShell session has been created with the container, the PowerShell prompt changes to reflect the container name.

```powershell
PS C:\> Enter-PSSession -ContainerId $con.ContainerId -RunAsAdministrator
[TP4Demo]: PS C:\Windows\system32>
```

### Modify Windows Server Container

Now the container can be modified, and these modifications captured to create a new container image. For this example, IIS will be installed.

To install the IIS role, use the `Install-WindowsFeature` command.

```powershell
Install-WindowsFeature web-server

Success Restart Needed Exit Code      Feature Result
------- -------------- ---------      --------------
True    No             Success        {Common HTTP Features, Default Document, D...
```
When the IIS installation has completed, exit the container by typing `exit`. This will return the PowerShell session to that of the container host.

```powershell
[TP4Demo]: PS C:\> exit
PS C:\>
```

Finally stop the container using the `Stop-Container` command.

```powershell
Stop-Container $con
```

### Create IIS Image

With a container created from the Windows Server Core OS image, and the modified to include IIS, you can now ‘capture’ the state of this container as a new container image. This new image can then be used to deploy IIS ready containers.

To capture the state of the container into a new image, use the `New-ContainerImage` command.

This example creates a new container image named `WindowsServerCoreIIS`, with a publisher of `Demo`, and a version `1.0`.

```powershell
New-ContainerImage -Container $con -Name WindowsServerCoreIIS -Publisher Demo -Version 1.0

Name                 Publisher Version IsOSImage
----                 --------- ------- ---------
WindowsServerCoreIIS CN=Demo   1.0.0.0 False
```

Run `Get-ContainerImage` to verify that the image has been created.

Take note, in the output of `Get-ContainerImage`, the IIS container image displays a property of `IsOSImage = False`. This property differentiates OS Images from non OS Images. While it is not displayed, a dependency is created between the IIS container image and the Windows Server Core OS image. For more information on Container images see Manage Container Images.

```powershell
Get-ContainerImage

Name                 Publisher    Version      IsOSImage
----                 ---------    -------      ---------
WindowsServerCoreIIS CN=Demo      1.0.0.0      False
NanoServer           CN=Microsoft 10.0.10586.0 True
WindowsServerCore    CN=Microsoft 10.0.10586.0 True

```

### Create IIS Container

Create a new container, this time from the `WindosServerCoreIIS` container image.

```powershell
$con = New-Container -Name IIS -ContainerImageName WindowsServerCoreIIS -SwitchName "Virtual Switch"
```    

```powershell
Start-Container $con
```

### Configure Network

The default network configuration for the Windows Container Quick Starts is to have the containers connected to a virtual switch configured with Network Address Translation (NAT). Because of this, in order to connect to an application running inside of a container, a port on the container host needs to be mapped to a port on the container. This can be done with the `Add-NetNatStaticMapping` command. For more information on Network Address Translation in Containers, see Container Networking.

For this exercise, a website will be hosted on IIS running inside of a container. To access the website on port 80, map port 80 of the container hosts IP address to port 80 of the containers IP address.

> NOTE – if running multiple containers on your host you will need to verify the IP address of the container and also that port 80 of the host is not already mapped to a running container. 

Run the following to return the IP address of the container.

```powershell
Invoke-Command -ContainerId $con.ContainerId {ipconfig}

Windows IP Configuration

Ethernet adapter vEthernet (Virtual Switch-04E1CA63-4C67-4457-B065-6ED7E99EC314-0):

   Connection-specific DNS Suffix  . : corp.microsoft.com
   Link-local IPv6 Address . . . . . : fe80::a9ab:8c0d:9da2:1a9a%17
   IPv4 Address. . . . . . . . . . . : 172.16.0.2
   Subnet Mask . . . . . . . . . . . : 255.240.0.0
   Default Gateway . . . . . . . . . : 172.16.0.1
```

To create the NAT port mapping, use the `Add-NetNatStaticMapping` command. The following example maps port 80 of the host to port 80 of the containers IP Address. 

```powershell
Add-NetNatStaticMapping -NatName "ContainerNat" -Protocol TCP -ExternalIPAddress 0.0.0.0 -InternalIPAddress 172.16.0.2 -InternalPort 80 -ExternalPort 80
```

When the port mapping has been created, you will also need to configure an inbound firewall rule for the configured port. To do so for port 80, run the following script.

```powershell
if (!(Get-NetFirewallRule | where {$_.Name -eq "TCP80"})) {
    New-NetFirewallRule -Name "TCP80" -DisplayName "HTTP on TCP/80" -Protocol tcp -LocalPort 80 -Action Allow -Enabled True
}
```

If you are working in Azure and have not already created a Network Security Group, you will need to create one now. For more information on Network Security Groups see this article: [What is a Network Security Group](https://azure.microsoft.com/en-us/documentation/articles/virtual-networks-nsg/).

Because NAT has been configured to pass traffic from port 80 on the hosts, to port 80 of the container, you should now be able to open a browser, enter the IP address of the container host, and see the IIS splash screen.

![](media/iis.png)

### Create Application

With the IIS instances verified as running, you can now create a ‘Hello World’ static site and host this in the IIS instance. To do so, create a PowerShell session with the container.

```powershell
Enter-PSSession -ContainerId $con.ContainerId –RunAsAdministrator
```

Run the following script to replace the default IIS splash screen with a new static site.

```powershell
del C:\inetpub\wwwroot\iisstart.htm
"Hello World From a Windows Server Container" > C:\inetpub\wwwroot\index.html
```

Browse again to the IP Address of the container host and you will now see the ‘Hello World’ application.

![](media/HWWINServer.png)

## Hyper-V Container

### Create Container

At the time of TP4 Hyper-V containers must use a Nano Server Core OS Image. To validate that the Nano Server Core OS image has been installed on the Container Host, use the `Get-ContainerImage` command.

```powershell
PS C:\> Get-ContainerImage
Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServer        CN=Microsoft 10.0.10586.1000 True
WindowsServerCore CN=Microsoft 10.0.10586.1000 True
```

To create a Hyper-V container use the **New-Container** command specifying a Runtime of HyperV.

```powershell
PS C:\> $con = New-Container -Name HYPV -ContainerImageName NanoServer -SwitchName "Virtual Switch" -RuntimeType HyperV
```

When the container has been created, do not start it.

For more information on managing Windows Containers, see the Managing Containers Technical Guide - <>

### Configure Container Network

The default network configuration for the Windows Container Quick Starts is to have the containers connected to a virtual switch configured with Network Address Translation (NAT). Because of this, in order to connect to an application running inside of a container, a port on the container host needs to be mapped to a port on the container. This can be done with the **Add-NetNatStaticMapping** command.

For this exercise, a website will be hosted on IIS running inside of a container. To access the website on port 80, map port 80 of the container host to port 80 of the container.

> NOTE – if running multiple containers on your host you will need to verify the IP address of the container and also that port 80 of the host is not already mapped to a running container. 

To create the port mapping, run the following command.

```powershell
Add-NetNatStaticMapping -NatName "ContainerNat" -Protocol TCP -ExternalIPAddress 0.0.0.0 -InternalIPAddress 172.16.0.2 -InternalPort 80 -ExternalPort 80
```
You will also need to open up port 80 on the container host.

```powershell
if (!(Get-NetFirewallRule | where {$_.Name -eq "TCP80"})) {
    New-NetFirewallRule -Name "TCP80" -DisplayName "HTTP on TCP/80" -Protocol tcp -LocalPort 80 -Action Allow -Enabled True
}
```

### Create a Shared Folder

Create a folder at the root of your container named ‘shared’.
```powershell
PS C:\> New-Item -Type Directory c:\share
```

Windows Container Shared Folders provide a way of sharing data between both the container host and container and between containers themselves. We will use a shared folder during this exercise to copy files into a container which will be used to configure an application.

Use the **Add-ContainerSharedFolder** command to create a shared folder.

> The container must be in a stopped stated when creating the shared folder.

```powershell
PS C:\> Add-ContainerSharedFolder -Container $con -SourcePath c:\share -DestinationPath c:\share
ContainerName SourcePath DestinationPath AccessMode
------------- ---------- --------------- ----------
HYPV          c:\share   c:\share        ReadWrite
```

When the shared folder has been created, start the container.
```powershell
Start-Container $con
```
Create a PowerShell remote session with the container using the **Enter-PSSession** command.

```powershell
PS C:\> Enter-PSSession -ContainerId $con.ContainerId –RunAsAdministrator
```
When in the remote session, notice that a directory has been created ‘c:\share’, and that you can now copy files into the c:\share directory of the host and access them in the container.

For more information on Shared Folders, see the [Shared Folders Technical Guide](../management/manage_data.md)

### Install IIS

Because your container is running a Windows Server Nano OS Image, to install IIS we will need to use IIS packages for Nano Server.

The IIS packages can be found on the Windows Sever Installation media under the **NanoServer\Packages** directory.

```powershell
D:\NanoServer\Packages
```
Copy the Microsoft-NanoServer-IIS-Package.cab from NanoServer\Packages to c:\source on your container host. Next copy NanoServer\Packages\en-us\Microsoft-NanoServer-IIS-Package.cab to c:\source\en-us on your container host.

Alternatively, use this script to complete this for you. Replace the **mediaPath** value with that of the Windows Server Media

```powershell
<insert script>
```
Create a file in the shared folder named unattend.xml, copy these lines into the unattend.xml file.

```powershell
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <servicing>
        <package action="install">
            <assemblyIdentity name="Microsoft-NanoServer-IIS-Package" version="10.0.10586.1000" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" />
            <source location="c:\share\Microsoft-NanoServer-IIS-Package.cab" />
        </package>
        <package action="install">
            <assemblyIdentity name="Microsoft-NanoServer-IIS-Package" version="10.0.10586.1000" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="en-US" />
            <source location="c:\share\en-us\Microsoft-NanoServer-IIS-Package.cab" />
        </package>
    </servicing>
</unattend>
```
From inside the container run the following commands to install IIS.

```powershell
dism /online /apply-unattend:c:\share\unattend.xml
```

Restart Container - is this really needed?

```powershell
PS C:\> Stop-Container $con
PS C:\> Start-Container $con
```
Now, using an internet browser, browse to the IP Address of the container host. You will see the IIS splash screen.

![](media/iis.png)

### Create IIS Image

Stop the Container.

```powershell
Stop-Container $con
```

Create new container images from container.

```powershell
PS C:\> New-ContainerImage -Container $con -Name NanoServerIIS -Publisher Demo -Version 1.0
```

Run **Get-ContainerImage** to see a complete list of images available on the container host. Notice in the output that a differentiation is made between OS Images and non OS images.

```powershell

PS C:\> Get-ContainerImage
Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServerIIS     CN=Demo      1.0.0.0         False
NanoServer        CN=Microsoft 10.0.10586.1000 True
WindowsServerCore CN=Microsoft 10.0.10586.1000 True
```

### Deploy IIS Application

So that you can re-use existing port mapping rules, ensure that all containers are stopped.

Create a new container from the IIS image using the **New-Container** command.

```powershell
PS C:\> $con = New-Container -Name IISApp -ContainerImageName nanoserverIIS -SwitchName "Virtual Switch" -RuntimeType HyperV
```

Start the container.

```powershell
PS C:\> Start-Container $con
```

Create a remote PowerShell session with the container.

```powershell
PS C:\> Enter-PSSession -ContainerId $con.ContainerId –RunAsAdministrator
```

Run the following script to replace the default IIS splash screen with a new static site.

```powershell
del C:\inetpub\wwwroot\iisstart.htm
"Hello World From a Hyper-V Container" > C:\inetpub\wwwroot\index.html
```

Browse to the IP Address of the container host and you will now see the ‘Hello World’ application.

![](media/iisapp.png)

### Container Resource Constraint