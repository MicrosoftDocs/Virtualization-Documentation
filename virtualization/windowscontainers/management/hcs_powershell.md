---
title: HCS PowerSWhell
description: Work with HCS PowerShell and Windows containers.
keywords: docker, containers
author: neilpeterson
manager: timlt
ms.date: 05/02/2016
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 45144ec5-f76a-4460-abd1-9b60e47506d6
---

# Management Interoperability

**This is preliminary content and subject to change.** 

## Display all Containers

To return a list of containers use the `Get-ComputeProcess` command.

```none
PS C:\> Get-ComputeProcess

Id                                                Name                                      Owner       Type
--                                                ----                                      -----       ----
2088E0FA-1F7C-44DE-A4BC-1E29445D082B              DEMO1                                     VMMS   Container
373959AC-1BFA-46E3-A472-D330F5B0446C              DEMO2                                     VMMS   Container
d273c80b6e.. 									  d273c80b6e.. 								docker Container
e49cd35542.. 									  e49cd35542.. 								docker Container
```

## Stop a Container

To stop a container regardless if it was created using PowerShell or Docker, use the `Stop-ComputeProcess` command.

> At the time of writing, the VMMS service will need to be restarted in order for the containers to be shown as stopped when using the `Get-Container` command.

```none
PS C:\> Stop-ComputeProcess -Id 2088E0FA-1F7C-44DE-A4BC-1E29445D082B -Force
```
