ms.ContentId: fbd49f81-b6cb-4030-9296-413d68a9428f
title: Container Ecosystem

** Goes live in May **

# Building a Container Ecosystem #

Windows containers are a small component of a large container ecosystem.

Besides isolation, most users will need some way to manage containers, share containers, develop apps that may run in containers, or even orchestrate resource division across many containers.

![](media\containerEcosystem.png)


## Developer Ecosystem ##

Containers make it easy for developers to produce applications which evolve rapidly and organically by providing agile application packaging and isolation.   

![](media/devCreateDeployManage.png)

Using containers, a developer can begin writing an application, containerize that application including the development environment, and pass the container on to someone else. When they start the container, the entire environment is there and ready to use. Because containers can be imported and exported easily based on container definitions, they can also be stored in a central repository where the container definitions can be shared, searched, and modified.

This is useful for iterative development, test frameworks, and numerous other applications.


## Hosting Ecosystem ##

Opportunity for high density hosting in situations where having a shared kernel is not a security concern. If it is a security concern, use a VM as the trust boundary then containers within the VM.
