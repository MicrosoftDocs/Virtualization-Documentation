# Description:

This topic describes how to create an image containing Django 3.2.9. Please do this after seting up your environment as described in [Prep Windows for containers] (https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/set-up-environment) and running your first container as described in and [Run your first windows Container] (https://docs.microsoft.com/en-us/virtualization/windowscontainers/quick-start/run-your-first-container).

You'll also need the Git source control system installed on your computer.

The python is used as the base image.

This dockerfile is for demonstration purposes and may require modification for production use. 

# Environment:

Windows Server Core Base OS Image

# Usage:

**Docker Build**

```
docker build -t django:latest .
```

**Docker Run** 

This will start a container, display "Hello World", and then exit. Modify the Dockerfile appropriately for application use. 

```
docker run -it -p 80:80 django cmd
```

**Instructions**

All container sample source code is kept under the Vitualization-Documentation git repository in a folder called windows-container-samples.
1. Open a CLI session and change directories to the folder in which you want to store this repository. 
2. Clone the repo to your current working directory:
    git clone https://github.com/MicrosoftDocs/Virtualization-Documentation.git
3. Navigate to the folder in CLI containing the django repository based on where you cloned the Virtualization-Documentation repo.
4. When you are at the directory that the dockerfile resides, run the docker build command to build the container from the Dockerfile.
    docker build -t django:latest .
5. To run the newly built container, run the docker run command.
    docker run -it -p 80:80 django cmd
6. This will enter you into the container. Use the following command to retrieve the version of django that you are using.
    django-admin --version
7. The django version should display. Use the exit command to exit the container.

## Dockerfile Details:
```
# This dockerfile utilizes components licensed by their respective owners/authors.
# Prior to utilizing this file or resulting images please review the respective licenses at: https://github.com/django/django/blob/master/LICENSE

FROM python
This specifies which base image we will use to build our container on top of. If the local system does not have this image already, then docker will automatically try and fetch it. 

LABEL Description="Django" Vendor="Django Software Foundation" Version="3.2.9"

RUN ["pip", "install", "Django==3.2.9"]
This command will run pip and install Django version 3.2.9. 

CMD ["django-admin --version"]
Using this command, it will share the version of django that is currently being used in the container.
```


