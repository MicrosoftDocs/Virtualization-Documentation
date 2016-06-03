---
author: neilpeterson
redirect_url: ../quick_start/manage_docker
---

# Windows Server Container Management

**This is preliminary content and subject to change.** 

The container life cycle includes actions such as, starting, stopping, and removing containers. When performing these actions, you may also need retrieve a list of container images, manage container networking, and limit container resources. This document will detail basic container management tasks using Docker and will also link through to in-depth articles. 

## Managing containers

### Create a container

Use `docker run` to create a container with Docker.

```none
PS C:\> docker run -p 80:80 windowsservercoreiis
```

For more information on the Docker `run` command, see the [Docker run reference]( https://docs.docker.com/engine/reference/run/).

### Stop a container

Use the `docker stop` command to stop a container with Docker.

```none
PS C:\> docker stop tender_panini

tender_panini
```

This example stops all running containers with Docker.

```none
PS C:\> docker stop $(docker ps -q)

fd9a978faac8
b51e4be8132e
```

### Remove container

To remove a container with Docker, use the `docker rm` command.

```none
PS C:\> docker rm prickly_pike

prickly_pike
``` 

To remove all containers with Docker.

```none
PS C:\> docker rm $(docker ps -aq)

dc3e282c064d
2230b0433370
```

For more information on the Docker rm command, see the [Docker rm reference](https://docs.docker.com/engine/reference/commandline/rm/).
