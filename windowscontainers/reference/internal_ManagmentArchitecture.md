ms.ContentId: d5ec4e10-b57f-486d-82e5-fac8abba6212
title: Management Architecture

**INTERNAL ONLY - NOT FOR PUBLICATION IN THIS FORM**

Microsoft is enabling two management experiences for Windows Server containers; the first is an inbox PowerShell/WMI experience based on our existing Hyper-V management models and the second is in partnership with Docker expanding the wildly popular Docker interface from Linux to work with Windows Server containers.  This decision as brought forth many questions, why not just focus on the Docker interface – that is what people want right?  Alternatively, why are we investing so much in a management experience that is not ours?

These are great questions; this goal of this document is to answer these types of questions in addition to outlining our architecture, experiences and interoperability scenarios for container management.  For folks that are not interested in the architecture or motivations the last section of this document contains a set of common questions (with answers).  

#Introduction
Containers bring a new set of experiences to the Windows Server platform and Windows users expect a Windows experience; for desktop users, an example of this is the start menu, and for server users PowerShell and consistent remote management are much the same.  Microsoft and Windows customers, especially server customers, also expect a high-level of support and consistency that few software companies other than Microsoft can provide.  For these reasons, we are building an inbox first class container management solution including PowerShell support.

However, containers are not a new concept, and the Linux and open source community has been going crazy over them for nearly a year, which is in part why we partnered with the leader in container management Docker.  It is our goal that using Docker customers can develop, deploy and manage Windows Server containers in the same manner as Linux containers.

There is a lot of skepticism in the Docker community about how the Windows Server container experience will compare to the established Linux experience.  Undoubtedly, there will be differences Linux containers along with Docker have a reasonable head start so it is reasonable to expect some things may be slower or less polished on Windows than on Linux initially – users expect this.  Users also expect that the core functionality of Docker will function the same for Windows containers as it does with Linux; for example, if docker build does not work on Windows, that will significantly affect adoption of Windows containers.  Functionality parity will also be very important for the solutions that build on top of Dockers API – if the API behaves vastly different between the two container platforms, those solutions may not function properly with Windows containers, which would also affect adoption.

Both the Windows inbox experience and the Docker experience are incredibly important to the overall success of the project, the ability to bridge these two experiences is also important.  Most users are likely to pick a management experience they prefer and rarely if ever cross over, but there will be occasions where utilizing both or crossing over will be required.  One example could be a consultant that utilizes Docker for their day-to-day work but one of their customer’s requirements is a complete Microsoft stack.

#Architecture and Overview
If not properly architected, having multiple management interfaces could easily conflict, providing a poor experience to both users.  There is also a risk that one interface becomes a first class citizen relegating the other(s) to build on top of it and work within the architectural choices (or limitations) it may have.  The model that Windows Server containers will utilize allows each management stack to stand on their own with only minimal intersection points at well-defined interface boundaries.  Under this model, all management stacks on a common level, responsible for managing only the artifacts they create.

##High Level Architecture
Docker’s architecture includes a set of interfaces between the bottom edge of their engine and the OSs isolation or virtualization layers; they call these ‘drivers’.  These interfaces control the compute, storage and networking components in Linux that facilitate creation, configuration and basic lifecycle of containers.  By integrating at this abstraction layer, we are able to preserve and reuse the majority of Dockers existing code and will benefit from future evolutions in there engine (including bug fixes and feature enhancements).  We anticipate that Docker will continue to evolve quickly as compared with Windows releases as evidence by there announced plans to ship new ‘supported’ versions monthly as compared to their previous six-week cycles.  By reducing that amount of Windows code Docker relies on, we dramatically increase the likelihood that Windows can maintain feature compatibility with Linux as the core Linux kernel is on much more similar release cycle.
![](Media\internal_ManagmentArchitecture_img1.png) 

##Packages and Images
One of the clear inflection points that launched the container frenzy was the ability to easily create and share ‘images’.  Images are like a read-only template that all containers start from – a basic image might just be an operating system installation, a more advanced one might contain an entire application; they can also take dependencies on each other such that the first image could be the OS, with a second dependent image being the application.

