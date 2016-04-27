---
author: neilpeterson
---

# Windows Containers Quick Start - Docker

**This is preliminary content and subject to change.** 

Windows Containers can be used to rapidly deploy many isolated applications on a single computer system. This exercise will demonstrate Windows Container creation and management using Docker. When completed you should have a basic understanding of how Docker integrates with Windows Containers and will have gained hands on experience with the technology.

This walkthrough will detail both Windows Server containers and Hyper-V containers. Each type of container has its own basic requirements. Included with the Windows Container documentation is a procedure for quickly deploying a container host. This is the easiest way to quickly start with Windows Containers. If you do not already have a container host, see [Install Base OS Images](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/manage_images#install-image).

The following items will be required for each exercise.

**Windows Server Containers:**

- A Windows Container Host running Windows Server 2016 (Full or Core), either on-prem or in Azure.
- The Windows Server Core base OS image. For information on installing Base OS images see [Install Base OS Images](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/manage_images#install-image).


**Hyper-V Containers:**

- A physical Windows container host, or a virtualized host with nested virtualization enabled.
- The Windows Server 2016 Media - [Download](https://aka.ms/tp5/serveriso).

> Microsoft Azure does not support Hyper-V containers. To complete the Hyper-V Container exercises, you need an on-prem container host.

## Windows Server Container

Windows Server Containers provide an isolated, portable, and resource controlled operating environment for running applications and hosting processes. Windows Server Containers provide isolation between the container and host, through process and namespace isolation.

### Create Container <!--1-->

Before creating a container, use the `docker images` command to list container images installed on the host.

```none
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
windowsservercore   10.0.10586.0        6801d964fda5        2 weeks ago         0 B
windowsservercore   latest              6801d964fda5        2 weeks ago         0 B
nanoserver          10.0.10586.0        8572198a60f1        2 weeks ago         0 B
nanoserver          latest              8572198a60f1        2 weeks ago         0 B
```

For this example, create a container using the Windows Server Core image. This is done with the `docker run command`. For more information on `docker run`, see the [Docker Run reference on docker.com]( https://docs.docker.com/engine/reference/run/).

This example creates a container named `iisbase`, and starts an interactive session with the container. 

```none
docker run --name iisbase -it windowsservercore cmd
```

When the container has been created, you will be working in a shell session from within the container. 


### Create IIS Image <!--1-->

IIS will be installed, and then an image created from the container. To install IIS, run the following.

```none
powershell.exe Install-WindowsFeature web-server
```

When completed, exit the interactive shell session.

```none
exit
```

Finally, the container will be committed to a new container image using `docker commit`. This example creates a new container image with the name `windowsservercoreiis`.

```none
docker commit iisbase windowsservercoreiis
```

The new IIS images can be viewed using the `docker images` command.

```none
docker images
```

Which will output something similar to the following:

```
REPOSITORY             TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
windowsservercoreiis   latest              4193c9f34e32        4 minutes ago       170.8 MB
windowsservercore      10.0.10586.0        6801d964fda5        2 weeks ago         0 B
windowsservercore      latest              6801d964fda5        2 weeks ago         0 B
nanoserver             10.0.10586.0        8572198a60f1        2 weeks ago         0 B
nanoserver             latest              8572198a60f1        2 weeks ago         0 B
```

### Configure Network
Beginning in Windows Server Technical Preview 5, you no longer need to explicitly create a Windows Firewall rule to allow external access to a specific network port. You may want to take note of the container host IP address. This will be use throughout the exercise.

### Create IIS Container <!--1-->

To create a container from the new image, use the `docker run` command, this time specifying the name of the IIS image. Notice that this sample has specified a parameter `-p 80:80`. Because the container is connected to a virtual switch which is supplying IP addresses via network address translation, a port needs to be mapped from the container host, to a port on the containers NAT IP address. In this case the container will be accessible through port 80 of the container host.

For more information on Windows container networking, see [Container networking](../management/container_networking.md).

For more information on the `-p` parameter see the [Docker Run reference on docker.com]( https://docs.docker.com/engine/reference/run/).

```none
docker run --name iisdemo -it -p 80:80 windowsservercoreiis cmd
```

When the container has been created, open a browser and browse to the IP address of the container host. Because port 80 of the host has been mapped to port 80 of the container, the IIS splash screen should be displayed.

![](media/iis1.png)

### Create Application <!--1-->

Run the following command to remove the IIS splash screen.

```none
del C:\inetpub\wwwroot\iisstart.htm
```

Run the following command to replace the default IIS site with a new static site.

```none
echo "Hello World From a Windows Server Container" > C:\inetpub\wwwroot\index.html
```

Browse again to the IP Address of the container host, you should now see the ‘Hello World’ application. Note – you may need to close any existing browser connections, or clear browser cache to see the updated application.

![](media/hello.png)

Exit the interactive session with the container.

```none
exit
```

Remove the container

```none
docker rm iisdemo
```
Remove the IIS image.

```none
docker rmi windowsservercoreiis
```

## Dockerfile

Through the last exercise, a container was manually created, modified, and then captured into a new container image. Docker includes a method for automating this process using what is called a dockerfile. This exercise will have identical results as the last, however this time the process will be completely automated.

### Create IIS Image

On the container host, create a directory `c:\build`, and in this directory create a file named `dockerfile`.

```none
powershell new-item c:\build\dockerfile -Force
```

Open the dockerfile in notepad.

```none
notepad c:\build\dockerfile
```

Copy the following text into the dockerfile and save the file. These commands instruct Docker to create a new image, using `windowsservercore` as the base, and include the modifications specified with `RUN`. 

For more information on Dockerfiles, see the [Dockerfiles on Windows](../docker/manage_windows_dockerfile.md).

```none
FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
```

This command will start the automated image build process. The `-t` parameter instructs the process to name the new image `iis`.

```none
docker build -t iis c:\Build
```

When completed, you can verify that the image has been created using the `docker images` command.

```none
docker images
```

Which will output something similar to this:

```
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
iis                 latest              abb93867b6f4        26 seconds ago      209 MB
windowsservercore   10.0.10586.0        6801d964fda5        2 weeks ago         0 B
windowsservercore   latest              6801d964fda5        2 weeks ago         0 B
nanoserver          10.0.10586.0        8572198a60f1        2 weeks ago         0 B
nanoserver          latest              8572198a60f1        2 weeks ago         0 B
```

### Deploy IIS Container

Now, just like in the last exercise, deploy the container, mapping port 80 of the host to port 80 of the container.

```none
docker run --name iisdemo -it -p 80:80 iis cmd
```

Once the container has been created, browse to the IP address of the container host. You should see the hello world application.

![](media/dockerfile2.png)

Exit the interactive session with the container.

```none
exit
```

Remove the container

```none
docker rm iisdemo
```
Remove the IIS image.

```none
docker rmi iis
```

## Hyper-V Container

Hyper-V Containers provide an additional layer of isolation over Windows Server Containers. Each Hyper-V Container is created within a highly optimized virtual machine. Where a Windows Server Container shares a kernel with the Container host, a Hyper-V container is completely isolated. Hyper-V Containers are created and managed identically to Windows Server Containers. For more information about Hyper-V Containers see [Managing Hyper-V Containers](../management/hyperv_container.md).

> Microsoft Azure does not support Hyper-V containers. To complete the Hyper-V exercises, you need an on-prem container host.

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