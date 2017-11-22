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
# Implementing resource controls for Windows containers
There are several resource controls that can be implemented on a per-container and per-resource basis.  By default, containers run are subject to typical Windows resource management, which in general is fair-share based but though configuration of these controls a developer or administrator can limit or influence resource usage.  Resources that can be controlled include: CPU/Processor, Memory/RAM, Disk/Storage and Networking/Throughput.
Windows containers utilize [job objects]( https://msdn.microsoft.com/en-us/library/windows/desktop/ms684161(v=vs.85).aspx) to group and track processes associated with each container.  Resource controls are implemented on the parent job object associated with the container.  In the case of [Hyper-V isolation](https://docs.microsoft.com/en-us/virtualization/windowscontainers/about/index#windows-container-types) resource controls are applied both to the virtual machine as well as to the job object of the container running inside the virtual machine automatically, this ensures that even if a process running in the container bypassed or escaped the job objects controls the virtual machine would ensure it was not able to exceed the defined resource controls.

## Resources
For each resource this section provides a mapping between the Docker command line interface as an example of how the resource control might be used (it might be configured by an orchestrator or other tooling) to the corresponding Windows host compute service (HCS) API as well as generally how the resource control has been implemented by Windows (please note that this description is high-level and that the underlying implementation is subject to change).

|  | |
| ----- | ------|
| *Memory* ||
| Docker interface | [--memory](https://docs.docker.com/engine/admin/resource_constraints/#memory) |
| HCS interface | [MemoryMaximumInMB]( https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | [JOB_OBJECT_LIMIT_JOB_MEMORY](https://msdn.microsoft.com/en-us/library/windows/desktop/ms684147(v=vs.85).aspx) |
| Hyper-V isolation | Virtual machine memory |
| ||
| *CPU (count)* ||
| Docker interface | [--cpus](https://docs.docker.com/engine/admin/resource_constraints/#cpu) |
| HCS interface | [ProcessorCount]( https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | Simulated with [JOB_OBJECT_CPU_RATE_CONTROL_HARD_CAP](https://msdn.microsoft.com/en-us/library/windows/desktop/ms684147(v=vs.85).aspx) |
| Hyper-V isolation | Number of virtual processors exposed |
| ||
| *CPU (percent)* ||
| Docker interface | [--cpu-percent](https://docs.docker.com/engine/admin/resource_constraints/#cpu) |
| HCS interface | [ProcessorMaximum](https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | [JOB_OBJECT_CPU_RATE_CONTROL_HARD_CAP](https://msdn.microsoft.com/en-us/library/windows/desktop/ms684147(v=vs.85).aspx) |
| Hyper-V isolation | Hypervisor limits on virtual processors |
| ||
| *CPU (shares)* ||
| Docker interface | [--cpu-shares](https://docs.docker.com/engine/admin/resource_constraints/#cpu) |
| HCS interface | [ProcessorWeight](https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | [JOB_OBJECT_CPU_RATE_CONTROL_WEIGHT_BASED](https://msdn.microsoft.com/en-us/library/windows/desktop/ms684147(v=vs.85).aspx) |
| Hyper-V isolation | Hypervisor virtual processors weights |
| ||
| *Storage (image)* ||
| Docker interface | [--io-maxbandwidth/--io-maxiops]( https://docs.docker.com/edge/engine/reference/commandline/run/#usage) |
| HCS interface | [StorageIOPSMaximum and StorageBandwidthMaximum](https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | [JobObjectIoRateControlInformation](https://msdn.microsoft.com/en-us/library/windows/desktop/hh448384(v=vs.85).aspx) |
| Hyper-V isolation | [JobObjectIoRateControlInformation](https://msdn.microsoft.com/en-us/library/windows/desktop/hh448384(v=vs.85).aspx) |
| ||
| *Storage (volumes)* ||
| Docker interface | [--storage-opt size=]( https://docs.docker.com/edge/engine/reference/commandline/run/#set-storage-driver-options-per-container) |
| HCS interface | [StorageSandboxSize](https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | [JobObjectIoRateControlInformation](https://msdn.microsoft.com/en-us/library/windows/desktop/hh448384(v=vs.85).aspx) |
| Hyper-V isolation | [JobObjectIoRateControlInformation](https://msdn.microsoft.com/en-us/library/windows/desktop/hh448384(v=vs.85).aspx) |

