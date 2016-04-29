---
author: neilpeterson
---

# Windows Server Containers - Quick Start

**This is preliminary content and subject to change.** 

Windows Containers can be used to rapidly deploy many isolated applications on a single computer system. This exercise will demonstrate creating and managing Windows Server containers. When completed, you should have a basic understanding of how Docker integrates with Windows Server containers and will have gained hands on experience with the technology.

The following items will be required for this exercise.

- A Windows Container Host running Windows Server 2016 (Full or Core), either on-prem or in Azure.
- The Windows Server Core base OS image. For information on installing Base OS images see, [Install Base OS Images](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/manage_images#install-image).

## Windows Server Containers

### Validate container image

Before starting this exercise, validate that the Server Core base OS image has been installed on your container host. Do so using the `docker images` command. You should see a ‘windowsservercore image with a tag of `latest`. If you do not, the Windows Server Core image will need to be installed. For instructions see, [Install Base OS Images](https://msdn.microsoft.com/en-us/virtualization/windowscontainers/management/manage_images#install-image).

> When running Docker commands locally on the container host, the shell must be running with elevated permissions. Start the command session, or PowerShell session as Administrator. 

```
docker images

REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
windowsservercore   10.0.14300.1000     dbfee88ee9fd        4 weeks ago         9.344 GB
windowsservercore   latest              dbfee88ee9fd        4 weeks ago         9.344 GB
```

### Create Container <!--1-->

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

Through the last exercise, a container was manually created, modified, and then captured into a new container image. Docker includes a method for automating this process using what is called a Dockerfile. This exercise will have identical results as the last, however this time the process will be completely automated.

### Create IIS Image

On the container host, create a directory `c:\build`, and in this directory create a file named `Dockerfile`.

```none
powershell new-item c:\build\Dockerfile -Force
```

Open the Dockerfile in notepad.

```none
notepad c:\build\Dockerfile
```

Copy the following text into the Dockerfile and save the file. These commands instruct Docker to create a new image, using `windowsservercore` as the base, and include the modifications specified with `RUN`. 

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

## Next Steps

[Hyper-V Containers – Quick Start](./manage_docker_hyperv.md)