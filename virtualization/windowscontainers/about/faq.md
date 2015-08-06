ms.ContentId: F0D47E70-0BA1-4A06-B2F3-0232C496709D
title: Frequently asked questions

# Frequently Asked Questions
Last updated: May 1, 2015

## Q: What is a Windows Server Container?  ##

Windows Server Containers are a lightweight operating system virtualization method used to separate applications or services from other services running on the same container host. To enable this, each container has its own view of the operating system, processes, file system, registry, and IP addresses.  


## Q: What is a Hyper-V Container?  ##

You can think of a Hyper-V Container as a Windows Server Container running inside of a Hyper-V partition. You don’t have to worry about creating a virtual machine, installing an operating system and container management tools just to run their workload it’s all part of Hyper-V Containers.


## Q: When will Windows Server Containers and Hyper-V Containers be available for use?  ##

Windows Server Containers will be available in preview this summer. We expect to deliver a preview of Hyper-V Containers this calendar year.



## Q: Will Hyper-V Containers also be available to the Docker ecosystem?   ##

Yes. Hyper-V Containers and Windows Server Containers will provide identical experiences across all management solutions, including Docker.


## Q: As a developer, do I have to re-write my app for each type of container? ##

No, Windows container images are common across both Windows Server Containers and Hyper-V Containers. The choice of container type is made when you start the container. Developers can choose to build container images using either type confident in the knowledge that either will work in deployment.


## Q: Are Hyper-V/Windows Server Containers an add-on, or will they integrated within Windows Server?  ##

The container capabilities will be integrated into Windows Server 2016. Stay tuned for more information closer to the general availability.  


## Q: What are the prerequisites for Windows Server Containers and Hyper-V Containers?  ##

Both Window Server Containers and Hyper-V Containers require Windows Server 2016. These technologies will not work with previous versions of Windows.

[Back to Container Home](../containers_welcome.md)