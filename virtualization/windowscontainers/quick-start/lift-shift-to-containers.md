---
title: Lift and shift to containers
description: Learn how to migrate existing applications to containers
keywords: containers, migrate
author: robinharwood
ms.author: roharwoo
ms.date: 08/01/2022
ms.topic: quickstart
---  

# Using Windows Containers to "Containerize" Existing Applications

> Applies to: Windows Server 2022, Windows Server 2019, Windows Server 2016

Windows containers provide a great mechanism for modernizing traditional or legacy applications.  Although you may hear this approach referred to as "lift and shift to containers," the lift-and-shift metaphor originates from shifting workloads from physical to virtual machines and has been used lately when referring to moving workloads as is to the cloud (whether private or public). Today this term is more appropriately applied to migrating virtual machines (VMs).  But containers are not VMs and thinking of them as VMs can lead to confusion over how an application can be containerized, or whether it even can – or should – be containerized.

This topic provides practical guidance on moving traditional applications to Windows containers. It's aimed at helping you prioritize which applications should be containerized, by explaining special considerations up-front.

## Introduction

### What Windows containers are, and what they aren't

The generic term container refers to a technology that virtualizes the operating system (OS). This virtualization provides a level of isolation from the OS of the server/host itself, which in turn enables more agility for application developers and operations teams.

Windows containers are a specific implementation of container technology. They provide instances of virtualized operating systems that are isolated from the Windows OS. But total interdependence between container and host is impossible: a Windows container must coordinate its demand for resources and functions with the Windows OS. Why is this important? Because a Windows container is not an entire virtualized server and some of the things you may want to do with an application can't be done with only a virtualized OS.

You can read more about this topic in [Containers vs. virtual machines](../about/containers-vs-vm.md). But a few good points that help you remember the container vs. VM distinction are:

- Containers aren't a solution equivalent to desktop application virtualization.  They support only server-side applications that don't require an interactive session. Because they run on specialized container images, they support only those applications that don't need a graphical front end.
- Containers are ephemeral by nature. This means that, by default, there's no mechanism to save the state of a container instance.  If an instance fails, another instance will take its place.

The container technology began on Linux, with Docker emerging as the standard. Microsoft has worked closely with Docker to ensure the container functionality is as much the same on Windows as is reasonably possible. Inherent differences between Linux and Windows may surface in ways that appear to be limitations of Windows containers when in fact they're just the Linux versus Windows differences. On the other hand, Windows containers provide some unique implementations, such as Hyper-V isolation, which will be covered later. This topic will help you understand those differences and how to accommodate them.

### Benefits of using containers

Much like running multiple VMs on a single physical host, you can run multiple containers on a single physical or virtual host. But unlike with VMs, you don't have to manage the OS for a container, which gives you the flexibility to focus on application development and underlying infrastructure. It also means you can isolate an application so that it's unaffected by any other processes supported by the OS.

Containers provide a lightweight method of creating and dynamically stopping the resources required for a functioning application. While it's possible to create and deploy VMs as application demand increases, it's quicker to use containers for scaling out. With containers, you can also restart quickly in case of a crash or hardware interruption. Containers enable you to take any app from development to production with little or no code change, as they "contain" application dependencies so that they work across environments. The ability to containerize an existing application with minimal code changes, due to the Docker integration across Microsoft developer tools, is also a powerful factor in application development and maintenance.

Finally, one of the most important benefits of using containers is the agility you gain for app development, since you can have different versions of an app running on the same host with no clash of resources.

You can find a much more complete list of benefits for using containers for existing applications on the Microsoft [.NET documentation page](/dotnet/architecture/modernize-with-azure-containers/modernize-existing-apps-to-cloud-optimized/deploy-existing-net-apps-as-windows-containers).

### Important concept of level of isolation

Windows containers provide isolation from the Windows OS, isolation that is advantageous when you're building, testing, and promoting an app to production. But the way the isolation is achieved is important to understand when you're thinking about containerizing an application.

