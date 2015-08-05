ms.ContentId: 347fa279-d588-4094-90ec-8c2fc241f5b6
title: Manage Windows Server Containers with Docker

#Manage Windows Server Containers with Docker

Windows Server Containers can be managed with native Docker commands. While Windows Server Containers are comparable to their Linux counterparts and the management experience with Docker is almost identical, not all Docker commands can be used with Windows Server Containers.

##Working with Docker Commands
!--Too vague as a header. How about "Use Docker commands to create Windows Containers" --!
The following exercise walks though some basic Windows Server Container management actions using Docker commands. The goal here is for you to become comfortable creating, managing and removing Windows Server Container Images and Windows Server Containers with Docker.

> Note – Windows Server Container created with PowerShell need to be managed with PowerShell. To checkout the PowerShell quick start documentation, see  [Managing Windows Server Container with PowerShell](./manage_powershell.md).

##Step 1 - Create a Container

To see a list of images available on the Windows Server Container host enter `docker Images`: 
```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
windowsservercore   latest              9eca9231f4d4        30 hours ago        9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        30 hours ago        9.613 GB

```
!-- Again I find this weird that this is the first step. Where did these images come from? Is there a "before you begin, you need to create or download x."?
To create a new container and open an interactive session into this new container run `docker run –it <image name or ID> cmd`: !--"Interactive" DELETE. Not adding any value or meaning to what you're saying. Computers are interactive. --!
```
docker run -it windowsservercore cmd
```
When this command completes, you will be working in an interactive session from within the container. Notice that working inside the container is almost identical to working in Windows installed on a virtual or physical machine. You can run commands such as `Ipconfig` to return the IP address of the container, `mkdir` to create a new directory, or `Powershell` to start a PowerShell session.
!--Least favorite word "interactive". Run find and delete.--!
![](media/docker4.png)

Next, make some simple changes to the container. For example, the following command creates a file that contains the output of ipconfig.
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

Exit the container by typing `Exit`. This will stop the interactive session, stop the container, and place you back in the command session of the host.
```
Exit
```

Notice that on the container host the ipconfig.txt file it is not present. This file was created in the container and will not exist on the host.
```
C:\Windows\system32>type c:\ipconfig.txt

The system cannot find the file specified.
```

##Step 2 - Create a Container Image

Now make an image from the container you created that includes all the changes you made to the container. This image will behave like a snapshot of the container and can be re-deployed many times.  Each time you deploy the image, you create a new container. To create an image from the container, you need the container ID. To see a list of containers that have been created on the host, run `docker ps –a`. This will return all running and stopped containers. Take note of the Container ID for the container you just created.
```
docker ps –a

CONTAINER ID        IMAGE               COMMAND      CREATED             STATUS                      NAMES
9fb031beb602        windowsservercore   "cmd"        9 minutes ago       Exited (0) 30 seconds ago   kickass_engelbart
```
!--Ass? I think that would fail policycheck...Edit "ass" out--!
To create a new image from a specific container use `Docker commit <container id> newcontainerimage`. This will create a new container image on the container host.
!--Generally I'd wouldn't use "run the following" unless is a script section that follows. It's odd to have it in the same sentence as the command...to me anyway.--!
```
docker commit 9fb031beb602 newcontainerimage
4f8ebcf0a334601e75070a92294d993b0f182abb6f4c88740c75b05093e6acff	
```

To see all images on the host, type `docker images`. Notice that a new image is created with the name that was specified during the container commit.
!--Who specified? "...with the name you used in the step above." Or "..with the name you used when you ran the docker commit command."--!
```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
newcontainerimage   latest              4f8ebcf0a334        2 minutes ago       9.613 GB
windowsservercore   latest              9eca9231f4d4        30 hours ago        9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        30 hours ago        9.613 GB
```

##Step 3 - Create Container From Image

Now that you have a custom container image, deploy a new container from this image and open an interactive session into the container. This do this, run `docker run –it <new container image name or id> cmd`.
```
docker run –it newcontainerimage cmd
```

Take a look at the c:\ drive of this new container and notice that the ipconfig.txt file is present.

![](media/docker3.png)

Exit the newly created container by running `exit`. When completed, you will be back in the host session.
```
exit
```

This exercise has shown that an image taken from a modified container will include all modifications. While the example here was a simple file modification, the same would apply if you were to install software into the container such as a web server. Using these methods, custom images can be created that will deploy application ready containers.

##Step 4 - Remove Containers and Images

To wrap up this introduction to managing Windows Server Containers with Docker you will see how to remove Windows Server Containers and Windows Server Container Images using Docker commands.

