## Install Docker Service

The Docker Daemon and Client is part of an open source software project founded by docker.com. Docker has driven functionality and consistence into the creation and management of container technology. Windows Containers and Container Images can be created and managed using the Docker tools. 

The Docker Daemon and Client are not shipped with Windows out of the box, rather need to be installed. This document will walk through manually installing the Docker daemon and Docker client. Automated methods for competing these task will also be provided.

## Install the Docker Client / Daemon for Windows:

Download docker.exe from "https://aka.ms/ContainerTools" and copy it into **c:\windows\system32** of your container host.

Create a folder **c:\programdata\docker** and copy **runDockerDaemon.cmd** into this folder.

Download nssm.exe from https://nssm.cc/release/nssm-2.24.zip, extract the files, and copy **nssm-2.24\win64\nssm.exe** into the **c:\windows\system32** directory.

Open a command prompt and enter **nssm install**.

![](media/nssm1.png)

![](media/nssm2.png)

## Automated Installation of the Docker Service