Windows containers offer two distinct modes of runtime isolation: process and Hyper-V. Containers under both modes are created and managed identically, and function identically. So, what are the differences and why should you care?
In process isolation, multiple containers run concurrently on a single host with isolation provided through namespace, resource control, and other features.  Containers in process isolation mode share the same kernel with the host as well as each other. This is roughly the same as the way Linux containers run.

In Hyper-V isolation, multiple containers also run concurrently on a single host, but the containers run inside of highly optimized virtual machines, with each effectively getting its own kernel. The presence of this virtual machine – effectively a "utility" VM – provides hardware-level isolation between each container, as well as the container host.

In a way, Hyper-V isolation mode is almost like a hybrid of a VM and container, providing an extra layer of security that's particularly helpful if your app needs multitenancy. But the possible trade-offs of using Hyper-V isolation mode include:

- Longer start-up time for the container, and a likely impact on overall app performance.
- Not all tools work natively with Hyper-V isolation.
- Neither Azure Kubernetes Service (AKS) nor AKS on Azure Stack HCI support Hyper-V isolation at this moment.

You can read more about how the two isolation modes are implemented in the topic [Isolation Modes](../manage-containers/hyperv-container.md). When you first containerize an app, you'll need to choose between the two modes. Fortunately, it's very easy to change from one mode to another later, as it doesn't require any changes to either the application or the container. But be aware that, when you containerize an app, choosing between the two modes is one of the first things you'll have to do.

### Container orchestration

The ability to run multiple containers on a single or multiple hosts without concern for OS management gives you great flexibility, helping you move toward a microservice-based architecture. One trade-off for that flexibility, though, is that an environment based upon containers and microservices can quickly mushroom into many moving parts – too many to keep track of. Fortunately, managing load balancing, high availability, container scheduling, resource management, and much more, is the role of a container orchestrator.

Orchestrators are perhaps misnamed; they're more like the conductors of an orchestra in that they coordinate the activity of multiple containers to keep the music playing.  In a sense, they handle the scheduling and resource allocation for containers in a way similar to the functioning of an OS. So, as you move to containerize your applications, you will need to choose among the orchestrators that support Windows containers. Some of the most common ones are Kubernetes and Docker Swarm.

## What can't be moved to Windows containers

When you consider whether an app can be containerized or not, it's probably easiest to start with the list of factors that completely rule out Windows containers as an option.

The following table summarizes the types of apps that can't be moved to Windows containers, and why not. The reasons are more fully explained in the subsections after the table.  Understanding the reasons for these limitations can give you a clearer idea of what containers really are, including how they differ from VMs. This will in turn help you better assess the capabilities of Windows containers that you can leverage with the existing apps you can containerize.

>Note: The list below is not a complete list. Instead, it is a compilation of apps Microsoft has seen customers try to containerize.

|Applications/features not supported | Why not supported | Can you work around this?|
| --- | --- | --- |
|Applications requiring a desktop | Containers don't support Graphic User Interface (GUI) | If the application only requires a GUI to install, changing it to a silent install might be a solution|
|Applications using Remote Desktop Protocol (RDP) | RDP is for interactive sessions, so the principle above applies here as well | You may be able to use Windows Admin Center (WAC) or Remote PowerShell as an alternative for remote management|
|Stateful applications | Containers are ephemeral | Yes, some applications might require minimal change, so they don't store data or state inside the container
|Database applications | Containers are ephemeral | Yes, some applications might require minimal change, so they don't store data or state inside the container|
|Active Directory | The design and purpose of Active Directory precludes running in a container | No. However, apps that are Active Directory dependent can use Group Managed Service Accounts (gMSA). More information on gMSA is provided below|
|Older Windows Server versions | Only Windows Server 2016 or later is supported | No. However, application compatibility might be an option – most Windows Server 2008/R2 and older apps run on newer versions of Windows Server|
|Apps using .NET Framework version 2.0 or older | Specific container images are required to support the .NET Framework, and only more recent versions are supported | Versions earlier than 2.0 aren't supported at all, but see below for the container images required for later versions|
|Apps using other third-party frameworks | Microsoft doesn't specifically certify or support the use of non-Microsoft frameworks on Windows Containers | Check with the vendor of the specific framework or app the support policy for Windows containers. See below for more information|

