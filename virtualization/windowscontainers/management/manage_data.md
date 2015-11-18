# Container Shared Folders

Shared folders allow data to be shared between a container host and container. When the shared folder has been created, the shared folder will be available inside of the container. Any data that is placed in the shared folder from the host, will be available inside of the container. Any data placed in the shared folder from within the container will be available on the host. A single folder on the host can be shared with many containers, in this configuration data can be shared between running containers.

## Manage Data - PowerShell

### Create Shared Folder

To create a shared folder, use the `Add-ContainerSharedFolder` command. The below example creates a directory in the container `c:\shared_data`, that is mapped to a directory on the host `c:\data_source`.

> A container must be in a stopped state when adding a shared folder.

```powershell
Add-ContainerSharedFolder -ContainerName DEMO -SourcePath c:\data_source -DestinationPath c:\shared_data

ContainerName SourcePath 	   DestinationPath AccessMode
------------- ---------- 	   --------------- ----------
DEMO          c:\data_source   c:\shared_data  ReadWrite
```

### Read Only Shared Folder

```powershell
Add-ContainerSharedFolder -ContainerName DEMO -SourcePath c:\sf1 -DestinationPath c:\sf2 -AccessMode ReadOnly

ContainerName SourcePath DestinationPath AccessMode
------------- ---------- --------------- ----------
DEMO         c:\sf1     c:\sf2          ReadOnly
```

### List Shared Folders

To see a list of shared folders for a particular container use the `Get-ContainerSharedFolder` command.

```powershell
Get-ContainerSharedFolder -ContainerName DEMO2

ContainerName SourcePath DestinationPath AccessMode
------------- ---------- --------------- ----------
DEMO         c:\source  c:\source       ReadWrite
```

### Modify Shared Folder

To modify and existing shared folder configuration, use the `Set-ContainerSharedFolder` command.

```powershell
Set-ContainerSharedFolder -ContainerName SFRO -SourcePath c:\sf1 -DestinationPath c:\sf1
```

### Remove Shared Folder

To remove a shared folder, use the `Remove-ContainerSharedFolder` command.

> A container must be in a stopped state when removing shared folder

```powershell
Remove-ContainerSharedFolder -ContainerName DEMO2 -SourcePath c:\source -DestinationPath c:\source
```
## Manage Data - Docker

### Mounting Volumes

When managing Windows Containers with Docker, volumes can be mounted using the `-v` option.

In the below example the source folder is c:\source and destination folder c:\destination.

```powershell
docker run -it -v c:\source:c:\destination 1f62aaf73140 cmd
```

For more information on managing data in containers with Docker see [Docker Volumes on Docker.com](https://docs.docker.com/userguide/dockervolumes/).

