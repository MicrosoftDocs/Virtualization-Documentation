# Windows Containers Quick Start

Windows Containers can be used to rapidly deploy many isolated applications on a single computer system. This exercise will demonstrate Windows Container creation and management using Docker. When completed you should have a basic understanding of how Docker integrates with Windows Containers and will have gained hands on experience with the technology.

This walkthrough will detail both Windows Server containers and Hyper-V containers. Each type of container has its own basic requirements. Included with the Windows Container documentation is a procedure for quickly deploying a container host. This is the easiest way to quickly start with Windows Container. If you do not already have a container host see the [Container Host Deployment Quick Start]().

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

```powershell
PS C:\> docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
windowsservercore   latest              6801d964fda5        2 weeks ago         0 B
windowsservercore   10.0.10586.0        6801d964fda5        2 weeks ago         0 B
nanoserver          10.0.10586.0        8572198a60f1        2 weeks ago         0 B
nanoserver          latest              8572198a60f1        2 weeks ago         0 B
```

```powershell
C:\>docker run -it windowsservercore cmd
```

### Create IIS Image <!--1-->

```powershell
C:\>powershell.exe Install-WindowsFeature web-server
```

```powershell
c:\exit
```

```powershell
C:\>docker ps -a
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS               NAMES
48355e3cd8e8        windowsservercore   "cmd"               10 minutes ago      Exited (0) 3 minutes ago                       awesome_mirzakhani
```

```powershell
C:\>docker commit 48355e3cd8e8 windowsservercoreiis
87e0ec900efcaf5cbe70b947b7c3d56aeeced4ae12227952f5ca1f545d147f2f
```

### Create IIS Container <!--1-->

```powershell
C:\>docker images
REPOSITORY             TAG                 IMAGE ID            CREATED              VIRTUAL SIZE
windowsservercoreiis   latest              87e0ec900efc        About a minute ago   176.3 MB
windowsservercore      10.0.10586.1000     83b613fea6fc        13 days ago          0 B
windowsservercore      latest              83b613fea6fc        13 days ago          0 B
nanoserver             10.0.10586.1000     646d6317b02f        13 days ago          0 B
```

```powershell
docker run -p 80:80 windowsservercoreiis
```

### Create Application <!--1-->

Run the following script to replace the default IIS site with a new static site.

```powershell
C:\>del C:\inetpub\wwwroot\iisstart.htm
echo "Hello World From a Windows Server Container" > C:\inetpub\wwwroot\index.html
```

Browse again to the IP Address of the container host, you should now see the ‘Hello World’ application.

![](media/HWWINServer.png)

## Dockerfile

### Create IIS Image

```powershell
FROM windowsservercore
RUN dism /online /enable-feature /all /featurename:iis-webserver /NoRestart
RUN echo "Hello World - Dockerfile" > c:\inetpub\wwwroot\index.html
```

```powershell
docker build -t iis c:\Build
```

```powershell
C:\>docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
iis                 latest              afc01d0f59d9        11 minutes ago      175.1 MB
windowsservercore   10.0.10586.0        6801d964fda5        2 weeks ago         0 B
windowsservercore   latest              6801d964fda5        2 weeks ago         0 B
nanoserver          10.0.10586.0        8572198a60f1        2 weeks ago         0 B
nanoserver          lates0t             8572198a60f1        2 weeks ago         0 B
```

### Deploy IIS Container

```powershell
C:\>docker run -it -p 80:80 iis
```

## Hyper-V Container

Hyper-V Containers provide an additional layer of isolation over Windows Server Containers. Each Hyper-V Container is created within a highly optimized virtual machine. Where a Windows Server Container shares a kernel with the Container host, and all other Windows Server Containers running on that host, a Hyper-V container is completely isolated from other containers. Hyper-V Containers are created and managed identically to Windows Server Containers. For more information about Hyper-V Containers see [Managing Hyper-V Containers](../management/hyperv_container.md).

> Microsoft Azure does not support Hyper-V container. To complete the Hyper-V exercises, you need an on-prem container host.

### Create Container <!--2-->

### Create a Shared Folder

### Create IIS Image <!--2-->

### Create IIS Container <!--2-->

### Configure Networking <!--2-->

### Create Application <!--2-->





