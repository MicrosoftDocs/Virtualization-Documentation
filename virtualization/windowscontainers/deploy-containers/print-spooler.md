---
title: Print spooler in Windows containers
description: Learn about current working behavior for the print spooler service in Windows containers.
author: cwilhit
ms.author: lizross
ms.date: 10/22/2019
ms.topic: how-to
---

# Print Spooler in Windows Containers

Applications with a dependency on printing services can be containerized successfully with Windows containers. There are special requirements that must be met in order to successfully enable printer service functionality. This guide explains how to properly configure your deployment.

> [!IMPORTANT]
> While getting access to printing services successfully in containers works, functionality is limited in form; some printing-related actions may not work. For example, apps that have a dependency on installing printer drivers into the host cannot be containerized because **driver installation from within a container is unsupported**. Please open a feedback below if you find an unsupported printing feature that you want to be supported in containers.

## Setup

* The host should be Windows Server 2019 or Windows 10 Pro/Enterprise October 2018 update or newer.
* The [mcr.microsoft.com/windows](https://hub.docker.com/_/microsoft-windowsfamily-windows) image should be the targeted base image. Other Windows container base images (such as Nano Server and Windows Server Core) do not carry the Printing Server Role.

### Hyper-V Isolation

We recommend running your container with Hyper-V isolation. When run in this mode, you can have as many containers as you want running with access to the print services. You do not need to modify the spooler service on the host.

You can verify functionality with the following PowerShell query:

```PowerShell
PS C:\Users\Administrator> docker run -it --isolation hyperv mcr.microsoft.com/windows:1809 powershell.exe
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.

PS C:\> Get-Service spooler

Status   Name               DisplayName
------   ----               -----------
Running  spooler            Print Spooler


PS C:\> Get-Printer

Name                           ComputerName    Type         DriverName                PortName        Shared   Published
----                           ------------    ----         ----------                --------        ------   --------
Microsoft XPS Document Writer                  Local        Microsoft XPS Document... PORTPROMPT:     False    False
Microsoft Print to PDF                         Local        Microsoft Print To PDF    PORTPROMPT:     False    False
Fax                                            Local        Microsoft Shared Fax D... SHRFAX:         False    False


PS C:\>
```

### Process Isolation

Due to the shared kernel nature of process-isolated containers, current behavior limits the user to running only **one instance** of the printer spooler service across the host and all its container children. If the host has the printer spooler running, you must stop the service on the host before attemping to launch the printer service in the guest.

> [!TIP]
> If you launch a container and query for the spooler service in both the container and the host simultaneously, both will report their state as 'running'. But do not be deceived--the container will not be able to query for a list of available printers. The host's spooler service must not run.

To check if the host is running the printer service, use the query in PowerShell below:

```PowerShell
PS C:\Users\Administrator> Get-Service spooler

Status   Name               DisplayName
------   ----               -----------
Running  spooler            Print Spooler

PS C:\Users\Administrator>
```

To stop the spooler service on the host, use the following commands in PowerShell below:

```PowerShell
Stop-Service spooler
Set-Service spooler -StartupType Disabled
```

Launch the container and verify access to the printers.

```PowerShell
PS C:\Users\Administrator> docker run -it --isolation process mcr.microsoft.com/windows:1809 powershell.exe
Windows PowerShell
Copyright (C) Microsoft Corporation. All rights reserved.


PS C:\> Get-Service spooler

Status   Name               DisplayName
------   ----               -----------
Running  spooler            Print Spooler


PS C:\> Get-Printer

Name                           ComputerName    Type         DriverName                PortName        Shared   Published
----                           ------------    ----         ----------                --------        ------   --------
Microsoft XPS Document Writer                  Local        Microsoft XPS Document... PORTPROMPT:     False    False
Microsoft Print to PDF                         Local        Microsoft Print To PDF    PORTPROMPT:     False    False
Fax                                            Local        Microsoft Shared Fax D... SHRFAX:         False    False


PS C:\>
```