Let's consider each of these limitations in turn.

### Applications requiring a desktop

Containers are ideal for ephemeral functions that are invoked from other applications, including those with user interactions. But you can't use them for applications that have GUIs themselves.  This is true even if the application itself doesn't have a GUI but has an installer that relies upon a GUI. In general, Windows Installer can be invoked using PowerShell, but if your application requires installation via a GUI, that requirement eliminates it as a candidate for containerizing.

This isn't an issue with the way Windows containers have been implemented, but rather a fundamental concept of how containers work.

It's a different matter if an app needs GUI APIs. The APIs are supported even though the GUI served by those APIs are not. This is more fully explained in the topic [Nano Server x Server Core x Server - Which base image is the right one for you?](https://techcommunity.microsoft.com/t5/containers/nano-server-x-server-core-x-server-which-base-image-is-the-right/ba-p/2835785)

### Applications using RDP

Because the whole purpose of Remote Desktop Protocol (RDP) is to establish an interactive, visual session, the GUI limitation just described also applies. An application using RDP can't be containerized as-is.

However, a good alternative is a remote management tool such as Windows Admin Center. You can use Windows Admin Center to manage Windows containers hosts, and the containers themselves, without the need to RDP into them.  You can also open a remote PowerShell session to the host and/or containers to manage them.

### Stateful applications

Applications that need to preserve state data can be containerized only if you isolate the data needed from one session to the next and store it in persistent storage. This might require some "rearchitecting" which may or may not be trivial but proceeding with it will eliminate this barrier to containerization.

An example of state is a web application that store images or music files to a local folder.  In a traditional Windows environment, a file is saved to disk at the moment the write operation concludes, so if the instance (a VM in this case) fails, you simply bring it back up and the file will still be there. By contrast, if a container instance performing a write operation fails, the new container instance won't include that file. For this reason, you should consider using persistent storage so all container instances can store state data or files to a centralized, durable location. This type of rearchitecting does not require you to change the code of the application, just the type of storage used by the Windows instance. For more information, check out the Windows container [documentation on storage](../manage-containers/persistent-storage.md).

However, this brings in another related topic…

### Database applications

As a general rule, database applications are not great candidates for containerization. While you can run a database inside a container, containerizing an existing database is usually not ideal, for two reasons.

First, the performance needed for a database might require the entire hardware resources available for the host – which devalues the benefit of consolidation. Second, multiple instances of a single database tier need coordination for its write operations. Container orchestration can solve that, but for existing databases, orchestration may become an overhead. Most databases, such as Microsoft SQL Server, have a built-in load balance and high availability mechanism.

### Infrastructure Roles on Windows Server

Windows Server infrastructure roles primarily handle functions closer to the operating system (for example, AD, DHCP, and File Server). As such they are not available to running containers. Therefore, applications needing these roles will always be difficult to containerize.

There are some gray areas. For example, some features such as DNS may work on Windows containers even though they're not really intended to be used in containers. Other infrastructure roles are simply removed from the base container image and cannot be installed, such as Active Directory, DHCP, and others.

### Active Directory (AD)

Active Directory was released more than twenty years ago along Windows 2000 Server. It uses a mechanism in which each device or user is represented by an object stored in its database. This relationship is tightly coupled, and objects are kept in the database even if the actual user or device is no longer in play. That approach for Active Directory directly contradicts the ephemeral nature of containers, which are expected to be either short-lived or deleted when turned off. Maintaining this one-to-one relationship with Active Directory is not ideal for those scenarios.

