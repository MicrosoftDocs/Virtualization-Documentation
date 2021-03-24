---
title: Windows Container Security
description: Defines the security boundaries of Windows Containers
keywords: docker, containers, security, windows, isolation, boundary, privacy, kubernetes, linux
author: brasmith
ms.date: 03/23/2020
ms.topic: conceptual
ms.assetid: 
---
## Windows Container Security

Containers lend their reduced image size to the fact that they can rely on the host to provide limited access to various resources. If the container knows that the host will be able to provide the functionality needed to perform a specific set of actions, then the container does not need to include the relevant software in its base image. The extent of resource sharing that occurs, however, can have a significant impact on both the performance and security of the container. Share too much and the application may as well just run as a process on the host. Share too little and the container becomes indistinguishable from a VM.  Both configurations are applicable to many scenarios but most people using containers generally opt for something in the middle.

The security of a Windows container is derived from the degree of sharing that occurs with its host. The security boundary of a container is constituted by the isolation mechanisms that separate the container from the host. Most importantly, these isolation mechanisms define which processes in the container can interact with the host. **If the design of a container allows for an elevated (admin) process to interact with the host, then Microsoft does not consider this container to have a robust security boundary.**

### Windows Server Containers vs. Linux Containers

Process-isolated Windows server containers and Linux containers share similar degrees of isolation. For both container types the developer must assume that any attack which can be performed via an elevated process on the host can also be performed via an elevated process in the container. Both operate via the primitive capabilities offered by their respective host kernels. The container images are built containing user mode binaries which utilize the APIs provided by the host kernel. The host kernel provides the same resource isolation and management capabilities to each container running in user space. If the kernel is compromised in any way shape or form, then so is every container sharing that kernel.

The fundamental design of Linux and Windows server containers trades security for flexibility. Windows server and Linux containers are built on top of the primitive components provided by the OS. Doing so provides the flexibility for sharing resources and namespaces between containers but adds additional complexity that opens the door for exploitation. Broadly stated, **we do not consider the kernel to be a sufficient security boundary for hostile multi-tenant workloads.**

### Kernel Isolation with Hypervisor-Isolated Containers

Hypervisor-isolated containers provide a higher degree of isolation than process isolated Windows Server or Linux containers and are considered robust security boundary. Hypervisor-isolated containers consist of a Windows server container wrapped in an ultra-light VM and run alongside the host OS via Microsoft’s hypervisor. The hypervisor provides hardware-level isolation that instates a highly robust security boundary between the host and other containers. Even if an exploit were to escape the Windows server container it would be contained within the hypervisor-isolated VM.

Neither Windows Server containers or Linux containers provide what Microsoft considers a robust security boundary and should not be used in hostile multi-tenant scenarios. A container must be confined to a dedicated VM to prevent a rogue container process from interacting with the host or other tenants. Hypervisor isolation enables this degree of separation while also offering several performance gains over traditional VMs. Therefore, it is highly recommended that in hostile multi-tenant scenarios Hypervisor-isolated containers be the container of choice.

### Container Security Servicing Criteria

Microsoft is committed to patching all exploits and escapes that break the established isolation boundary of any Windows container type. However, only exploits that break a security boundary are serviced via the MSRC process. **Only hypervisor-isolated containers provide a security boundary, and process-isolated containers do not.** The only way to generate an MSRC for a process-isolated container escape is if a non-admin process can gain access to the host. If an exploit uses an admin process to escape the container then Microsoft considers it to be a non-security bug and will patch it per the normal servicing process. If an exploit uses a non-admin process to perform an action that breaches an security boundary then Microsoft will investigate it per the [established security servicing criteria](https://www.microsoft.com/msrc/windows-security-servicing-criteria).

### What makes a multi-tenant workload hostile?

Multi-tenant environments exist when multiple workloads are operating on shared infrastructure and resources. If one or more workloads running on said infrastructure cannot be trusted, then the multi-tenant environment is considered hostile. Both Windows server and Linux containers share the host kernel so any exploit performed on a single container can impact all other workloads running on the shared infrastructure.

There are steps which can be taken to reduce the chance that an exploit will occur (pod security policies, AppArmor, RBAC, etc.) but they do not provide guaranteed protection against an attacker. We recommend you follow our [best practices for cluster isolation](https://docs.microsoft.com/azure/aks/operator-best-practices-cluster-isolation) for any multi-tenant scenario.

### When to use ContainerAdmin vs. ContainerUser

Windows server containers offer two default user accounts, ContainerUser and ContainerAdministrator, each with their own specific purpose. The ContainerAdministrator account enables the container to be used for administrative purposes: installing services and software (e.g. enabling IIS within a container), making configuration changes, and creating new accounts. These are important for a number of IT scenarios which may be running in custom on-prem deployment environments.

The ContainerUser account exists for all other scenarios where administrator privileges in Windows are not needed. It is a restricted user account designed purely for applications which do not need to interact with the host. **We strongly recommended that when deploying a Windows server container to any multi-tenant environment that your application runs via the ContainerUser account.** In a multi-tenant environment it is always best to follow the principle of least privilege purely for the reason that if an attacker compromises your workload then the shared resource and neighboring resources have a lower chance or being impacted as well. Running containers using the ContainerUser account greatly reduces the chance of the cluster being compromised. Again, this still does not provide a robust security boundary so anywhere security is a concern hypervisor-isolated containers should be used.
