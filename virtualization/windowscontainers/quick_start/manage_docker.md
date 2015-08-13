ms.ContentId: 347fa279-d588-4094-90ec-8c2fc241f5b6
title: Manage Windows Server Containers with Docker

#Quick Start: Windows Server Containers and Docker

This article will walk through the fundamentals of managing windows Server Container with Docker. Items covered will include creating Windows Server Containers and Windows Server Container Images, removing Windows Server Container and Container Images and finally deploying an application into a Windows Server Container. The lessons learned in this walkthrough should enable you to begin exploring deployment and management of Windows Server Containers using Docker.

Have questions? Ask them on the [Windows Containers forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers).

> Note: Windows Containers created with PowerShell can not be managed with Docker right now and visa versa. To create containers with PowerShell, see  [Quick Start: Windows Server Containers and PowerShell](./manage_powershell.md).

As you start this guide, you should be looking at a screen that looks like this:
![](./media/ContainerHost_ready.png)
If you don't have this set up, see the [Container setup in a local VM](./container_setup.md) or [container setup in Azure](./azure_setup.md) articles.

The window in the forground (highlighted in red) is a cmd prompt from which you will start working with containers.

##Basic Container Management with Docker

This first example will walk through the basics of creating and removing Windows Server Containers with Docker.

##Step 1 - Create a New Container

Before creating a Windows Server Container with Docker you will need the name or ID of an exsisitng Windows Server Container image. To see all images loaded on the container host use the `docker images` command.

```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
windowsservercore   latest              9eca9231f4d4        30 hours ago        9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        30 hours ago        9.613 GB
```

To create a new Windows Server Container run the following command. This command instructs the Docker to create a new container named ‘dockerdemo’ from the image ‘windowsservercore’ and open an interactive (-it) console session (cmd) with the container.

```powershell
docker run -it --name dockerdemo windowsservercore cmd
```
When the command completes you will be working in a console session on the container.

Working in a container is almost identical to working with Windows installed on a virtual or physical machine. You can run commands such as `ipconfig` to return the IP address of the container, `mkdir` to create a new directory, or `powershell` to start a PowerShell session. Go ahead and make a change to the container such as creating a file or folder. For example, the following command will create a file which contains network configuration data about the container.

```
ipconfig > c:\ipconfig.txt
```

You can read the contents of the file to ensure the command completed successfully. Notice that the IP address contained in the text file matches that of the container.

```
Type c:\ipconfig.txt

Ethernet adapter vEthernet (Virtual Switch-b34f32fcdc63b8632eaeb114c6eb901f8982bc91f38a8b64e6da0de40ec47a07-0):

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::85b:7834:454c:375b%20
   IPv4 Address. . . . . . . . . . . : 192.168.1.55
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . :
```

Now that the container has been modified, run the following to stop the console session placing you back in the console session of the container host.

```
exit
```

Finally to see a list of containers on the container host use the `docker ps –a` command. Notice in the output a container named 'dockerdemo' has been created.

```
docker ps -a

CONTAINER ID        IMAGE               COMMAND        CREATED             STATUS                     PORTS     NAMES
4f496dbb8048        windowsservercore   "cmd"          2 minutes ago       Exited (0) 2 minutes ago             dockerdemo
``` 

##Step 2 - Create a New Container Image

An image can now be made from this container. This image will behave like a snapshot of the container and can be re-deployed many times.

To create a new image run the following. This command instructs the Docker engine to create a new image named 'newcontainerimage' that will include all changes made to the 'deckerdemo' container.

```
docker commit dockerdemo newcontainerimage
```

To see all images on the host, run `docker images`. Notice that a new image has been created with the name 'newcontainerimage'.

```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
newcontainerimage   latest              4f8ebcf0a334        2 minutes ago       9.613 GB
windowsservercore   latest              9eca9231f4d4        30 hours ago        9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        30 hours ago        9.613 GB
```

##Step 3 - Create New Container From Image

Now that you have a custom container image, deploy a new container named 'newcontainer' from 'newcontainerimage' and open an interactive shell session with the container.

```powershell
docker run –it --name newcontainer newcontainerimage cmd
```

Take a look at the c:\ drive of this new container and notice that the ipconfig.txt file is present.

![](media/docker3.png)

Exit the newly created container to return to the container hosts console session.

```
exit
```

