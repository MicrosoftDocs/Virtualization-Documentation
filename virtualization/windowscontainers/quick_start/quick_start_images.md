---
title: Container Deployment Quick Start - Images
description: Container deployment quick start
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05//2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 479e05b1-2642-47c7-9db4-d2a23592d29f
---

# Create Container Images

In the previous quick starts a Windows container was created from a pre-existing container image. This exercise will detail creating your own container images manually, creating images using a Dockerfile, and uploading these images to Docker Hub.

**Prerequisites** -  in order to complete this exercise, you will need a Windows Server host fully configured with the container feature and Docker.

## 1. Container Image - Manual

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

## 2. Container Image - Dockerfile

Through the last exercise, a container was manually created, modified, and then captured into a new container image. Docker includes a method for automating this process using what is called a Dockerfile. This exercise will have identical results as the last, however this time the process will be completely automated.


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
```


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

## 3. Upload to Docker Hub