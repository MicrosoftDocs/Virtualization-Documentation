---
author: neilpeterson
---

# Hyper-V Containers - Quick Start

**This is preliminary content and subject to change.** 

Hyper-V Containers provide an additional layer of isolation over Windows Server Containers. Each Hyper-V Container is created within a highly optimized virtual machine. Where a Windows Server Container shares a kernel with the Container host, a Hyper-V container is completely isolated. Hyper-V Containers are created and managed identically to Windows Server Containers. For more information about Hyper-V Containers see [Managing Hyper-V Containers](../management/hyperv_container.md).

The following items will be required for this exercise.

- A physical Windows container host, or a virtualized host with nested virtualization enabled.
- The Nano Serverbase OS image. For information on installing Base OS images see, [Install Base OS Images](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/manage_images#install-image).
- The Windows Server 2016 Media - [Download](https://aka.ms/tp5/serveriso).
- Microsoft Azure does not support Hyper-V containers. To complete the Hyper-V Container exercises, you need an on-prem container host.

## Hyper-V Container

### Validate container image

> When running Docker commands locally on the container host, the shell must be running with elevated permissions. Start the command session, or PowerShell session as Administrator. 

Before starting this exercise, validate that the Nano Server base OS image has been installed on your container host. Do so using the `docker images` command. You should see a ‘nanoserver’ image with a tag of `latest`. If you do not, the Nano Server image will need to be installed. For instructions see, [Install Base OS Images](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/manage_images#install-image).

```none
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
nanoserver          10.0.14300.1010     cb48429c84fa        4 weeks ago         817.1 MB
nanoserver          latest              cb48429c84fa        4 weeks ago         817.1 MB\
```

 
### Create Container <!--2-->

First, create a directory on the container host name ‘share’, with a sub directory of ‘en-us’
```none
powershell New-Item -Type Directory c:\share\en-us
```

Hyper-V containers use the Nano Server base OS image. Because Nano Server is light weight operating system and does not include the IIS package, this needs to be obtained in order to complete this exercise. This can be found on the Window Server 2016 technical preview media under the NanoServer\Packages directory.

Copy `Microsoft-NanoServer-IIS-Package.cab` from `NanoServer\Packages` to `c:\share` on the container host. 

Copy `NanoServer\Packages\en-us\Microsoft-NanoServer-IIS-Package_en-us.cab` to `c:\share\en-us` on the container host.

Create a file in the c:\share folder named unattend.xml, copy this text into the unattend.xml file.

```none
<?xml version="1.0" encoding="utf-8"?>
    <unattend xmlns="urn:schemas-microsoft-com:unattend">
    <servicing>
        <package action="install">
            <assemblyIdentity name="Microsoft-NanoServer-IIS-Feature-Package" version="10.0.14300.1000" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="neutral" />
            <source location="c:\iisinstall\Microsoft-NanoServer-IIS-Package.cab" />
        </package>
        <package action="install">
            <assemblyIdentity name="Microsoft-NanoServer-IIS-Feature-Package" version="10.0.14300.1000" processorArchitecture="amd64" publicKeyToken="31bf3856ad364e35" language="en-US" />
            <source location="c:\iisinstall\en-us\Microsoft-NanoServer-IIS-Package_en-us.cab" />
        </package>
    </servicing>
    <cpi:offlineImage cpi:source="" xmlns:cpi="urn:schemas-microsoft-com:cpi" />
</unattend>
```

When completed, the `c:\share` directory, on the container host, should be configured like this.

```none
c:\share
|-- en-us
|    |-- Microsoft-NanoServer-IIS-Package_en-us.cab
|
|-- Microsoft-NanoServer-IIS-Package.cab
|-- unattend.xml
```

To create a Hyper-V container using docker, specify the `--isolation=hyperv` parameter. This example mounts the `c:\share` directory from the host, to the `c:\iisinstall` directory of the container, and then creates an interactive shell session with the container.

```none
docker run --name iisnanobase -it -p 80:80 -v c:\share:c:\iisinstall --isolation=hyperv nanoserver cmd
```

### Create IIS Image <!--2-->

From within the container shell session, IIS can be installed using `dism`. Run the following command to install IIS in the container.

```none
dism /online /apply-unattend:c:\iisinstall\unattend.xml
```

When the IIS installation has complete, run the following command to remove the IIS splash screen:


```none
del C:\inetpub\wwwroot\iisstart.htm
```

Run the following command to replace the default IIS site with a new static site:

```none
echo "Hello World From a Hyper-V Container" > C:\inetpub\wwwroot\index.html
```

Next, manually start IIS with the following command:

```none
Net start w3svc
```

Browse to the IP Address of the container host, you should now see the ‘Hello World’ application. Note – you may need to close any existing browser connections, or clear browser cache to see the updated application.

![](media/HWWINServer.png)

Exit the interactive session with the container.

```none
exit
```

## Next Steps

[Windows Server Containers – Quick Start](./manage_docker.md)
