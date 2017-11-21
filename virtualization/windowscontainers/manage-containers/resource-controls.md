---
title: Implementing resource controls
description: Details regarding resource controls for Windows containers
keywords: docker, containers, cpu, memory, disk, resources
author: taylorb-microsoft
ms.date: 11/21/2017
ms.topic: article
ms.prod: windows-containers
ms.service: windows-containers
ms.assetid: 8ccd4192-4a58-42a5-8f74-2574d10de98e
---
_draft_

# Implementing resource controls for Windows containers
There are several resource controls that can be implemented on a per-container and per-resource basis.  By default, containers run are subject to typical Windows resource management, which in general is fair-share based but though configuration of these controls a developer or administrator can limit or influence resource usage.  Resources that can be controlled include: CPU/Processor, Memory/RAM, Disk/Storage and Networking/Throughput.
Windows containers utilize [job objects]( https://msdn.microsoft.com/en-us/library/windows/desktop/ms684161(v=vs.85).aspx) to group and track processes associated with each container.  Resource controls are implemented on the parent job object associated with the container.  In the case of [Hyper-V isolation](https://docs.microsoft.com/en-us/virtualization/windowscontainers/about/index#windows-container-types) resource controls are applied both to the virtual machine as well as to the job object of the container running inside the virtual machine automatically, this ensures that even if a process running in the container bypassed or escaped the job objects controls the virtual machine would ensure it was not able to exceed the defined resource controls.
