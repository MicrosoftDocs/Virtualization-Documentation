# Windows Containers Quick Start

Windows Containers can be used to rapidly deploy many isolated applications on a single computer system. This quick start demonstrates deployment and management of both Windows Server and Hyper-V containers using PowerShell. Throughout this exercise you will build from the ground up a very simple ‘hello world’ application running in both a Windows Server Container and a Hyper-V Container. During this process you will created container image, work with container shared folders, and delete containers and container images. When completed, you will have a basic understanding of Widows Container deployment and management.
This walkthrough details both Windows Server containers and Hyper-V containers. Each type of container has its own basic requirements. Included with the Windows Container documentation is a procedure for quickly deploying a container host. This is the easiest way to quickly start with Windows Containers. If you do not already have a container host, see the [Container Host Deployment Quick Start](./container_setup.md).

The following items are required for each exercise.

**Windows Server Containers:**

- A Windows Container Host running Windows Server 2016 (Full or Core), either on-prem or in Azure.

**Hyper-V Containers:**

- A Windows Container host enabled with Nested Virtualization.
- The Windows Serve 2016 Media.

> Microsoft Azure does not support Hyper-V container. To complete the Hyper-V exercises, you need an on-prem container host.

## Windows Server Container

Windows Server Containers provide an isolated, portable, and resource controlled operating environment for running applications and hosting processes. Windows Server Containers provide isolation between the container and host, and between containers running on the host, through process and namespace isolation.

### Create Container <!--1-->

At the time of TP4, Windows Server Containers running on a Windows Server 2016 with full UI or a Windows Server 2016 require the Windows Server 2016 Core OS Image.

To validate that the Windows Serve Core OS Image has been installed, use the `Get-ContainerImage` command. You may see multiple OS images, which is ok.

```powershell
Get-ContainerImage

#output

Name              Publisher    Version      IsOSImage
----              ---------    -------      ---------
NanoServer        CN=Microsoft 10.0.10586.0 True
WindowsServerCore CN=Microsoft 10.0.10586.0 True
```

To create a Windows Server Container, use the `New-Container` command. The below example creates a container named `TP4Demo` from the `WindowsServerCore` OS Image, and connects the container to a VM Switch named `Virtual Switch`. Note that the output, an object representing the container, is stored in a variable `$con`. This variable is used in subsequent commands.

```powershell
 $con = New-Container -Name TP4Demo -ContainerImageName WindowsServerCore -SwitchName "Virtual Switch"
```

Start the container using the `Start-Container` command.

```powershell
Start-Container $con
```

Connect to the container using the `Enter-PSSession` command. Notice that when the PowerShell session has been created with the container, the PowerShell prompt changes to reflect the container name.

```powershell
Enter-PSSession -ContainerId $con.ContainerId -RunAsAdministrator

#output

[TP4Demo]: PS C:\Windows\system32>
```

### Create IIS Image <!--1-->

Now the container can be modified, and these modifications captured to create a new container image. For this example, IIS is installed.

To install the IIS role, use the `Install-WindowsFeature` command.

```powershell
Install-WindowsFeature web-server

#output

Success Restart Needed Exit Code      Feature Result
------- -------------- ---------      --------------
True    No             Success        {Common HTTP Features, Default Document, D...
```
When the IIS installation has completed, exit the container by typing `exit`. This returns the PowerShell session to that of the container host.

```powershell
exit
```

Finally stop the container using the `Stop-Container` command.

```powershell
Stop-Container $con
```

The state of this container can now be captured into a new container image. Do so using the `New-ContainerImage` command.

This example creates a new container image named `WindowsServerCoreIIS`, with a publisher of `Demo`, and a version `1.0`.

```powershell
New-ContainerImage -Container $con -Name WindowsServerCoreIIS -Publisher Demo -Version 1.0

#output

Name                 Publisher Version IsOSImage
----                 --------- ------- ---------
WindowsServerCoreIIS CN=Demo   1.0.0.0 False
```

### Create IIS Container <!--1-->

Create a new container, this time from the `WindosServerCoreIIS` container image.

```powershell
$con = New-Container -Name IIS -ContainerImageName WindowsServerCoreIIS -SwitchName "Virtual Switch"
```    
Start the container.

```powershell
Start-Container $con
```

