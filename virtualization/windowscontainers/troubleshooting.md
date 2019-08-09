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

If that doesn't help find the source of the problem, please go ahead and post the output from your script on the [Container Forum](https://social.msdn.microsoft.com/Forums/home?forum=windowscontainers). This is the best place to get help from the community including Windows Insiders and developers.


## Finding Logs
There are multiple services that are used to manage Windows containers. The next sections shows where to get logs for each service.

# Docker Engine
The Docker Engine logs to the Windows 'Application' event log, rather than to a file. These logs can easily be read, sorted, and filtered using Windows PowerShell

For example, this will show the Docker Engine logs from the last 5 minutes starting with the oldest.

```
Get-EventLog -LogName Application -Source Docker -After (Get-Date).AddMinutes(-5) | Sort-Object Time 
```

This could also easily be piped into a CSV file to be read by another tool or spreadsheet.

```
Get-EventLog -LogName Application -Source Docker -After (Get-Date).AddMinutes(-30)  | Sort-Object Time | Export-CSV ~/last30minutes.CSV
```

## Enabling Debug logging
You can also enable debug-level logging on the Docker Engine. This may be helpful for troubleshooting if the regular logs don't have enough detail.

First, open an elevated Command Prompt, then run `sc.exe qc docker` get the current command line for the Docker service.
Example:
```
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

Then run `sc.exe config docker binpath=` followed by the new string. For example: 
```
sc.exe config docker binpath= "\"C:\Program Files\Docker\dockerd.exe\" --run-service -D"
```


Now, restart the Docker service
```
sc.exe stop docker
sc.exe start docker
```

This will log much more into the Application event log, so it's best to remove the `-D` option once you are done troubleshooting. Use the same steps above without `-D` and restart the service to disable the debug logging.

An alternate to the above is to run the docker daemon in debug mode from an elevated PowerShell prompt, capturing output directly into a file.
```PowerShell
sc.exe stop docker
<path\to\>dockerd.exe -D > daemon.log 2>&1
```

## Obtaining stack dump.

Generally, this is only useful if explicitly requested by Microsoft support, or docker developers. It can be used to assist diagnosing a situation where docker appears to have hung. 

Download [docker-signal.exe](https://github.com/jhowardmsft/docker-signal).

Usage:
```PowerShell
Get-Process dockerd
# Note the process ID in the `Id` column
docker-signal -pid=<id>
```

The output file will be located in the data-root directory docker is running in. The default directory is `C:\ProgramData\Docker`. The actual directory can be confirmed by running `docker info -f "{{.DockerRootDir}}"`.

The file will be `goroutine-stacks-<timestamp>.log`.

Note that `goroutine-stacks*.log` does not contain personal information.


# Host Compute Service
The Docker Engine depends on a Windows-specific Host Compute Service. It has separate logs: 
- Microsoft-Windows-Hyper-V-Compute-Admin
- Microsoft-Windows-Hyper-V-Compute-Operational

They are visible in Event Viewer, and may also be queried with PowerShell.

For example:
```PowerShell
Get-WinEvent -LogName Microsoft-Windows-Hyper-V-Compute-Admin
Get-WinEvent -LogName Microsoft-Windows-Hyper-V-Compute-Operational 
```

## Capturing HCS analytic/debug logs

To enable analytic/debug logs for Hyper-V Compute and save them to `hcslog.evtx`.

```PowerShell
# Enable the analytic logs
wevtutil.exe sl Microsoft-Windows-Hyper-V-Compute-Analytic /e:true /q:true

# <reproduce your issue>

# Export to an evtx
wevtutil.exe epl Microsoft-Windows-Hyper-V-Compute-Analytic <hcslog.evtx>

# Disable
wevtutil.exe sl Microsoft-Windows-Hyper-V-Compute-Analytic /e:false /q:true
```

## Capturing HCS verbose tracing

Generally, these are only useful if requested by Microsoft support. 

Download [HcsTraceProfile.wprp](https://gist.github.com/jhowardmsft/71b37956df0b4248087c3849b97d8a71)

```PowerShell
# Enable tracing
wpr.exe -start HcsTraceProfile.wprp!HcsArgon -filemode

# <reproduce your issue>

# Capture to HcsTrace.etl
wpr.exe -stop HcsTrace.etl "some description"
```

Provide `HcsTrace.etl` to your support contact.
