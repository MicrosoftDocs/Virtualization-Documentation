ms.ContentId: F0D47E70-0BA1-4A06-B2F3-0232C496709D
title: Frequently asked questions

# Frequently Asked Questions
Last updated: May 1, 2015

## What is a Windows Server Container?

Windows Server Containers are a lightweight operating system virtualization method used to separate applications or services from other services running on the same container host. To enable this, each container has its own view of the operating system, processes, file system, registry, and IP addresses.  


## What is a Hyper-V Container?

You can think of a Hyper-V Container as a Windows Server Container running inside of a Hyper-V partition. You don’t have to worry about creating a virtual machine, installing an operating system and container management tools just to run their workload it’s all part of Hyper-V Containers.


## When will Hyper-V Containers be available for use?

We expect to deliver a preview of Hyper-V Containers this calendar year.


## Will Hyper-V Containers also be available to the Docker ecosystem?

Yes. Hyper-V Containers and Windows Server Containers will provide identical experiences across all management solutions, including Docker.


## As a developer, do I have to re-write my app for each type of container?

No, Windows container images are common across both Windows Server Containers and Hyper-V Containers. The choice of container type is made when you start the container. Developers can choose to build container images using either type confident in the knowledge that either will work in deployment.


## Are Hyper-V/Windows Server Containers an add-on, or will they integrated within Windows Server?

The container capabilities will be integrated into Windows Server 2016. Stay tuned for more information closer to the general availability.  


## What are the prerequisites for Windows Server Containers and Hyper-V Containers?

Both Window Server Containers and Hyper-V Containers require Windows Server 2016. These technologies will not work with previous versions of Windows.

## Is Microsoft participating in the Open Container Initiative (OCI)?
To guarantee the packaging format remains universal, Docker recently organized the Open Container Initiative (OCI), aiming to ensure container packaging remains an open and foundation-led format with Microsoft as one of the founding members.

## Is Microsoft really partnering with Docker?
Yes.  
Our partnership with Docker enables developers to create, manage and deploy both Windows Server and Linux containers using the same Docker tool set. Developers targeting Windows Server will no longer have to make a choice between using the vast range of Windows Server technologies and building containerized applications.  

Docker is two things, the open source group of projects and Docker the company. We consider this partnership to include both. Docker is successful, in part, because of the vibrant ecosystem that has built up around the Docker container technology. Microsoft is contributing to the Docker Project, enabling support for Windows Server Containers and Hyper-V Containers.  

For more information, see the [New Windows Server containers and Azure support for Docker](http://azure.microsoft.com/blog/2014/10/15/new-windows-server-containers-and-azure-support-for-docker/?WT.mc_id=Blog_ServerCloud_Announce_TTD) blog post.

-------------------
[Back to Container Home](../containers_welcome.md)