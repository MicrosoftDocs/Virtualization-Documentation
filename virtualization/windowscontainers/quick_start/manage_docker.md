ms.ContentId: 347fa279-d588-4094-90ec-8c2fc241f5b6
title: Manage Windows Server Containers with Docker

#Manage Windows Server Containers with Docker

Windows Server Containers can be managed with native Docker commands. While Windows Server Containers are comparable to their Linux counterparts and the management experience with Docker is almost identical, not all Docker commands can be used with Windows Server Containers. This walkthrough will demonstrate basic use of Docker command with Windows Server Containers, basic image and container management and finally a simple yet practical use for Windows Server Containers. The lessons learned from this walkthrough should enable you to begin exploring deployment and management of Windows Server Containers using the Docker toolset.

> Please Note – Windows Server Container created with PowerShell need to be managed with PowerShell. To checkout the PowerShell quick start documentation, see  [Managing Windows Server Container with PowerShell](./manage_powershell.md).

##Basic Container Management with Docker

This first example will walk through basic container management functionality using Docker such as creating and removing containers and container images.

##Step 1 - Create a Container

Before creating a Windows Server Container with Docker you will need the name or id of a container image. To see all images loaded on the container host run the following:

```
docker images
```

The output will look similar to:

```
REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
windowsservercore   latest              9eca9231f4d4        30 hours ago        9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        30 hours ago        9.613 GB
```

To create a new container and open a console session into the container run:

```
docker run -it --name dockerdemo windowsservercore cmd
```

![](media/docker4.png)

Working in the container is almost identical to working with Windows installed on a virtual or physical machine. You can run commands such as `ipconfig` to return the IP address of the container, `mkdir` to create a new directory, or `powershell` to start a PowerShell session.

Make a simple change to the container. For example, the following command creates a file that contains the output of ipconfig.

```
ipconfig | c:\ipconfig.txt
```

Run the following to verify that the file was successfully created:

```
Type c:\ipconfig.txt
```
The output will look similar to the following:

```
Ethernet adapter vEthernet (Virtual Switch-b34f32fcdc63b8632eaeb114c6eb901f8982bc91f38a8b64e6da0de40ec47a07-0):

   Connection-specific DNS Suffix  . :
   Link-local IPv6 Address . . . . . : fe80::85b:7834:454c:375b%20
   IPv4 Address. . . . . . . . . . . : 192.168.1.55
   Subnet Mask . . . . . . . . . . . : 255.255.255.0
   Default Gateway . . . . . . . . . :
```

Run the following to stop the console session and place you back in the command session of the container host.

```
exit
```

##Step 2 - Create a Container Image

Now that a container has been created and modified, an image can be made from this container. This image will behave like a snapshot of the container and can be re-deployed many times. To see a list of containers that have been created on the host run the following.

```
docker ps –a
```

The output will look similar to this:

```
CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     PORTS     NAMES
4f496dbb8048        windowsservercore   "cmd"               2 minutes ago       Exited (0) 2 minutes ago             dockerdemo
```

To create a new image from a specific container use `docker commit`. Run the following command to create an image with the name ‘newcontainerimage’.

```
docker commit dockerdemo newcontainerimage
```

To see all images on the host, use `docker images`. Notice that a new image has been created with the name that was specified during the container commit.

```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
newcontainerimage   latest              4f8ebcf0a334        2 minutes ago       9.613 GB
windowsservercore   latest              9eca9231f4d4        30 hours ago        9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        30 hours ago        9.613 GB
```

##Step 3 - Create Container From Image

Now that you have a custom container image, deploy a new container from this image and open an interactive session into the container.

```
docker run –it newcontainerimage cmd
```

Take a look at the c:\ drive of this new container and notice that the ipconfig.txt file is present.

![](media/docker3.png)

Exit the newly created container by running exit. When completed, you will be back in the host session.

```
exit
```

This exercise has shown that an image taken from a modified container will include all modifications. While the example here was a simple file modification, the same would apply if you were to install software into the container such as a web server. Using these methods, custom images can be created that will deploy application ready containers.

##Step 4 - Remove Containers and Images

To remove a container after it is no longer needed you will need the name or id of the container which can be found with the docker ps –a command.

