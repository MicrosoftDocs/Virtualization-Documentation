ms.ContentId: 347fa279-d588-4094-90ec-8c2fc241f5b6
title: Manage Windows Containers with Docker

##Manage Windows Containers with Docker

Windows Server Containers can be managed with native Docker commands. While Windows Server Containers are comparable to their Linux counterparts and the management experience with Docker is almost identical, not all Docker commands will be used with Windows Server Containers.

####Working with Docker Commands:

The following exercise will walk though some basic Windows Server Container management actions using Docker commands. The goal here is to become comfortable creating, managing and removing both Windows Server Container Images and Windows Server Containers.

####Creating a Container

To see a list of images available on the Windows Container host enter `docker Images` 
```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
windowsservercore   latest              9eca9231f4d4        30 hours ago        9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        30 hours ago        9.613 GB

```

To create a new container and open an interactive session from within the new container run the `docker run –it <image name or ID> cmd`:
```
docker run -it windowsservercore cmd
```
Once this command completes you are now working in an interactive shell session from within the container.

![](media/docker4.png)

Now that you are working from inside of the container make a simple modification to the container. For example the following command will create a file that contains the output of ipconfig.
```
Ipconfig > c:\ipconfig.txt
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

Now exit the container by typing `Exit`. This will stop the interactive session, stop the container and place you back in the command session of the host.
```
Exit
```

Back in the host session notice that if you look for the ipconfig.txt file it is not present. This file was created in the container and will not exist on the host.
```
C:\Windows\system32>type c:\ipconfig.txt
The system cannot find the file specified.
```

####Create a Container Image

Now that a container has been created and modified, an image can be made from this container that will include all changes made to the container. This image will behave like a snapshot of the container and can be re-deployed many times, each time creating a new container. To create an image from the container you will need the container ID. To see a list of containers that have been created on the host run `docker ps –a`. This will return all running and stopped containers. Take note of the Container ID for the container just created.
```
docker ps –a

CONTAINER ID        IMAGE               COMMAND      CREATED             STATUS                      NAMES
9fb031beb602        windowsservercore   "cmd"        9 minutes ago       Exited (0) 30 seconds ago   kickass_engelbart
```

To create a new container image from a specific container run the following - `Docker commit <container id> newcontainerimage`. This will create a new container image on the container host.
```
docker commit 9fb031beb602 newcontainerimage
4f8ebcf0a334601e75070a92294d993b0f182abb6f4c88740c75b05093e6acff	
```

To see all images on the host type `docker images`. Notice the new image and take note of the name or ID of this image.
```
Docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
newcontainerimage   latest              4f8ebcf0a334        2 minutes ago       9.613 GB
windowsservercore   latest              9eca9231f4d4        30 hours ago        9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        30 hours ago        9.613 GB
```

####Create New Container From Image

Now that we have a custom container image, deploy a new container from this image and open an interactive session in the container. This can be done by running `docker run –it <new container name or id> cmd`.
```
Docker run –it newcontainerimage cmd
```

Take a look at the c:\ drive of this new container and notice that the ipconfig.txt file is present.

![](media/docker3.png)

Exit the newly created container by running `exit`, Once completed you will be back in the host session.
```
Exit
```

This exercise has shown that an image taken from a modified container will include all modifications. While the example here was a simple file modification, the same would apply if we were to install software into the container such as a web server. Using these methods custom images can be created that will deploy application ready containers.

####Removing Containers and Container Images

To wrap up this introduction to managing Windows Server Containers with Docker you will see how to remove Windows Containers and Windows Container Images.

To remove containers after they are no longer needed run `docker rm <container name or ID>`:
```
docker rm 69cebe720e38
69cebe720e38
```
To remove container images when they are no longer needed run `docker rmi <image name or ID>`. Note, an image cannot be removed if it is referenced but a container.
```
docker rmi newcontainerimage

Untagged: newcontainerimage:latest
Deleted: 4f8ebcf0a334601e75070a92294d993b0f182abb6f4c88740c75b05093e6acff
```

##Prepare an NGinx Container Image

This example will demonstrate a more practical application for Windows Server Containers. First a dockerfile will be used to automation the creation of a new container image. Dockerfiles contain instruction that the Docker engine will use to build a container, make modification to the container and then commit to a container image.

####Download and Extract the NGinx Software

On the container host create folders in the following structure:
```
c:\build\nginx\source
```

Download and extract the NGinx software to <b>c:\build\nginx\source</b>. The software can be downloaded from the following site – [NGinx for Windows](http://nginx.org/en/download.html). Alternatively use the following commands on the container host to download and extract the NGinx software to <b>c:\build\nginx\source</b>.
```
PowerShell.exe Invoke-WebRequest 'http://nginx.org/download/nginx-1.9.3.zip' -OutFile "c:\nginx-1.9.3.zip"
PowerShell.exe Expand-Archive -Path C:\nginx-1.9.3.zip -DestinationPath c:\build\nginx\source -Force
```
####Prepare the dockerfile
Create a file named dockerfile and open it with your favirote text editor. It is important that this file have no file extension.

For more information on dockerfile see the documentation on the Docker site -  [Dockerfile reference](https://docs.docker.com/reference/builder/).

Enter the following text into the dockerfile, save the file and copy it to <b>c:\build\nginx</b> on the container host.
```
FROM windowsservercore
LABEL Description="NGINX For Windows" Vendor="NGINX" Version="1.9.3"
ADD source /nginx
```

At this point the dockerfile will be in <b>c:\build\nginx</b> and the NGinx software extracted to <b>c:\build\nginx\source</b>. You are now ready to build an images based on the instructions in the dockerfile. To do so run the following command on the container host:
```
Docker build c:\build\nginx
```

The output will look similar to this:

![](media/docker1.png)

Once completed take a look at all images on the host using the `docker images` command, you should notice a new one. Take note of the image ID for the new image, this will be used to deploy a container referencing the new image.
```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             VIRTUAL SIZE
<none>              <none>              012e178ea519        44 seconds ago      9.613 GB
windowsservercore   10.0.10254.0        9eca9231f4d4        34 hours ago        9.613 GB
windowsservercore   latest              9eca9231f4d4        34 hours ago        9.613 GB
```

##Deploying an NGinx Webserver in a Windows Server Contianer

 
##Navigation:
[Back to Container Home](../containers_welcome.md)