To remove containers after they are no longer needed,  run `docker rm <container name or ID>`:
!--You might look at how other teams write these up. For example, I was trained to write "...run the following command where container name is x." Or you say "the following example removes a docker container with the name x." X is the name you used in your example. Anyway, this is fine for now. In the future, would be good to format similar to other teams for consistency and clarity. --!
```
docker rm 69cebe720e38
69cebe720e38
```
To remove container images when they are no longer needed run `docker rmi <image name or ID>`. You can't remove an image if it is referenced by an existing container.
```
docker rmi newcontainerimage

Untagged: newcontainerimage:latest
Deleted: 4f8ebcf0a334601e75070a92294d993b0f182abb6f4c88740c75b05093e6acff
```

##Host a Web Server in a Container
!--Might change section header to "Host a Web Server in a Container using Docker commands"? What's different about this one from the PowerShell article? You should have headers on both that are distinctive.--!
This next example will walk through a more practical use case for a Windows Server Container. The steps included in this exercise will complete the following:  
- Create a container from the Windows Server Core base image.  
- Deploy web server software into the container.  
- Create an new image from the modified container.  
- Deploy a web server ready container and host a simple website in the container.
!--Again fix the headers below so they match above. I like the more descriptive wording you have above.--!
##Step 1 - Prepare Web Server Software

Before creating a container image, a few items need be staged on the container host. On the container host, create folders in the following structure:
```
c:\build\nginx\source
```

Download and extract the nginx software to c:\build\nginx\source on the container host. The software can be downloaded from [nginx for Windows](http://nginx.org/en/download.html). Or use the following commands on the container host to download and extract the nginx software to c:\build\nginx\source.
```powershell
powerShell.exe Invoke-WebRequest 'http://nginx.org/download/nginx-1.9.3.zip' -OutFile "c:\nginx-1.9.3.zip"
PowerShell.exe Expand-Archive -Path C:\nginx-1.9.3.zip -DestinationPath c:\build\nginx\source -Force
```
##Step 2 - Create Web Server Image
In the previous example, you created, updated and captured a container. This example demonstrates an automated method to create images using a Dockerfile. Dockerfiles contain instructions that the Docker engine uses to build and make changes to the container, and then commits to a container image. For more information on dockerfiles, see [Dockerfile reference](https://docs.docker.com/reference/builder/).

Create a file named dockerfile and open it with your favorite text editor. It is important that this file have no file extension.

Enter the following text into the dockerfile and save the file to <b>c:\build\nginx</b> on the container host.
```
FROM windowsservercore
LABEL Description="nginx For Windows" Vendor="nginx" Version="1.9.3"
ADD source /nginx
```

At this point the dockerfile will be in <b>c:\build\nginx</b> and the nginx software extracted to <b>c:\build\nginx\source</b>. You are now ready to build the web server image based on the instructions in the dockerfile. To do this, run the following command on the container host. 
```
docker build -t nginx_windows c:\build\nginx
```

The output will look similar to this:

![](media/docker1.png)

When completed, take a look at all images on the host using the `docker images` command. You should notice a new image. Take note of the name or ID for the new image so you can to deploy a container from this image.
```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE

nginx_windows       latest              d792268338d0        5 seconds ago       9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        35 hours ago        9.613 GB
windowsservercore   latest              9eca9231f4d4        35 hours ago        9.613 GB
```

##Step 3 - Deploy Web Server Container

With a web server image created, you can now deploy multiple containers based off of this image. To deploy a Windows Server Container based off of the nginx_windows image use the `Docker Run` command as seen below. When the command completes you will be in an interactive session on the container.
```
docker run -it nginx_windows cmd
```

From inside the container the nginx web server can be started and web content staged for consumption. To start the nginx web server move to the installation folder and run `start nginx`:
```
cd c:\nginx\nginx-1.9.2
start nginx
```

When the nginx software is running, get the IP address of the container using `ipconfig` and on a different machine open up a web browser and browse to `http//<ip address>`. If everything has been correctly configured you will see the nginx welcome page.

![](media/nginx.png)

At this point feel free to update the website, copy in your own sample website or run the following command to replace the nginx welcome page with a ‘Hello World’ web page.

```powershell
powershell Invoke-WebRequest 'https://raw.githubusercontent.com/neilpeterson/index/master/index.html' -OutFile "C:\nginx\nginx-1.9.3\html\index.html"
```
After the website has been updated navigate back to `http://<ipaddress>`.

![](media/hello.png)

####Wrap Up

This walkthrough has demonstrated basic use of Docker command with Windows Server Containers, basic image and container management and finally has demonstrated a simple yet practical use for Windows Server Containers. The lessons learned from this walkthrough should enable you to begin exploring deployment and management of Windows Server Containers using the Docker toolset.

 ####Navigation
[Back to Container Home](../containers_welcome.md)
