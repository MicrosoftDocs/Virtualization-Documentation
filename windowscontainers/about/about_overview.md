ms.ContentId: 526e4f1a-2936-4c61-b3be-d41b4cf9d10f
title: About Windows Server Containers

# Windows Server Containers #

Windows Server contrainers provide a new way to build, ship, deploy, and instanciate applications by providing applications an isolated, portable and resource controlled operating environment.

![](media\WindowsServerContainer.png)

Basically, a container is an isolated place in which an application can run with out affecting the rest of the system and without your system affecting the application.  Isolatiing the application allows it to run without risk of mismatched dependencies or environmental configuration affecting the application.

At the same time, containers are light and responsive compaired to a traditional virtual machine.  By sharing the same kernel and other key system components, containers exhibit rapid startup times and reduced resource overhead. Rapid startup helps in development and testing scenarios and continuous integration environments, while the reduced resource overhead makes them ideal for service-oriented architectures.

![](media\isolationSpectrum.png)

[Read more about when to use containers.](when_containers.md)

In additon to isolation, Windows Server container infrastructure allows for sharing, publishing and shipping of containers to anywhere running Windows 10 Server.

With this new technology, Windows developers familiar with technologies such as .NET, ASP.NET, PowerShell, and more will be able to run their application, app test harness, or pre-configured dev environment on any Windows 10 Server.  

Would you like to learn more?

Read more about [how to use containers](container_life_cycle.md) or get started with your own Windows containers using the [quickstart guide](..\quick_start\hello_world.md)

