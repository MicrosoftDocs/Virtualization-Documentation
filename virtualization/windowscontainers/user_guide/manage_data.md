Owner: Senthil Rajaram
To do:
* Verify that this is our prescribed way to get data into a container.
* Add ReadWrite, Maximum bandwidth and Maximum IOPS
* Add Simple Docker section with pointer to Docker Docs.

## Managing Shared Folders with PowerShell:

Shared folders allow data to be shared between a container host and container. When the shared folder has been created, the shared folder will be available inside of the container. Any data that is placed in the shared folder from the host, will be available inside of the container. Any data placed in the shared folder from within the container will be available on the host. A single folder on the host can be shared with many containers, in this configuration data can be shared between running containers.

Shared folders have the following characteristics.

- A single shared folder can be shared between many containers.
- A single container can have many shared folders.
- If a container image is taken from a container with shared folders, the data in the shared folder is not captured into the image.*
- When a container is removed, the source folder on the host is not removed.

## Create Shared Folder

To create a shared folder, use the **Add-ContainerSharedFolder** command. 

```powershell
PS C:\> Add-ContainerSharedFolder -ContainerName DEMO -SourcePath c:\source -DestinationPath c:\source
ContainerName SourcePath DestinationPath AccessMode
------------- ---------- --------------- ----------
DEMO          c:\source  c:\source       ReadWrite
```

## Create a Read Only Shared Folder*

```powershell
PS C:\> Add-ContainerSharedFolder -ContainerName SFRO -SourcePath c:\sf1 -DestinationPath c:\sf2 -AccessMode ReadOnly

ContainerName SourcePath DestinationPath AccessMode
------------- ---------- --------------- ----------
SFRO          c:\sf1     c:\sf2          ReadOnly
```

## List Shared Folders

To see a list of shared folders for a particular container use the **Get-ContainerSharedFolder** command.

```powershell
PS C:\> Get-ContainerSharedFolder -ContainerName DEMO2
ContainerName SourcePath DestinationPath AccessMode
------------- ---------- --------------- ----------
DEMO2         c:\source  c:\source       ReadWrite
```

## Modify Shared Folder*

To modify and existing shared folder configuration, use the Set-ContainerSharedFolder command.

```powershell
PS C:\> Set-ContainerSharedFolder -ContainerName SFRO -SourcePath c:\sf1 -DestinationPath c:\sf1
```

## Remove Shared Folder*

To remove a shared folder, use the **Remove-ContainerSharedFolder** command.

```powershell
PS C:\> Remove-ContainerSharedFolder -ContainerName DEMO2 -SourcePath c:\source -DestinationPath c:\source
```

## Mounting Volumes with Docker 

When managing Windows Containers with Docker shared folders or volumes can be created using the **-v** option.

In the below example the source folder is c:\sf1 and destination folder c:\fs1.

```powershell
C:\>docker run -it -v c:\sf1:c:\sf1 1f62aaf73140 cmd
```

For more information on managing data in containers with Docker see [Docker Volumes on Docker.com](https://docs.docker.com/userguide/dockervolumes/)

*At the time of writing this functionality may not be fully functional.