For that reason, Windows containers cannot be domain-joined. As an effect of that, you cannot run Active Directory Domain Services as an infrastructure role on Windows containers. You can run the PowerShell module for managing Domain Controllers remotely inside a Windows container.

For applications running on Windows containers that are Active Directory dependent, you can use Group Managed Service Accounts (gMSA), which will be explained further.

### Apps using .NET Framework version 2.0 or older

If your application requires .NET, your ability to containerize depends entirely on the version of .NET Framework it uses. Any version before .NET Framework 2.0 is not supported at all; higher versions require the use of specific images as described later.

### Apps using third-party (non-Microsoft) frameworks

Generally speaking, Microsoft is unable to certify third-party frameworks or applications, or support them running on Windows containers – or physical and virtual machines for that matter. However, Microsoft does perform its own internal testing for usability of multiple third-party frameworks and tools, including Apache, Cassadra, Chocolatey, Datadog, Django, Flask, Git, Golang, JBoss, Jenkins, Rust, Nodejs, Pearl, Python, Ruby, Tomcat, and many others. 

For any third-party framework or software, please validate its supportability on Windows containers with the vendor that supplies it.

## Ideal candidates for containerizing

Now that we've considered the hard limitations on containerizing apps, it's easier to see what types of apps more readily lend themselves to Windows containers. The ideal candidates for Windows containers, and any special considerations for containerizing them, are in the following table.

|Type of application | Why these are good candidates | Special considerations|
|---|---|---|
|Console applications | With no GUI limitations, console apps are ideal candidates for containers. | Use the appropriate base container image depending on the application's needs.|
|Windows services | Because these are background processes not requiring any direct user interaction | Use the appropriate base container image depending on the application's needs. You need to create a foreground process to keep any containerized background process running. See the section on Background services below.|
|Windows Communication Foundation (WCF) services | Because they're service-oriented apps that can also run in the background | Use the appropriate base container image depending on the application's needs. You may need to create a foreground process to keep any containerized background process running. See the section on Background services below.|
|Web apps | Web applications are in essence background services listening on a specific port and are therefore great candidates for containerization, as they can leverage the scalability offered by containers | Use the appropriate base container image depending on the application's needs.|

>Note: even these ideal candidates for containerization may rely upon core Windows features and components that will need to be handled differently in Windows containers. The next section, which goes into more details on such practical considerations, will better prepare you for leveraging the functionality of Windows containers.

## Practical considerations for applications that can be containerized

App renovation projects typically take into account whether a particular app can be containerized through the perspective of the app's business function. But the business functionality is not the factor that determines whether it's technically possible. What's important is the app's architecture, i.e., what technical components it relies upon. Therefore, there's no easy answer to a question like "Can I containerize my HR application?" because it's not what the application is doing, it's how (and what Windows components/services it uses) that makes the difference.

This is an important distinction, because if your application isn't built with a microservices architecture to begin with, it's likely to be harder to containerize. As you proceed to containerize it, certain features may need special handling. Some may be due to the app's use of core Windows components and frameworks that are not supported in Windows containers. Others, such as event logging and monitoring, are due to inherent differences between Linux and Windows that become apparent only when you containerize the app. Still others, such as scheduled tasks and background services, must be understood from the perspective that a container isn't a VM but is ephemeral, and therefore needs special handling.

The following table presents a quick summary of the components/features of applications that need special consideration when you're thinking about containerizing. The subsections that follow give you more detail, including examples that illustrate techniques for handling each scenario. While the list below covers scenarios that are supported on Windows containers, these scenarios still need to respect the guidance from the previous chapter. For example, while background services are supported, running a background service on .NET Framework 1.1 is not supported.

