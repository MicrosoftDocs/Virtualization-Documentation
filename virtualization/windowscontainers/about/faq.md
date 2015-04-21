ms.ContentId: F0D47E70-0BA1-4A06-B2F3-0232C496709D
title: Frequently asked questions


# Frequently Asked Questions

## Q: Are Hyper-V Containers vaporware? ##   

Nope, check out the first live demonstrations of Windows Server Containers at Ignite! <!-- Link to video -->


## Q: Are you releasing Hyper-V Containers because Windows Server Containers are insecure?  ## 

No, we believe that Windows Server Containers are secure. We know customers value and trust Hyper-V to provide and an additional, CEC certified, hardware backed layer of isolation and assurance to their workloads.  For organizations concerned with compliance, they won’t have to enable new compliance requirements because it’s all Hyper-V. 


## Q: Does this announcement mean Microsoft is acknowledging virtual machines may become obsolete? Are you saying developers should stop writing apps on virtual machines?  ## 

No, VMs are well-understood and broadly adopted today. However, existing hardware and machine virtualization was meant to deal with application compatibility and enable hardware consolidation. Containers empower dev-ops app builders to spin up light-weight and portable app components for distributed line-of-business apps as well as for certain task patterns (e.g. batch jobs).   


## Q: What is a Windows Server Container?  ##

Windows Server Containers are a lightweight operating system virtualization method used to separate applications or services from other services running on the same container host. To enable this, each container has its own view of the operating system, processes, file system, registry, and IP addresses. For more information, see [Windows Server Containers](about_overview.md) 


## Q: What is a Hyper-V Container?  ##

You can think of a Hyper-V Container as a Windows Server Container running inside of a Hyper-V partition. You don’t have to worry about creating a virtual machine, installing an operating system and container management tools just to run their workload it’s all part of Hyper-V Containers. 


## Q: When will Windows Server Containers and Hyper-V Containers be available for use?  ##

Windows Server Containers will be available in preview this summer. We expect to deliver a preview of Hyper-V Containers this calendar year.   



## Q: Will Hyper-V Containers also be available to the Docker ecosystem?   ##

Yes. Hyper-V Containers will provide the same level of integration and management with Docker as Windows Server Containers, enabling an open, consistent, cross-platform experience. The Docker platform will also greatly simplify and enhance the experience of working across our container portfolio. 


## Q: As a developer, do I have to re-write my app for each type of container? ##
Containers can be deployed as a Hyper-V Container without change, providing greater flexibility for operators who need to choose degrees of density, agility, and isolation in a multi-platform, multi-application environment. 


## Q: Aren’t Hyper-V and Windows Server Containers Microsoft’s attempt to create its own container solution vs. embracing industry solutions? ## 

No. Containers, just like processes and threads are operating system constructs. To embrace the industry solution, we need to ensure that Windows Server, as an operating system, has core container capabilities.   


## Q: How do I choose between Windows Server Containers and Hyper-V Containers? Is there a difference in the workloads they will be able to run?  ##

From a developer standpoint, Windows Server Containers and Hyper-V Containers are two flavors of the same thing-- deployment options for Microsoft's containers. They offer the same development, programming and management experience, are open and extensible and will include the same level of integration and support via Docker.  A developer can create a container image using a Windows Server Container and deploy it as a Hyper-V Container or vice-verse without any changes other than specifying the appropriate runtime flag. 


Operators need the flexibility to serve many different scenarios so we felt it was vital to offer a range of solutions that scale to density and performance or security and isolation depending on use case and customer needs. Windows Server Containers will offer greater density and performance (e.g. lower spin up time, faster runtime performance compared to nested configurations) for when speed is key. Hyper-V Containers offer greater isolation, ensuring that code running in one container can't compromise or impact the host operating system or other containers running on the same host. This is useful for multitenant scenarios (with requirements for hosting untrusted code) including SaaS applications and compute hosting. 


## Q: Are Hyper-V/Windows Server containers an add-on, or will they integrated within Windows Server?  ##

The container capabilities will be integrated into the next version of Windows Server. Stay tuned for more information closer to the general availability.  


## Q: What are the pre-requisites for Windows Server containers and Hyper-V Containers?  ##

Both Window Server Containers and Hyper-V Containers require the next version of Windows Server. These technologies will not work with previous versions of Windows. 


## Q: What is the difference between Linux and Windows Server Containers? ## 

Linux and Windows Server Containers are similar, and both implement similar technologies within their kernel and core operating system. The difference and value-add comes from the surrounding management experience and workloads that run within the containers. When a customer is using 

Windows Server Containers, they can integrate seamlessly with existing Windows technologies such as .NET, ASP.NET, PowerShell and more. 


## Q: Why should a developer or a company choose Windows Server Containers over Linux? Is that why Microsoft made this announcement?  ##

This announcement is about freedom of choice.  A developer or a company does not have to choose one or the other; in fact they can build container-based distributed applications with the best application content from both. Our approach thoughtfully combines open source, hybrid, and traditional approaches to deliver the most value to customers. This pragmatic focus means that Microsoft is committed to being the best choice for companies managing mixed IT environments. 


## Q: How does Microsoft’s container strategy compare to the competition? In particular, how is your approach different from VMware, Google, and AWS? ## 

Only Microsoft can bring Windows Server technologies and communities into the container movement.  Microsoft is excited to be able to help both Windows Server and Linux developers to deliver containerized applications in Microsoft Azure as well as on-premises – and ultimately across any cloud platform - using the development tools, languages and technologies that they are accustomed to using.  




## Q: Are Hyper-V Containers this built using “Drawbridge” technologies that apparently originated from MSR?  ##

Drawbridge is an internal project that we have been innovating on. The project helped us gain valuable experience with containers. Much of what we announcing today was born from the experience that we had with Drawbridge and we are excited to bring container technologies to Windows Server and the Docker ecosystem along with Linux.   


## Q: Will Microsoft work with other companies besides Docker on containers? ## 

Microsoft and Docker are continuing to work together as evidenced by several recent announcements. As a platform company, we are always interested in enabling broad ecosystems to enable developers and IT pros to be more productive and deliver more business value.  


## Q: Isn’t Microsoft late to the container space? Why would a customer choose Microsoft for container scenarios?  ##

No.  Azure deployed Docker 1.0, the first enterprise-ready version of the Docker open platform for Linux when it was released to the market in June 2014.  With regards to Windows Server, Microsoft has worked on container prototypes as early as 2005, and has been using container technologies internally to power some of its own global-scale public cloud services for many years. With this announcement, Microsoft is making containers a first class object within Windows Server. Microsoft will leverage expertise, experience and technology from this early work into its container technology for Windows Server, enabling our customers to seamlessly work with their existing technologies such as .NET, ASP.NET, PowerShell and more.   



## Q: Is Microsoft offering first-party container orchestration?  ## 

We are currently focused on building to an open API to enable open source across any cloud. This allows customers to take advantage of open source container orchestration options like Docker. We are closely monitoring our customers and their requests and will continue to evolve our offerings based on their usage and experience.  


## Q: What are your options for container management?  ## 

We offer customers choice to leverage Docker management solutions or Windows PowerShell.  



## Next Steps:
[Create your first container](..\quick_start\hello_world.md)