ms.ContentId: 347fa279-d588-4094-90ec-8c2fc241f5b6
title: Manage Windows Containers with Docker

##Manage Windows Containers with Docker

Windows Server Containers can be managed with Docker commands. While Windows Server Containers are comparable to their Linux counterparts and the management experience with Docker is almost identical, not all Docker commands will be used with Windows Server Containers.
***
Windows Containers created with PowerShell need to be managed with PowerShell – Managing Windows Containers with PowerShell

Windows Containers are in an early preview, not all features are functional and some Docker commands have not yet been tested.
***

##Working with Docker Commands:

The following exercise will walk though some basic Windows Server Container management steps using Docker commands. The goal here is to become comfortable creating, managing and removing both Windows Server Container Images and Windows Server Containers.

To see a list of images available on the Windows Container host:
```
docker images
```
To create a new container and open an interactive session:
```
docker run –it <image Name or ID> cmd
```
Once this command completes you are now working in an interactive shell session from within the container.

Create a text file:
```
Ipconfig > c:\ipconfig.txt
```
Read the text file, it contains the up address of the container.
```
Type c:\ipconfig.txt
```
Exit the container, returning to the host session:
```
Exit
```
Back in the host session, notice that the ipconfig.txt files has not been created on the host.

See a list of containers on the host, take note of the container from the container just created.
```
docker ps –a
```
Create a new container image from the container just created.
```
Docker commit <container id> newcontainerimage
```
Take a look at all container images again, notice that there is a new image and note its name or id. 
```
Docker images
```
Create a new container from the new image and start an interactive command session:
```
Docker run –it <image name or id> cmd
```
Take a look at the c:\ drive of this new containers and notice that network folder and ipconfig.txt are in this container.

Exit the newly created containers:
```
Exit
```
To remove containers after they are no longer needed:
```
Docker rm <container name or id>
```
To remove container images when they are no longer needed:
```
docker rmi <image name or id>
```
An image cannot be removed if it is referenced but a container. 

These steps demonstrated the basics of creating container images, running and managing Windows Server Containers with Docker.

## Deploying an NGinx Webserver with a Windows Server Container and Docker

This example will demonstrate a more practical application for Windows Server Containers. First a dockerfile will be used to automation the creation of a new container image. Dockerfiles contain instruction that the Docker engine will use to build a container, make modification to the container and then commit to a container image. This image will then be used to deploy multiple containers each hosting a simple website.

##Download and Extract the NGinx Software

On the container host create folders in the following structure:
```
c:\build\nginx\source
```
Download and extract the NGinx software to c:\build\nginx\source. The software can be downloaded from the following site – [NGinx for Windows](http://nginx.org/en/download.html). Alternatively use the following commands on the container host to download and extract the NGinx software to c:\build\nginx\source.
```
PowerShell.exe Invoke-WebRequest 'http://nginx.org/download/nginx-1.9.3.zip' -OutFile "c:\nginx-1.9.3.zip"
PowerShell.exe Expand-Archive -Path C:\nginx-1.9.3.zip -DestinationPath c:\build\nginx\source -Force
```
##Prepare the dockerfile
Create a file named dockerfile and open it with your favirote text editor. It is important that this file have no file extension.

For more information on dockerfile see the documentation on the Docker site -  [Dockerfile reference](https://docs.docker.com/reference/builder/).

Enter the following text into the dockerfile, save the file and copy it to c:\build\nginx on the container host.
```
FROM windowsservercore
LABEL Description="NGINX For Windows" Vendor="NGINX" Version="1.9.3"
ADD source /nging
```
At this point the dockerfile will be in c:\build\nginx and the NGinx software extracted to c:\build\nginx\source. You are now ready to build an images based on the instructions in the dockerfile. To do so run the following command on the container host:
```
Docker build c:\build\nginx
```
The output will look similar to this:

![](media/docker1.png)

Once completed take a look at all images on the host, you should notice a new one. Take note of the image ID for the new image, this will be used to deploy a container referencing the new image.

##Deploying an NGinx Webserver in a Windows Server Contianer

 



