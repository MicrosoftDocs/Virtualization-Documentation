ms.ContentId: F0D47E70-0BA1-4A06-B2F3-0232C496709D
title: Frequently asked questions


# Frequently Asked Questions

## Q: Are Hyper-V Containers vaporware? ##   

Nope, check out the first live demonstrations of Windows Server Containers at Ignite! <!-- Link to video -->


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


## Q: How do I choose between Windows Server Containers and Hyper-V Containers? ##

From a developer standpoint, Windows Server Containers and Hyper-V Containers are two flavors of the same thing-- deployment options for Microsoft's containers. They offer the same development, programming and management experience, are open and extensible and will include the same level of integration and support via Docker.  A developer can create a container image using a Windows Server Container and deploy it as a Hyper-V Container or vice-verse without any changes other than specifying the appropriate runtime flag. 



## Q: Are Hyper-V/Windows Server containers an add-on, or will they integrated within Windows Server?  ##

The container capabilities will be integrated into the next version of Windows Server. Stay tuned for more information closer to the general availability.  


## Q: What are the pre-requisites for Windows Server containers and Hyper-V Containers?  ##

Both Window Server Containers and Hyper-V Containers require the next version of Windows Server. These technologies will not work with previous versions of Windows. 


## Q: What is the difference between Linux and Windows Server Containers? ## 

Linux and Windows Server Containers are similar, and both implement similar technologies within their kernel and core operating system. The difference and value-add comes from the surrounding management experience and workloads that run within the containers. When a customer is using Windows Server Containers, they can integrate seamlessly with existing Windows technologies such as .NET, ASP.NET, PowerShell and more. 


## Q: Why should a developer or a company choose Windows Server Containers over Linux? Is that why Microsoft made this announcement?  ##

This announcement is about freedom of choice. A developer or a company does not have to choose one or the other; in fact they can build container-based distributed applications with the best application content from both. Our approach thoughtfully combines open source, hybrid, and traditional approaches to deliver the most value to customers. This pragmatic focus means that Microsoft is committed to being the best choice for companies managing mixed IT environments. 


## Q: Are Hyper-V Containers built using “Drawbridge” technologies?  ##

Drawbridge is an internal project that we have been innovating on. The project helped us gain valuable experience with containers. Much of what we announcing today was born from the experience that we had with Drawbridge and we are excited to bring container technologies to Windows Server and the Docker ecosystem along with Linux.   


## Q: Will Microsoft work with other companies besides Docker on containers? ## 

Microsoft and Docker are continuing to work together as evidenced by several recent announcements. As a platform company, we are always interested in enabling broad ecosystems to enable developers and IT pros to be more productive and deliver more business value.  


## Q: Is Microsoft offering first-party container orchestration?  ## 

We are currently focused on building an open API to enable open source across any cloud. This allows customers to take advantage of open source container orchestration options like Docker. We are closely monitoring our customers and their requests and will continue to evolve our offerings based on their usage and experience.  


## Q: What are your options for container management?  ## 

We offer customers choice to leverage Docker management solutions or Windows PowerShell.  



## Next Steps:
[Create your first container](..\quick_start\hello_world.md)