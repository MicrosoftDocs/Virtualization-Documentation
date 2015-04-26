ms.ContentId: F0D47E70-0BA1-4A06-B2F3-0232C496709D
title: Frequently asked questions


# Frequently Asked Questions

## Q: What is a Windows Server Container?  ##

Windows Server Containers are a lightweight operating system virtualization method used to separate applications or services from other services running on the same container host. To enable this, each container has its own view of the operating system, processes, file system, registry, and IP addresses. For more information, see [Windows Server Containers](about_overview.md) 


## Q: What is a Hyper-V Container?  ##

You can think of a Hyper-V Container as a Windows Server Container running inside of a Hyper-V partition. You don’t have to worry about creating a virtual machine, installing an operating system and container management tools just to run their workload it’s all part of Hyper-V Containers. 


## Q: When will Windows Server Containers and Hyper-V Containers be available for use?  ##

<!-- check with marketing -->
Windows Server Containers will be available in preview this summer. We expect to deliver a preview of Hyper-V Containers this calendar year.   



## Q: Will Hyper-V Containers also be available to the Docker ecosystem?   ##

Yes. Hyper-V Containers will provide the same level of integration and management with Docker as Windows Server Containers, enabling an open, consistent, cross-platform experience. The Docker platform will also greatly simplify and enhance the experience of working across our container portfolio. 


## Q: As a developer, do I have to re-write my app for each type of container? ##
<!-- need to clarify the use of runtime - do you mean container type? -->
No, Windows container images are common across both Windows Server Containers and Hyper-V Containers. The choice of container runtime is made when you start the container. Developers can choose to build container images using either runtime. QA can use either runtime to validate applications and operations an use either runtime in production. 


## Q: Are Hyper-V/Windows Server containers an add-on, or will they integrated within Windows Server?  ##

The container capabilities will be integrated into the next version of Windows Server. Stay tuned for more information closer to the general availability.  


## Q: What are the pre-requisites for Windows Server containers and Hyper-V Containers?  ##

Both Window Server Containers and Hyper-V Containers require the next version of Windows Server. These technologies will not work with previous versions of Windows. 


## Next Steps:
[Create your first container](..\quick_start\hello_world.md)