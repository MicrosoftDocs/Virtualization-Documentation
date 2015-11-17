# Windows Containers Quick Start

Windows Containers can be used to rapidly deploy many isolated applications on a single computer system. This exercise will demonstrate Windows Container creation and management using Docker. When completed you should have a basic understanding of how Docker integrates with Windows Containers and will have gained hands on experience with the technology.

This walkthrough will detail both Windows Server containers and Hyper-V containers. Each type of container has its own basic requirements. Included with the Windows Container documentation is a procedure for quickly deploying a container host. This is the easiest way to quickly start with Windows Containers. If you do not already have a container host, see the [Container Host Deployment Quick Start](./container_setup.md).

The following items will be required for each exercise.

**Windows Server Containers:**

- A Windows Container Host running Windows Server 2016 (Full or Core), either on-prem or in Azure.

**Hyper-V Containers:**

- A Windows Container host enabled with Nested Virtualization.
- The Windows Serve 2016 Media.

> Microsoft Azure does not support Hyper-V container. To complete the Hyper-V exercises, you need an on-prem container host.

## Windows Server Container

Windows Server Containers provide an isolated, portable, and resource controlled operating environment for running applications and hosting processes. Windows Server Containers provide isolation between the container and host, and between containers running on the host, through process and namespace isolation.

### Create Container <!--1-->

Before creating a container, list the container images installed on the container host. To see all container images with Docker, use the `docker images` command.

```powershell
docker images

#output

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
windowsservercore   latest              6801d964fda5        2 weeks ago         0 B
windowsservercore   10.0.10586.0        6801d964fda5        2 weeks ago         0 B
nanoserver          10.0.10586.0        8572198a60f1        2 weeks ago         0 B
nanoserver          latest              8572198a60f1        2 weeks ago         0 B
```