### Configure Networking <!--1-->

The default network configuration for the Windows Container Quick Starts is to have containers connected to a virtual switch, configured with Network Address Translation (NAT). Because of this, in order to connect to an application running inside of a container, a port on the container host, needs to be mapped to a port on the container. For more information on Network Address Translation in Containers, see [Manage Container Networking](../management/container_networking.md).

For this exercise, a website is hosted in IIS, running inside of a container. To access the website on port 80, map port 80 of the container hosts IP address. to port 80 of the containers IP address.

Run the following to return the IP address of the container.

```powershell
Invoke-Command -ContainerId $con.ContainerId {ipconfig}

#output

Windows IP Configuration

Ethernet adapter vEthernet (Virtual Switch-04E1CA63-4C67-4457-B065-6ED7E99EC314-0):

   Connection-specific DNS Suffix  . : corp.microsoft.com
   Link-local IPv6 Address . . . . . : fe80::a9ab:8c0d:9da2:1a9a%17
   IPv4 Address. . . . . . . . . . . : 172.16.0.2
   Subnet Mask . . . . . . . . . . . : 255.240.0.0
   Default Gateway . . . . . . . . . : 172.16.0.1
```

To create the NAT port mapping, use the `Add-NetNatStaticMapping` command. The following examples checks for an existing port mapping rule, and if one does not exist, creates it. Note, the `-InternalIPAddress` needs to match the IP address of the container.

```powershell
if (!(Get-NetNatStaticMapping | where {$_.ExternalPort -eq 80})) {
Add-NetNatStaticMapping -NatName "ContainerNat" -Protocol TCP -ExternalIPAddress 0.0.0.0 -InternalIPAddress 172.16.0.2 -InternalPort 80 -ExternalPort 80
}

#output

StaticMappingID               : 6
NatName                       : ContainerNat
Protocol                      : TCP
RemoteExternalIPAddressPrefix : 0.0.0.0/0
ExternalIPAddress             : 0.0.0.0
ExternalPort                  : 80
InternalIPAddress             : 172.16.0.2
InternalPort                  : 80
InternalRoutingDomainId       : {00000000-0000-0000-0000-000000000000}
Active                        : True
```

When the port mapping has been created, you also need to configure an inbound firewall rule for the configured port. To do so for port 80, run the following script.

```powershell
if (!(Get-NetFirewallRule | where {$_.Name -eq "TCP80"})) {
    New-NetFirewallRule -Name "TCP80" -DisplayName "HTTP on TCP/80" -Protocol tcp -LocalPort 80 -Action Allow -Enabled True
}
```

