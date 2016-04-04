---
author: neilpeterson
---

# Container Shared Folders

**This is preliminary content and subject to change.** 

When creating containers, you may need to create a new data directory, or add an existing directory to the container. This can be accomplished through adding data volumes. Data volumes are visible to both container and continuer host, and data can be shared between them. Data volumes can also be shared between multiple containers on the same container host. 
This document will detail creating, inspecting, and removing data volumes.

## Data volumes

### Create new volume

Create a new data volume using `-v` parameter of the `docker run` command. By default, new data volumes are stored on the host under `c:\ProgramData\Docker\volumes`.

This example creates a data volume named `new-data-volume`. This data volume will be accessible in the running container at `c:\new-data-volume`.

```none
docker run -it -v c:\new-data-volume windowsservercore cmd
```

For more information on creating volumes, see [Manage data in containers on docker.com](https://docs.docker.com/engine/userguide/containers/dockervolumes/#data-volumes).

### Inspect new data volume

To list date volumes for a specific container, use the `docker inspect` command.

```none
docker inspect gloomy_pare
```

The output will include a section named ‘Mounts’. Here you can see information about the data volume such as source and destination.

```none
"Mounts": [
    {
        "Name": "faf0ed35b9cffc0df8e4175802b21a237c006f61ed00204e30a0492960437344",
        "Source": "C:\\ProgramData\\Docker\\volumes\\faf0ed35b9cffc0df8e4175802b21a237c006f61ed00204e30a0492960437344\\_data",
        "Destination": "c:\\new-data-volume",
        "Driver": "local",
        "Mode": "",
        "RW": true,
        "Propagation": ""
    }
````

For more information on inspecting volumes, see [Manage data in containers on docker.com](https://docs.docker.com/engine/userguide/containers/dockervolumes/#locating-a-volume).

### Mounting existing directory

In addition to creating new data volumes, you may want to pass an existing director from the host, through to one or many containers. This can also be accomplished with the `-v` parameter of the `docker run` command.

In the below example the source directory, `c:\source`, is mounted into a container as `c:\destination`.

```none
PS C:\> docker run -it -v c:\source:c:\destination windowsservercore cmd
```

For more information on monting host directories, see [Manage data in containers on docker.com](https://docs.docker.com/engine/userguide/containers/dockervolumes/#mount-a-host-directory-as-a-data-volume).

### Inspecting shared data volume

Mounted volumes can be viewed using the `docker inspect` command against a container.

```none
docker inspect backstabbing_kowalevski
```

This will return a large blob of information about the container, including a section named ‘Mounts’, which contains data about the mounted volumes such as the source and destination directory.

```none
"Mounts": [
    {
        "Source": "c:\\container-share",
        "Destination": "c:\\data",
        "Mode": "",
        "RW": true,
        "Propagation": ""
}
````

## Data volume contianers

```none
docker run -it --volumes-from cocky_bell windowsservercore cmd
```

```none
docker inspect backstabbing_archimedes
```

```none
"Mounts": [
    {
        "Name": "f9786fdea26a8e0e800564d5b75a6705128a21236da6a905ea882da013490208",
        "Source": "C:\\ProgramData\\Docker\\volumes\\f9786fdea26a8e0e800564d5b75a6705128a21236da6a905ea882da013490208\\_data",
        "Destination": "c:\\share",
        "Driver": "local",
        "Mode": "",
        "RW": true,
        "Propagation": ""
    }
```


For more information on data containers see [Manage data in containers on docker.com](https://docs.docker.com/engine/userguide/containers/dockervolumes/#creating-and-mounting-a-data-volume-container).