|Windows feature/component requiring special handling | Reason|
|---|---|
|Microsoft Messaging Queueing (MSMQ) | MSMQ originated long before containers and not all of its deployment models for message queues are compatible with container architecture.|
|Microsoft Distributed Transaction Coordinator (MSTDC) | Name resolution between MSTDC and the container requires special consideration.|
|IIS | IIS is the same as in a VM, but there are important considerations when running it in a container environment, such as certificate management, database connection strings, and more.|
|Scheduled tasks | Windows containers can run scheduled tasks, just like any Windows instance. However, you might need to run a foreground task to keep the container instance running. Depending on the application, you might want to consider an event driven approach.|
|Background services | Since containers run as ephemeral processes, you'll need additional handling to keep the container running|
|.NET Framework and .NET (formerly .Net Core) | Make sure to use the right image to ensure compatibility, as explained in the subsection below|

Other supporting components

|Component requiring special handling | Reason | Alternative approach|
|---|---|---|
|Event logging/monitoring | Because the way Windows writes events and logs is inherently different from Linux stdout | Use the new Log Monitor tool to normalize the data and combine from both Linux and Windows|
|Windows containers security | While many security practices remain the same, containers require additional security measures | Employ a purpose-built registry and image scanning tool – more details later|
|Backup of Windows containers | Containers should not have data or state in it | Backup any persistent storage used by containers, as well as container images|

### Windows components/features

Now let's dive into the details of applications and components that can be containerized, but do require additional handling.

#### MSMQ

If your application is dependent upon MSMQ, whether you can containerize it depends on its MSMQ deployment scenario. MSMQ includes multiple deployment options. The factors of private vs. public queues, transactional or not, and authentication type form a matrix of scenarios that MSMQ was originally designed to support. Not all of these can be easily moved to Windows containers. The following table lists the scenarios that are supported:

|Scope|Transactional?|Queue location|Authentication type|Send and receive?|
|---|---|---|---|---|
|Private|Yes|Same container (single container)|Anonymous|Yes|
|Private|Yes|Persistent volume|Anonymous|Yes|
|Private|Yes|Domain Controller|Anonymous|Yes|
|Private|Yes|Single host (two containers)|Anonymous|Yes|
|Public|No|Two hosts|Anonymous|Yes|
|Public|Yes|Two hosts|Anonymous|Yes|

A few notes about these supported scenarios, which have been validated by Microsoft's internal development teams:

- Isolation mode: Both process mode and Hyper-V mode for isolation work with the scenarios listed above.
- Minimal OS and container image:  The minimal OS version recommended for using with MSMQ is Windows Server 2019.
- Persistent volumes: The scenarios above were validated running MSMQ on Azure Kubernetes Service (AKS) using Azure files for persistent storage.

When you put these considerations together with the table above, you can see that the only scenario that isn't supported is for queues that require authentication with Active Directory. The integration of gMSAs (Group Managed Service Accounts) with MSMQ is currently not supported as MSMQ has dependencies on Active Directory that are not yet in place.

Alternatively, use Azure Service Bus instead of MSMQ. Azure Service Bus is a fully managed enterprise message broker with message queues and publish-subscribe topics (in a namespace). Switching from MSMQ to Azure Service Bus requires code changes and application re-architecture, but will give you the agility to move to a modern platform.

#### How IIS works in a container vs. a VM

IIS works the same on a Windows container as in a VM. However, there are some aspects of running an IIS instance that should be considered when running on a container environment:

