ms.ContentId: 150B8DCC-861B-4FD4-9353-C9886F2F0C30
title: When to use Containers

# When to use Containers #

This article aims to demystify the various technologies that provide isoation in Windows enviornments.

When should you use Windows containers, AppV, virtual machines, or some combination?  Afterall, all three provide flexible ways to run workloads in an isolated fashion.

## Overview ##

All of these technologies provide some level of isolation between your machine and an application though they differ in isolation and purpous.

![The continuum of isolation](media\isolationSpectrum.png)

However, there is a price to pay in overhead.  The more isolation from the machine's operating system, the more resources needed.

![The continuum of resource use](media\overheadSpectrum.png)

So really, to understand when to use a container, VM, or other technology, it's important to consider:
1.  Required security/trust boundries -- Do you trust the machine/its administrator?
2.  Compatability (across different systems) -- Does this need to run on different operating systems?  Different versions of the operating system?
2.  Density -- Are you running many instances?  If so, do your system resources support that?
3.  Resource management/Quality of Service -- Do you need to specify resource use?

|  | **Windows Container** | **Virtual Machines** |  **Application Virtualization** |
|:-----|:-----|:-----|:-----|
|Kernel| Same as host | Any (Windows/Linux)| Same as host |
|Multi-tenant security | No | Yes | No |
|Resource managed | Yes | Yes | No |
|Density | High | Lower | Higher |
|Startup time | Short | Longer | Shorter |
|Disk footprint | Small | Larger | Smaller |
|Application compatability | Medium | High | Medium |

## Properties of a container ##
Containers have the following properties:
- Start and stop very fast
- Use small amounts of memory

Windows Containers provide a dynamic isolated execution environment for server grade applications.  By using containers, resources can be isolated, services restricted, and processes provisioned to have a private view of the operating system with their own process ID space, file system structure, and network interfaces. Multiple containers can share the same kernel, but each container can be constrained to only use a defined amount of resources such as CPU, memory and I/O.

Users can create, deploy and run server applications directly inside a Windows Server Container.

### Containers for Developers  

With containers, developers can build any app in any language using any libraries. These apps are completely portable and can run anywhere - colleagues’ computers, QA servers running in the cloud, and production data center VMs.  

Containers helps developers build and ship higher-quality applications, faster. 

### Containers for Systems Administrators

Systems administrators can use containers to provide standardized environments for their development, QA, and production teams, reducing “works on my machine” finger-pointing. By using containers  systems administrators abstract away differences in OS installations and underlying infrastructure. 

Containers helps systems administrators deploy and run any app on any infrastructure, quickly and reliably. 
nd security


## Properties of a virtual machine ##

Virtual machines have the following properties:
- Can run other operating systems to the host operating system
- Highest level of isolation
- Provide very high availability without requiring application intelligence
- Legacy applications 
- Strong resource management
- Persistent storage


## About App-V ##

Application Virtualization (App-V)
Microsoft Application Virtualization (App-V) transforms applications into centrally managed services that are never installed and don’t conflict with other applications.
IT professionals and end-users alike face challenges in today’s work environment. End-users speak many languages, are geographically dispersed and may not be connected to corporate networks at all times. IT must meet the needs of these users, and provide solutions that are fast, flexible and reliable. App-V can help with the challenges you face day to day and enable your business to be more flexible and responsive to changing needs. Some of the key benefits of App-V include:
An integrated platform: 
Virtual Applications leverage Windows standards for a consistent user experience. With App-V 5.0, virtual applications work more like traditionally installed applications. This means that users don’t have to change the way they use an application just because it’s virtual. It also makes it easy for IT to ork with virtual applications. Diagnostic messages provide meaningful feedback, helping users resolve problems on their own.
Flexible virtualization: 
Businesses can connect separately packaged App-V applications, enabling them to communicate with each other and with traditionally installed applications. This gives businesses the best of both worlds, providing isolation – reducing conflict and time spent regression testing – yet allowing applications to interact and communicate when needed. 
Powerful management of virtualized applications: 
App-V 5.0 allows IT to deploy, track and service virtual applications. With new, web-based management interface based on Silverlight, IT can manage applications without being tied to an installed management console. And App-V 5.0 is designed to be easy and efficient to use in VDI environments, allowing IT to make the best use of expensive disk resources without changing the way they get their jobs done. It lets IT simply choose to turn off local application storage, drmatically reducing disk requirements for VDI while leaving the application provisioning and update process unchanged. 

Microsoft Application Virtualization (App-V) Provides anywhere user access to their applications on any authorized device without application installs. 

App-V increases business agility through faster application deployment and updates with no user interruptions. It minimizes conflicts between applications, allowing enterprises to reduce application compatibility testing time. App-V together with USV provides users with a consistent experience and reliable access to applications and business data, no matter their location and connection to the Internet.

App-V allows applications to be deployed ("streamed") in real-time to any client from a virtual application server. It removes the need for traditional local installation of the applications, although a standalone deployment method is also supported. 

With a streaming-based implementation, the App-V client needs to be installed on the client machines and application data that is stored on the virtual application server is installed (streamed) to the client cache on demand when it is first used, or pre-installed in a local cache. 

The App-V stack sandboxes the execution environment so that an application does not make changes directly to the underlying operating system's file system and/or Registry, but rather contained in an application-specific "bubble". App-V applications are also sandboxed from each other, so that different versions of the same application can be run under App-V concurrently, and so that mutually exclusive applications can co-exist on the same system.

In other words, App-V:
-  Addresses application installation and management
-  Users experience is unchanged when an application is virtualized
-  Applications communicate with each-other and with traditionally installed applications
-  Resource management provided by the OS
-  Applications can leverage any hardware available

You can read more about App-V [here](http://technet.microsoft.com/en-us/windows/hh826068.aspx).
