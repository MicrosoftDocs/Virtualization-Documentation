ms.ContentId: 95ece47b-4f08-49a5-ba22-4f9f044c282b
title: Manage Data in Windows Container

## Owner: Senthil Rajaram <senthilr@microsoft.com>

## TODO:
* Verify that this is our prescribed way to get data into a container.
* Add ReadWrite, Maximum bandwidth and Maximum IOPS
* Add Simple Docker section with pointer to Docker Docs.

## Managing Shared Folders with PowerShell:

Shared folders can be created, viewed and deleted using PowerShell.

## Create Shared Folder

To create a shared folder, use the **Add-ContainerSharedFolder** command.

```powershell
PS C:\> Add-ContainerSharedFolder -ContainerName DEMO -SourcePath c:\source -DestinationPath c:\source
ContainerName SourcePath DestinationPath AccessMode
------------- ---------- --------------- ----------
DEMO          c:\source  c:\source       ReadWrite
```

When the shared folder has been created, the shared folder will be available inside of the container. Any data that is placed in the shared folder from the host, will be available inside of the container and any data placed in the shared folder from within the container will be available on the host.

## List Shared Folders

To see a list of shared folders for a particular container use the **Get-ContainerSharedFolder** command.

```powershell
PS C:\> Get-ContainerSharedFolder -ContainerName DEMO2
ContainerName SourcePath DestinationPath AccessMode
------------- ---------- --------------- ----------
DEMO2         c:\source  c:\source       ReadWrite
```

## Modify Shared Folder

To modify and existing shared folder configuration, use the Set-ContainerSharedFolder command.

```powershell
Add sample code here.
```

## Remove Shared Folder

To remove a shared folder, use the **Remove-ContainerSharedFolder** command.

```powershell
PS C:\> Remove-ContainerSharedFolder -ContainerName DEMO2 -SourcePath c:\source -DestinationPath c:\source
```