This exercise has shown that an image taken from a modified container will include all modifications. While the example here was a simple file modification, the same would apply if you were to install software into the container such as a web server. Using these methods, custom images can be created that will deploy application ready containers.

##Step 4 - Remove Containers and Images

To remove a container after it is no longer needed use the `docker rm` command. The following command will remove the container name 'newcontainer'.

```
docker rm newcontainer
```
To remove container images when they are no longer needed use the `docker rmi` command. You cannot remove an image if it is referenced by an existing container.

The following command removes the container image named 'newcontainerimage'.
```
docker rmi newcontainerimage

Untagged: newcontainerimage:latest
Deleted: 4f8ebcf0a334601e75070a92294d993b0f182abb6f4c88740c75b05093e6acff
```

##Host a Web Server in a Container

This next example will demonstrate a more practical use case for Windows Server Containers. The steps included in this exercise will guide you through creating a web server container image that can be used for deploying web applications hosted inside of a Windows Server Container.

##Step 1 - Download Web Server Software

Before creating a container image the web server software will need to be downloaded and staged on the container host. We will be using the nginx for Windows software for this example. 

Run the following command on the container host to create the directory structure that will be used for this example.

```
mkdir c:\build\nginx\source
```

Run this command on the container host to download the nginx software to 'c:\nginx-1.9.3.zip'.

```powershell
powerShell.exe Invoke-WebRequest 'http://nginx.org/download/nginx-1.9.3.zip' -OutFile "c:\nginx-1.9.3.zip"
```
 
Finally the following command will extract the nginx software to 'c:\build\nginx\source'. 
```    
PowerShell.exe Expand-Archive -Path C:\nginx-1.9.3.zip -DestinationPath c:\build\nginx\source -Force
```

##Step 2 - Create Web Server Image
In the previous example, you manually created, updated and captured a container image. This example will demonstrate an automated method for creating container images using a Dockerfile. Dockerfiles contain instructions that the Docker engine uses to build and modify a container, and then commit the container to a container image. For more information on dockerfiles, see [Dockerfile reference](https://docs.docker.com/reference/builder/).

To create the Dockerfile run the following command.

```
type NUL > c:\build\nginx\dockerfile
```

You will now open the Dockerfile with notepad and place the container build instructions into the file. To open up notepad run the following.

```
notepad.exe c:\build\nginx\dockerfile
```

Copy and paste the following text into notepad, save the file and close notepad.

```
FROM windowsservercore
LABEL Description="nginx For Windows" Vendor="nginx" Version="1.9.3"
ADD source /nginx
```
At this point the dockerfile will be in 'c:\build\nginx' and the nginx software extracted to 'c:\build\nginx\source'. You are now ready to build the web server container image based on the instructions in the dockerfile. To do this, run the following command on the container host.

```
docker build -t nginx_windows c:\build\nginx
```
This command instructs the docker engine to use the dockerfile located at `c:\build\nginx` to create an image named 'nginx_windows'.

The output will look similar to this:

![](media/docker1.png)

When completed, take a look at the images on the host using the `docker images` command. You should see a new image named 'nginx_windows'.
```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE

nginx_windows       latest              d792268338d0        5 seconds ago       9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        35 hours ago        9.613 GB
windowsservercore   latest              9eca9231f4d4        35 hours ago        9.613 GB
```

##Step 3 - Deploy Web Server Ready Container

To deploy a Windows Server Container based off of the 'nginx_windows' container run the following command. This will create a new container named 'nginxcontainer' and start an console session on the container.

```powershell
docker run -it --name nginxcontainer nginx_windows cmd
```
Once working inside the container, the nginx web server can be started and web content staged. To start the nginx web server, change to the nginx installation directory.

```
cd c:\nginx\nginx-1.9.3
```

Start the nginx web server.
```
start nginx
```

When the nginx software is running, get the IP address of the container using `ipconfig`. On a different machine, open up a web browser and browse to `http//ipaddress`. If everything has been correctly configured, you will see the nginx welcome page.

![](media/nginx.png)

At this point, feel free to update the website. Copy in your own sample website, or run the following command to replace the nginx welcome page with a ‘Hello World’ web page.

```powershell
powershell Invoke-WebRequest 'https://raw.githubusercontent.com/neilpeterson/index/master/index.html' -OutFile "C:\nginx\nginx-1.9.3\html\index.html"
```
After the website has been updated, navigate back to `http://ipaddress`.

![](media/hello.png)

[Back to Container Home](../containers_welcome.md)  
