ms.ContentId: A571D01D-FF87-4158-A97E-D528A6C5DBA0
title: Containers versus App-V

# Containers vs. App-V

A common question is "How do containers compare to App-V?  When should I use one, when should I use the other?"

## App-V

Microsoft Application Virtualization (App-V) Provides anywhere user access to their applications on any authorized device without application installs. 

App-V increases business agility through faster application deployment and updates with no user interruptions. It minimizes conflicts between applications, allowing enterprises to reduce application compatibility testing time. App-V together with USV provides users with a consistent experience and reliable access to applications and business data, no matter their location and connection to the Internet.

App-V allows applications to be deployed ("streamed") in real-time to any client from a virtual application server. It removes the need for traditional local installation of the applications, although a standalone deployment method is also supported. 

With a streaming-based implementation, the App-V client needs to be installed on the client machines and application data that is stored on the virtual application server is installed (streamed) to the client cache on demand when it is first used, or pre-installed in a local cache. 

The App-V stack sandboxes the execution environment so that an application does not make changes directly to the underlying operating system's file system and/or Registry, but rather contained in an application-specific "bubble". App-V applications are also sandboxed from each other, so that different versions of the same application can be run under App-V concurrently, and so that mutually exclusive applications can co-exist on the same system.

You can read more about App-V here: http://technet.microsoft.com/en-us/windows/hh826068.aspx

## Containers

Windows Containers provide a dynamic isolated execution environment for server grade applications.  By using containers, resources can be isolated, services restricted, and processes provisioned to have a private view of the operating system with their own process ID space, file system structure, and network interfaces. Multiple containers can share the same kernel, but each container can be constrained to only use a defined amount of resources such as CPU, memory and I/O.

Users can create, deploy and run server applications directly inside a Windows Server Container.

### Containers for Developers  

With containers, developers can build any app in any language using any libraries. These apps are completely portable and can run anywhere - colleagues’ computers, QA servers running in the cloud, and production data center VMs.  

Containers helps developers build and ship higher-quality applications, faster. 

### Containers for Systems Administrators

Systems administrators can use containers to provide standardized environments for their development, QA, and production teams, reducing “works on my machine” finger-pointing. By using containers  systems administrators abstract away differences in OS installations and underlying infrastructure. 

Containers helps systems administrators deploy and run any app on any infrastructure, quickly and reliably. 