- Persistent storage for local data: Folders on which the app writes/reads files to/from are a great example of something you would keep in a VM for an IIS instance. With containers, you don't want any data being written directly into the container. Containers use a "scratch space" for local storage and when a new container comes up for the same application, it has no access to that area from a previous container. For that reason, you should use persistent storage for data that needs to be accessible to the web application, so any container instance can have access to that storage.
- Certificates: Although you can have local certificates on container instances, you should avoid doing so, because if a certificate needs to be updated, you have to rebuild your container image. Alternatively, you can use a container orchestrator with Ingress control. Ingress controllers can apply network policies and also handle the certificate management for the website being hosted behind it. The upside is you decouple the certificate lifecycle management from the website management.
- Database connection strings: For traditional IIS deployment, you can pass the DB connection string as part of your application deployment. While Windows containers allow you to follow that model, you might want to consider decoupling the DB connection string from the container to a centralized configuration provided by the container orchestrator, from which the application can read. This allows you to manage and update the DB connection string independently from the application. If the DB changes (for cases of Lift and Shift to the cloud, for example) you can easily change the connection string without rebuilding your container image. This approach also allows you to keep secrets (such as username and password for connecting to the DB) on a secret store.
- Horizontal auto-scale: When load increases, compute systems tend to slow down the perceived performance while trying to process the simultaneous requests. There are generally two ways to avoid performance impact, – vertical or horizontal scale. Vertical scale increases the resources available for the existing compute instances (more CPU, Memory, etc.). Horizontal scale increases the number of instances supporting the requests (more physical hosts, or VMs, or containers). For web tiers such as IIS, horizontal scale tends to be more efficient than vertical, but on-premises environments might encounter resource limitations and load balancing issues. With cloud environments, horizontal scale is much easier as resources are readily available (for an additional cost) and the cloud provider typically designs its load balancing mechanism with horizontal scale in mind. Windows containers can leverage horizontal scale for IIS, but the ephemeral aspect of containers plays an important role. It's imperative that your containers have the same configuration and that no state or data is stored to allow for scaling up or down the number of instances supporting your web application.

#### Scheduled tasks

Scheduled tasks are used to call a program, service, or script at any moment in time in a Windows environment. Traditionally, you have a Windows instance up and running at all times and when a trigger is met, the task is executed. This is possible with Windows containers and – aside from the fact that you need to configure and manage scheduled tasks via Azure PowerShell – they work exactly the same.

With a microservices approach, however, you have a few options to avoid keeping a container running to wait for a trigger:

- Use an event driven PaaS (Platform as a Service) such as Azure Function to store your code and define a trigger for that app. Azure Functions even supports Windows container images to be run when a trigger is met.
- Use Windows containers in conjunction with a container orchestrator. The container can run only when the trigger is met and called from other parts of the application. In this case, the container orchestrator will handle the scheduling and trigger for the application.
- Finally, keep a Windows container running to run a scheduled task. You will need a foreground service (such as Service Monitor) to keep the container running.

#### Background services

Although containers are generally for ephemeral processes, you can containerize a background, long-running application provided you create a foreground process to both kick it off and keep it running.  

A great example of this is ServiceMonitor, which is a Windows executable designed to be used as an entry-point process when running IIS in containers.  Although it was built for IIS, the ServiceMonitor tool offers a model that can also be used to monitor other services, with some limitations.