```
docker ps -a

CONTAINER ID        IMAGE               COMMAND             CREATED             STATUS                     NAMES
9e613d3ebf9e        windowsservercore   "cmd"               5 minutes ago       Exited (0) 5 minutes ago   elegant_engelbart
```
Run docker rm container name or id to remove the container.

```
docker rm elegant_engelbart
```
To remove container images when they are no longer needed run docker rmi imagenameorid. You can't remove an image if it is referenced by an existing container.
```
docker rmi newcontainerimage

Untagged: newcontainerimage:latest
Deleted: 4f8ebcf0a334601e75070a92294d993b0f182abb6f4c88740c75b05093e6acff
```

##Host a Web Server in a Container

This next example will walk through a more practical use case for a Windows Server Container. The steps included in this exercise will complete the following:  
- Create a container from the Windows Server Core base image.  
- Deploy web server software into the container.  
- Create an new image from the modified container.  
- Deploy a web server ready container and host a simple website in the container.

##Step 1 - Prepare Web Server Software

Before creating a container image, a few items need be staged on the container host. On the container host, create folders in the following structure:

```
mkdir c:\build\nginx\source
```

Download and extract the nginx software to c:\build\nginx\source on the container host. The software can be downloaded from [nginx for Windows](http://nginx.org/en/download.html). Or use the following commands on the container host to download and extract the nginx software to c:\build\nginx\source.

```powershell
powerShell.exe Invoke-WebRequest 'http://nginx.org/download/nginx-1.9.3.zip' -OutFile "c:\nginx-1.9.3.zip"
PowerShell.exe Expand-Archive -Path C:\nginx-1.9.3.zip -DestinationPath c:\build\nginx\source -Force
```
##Step 2 - Create Web Server Image
In the previous example, you created, updated and captured a container. This example demonstrates an automated method to create images using a Dockerfile. Dockerfiles contain instructions that the Docker engine uses to build and make changes to the container, and then commits to a container image. For more information on dockerfiles, see [Dockerfile reference](https://docs.docker.com/reference/builder/).

Create a file named dockerfile and open it with your favorite text editor. It is important that this file have no file extension.

Enter the following text into the dockerfile and save the file to c:\build\nginx on the container host.
```
FROM windowsservercore
LABEL Description="nginx For Windows" Vendor="nginx" Version="1.9.3"
ADD source /nginx
```


At this point the dockerfile will be in c:\build\nginx and the nginx software extracted to c:\build\nginx\source. You are now ready to build the web server image based on the instructions in the dockerfile. To do this, run the following command on the container host.

```
docker build -t nginx_windows c:\build\nginx
```

The output will look similar to this:

![](media/docker1.png)

When completed, take a look at all images on the host using the docker images command. You should notice a new image. Take note of the name or ID for the new image so you can to deploy a container from this image.
```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE

nginx_windows       latest              d792268338d0        5 seconds ago       9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        35 hours ago        9.613 GB
windowsservercore   latest              9eca9231f4d4        35 hours ago        9.613 GB
```

##Step 3 - Deploy Web Server Container

With a web server image created, you can now deploy multiple containers based off of this image. To deploy a Windows Server Container based off of the nginx_windows image use the Docker Run command as seen below. When the command completes you will be in an interactive session on the container.
```
docker run -it nginx_windows cmd
```

From inside the container the nginx web server can be started and web content staged for consumption. To start the nginx web server move to the installation folder and run start nginx:
```
cd c:\nginx\nginx-1.9.2
start nginx
```

When the nginx software is running, get the IP address of the container using ipconfig and on a different machine open up a web browser and browse to http://ipaddress. If everything has been correctly configured you will see the nginx welcome page.

![](media/nginx.png)

At this point feel free to update the website, copy in your own sample website or run the following command to replace the nginx welcome page with a ‘Hello World’ web page.

```powershell
powershell Invoke-WebRequest 'https://raw.githubusercontent.com/neilpeterson/index/master/index.html' -OutFile "C:\nginx\nginx-1.9.3\html\index.html"
```
After the website has been updated navigate back to http://ipaddress

![](media/hello.png)

####Navigation
[Back to Container Home](../containers_welcome.md)
[Managing Windows Containers with PowerShell](./manage_powershell.md)