For this example, create a container using the Windows Server Core image as the container base. This is done with the `docker run command`. For more information on `docker run`, see the [Docker Run reference on docker.com]( https://docs.docker.com/engine/reference/run/).

This example creates a container named `iisbase` and starts an interactive session with the container. 

```powershell
docker run --name iisbase -it windowsservercore cmd
```

When the container has been created, you will be working in a shell session from within the container. 


### Create IIS Image <!--1-->

IIS will be installed in the container, and then an image created from the container. 

To install IIS, run the following.

```powershell
powershell.exe Install-WindowsFeature web-server
```

When completed, exit the interactive shell session.

```powershell
exit
```

Finally, the container will be committed to a new container image using `docker commit`. This example creates a new container image with the name ` windowsservercoreiis`.

```powershell
docker commit iisbase windowsservercoreiis

#output

87e0ec900efcaf5cbe70b947b7c3d56aeeced4ae12227952f5ca1f545d147f2f
```

The new IIS images can be viewed using the `docker images` command.

```powershell
docker images

#output

REPOSITORY             TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
windowsservercoreiis   latest              87e0ec900efc        About a minute ago   176.3 MB
windowsservercore      10.0.10586.1000     83b613fea6fc        13 days ago          0 B
windowsservercore      latest              83b613fea6fc        13 days ago          0 B
nanoserver             10.0.10586.1000     646d6317b02f        13 days ago          0 B
```

### Create IIS Container <!--1-->

You now have a container image that contains IIS, and can be used to deploy IIS ready operating environments. 

To create a container from the new image, use the `docker run` command, this time specifying the name of the IIS image. Notice that this sample has specified a parameter `-p 80:80`. Because the container is connected to a virtual switch that is supplying IP addresses .via network address translation, a port needs to be mapped from the container host, to a port on the containers NAT IP address. For more information on the `-p` see the [Docker Run reference on docker.com]( https://docs.docker.com/engine/reference/run/)

```powershell
docker run --name iisdemo -it -p 80:80 windowsservercoreiis cmd
```

When the container has been created, open a browser, and browse to the IP address of the container host. Because port 80 of the host has been mapped to port 80 if the container, the IIS splash screen should be displayed.

![](media/iis1.png)

### Create Application <!--1-->

Run the following script to replace the default IIS site with a new static site.

```powershell
del C:\inetpub\wwwroot\iisstart.htm
echo "Hello World From a Windows Server Container" > C:\inetpub\wwwroot\index.html
```

Browse again to the IP Address of the container host, you should now see the ‘Hello World’ application. Note – you may need to close any existing browser connections, or clear browser cache to see the updated application.

![](media/HWWINServer.png)

Exit the interactive session with the container.

```powershell
exit
```

Remove the container

```powershell
docker rm iisdemo
```
Remove the IIS image.

```powershell
docker rmi windowsservercoreiis
```

## Dockerfile

Through the last exercise, a container was manually created, modified, and then captured into a new container image. Docker includes a method for automating this process, using what is called a dockerfile. This exercise will have identical results as the last, however this time the process will be completley automated.

### Create IIS Image

On the container host, create a directory `c:\build’, and in this directory create a file named `dockerfile`.

```powershell
powershell new-item c:\build\dockerfile -Force
```

Copy the following text into the dockerfile. These commands will instruct Docker to create a new image, using `windosservercore` as the base, and include the modifications specified with `RUN`. For more information on Dockerfiles, see the [Dockerfile reference at docker.com](http://docs.docker.com/engine/reference/builder/).

```powershell
FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
```

This command will start the automate image build process. The `-t` parameter instructs the process to name the new image `iis`.

```powershell
docker build -t iis c:\Build
```

When completed, you can verify that the image has been created using the `docker images` command.

```powershell
docker images

#output

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
iis                 latest              afc01d0f59d9        11 minutes ago      175.1 MB
windowsservercore   10.0.10586.0        6801d964fda5        2 weeks ago         0 B
windowsservercore   latest              6801d964fda5        2 weeks ago         0 B
nanoserver          10.0.10586.0        8572198a60f1        2 weeks ago         0 B
nanoserver          lates0t             8572198a60f1        2 weeks ago         0 B
```

### Deploy IIS Container

Now, just like in the last exercise, deploy the container, mapping port 80 of the host to port 80 of the container.

```powershell
docker run --name iisdemo -it -p 80:80 iis cmd
```

Once the container has been created, browse to the IP address of the container host. You should see the hello world application.

![](media/dockerfile2.png)

Exit the interactive session with the container.

```powershell
exit
```

Remove the container

```powershell
docker rm iisdemo
```
Remove the IIS image.

```powershell
docker rmi iis
```

## Hyper-V Container

Hyper-V Containers provide an additional layer of isolation over Windows Server Containers. Each Hyper-V Container is created within a highly optimized virtual machine. Where a Windows Server Container shares a kernel with the Container host, and all other Windows Server Containers running on that host, a Hyper-V container is completely isolated from other containers. Hyper-V Containers are created and managed identically to Windows Server Containers. For more information about Hyper-V Containers see [Managing Hyper-V Containers](../management/hyperv_container.md).

> Microsoft Azure does not support Hyper-V container. To complete the Hyper-V exercises, you need an on-prem container host.

### Create Container <!--2-->

Because the container will be running a Nano Server OS Image, the Nano Server IIS packages will be needed to install IIS. These can be found on the Windows Sever 2016 TP4 Installation media, under the `NanoServer\Packages` directory.

In this example a directory from the container host will be made available to the running container using the `-v` parameter of `docekr run`. Before doing so, the source directory will need to be configured. 

Create a directory on the container host that will be shared with the container.

```powershell
powershell New-Item -Type Directory c:\share\en-us
```

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

To create a Hyper-V container using docker, specify the `--isolation=hyperv` parameter. This example mounts the `c:\share` directory from the host, to the `c:\iisinstall` directory of the container, and then creates an interactive shell session with the container.

```powershell
docker run --name iisnanobase -it -v c:\share:c:\iisinstall --isolation=hyperv nanoserver cmd
```

### Create IIS Image <!--2-->

From within the container shell session, IIS can be installed using `dism`.

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

### Create IIS Container <!--2-->

The modified Nano Server container can now be committed to a new container image. To do so, use the `docker commit` command.

```powershell
docker commit iisnanobase nanoserveriis

#output

aabc90a4002feb715256623a0fdabb83eba62b1fb58e5fed6b5ee9fff051d34f
```

The results can be seen when returning a list of container images.

```poweershell
docker images

#output

REPOSITORY          TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
nanoserveriis       latest              aabc90a4002f        About a minute ago   68.72 MB
windowsservercore   10.0.10586.0        6801d964fda5        2 weeks ago          0 B
windowsservercore   latest              6801d964fda5        2 weeks ago          0 B
nanoserver          10.0.10586.0        8572198a60f1        2 weeks ago          0 B
nanoserver          latest              8572198a60f1        2 weeks ago          0 B

```

### Create Application <!--2-->

The Nano Server IIS image can now be deployed to a new container.

```powershell
docker run -it -p 80:80 --isolation=hyperv nanoserveriis cmd
```

Run the following script to replace the default IIS site with a new static site.

```powershell
del C:\inetpub\wwwroot\iisstart.htm
echo "Hello World From a Hyper-V Container" > C:\inetpub\wwwroot\index.html
```

Browse to the IP Address of the container host, you should now see the ‘Hello World’ application. Note – you may need to close any existing browser connections, or clear browser cache to see the updated application.

![](media/HWWINServer.png)

Exit the interactive session with the container.

```powershell
exit
```