For more information on ServiceMonitor, check out the [documentation on Github](https://github.com/microsoft/IIS.ServiceMonitor).

#### .NET Framework and .NET

Windows containers support both .NET Framework and .NET (formerly, .NET Core). The .NET team creates its own official images for both frameworks on top of the Windows base container images. Choosing the appropriate image is critical to ensure compatibility. The .NET team provides .Net Framework images on top of the Server Core base container image and .NET images on top of both the Server Core and Nano Server base container images. Server Core has a larger API set than Nano Server, which allows for greater compatibility, but also a larger image size. Nano Server has a severely reduced API surface, but a much smaller image size.

In some cases, you might need to build your own .NET Framework or .NET image on top of the Windows, or Server base container images. This might be necessary if your application has not only a framework dependency but an OS dependency.  You'll be able to detect any such dependencies by testing your application with a particular base container image.

For example, the Server Core and Nano Server base container images have only one font available, to reduce the image size. If your application requires a different font, you'll either have to [install that font](https://techcommunity.microsoft.com/t5/itops-talk-blog/adding-optional-font-packages-to-windows-containers/ba-p/3559761) or use the Server or Windows images, which have a larger API set and include all the default Windows fonts. From a compatibility standpoint, this allows for virtually any app (as long as they respect the nature of containers, such as no-GUI) to be containerized. On the downside, they will be much larger in size, which may affect performance.

When validating if the application to be containerized works on Windows containers, Microsoft recommends the following:

|For this framework|Test with this container image first|Fallback to this container image if first doesn't work|Base image|
|---|---|---|---|
|.NET Framework versions 2.X and 3.X|.NET Framework 4.x|.NET Framework 3.5|Windows Server Core|
|.NET Framework 4.x versions|.NET Framework 4.x|Build your .NET Framework container image with Server or Windows images|Windows Server Core|
|.NET 6 or 7|.NET 6 or 7 respectively|Build your .NET container image with Windows or Server base images|Windows Nano Server or Server Core|

### Other supporting components

The components and topics below provide additional guidance for items that go alongside or that provide better clarity on Windows containers.

#### Event logging

Windows and Linux use different methods to store and present logs and events to its users. Traditionally, Windows has used the EVT format, which can be viewed in a structured way in Event Viewer. Linux, by contrast, has provided a streamlined approach with Standard Output (stdout) that other tools, such as Docker, rely upon.

Docker has always had a mechanism to extract logs from Linux containers. Using the "docker logs" command with a default stdout configuration, Docker brings application logs out of the container without opening the container interactively. Until the launch of the Log Monitor tool, however, the same technique didn't work on Windows.

The Log Monitor tool presents the Windows logs in the stdout format so other tools, such as Docker, can gather the information necessary to display it. Additional benefits to using Log Monitor include these:

- Being able to filter which types of events/logs you want to expose on stdout. For example, you can filter the application log for "error" and "warning" messages only if you're not interested in "information" events.
- The ability to choose from Event Logs, Custom Log Files, or Event Tracing for Windows (ETW). This is particularly helpful if your application is writing on a different log source. An example of this is the IIS logs located on the "C:\inetpub" folder.
- The fact that Log Monitor makes Windows containers behave much like Linux containers, and therefore tools that look for stdout and interact with the container runtime function as expected. For example, if you move from Docker to ContainerD as the container runtime, the logs should still be visible from the container host via (for example) "crictl logs".

You can read more about the Log Monitor tool in [this blog post](https://techcommunity.microsoft.com/t5/itops-talk-blog/how-to-troubleshoot-applications-on-windows-containers-with-the/ba-p/3201318).

#### Windows containers security

Windows containers are built on the same base as Windows instances running on physical or virtual machines. Understanding the specifics of how containers are implemented, especially their shared-kernel nature, helps you secure a containerized application:

- Shared components. Windows containers share some of the host's components for security purposes. This includes the Windows Firewall, Windows Defender (Antivirus), and other resource access limitations. You do not need to configure these components on your container directly because the container host makes the necessary adjustments based on your container workload. For example, if the container makes a web request, the container host will forward the necessary traffic through its firewall so the container can access the web.
- Isolation mode. As discussed, Windows containers can be deployed in process or Hyper-V isolation mode, with Hyper-V providing the most secure isolation. In process isolation, the container shares its kernel, file system, and registry with the host, which allows for an elevated (admin) process to interact with the container processes and services. Choosing the correct isolation mode for your application is important to ensure the appropriate security model.
- Windows updates. Because the servicing stack is not present on Windows containers, Windows containers don't receive updates like general Windows instances. Instead, you need to rebuild Windows containers using the latest available base container image. Customers can leverage DevOps pipelines for that purpose. Microsoft updates the base container images for all its official images each month following the Patch Tuesday cadence.
- Container user account. By default, applications inside Windows containers run with elevated privileged under the ContainerAdmin user account. This is helpful for installing and configuring the necessary components inside the container image. However, you should consider changing the user account to ContainerUser when running an application that does not require the elevated privileges. For specific scenarios, you can also create a new account with the appropriate privileges.
- Image and runtime scanning. Containers require that images on repositories and containers instances are secure. Microsoft recommends that you use Microsoft Defender for Containers for image scanning and runtime scanning. Defender for Containers supports Windows containers for vulnerability assessment with registry scan and runtime protection with threat detection.

More information on the above topics can be found in the Windows containers [documentation page](../manage-containers/container-security.md).

#### Backup of Windows containers

You need to think about backups differently when using containers. As discussed previously, a container shouldn't be used to store state or data given its ephemeral nature. If you separate state and data from the container instance, your backup concerns are outside of the runtime of the container instance, which can be replaced with a new one to which all necessary persistent storage will still be available.

There are still components you are responsible for backing up, however; including the application, the container image, and the dockerfile that builds the container image. Most of these operations are handled by the platform on which you run your production and development workloads. When adopting a DevOps approach, consider the most common cases:

- Application: Your application probably resides in a source repository such as GitHub or Azure DevOps. These repositories provide version control, which allows you to revert back to a specific version of the application. If you own the source repository, make sure to follow its backup and management recommendations.
- Container image: For production environments, your container image should live in a centralized image repository, such as Azure Container Registry (ACR). You can push your container images to ACR so it makes it available to other hosts to pull it. ACR handles the availability of the container images and serve as a backup option – however, keep in mind that while ACR handles the availability of the image it does not prevent an image from being deleted or overwritten. For any other local or on-premises image repository, follow the vendor's recommendation for backing up existing registries.
- Dockerfile: Dockerfiles build new container images and are usually stored along with the application source. Since the dockerfile might not have been created with the application, especially if it's an existing application that is being containerized, you're responsible for ensuring the dockerfile is stored in a secure and backed-up location.
You should also ensure that any other assets necessary for your application to work in a container are backed up; for example: YAML and JSON files for Kubernetes, Docker Swarm, and Azure ARM templates follow the same guidelines as above.

## Planning the lift-and-shift process

After you've assessed your application's readiness for containerizing, use the following general guidance to plan the process:

1. Determine the Windows operating system base image you need: [Windows Server Core](https://hub.docker.com/_/microsoft-windows-servercore), [Nano Server](https://hub.docker.com/_/microsoft-windows-nanoserver), [Windows](https://hub.docker.com/_/microsoft-windows), or [Server](https://hub.docker.com/_/microsoft-windows-server) images.
2. Determine the type of isolation mode for the container: choose between process or Hyper-V isolation modes.
Note: Currently, AKS and AKS on Azure Stack HCI support only process-isolated containers. In a future release, both AKS and AKS on Azure Stack HCI will also support Hyper-V-isolated containers. For more information, see [Isolation Modes](../manage-containers/hyperv-container.md).
3. Choose the right Windows Server version for your application for app-compat purposes. The minimal Windows Server version for containers is Windows Server 2016, but Windows Server 2019 and Windows Server 2022 are the only container host operating systems supported on AKS and AKS on Azure Stack HCI.
4. Ensure your company's security policies are in place for the container environment. This includes adapting to container specific requirements, such as registry scanning and threat detection.
5. Consider load-balancing needs. Containers themselves don't move; you can use an orchestrator instead to automatically start or stop containers on cluster nodes, or to manage changes in load and availability with automatic horizontal scale.
6. Consider orchestration needs. Once containerized, your application likely needs automated management available with tools such as Kubernetes, AKS, or AKS on Azure Stack HCI. See [Windows Container orchestration overview](../about/overview-container-orchestrators.md) for a full discussion and guide to choosing among the tools.
7. Containerize the app.
8. Push the app to an image repository. This will allow the container hosts to download the image in any environment, including dev, test, and production.