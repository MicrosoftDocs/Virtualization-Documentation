# Windows Containers Quick Start

Windows Containers can be used to rapidly deploy many isolated applications on a single container host. This exercise will walk through simple container creation, container image creation, and application deployment within both a Windows Server Container and a Hyper-V Container. When completed you should have a basic understanding of container creation and management.

This walkthrough demonstrates both Windows Server containers and Hyper-V containers. Each type of container has its own basic requirements. The following items will be required for each exercise.

**Windows Server Containers:**

- A Windows Container Host running Windows Server 2016 (Full or Core), either on-prem or in Azure.

**Hyper-V Containers:**

- A Windows Container Host enabled with Nested Virtualization.
- The Windows Serve 2016 Media.

## Windows Server Container

Windows Server Containers provide an isolated, portable, and resource controlled operating environment for running applications and hosting processes. Windows Server Containers provide isolation between the container and host, and between containers running on the host, through process and namespace isolation.

### Create Container <!--1-->
### Create IIS Image <!--1-->
### Create IIS Container <!--1-->
### Configure Networking <!--1-->
### Create Application <!--1-->

## Hyper-V Container
### Create Container <!--2-->
### Create a Shared Folder
### Create IIS Image <!--2-->
### Create IIS Container <!--2-->
### Configure Networking <!--2-->
### Create Application <!--2-->

## Next Steps
Now that you have containers set up and an introduction to the tools, go build your own containerized apps.

Learn more about [Docker](https://www.docker.com/).

Remember, this is a **preview** there are bugs and we have a lot of work in progress.  [This page](../about/work_in_progress.md) contains many of our known issues.

Be aware that there are some known Docker commands that [don't work](../about/work_in_progress.md#DockermanagementDockercommandsthatdontworkwithWindowsServerContainers) and some that only [partially work](../about/work_in_progress.md#DockermanagementDockercommandsthatpartiallyworkwithWindowsServerContainers)

We are also monitoring the [forums](https://social.msdn.microsoft.com/Forums/en-US/home?forum=windowscontainers) very closely.

There are also pre-made samples on [GitHub](https://github.com/Microsoft/Virtualization-Documentation/tree/master/windows-server-container-samples).