If you are working in Azure, and have not already created a Network Security Group, you need to create one now. For more information on Network Security Groups see this article: [What is a Network Security Group](https://azure.microsoft.com/en-us/documentation/articles/virtual-networks-nsg/).

### Create Application <!--1-->

Now that a container has been created from the IIS image, and networking configured, open up a browser and browse to the IP address of the container host. You should see the IIS splash screen.

![](media/iis1.png)

With the IIS instances verified as running, you can now create a ‘Hello World’ application, and host this in the IIS instance. To do so, create a PowerShell session with the container.

```powershell
Enter-PSSession -ContainerId $con.ContainerId –RunAsAdministrator
```

Run the following script to replace the default IIS site with a new static site.

```powershell
del C:\inetpub\wwwroot\iisstart.htm
"Hello World From a Windows Server Container" > C:\inetpub\wwwroot\index.html
```

Browse again to the IP Address of the container host, you should now see the ‘Hello World’ application. Note – you may need to close any existing browser connections, or clear browser cache to see the updated application.

![](media/HWWINServer.png)

Exit the remote container session.

```powershell
exit
```

### Remove Container

A container needs to be stopped, before it can be removed.

```powershell
Stop-Container $con
```

When the container has been stopped, it can be removed with the `Remove-Container` command.

```powershell
Remove-Container $con –Force
```

Finally, a container image can be removed using the ` Remove-ContainerImage` command.

```powershell
Remove-ContainerImage -Name WindowsServerCoreIIS –Force
```

## Hyper-V Container

Hyper-V Containers provide an additional layer of isolation over Windows Server Containers. Each Hyper-V Container is created within a highly optimized virtual machine. Where a Windows Server Container shares a kernel with the Container host, and all other Windows Server Containers running on that host, a Hyper-V container is completely isolated from other containers. Hyper-V Containers are created and managed identically to Windows Server Containers. For more information about Hyper-V Containers see [Managing Hyper-V Containers](../management/hyperv_container.md).

> Microsoft Azure does not support Hyper-V container. To complete the Hyper-V exercises, you need an on-prem container host.

### Create Container <!--2-->

At the time of TP4, Hyper-V containers must use a Nano Server Core OS Image. To validate that the Nano Server OS image has been installed on the Container Host, use the `Get-ContainerImage` command.

```powershell
Get-ContainerImage

#output

Name              Publisher    Version         IsOSImage
----              ---------    -------         ---------
NanoServer        CN=Microsoft 10.0.10586.0    True
WindowsServerCore CN=Microsoft 10.0.10586.0    True
```

To create a Hyper-V container, use the `New-Container` command specifying a Runtime of HyperV.

```powershell
$con = New-Container -Name HYPV -ContainerImageName NanoServer -SwitchName "Virtual Switch" -RuntimeType HyperV
```

When the container has been created, **do not start it**.

### Create a Shared Folder

Shared folders expose a directory from the container host to the container. When a shared folder has been created, any files placed in the shared folder are available in the container. A shared folder is used in this example to copy the Nano Server IIS packages into the container. These packages will then be used to install. For more information on shared folder see [Managing Container Data](../management/manage_data.md). 

Create a directory on the container host that will be shared with the container.

```powershell
New-Item -Type Directory c:\share\en-us
```

Use the `Add-ContainerSharedFolder` command to create a new shared folder with the new container.

> The container must be in a stopped stated when creating the shared folder.

```powershell
Add-ContainerSharedFolder -Container $con -SourcePath c:\share -DestinationPath c:\iisinstall

#output

ContainerName SourcePath DestinationPath AccessMode
------------- ---------- --------------- ----------
HYPV          c:\share   c:\iisinstall        ReadWrite
```

When the shared folder has been created, start the container.

```powershell
Start-Container $con
```
Create a PowerShell remote session with the container using the `Enter-PSSession` command.

```powershell
Enter-PSSession -ContainerId $con.ContainerId –RunAsAdministrator
```
When in the remote session, notice that the shared folder `c:\iisinstall\en-us` has been created, however is empty.

```powershell
ls c:\iisinstall
```

For more information on Shared Folders see [Container Data Management](../management/manage_data.md).

### Create IIS Image <!--2-->

Because the container is running a Nano Server OS Image, the Nano Server IIS packages are needed to install IIS. These can be found on the Windows Sever 2016 TP4 Installation media, under the `NanoServer\Packages` directory.

Copy `Microsoft-NanoServer-IIS-Package.cab` from `NanoServer\Packages` to `c:\share` on the container host. 

Copy `NanoServer\Packages\en-us\Microsoft-NanoServer-IIS-Package.cab` to `c:\share\en-us` on the container host.

Create a file in the c:\share folder named unattend.xml, copy this text into the unattend.xml file.

```powershell
<?xml version="1.0" encoding="utf-8"?>
<unattend xmlns="urn:schemas-microsoft-com:unattend">
    <servicing>
        <package action="install">
            <assemblyIdentity name="Microsoft-NanoServer-IIS-Package" version="10.0.10586.0" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" />
            <source location="c:\iisinstall\Microsoft-NanoServer-IIS-Package.cab" />
        </package>
        <package action="install">
            <assemblyIdentity name="Microsoft-NanoServer-IIS-Package" version="10.0.10586.0" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="en-US" />
            <source location="c:\iisinstall\en-us\Microsoft-NanoServer-IIS-Package.cab" />
        </package>
    </servicing>
</unattend>
```

When completed, the `c:\share` directory, on the container host, should be configured like this.

```
c:\share
|-- en-us
|    |-- Microsoft-NanoServer-IIS-Package.cab
|
|-- Microsoft-NanoServer-IIS-Package.cab
|-- unattend.xml
```

Back in the remote session on the container, note that the IIS packages and unattended.xml files are now visible in the c:\iisinstall directory.

```powershell
ls c:\iisinstall

#output

    Directory: C:\iisinstall

Mode                LastWriteTime         Length Name
----                -------------         ------ ----
d-----       11/11/2015   1:57 PM                en-us
-a----       10/29/2015  10:27 PM        1919875 Microsoft-NanoServer-IIS-Package.cab
-a----       11/11/2015   1:58 PM            795 unattend.xml
```

Run the following command to install IIS.

```powershell
dism /online /apply-unattend:c:\iisinstall\unattend.xml
```

When the IIS installation has complete, manually start IIS with the following command.

```powershell
Net start w3svc
```

Exit the container session.

```powershell
exit
```

Stop the container.

```powershell
Stop-Container $con
```

The state of this container can now be captured into a new container image.

This example creates a new container image named `NanoServerIIS`, with a publisher of `Demo`, and a version `1.0`.

```powershell
New-ContainerImage -Container $con -Name NanoServerIIS -Publisher Demo -Version 1.0

#output

Name                 Publisher Version IsOSImage
----                 --------- ------- ---------
NanoServerIIS        CN=Demo   1.0.0.0 False
```

### Create IIS Container <!--2-->

Create a new Hyper-V container from the IIS image using the `New-Container` command.

```powershell
$con = New-Container -Name IISApp -ContainerImageName NanoServerIIS -SwitchName "Virtual Switch" -RuntimeType HyperV
```

Start the container.

```powershell
Start-Container $con
```

### Configure Networking <!--2-->

The default network configuration for the Windows Container Quick Starts is to have containers connected to a virtual switch, configured with Network Address Translation (NAT). Because of this, in order to connect to an application running inside of a container, a port on the container host, needs to be mapped to a port on the container. For more information on Network Address Translation in Containers, see [Manage Container Networking](../management/container_networking.md).

For this exercise, a website is hosted in IIS, running inside of a container. To access the website on port 80, map port 80 of the container hosts IP address. to port 80 of the containers IP address.

Run the following to return the IP address of the container.

```powershell
Invoke-Command -ContainerId $con.ContainerId {ipconfig}

#output

Windows IP Configuration

Ethernet adapter vEthernet (Virtual Switch-04E1CA63-4C67-4457-B065-6ED7E99EC314-0):

   Connection-specific DNS Suffix  . : corp.microsoft.com
   Link-local IPv6 Address . . . . . : fe80::a9ab:8c0d:9da2:1a9a%17
   IPv4 Address. . . . . . . . . . . : 172.16.0.2
   Subnet Mask . . . . . . . . . . . : 255.240.0.0
   Default Gateway . . . . . . . . . : 172.16.0.1
```

To create the NAT port mapping, use the `Add-NetNatStaticMapping` command. The following examples checks for an existing port mapping rule, and if one does not exist, creates it. Note, the `-InternalIPAddress` needs to match the IP address of the container.

```powershell
if (!(Get-NetNatStaticMapping | where {$_.ExternalPort -eq 80})) {
Add-NetNatStaticMapping -NatName "ContainerNat" -Protocol TCP -ExternalIPAddress 0.0.0.0 -InternalIPAddress 172.16.0.2 -InternalPort 80 -ExternalPort 80
}
```
You also need to open up port 80 on the container host.

```powershell
if (!(Get-NetFirewallRule | where {$_.Name -eq "TCP80"})) {
    New-NetFirewallRule -Name "TCP80" -DisplayName "HTTP on TCP/80" -Protocol tcp -LocalPort 80 -Action Allow -Enabled True
}
```

### Create Application <!--2-->

Now that a container has been created from the IIS image, and networking configured, open up a browser and browse to the IP address of the container host, you should see the IIS splash screen.

![](media/iis1.png)

With the IIS instances verified as running, you can now create a ‘Hello World’ application, and host this in the IIS instance. To do so, create a PowerShell session with the container.

```powershell
Enter-PSSession -ContainerId $con.ContainerId –RunAsAdministrator
```

Run the following script to replace the default IIS site with a new static site.

```powershell
del C:\inetpub\wwwroot\iisstart.htm
"Hello World From a Hyper-V Container" > C:\inetpub\wwwroot\index.html
```

Browse again to the IP Address of the container host, you should now see the ‘Hello World’ application. Note – you may need to close any existing browser connections, or clear browser cache to see the updated application.

![](media/HWWINServer.png)

Exit the remote container session.

```powershell
exit
```
