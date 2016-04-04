---
author: neilpeterson
---

# Container Shared Folders

**This is preliminary content and subject to change.** 

When creating containers, you may need to create a new data directory, or add an existing directory to the container. This can be accomplished through adding data volumes. Data volumes are visible to both container and continuer host, and data can be shared between them. Data volumes can also be shared between multiple containers on the same container host. 
This document will detail creating, inspecting, and removing data volumes.

## Data Volumes

### Create new volume

Create a new data volume using `-v` parameter of the `docker run` command. This example creates a data volume named `new-data-volume`. By default, new data volumes are stored under ` C:\ProgramData\Docker\volumes’.

```none
docker run -it -v c:\new-data-volume windowsservercore cmd
```

### Inspect new data volume

```none
docker inspect gloomy_pare
````

````none
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

### Mounting existing directory

In the below example the source folder is c:\source and destination folder c:\destination.

```none
PS C:\> docker run -it -v c:\source:c:\destination windowsservercore cmd
```

### Inspecting shared data volume

Mounted volumes can be viewed using the `docker inspect` command against a container.

```none
docker inspect backstabbing_kowalevski
```

This will return a large blob of information about the container, including a section named ‘Mounts’, which contains data about the mounted volumes.

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

## Data volume contianer

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


For more information on managing data in containers with Docker see [Docker Volumes on Docker.com](https://docs.docker.com/userguide/dockervolumes/).