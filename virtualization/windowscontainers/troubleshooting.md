---
title: Troubleshooting Windows Containers
description: Troubleshooting tips, automated scripts, and log information for Windows containers and Docker
keywords: docker, containers, troubleshooting, logs
author: PatrickLang
ms.date: 12/19/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: ebd79cd3-5fdd-458d-8dc8-fc96408958b5
---

# Troubleshooting

Having trouble setting up your machine or running a container? We created a PowerShell script to check for common problems. Please give it a try first to see what it finds and share your results.

```PowerShell
Invoke-WebRequest https://aka.ms/Debug-ContainerHost.ps1 -UseBasicParsing | Invoke-Expression
```
A list of all of the tests it runs along with common solutions is in the [Readme file](https://github.com/Microsoft/Virtualization-Documentation/blob/live/windows-server-container-tools/Debug-ContainerHost/README.md) for the script.

If that doesn't help find the source of the problem, please go ahead and post the output from your script on the [Container Forum](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers). This is the best place to get help from the community including Windows Insiders and developers.


## Finding Logs
There are multiple services that are used to manage Windows Containers. The next sections shows where to get logs for each service.

### Docker Engine
The Docker Engine logs to the Windows 'Application' event log, rather than to a file. These logs can easily be read, sorted, and filtered using Windows PowerShell

For example, this will show the Docker Engine logs from the last 5 minutes starting with the oldest.

```
Get-EventLog -LogName Application -Source Docker -After (Get-Date).AddMinutes(-5) | Sort-Object Time 
```

This could also easily be piped into a CSV file to be read by another tool or spreadsheet.

```
Get-EventLog -LogName Application -Source Docker -After (Get-Date).AddMinutes(-30)  | Sort-Object Time | Export-CSV ~/last30minutes.CSV
```

#### Enabling Debug logging
You can also enable debug-level logging on the Docker Engine. This may be helpful for troubleshooting if the regular logs don't have enough detail.

First, open an elevated Command Prompt, then run `sc.exe qc docker` get the current command line for the Docker service.
Example:
```none
C:\> sc.exe qc docker
[SC] QueryServiceConfig SUCCESS

SERVICE_NAME: docker
        TYPE               : 10  WIN32_OWN_PROCESS
        START_TYPE         : 2   AUTO_START
        ERROR_CONTROL      : 1   NORMAL
        BINARY_PATH_NAME   : "C:\Program Files\Docker\dockerd.exe" --run-service
        LOAD_ORDER_GROUP   :
        TAG                : 0
        DISPLAY_NAME       : Docker Engine
        DEPENDENCIES       :
        SERVICE_START_NAME : LocalSystem
```

Take the current `BINARY_PATH_NAME`, and modify it:
- Add a -D to the end
- Escape each " with \
- Enclose the whole command in "

Then run `sc.exe config docker binpath= ` followed by the new string. For example: 
```none
sc.exe config docker binpath= "\"C:\Program Files\Docker\dockerd.exe\" --run-service -D"
```


Now, restart the Docker service
```none
sc.exe stop docker
sc.exe start docker
```

This will log much more into the Application event log, so it's best to remove the `-D` option once you are done troubleshooting. Use the same steps above without `-D` and restart the service to disable the debug logging.


### Host Container Service
The Docker Engine depends on a Windows-specific Host Container Service. It has separate logs: 
- Microsoft-Windows-Hyper-V-Compute-Admin
- Microsoft-Windows-Hyper-V-Compute-Operational

They are visible in Event Viewer, and may also be queried with PowerShell.

For example:
```PowerShell
Get-WinEvent -LogName Microsoft-Windows-Hyper-V-Compute-Admin
Get-WinEvent -LogName Microsoft-Windows-Hyper-V-Compute-Operational 
```