Windows containers share a very similar concept, that we are calling packages.  A package contains a set of payload such as file system or registry changes in a transport friendly layout along with metadata describing the package including the packages name, dependencies, publisher and other relevant information.  Windows servers can export packages resulting from container execution or import packages and create new containers from them.
![](Media\internal_ManagmentArchitecture_img2.png)
###Layouts
The actual container state exists in one of two layouts (both defined and owned by Microsoft) the first layout is transport friendly and the second is a runtime layout.  The runtime layout results from a management layer calling a new Windows API with the location of a transport layout as well as a destination repository location and any dependency information.  Once completed new containers can utilize this payload as their initial state.  Similarly, the transport layout is created via calling a new Windows API that transforms a runtime layout into a transport friendly layout.
![](Media\internal_ManagmentArchitecture_img3.png)
###Docker - Images and Layers
A fundamental part of Dockers management model is the notion of layers within an image; images may have many layers (10+ is quite common).  We are not planning this functionality in the first version of the inbox Windows management model – however, by virtue of the approach we are taking, the Docker engine can still support layers.  As illustrated Dockers image contains metadata about the image in a file, they call the ‘repository file’ as well as one or more layers.  Each layer is its own tar ball with some additional metadata and the layers payload.  For Windows containers this payload would be Transport Friendly layouts as described above.
![](Media\internal_ManagmentArchitecture_img4.png)
#Bridging Experiences
The ability to bridge between different management experiences is very important; customers are very fearful of ‘vendor locked in’ and demand the freedom to change their minds.  Customers accept that changing tool sets or experiences will require work and even downtime – what they will not accept is solutions that in their view lock them into a single vendor or experience.  It is equally important that customers and support teams have ways to get global views of a system – this is evident by our own support teams gathering process lists as an initial triage step when supporting customers.
##Data and Package Portability
Most users will identify a management and development experience they prefer and largely stick with it until they find a better experience, cheaper experience or some other forcing function compels them to change.  When migrating, the data or state is often the most import consideration – they are moving to a new experience and thus expect process and commands to change, but they generally want to bring along their state.

Both the runtime layout as well as the transport layout are owned and defined by Microsoft (as called out in the Layouts subsection of the Packaging and Images section) and the conversion between the layouts is only supported via a Windows API.  This enables the creation of transportable layouts from any management interface’s runtime repository and those transportable layouts can then be packaged into any other management or development interfaces format for later consumption.

It is our intention to take a position of data transportability and provide open tooling that enables customers or other management experience to consume packages from any runtime repository though Windows APIs as transport friendly layouts.  
##Common Runtime Management
Support teams and even IT admins may not know what management experiences their customers are using, and without common methods of reporting running containers (and ideally what management tool created the container) they will have a very difficult time efficiently supporting their customers.  Customers may also find occasion that they need to stop or kill running containers when there management tools are not functioning properly (ctrl-alt-del and task manger).  These common runtime operations should work across all containers regardless of the management interface that created them.

In the High Level Architecture sections diagram there is an arrow denoting ‘Core Runtime Operations’ that connects PowerShell directly to the common ‘Host Compute Service’.  This arrow serves to all out a set of core PowerShell cmdlets that will execute locally on a server and communicate directly with the common host compute service.  The cmdlets will be able to report on all running containers, the management interface that created them as well as other critical runtime state.  They will also be able to stop or kill any running container on the system – regardless of what tool created it.
#Common Question w/Answers
###Q: Why are we building two experiences?
The two experiences target different sets of users – see the two question below.
###Q: Why are we building an Inbox management experience?
Multiple reasons:
 - To have a Windows first, familiar and inbox management experience
 - To avoid having to take a dependency on Docker for all container scenarios
 - Some customers don’t trust ‘a US based startup’ referring to Docker (direct quote from a field TSP)
 - Backup in case Docker was to fall from graces, or were acquired etc…
###Q: Why are we building a Docker experience?
Docker is currently the de facto container management solution, with little indication that this will change in the near term.  Our Docker experience targets the existing Docker users enabling them leverage Windows Server containers instead of or in addition to Linux containers – this also extends to the broad set of solutions that build on top of Dockers REST API.
###Q: Can our inbox management tools manage Docker containers as well?
Yes and No.  We will have a ‘Core’ set of PowerShell cmdlets that will work from all containers (regardless of who creates them) – these cmdlets will cover scenarios such as listing all containers or stopping containers.  Our full PowerShell cmdlet set will only work for containers managed by our inbox management service.
###Q: Isn’t this a major duplication of effort?
True, there is some duplication of effort but it is much less than expected.  Both management stacks already existed (Docker for Linux and Hyper-V for containers) and while each requires work to understand Windows containers through a shared base API layer the amount of duplicated work is actually quite small.
###Q: What is the Microsoft answer to the Docker Hub?
The short answer is – we are going to leverage it with Windows Server container images living in the Docker Hub right next to Linux container images.
###Q: Shouldn't we have our own Hub/Store?
Possibly, we designed our management stack to allow us to introduce one in the future.
###Q: Can users share packages between the management models?
Yes though a conversation process – since we own the runtime repository and the transport layout it is our intention to provide tools that enable conversation between management experiences.
