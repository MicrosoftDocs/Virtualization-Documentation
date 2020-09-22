---
title: Implementing resource controls
description: Details regarding resource controls for Windows containers
keywords: docker, containers, cpu, memory, disk, resources
author: taylorb-microsoft
ms.author: jgerend
ms.date: 08/12/2020
ms.topic: conceptual
ms.assetid: 8ccd4192-4a58-42a5-8f74-2574d10de98e
---
# Implementing resource controls for Windows containers

There are several resource controls that can be implemented on a per-container and per-resource basis.  By default, containers run are subject to typical Windows resource management, which in general is fair-share based but though configuration of these controls a developer or administrator can limit or influence resource usage.  Resources that can be controlled include: CPU/Processor, Memory/RAM, Disk/Storage and Networking/Throughput.

Windows containers utilize [job objects](/windows/desktop/ProcThread/job-objects) to group and track processes associated with each container.  Resource controls are implemented on the parent job object associated with the container.

In the case of [Hyper-V isolation](./hyperv-container.md) resource controls are applied both to the virtual machine as well as to the job object of the container running inside the virtual machine automatically, this ensures that even if a process running in the container bypassed or escaped the job objects controls the virtual machine would ensure it was not able to exceed the defined resource controls.

## Resources

For each resource this section provides a mapping between the Docker command line interface as an example of how the resource control might be used (it might be configured by an orchestrator or other tooling) to the corresponding Windows host compute service (HCS) API as well as generally how the resource control has been implemented by Windows (please note that this description is high-level and that the underlying implementation is subject to change).

### Memory

| Resource | Location |
|-----|------|
| Docker interface | [--memory](https://docs.docker.com/engine/admin/resource_constraints/#memory) |
| HCS interface | [MemoryMaximumInMB](https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | [JOB_OBJECT_LIMIT_JOB_MEMORY](/windows/desktop/api/winnt/ns-winnt-_jobobject_basic_limit_information) |
| Hyper-V isolation | Virtual machine memory |

>[!NOTE]
>For Hyper-V isolation in Windows Server 2016, when using a memory cap, you'll see the container initially allocate the cap amount of memory, then start to return it to the container host. Later versions of Windows Server (1709 or later) have optimized this process.

### CPU (count)

| Resource | Location |
|---|---|
| Docker interface | [--cpus](https://docs.docker.com/engine/admin/resource_constraints/#cpu) |
| HCS interface | [ProcessorCount](https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | Simulated with [JOB_OBJECT_CPU_RATE_CONTROL_HARD_CAP](/windows/desktop/api/winnt/ns-winnt-_jobobject_cpu_rate_control_information)* |
| Hyper-V isolation | Number of virtual processors exposed |

### CPU (percent)

| Resource | Location |
|---|---|
| Docker interface | [--cpu-percent](https://docs.docker.com/engine/admin/resource_constraints/#cpu) |
| HCS interface | [ProcessorMaximum](https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | [JOB_OBJECT_CPU_RATE_CONTROL_HARD_CAP](/windows/desktop/api/winnt/ns-winnt-_jobobject_cpu_rate_control_information) |
| Hyper-V isolation | Hypervisor limits on virtual processors |

### CPU (shares)

| Resource | Location |
|---|---|
| Docker interface | [--cpu-shares](https://docs.docker.com/engine/admin/resource_constraints/#cpu) |
| HCS interface | [ProcessorWeight](https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | [JOB_OBJECT_CPU_RATE_CONTROL_WEIGHT_BASED](/windows/desktop/api/winnt/ns-winnt-_jobobject_cpu_rate_control_information) |
| Hyper-V isolation | Hypervisor virtual processors weights |

### Storage (image)

| Resource | Location |
|---|---|
| Docker interface | [--io-maxbandwidth/--io-maxiops](https://docs.docker.com/edge/engine/reference/commandline/run/#usage) |
| HCS interface | [StorageIOPSMaximum and StorageBandwidthMaximum](https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | [JOBOBJECT_IO_RATE_CONTROL_INFORMATION](/windows/desktop/api/jobapi2/ns-jobapi2-jobobject_io_rate_control_information) |
| Hyper-V isolation | [JOBOBJECT_IO_RATE_CONTROL_INFORMATION](/windows/desktop/api/jobapi2/ns-jobapi2-jobobject_io_rate_control_information) |

### Storage (volumes)

| Resource | Location |
|---|---|
| Docker interface | [--storage-opt size=](https://docs.docker.com/edge/engine/reference/commandline/run/#set-storage-driver-options-per-container) |
| HCS interface | [StorageSandboxSize](https://github.com/Microsoft/hcsshim/blob/b144c605002d4086146ca1c15c79e56bfaadc2a7/interface.go#L67) |
| Shared Kernel | [JOBOBJECT_IO_RATE_CONTROL_INFORMATION](/windows/desktop/api/jobapi2/ns-jobapi2-jobobject_io_rate_control_information) |
| Hyper-V isolation | [JOBOBJECT_IO_RATE_CONTROL_INFORMATION](/windows/desktop/api/jobapi2/ns-jobapi2-jobobject_io_rate_control_information) |

## Additional notes or details

### Memory requirements

Windows containers run some system process in each container typically those which provide per-container functionality like user management, networking etc… and while much of the memory required by these processes is shared amongst containers the memory cap must be high enough to allow for them.  A table is provided in the [system requirements](../deploy-containers/system-requirements.md#memory-requirments) document for each base image type and with and without Hyper-V isolation.

### CPU Shares (without Hyper-V isolation)

When using CPU shares the underlying implementation (when not using Hyper-V isolation) configures the [JOBOBJECT_CPU_RATE_CONTROL_INFORMATION](/windows/desktop/api/winnt/ns-winnt-_jobobject_cpu_rate_control_information), specifically setting the control flag to JOB_OBJECT_CPU_RATE_CONTROL_WEIGHT_BASED and providing an appropriate Weight.  The valid weight ranges of the job object are 1 – 9 with a default of 5 which is lower fidelity than the host compute services values of 1 – 10000.  As examples a share weight of 7500 would result in a weight of 7 or a share weight of 2500 would result in a value of 2.